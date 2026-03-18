import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/http_client.dart';
import '../../../../core/api/ws_client.dart';
import '../../domain/models/dm_channel.dart';

part 'dm_provider.g.dart';

/// All DM channels for the current user, updated via WebSocket (DM-01).
@riverpod
class DmChannelList extends _$DmChannelList {
  @override
  Future<List<DmChannel>> build() async {
    final channels = await _fetch();

    final ws = ref.watch(wsClientProvider);
    final sub = ws.events
        .where(
          (e) =>
              e.type == WsEventType.messageCreated ||
              e.type == WsEventType.channelMemberJoined,
        )
        .listen((_) => ref.invalidateSelf());
    ref.onDispose(sub.cancel);

    return channels;
  }

  Future<List<DmChannel>> _fetch() async {
    final dio = ref.read(httpClientProvider);
    final resp = await dio.get<List<dynamic>>('/dm/channels');
    return (resp.data ?? [])
        .cast<Map<String, dynamic>>()
        .map(DmChannel.fromJson)
        .toList();
  }

  /// Opens (or retrieves) a DM channel with the given set of user IDs.
  Future<DmChannel> openOrCreate(List<String> userIds) async {
    final dio = ref.read(httpClientProvider);
    final resp = await dio.post<Map<String, dynamic>>(
      '/dm/channels',
      data: {'memberIds': userIds},
    );
    final channel = DmChannel.fromJson(resp.data!);
    // Optimistically prepend if not already present
    state.whenData((list) {
      if (!list.any((c) => c.id == channel.id)) {
        state = AsyncData([channel, ...list]);
      }
    });
    return channel;
  }
}

/// Messages for a single DM channel — same shape as MessageListProvider.
@riverpod
class DmMessages extends _$DmMessages {
  @override
  Future<List<_DmMessage>> build({required String dmChannelId}) async {
    final messages = await _fetch();

    final ws = ref.watch(wsClientProvider);
    final sub = ws.events.listen((event) {
      if (event.type == WsEventType.messageCreated) {
        final msg = _DmMessage.fromJson(event.payload);
        if (msg.dmChannelId != dmChannelId) return;
        state.whenData((list) => state = AsyncData([...list, msg]));
      }
    });
    ref.onDispose(sub.cancel);

    return messages;
  }

  Future<List<_DmMessage>> _fetch() async {
    final dio = ref.read(httpClientProvider);
    final resp = await dio.get<List<dynamic>>(
      '/dm/channels/$dmChannelId/messages',
      queryParameters: {'limit': 50},
    );
    return (resp.data ?? [])
        .cast<Map<String, dynamic>>()
        .map(_DmMessage.fromJson)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  Future<void> send(String text) async {
    final dio = ref.read(httpClientProvider);
    await dio.post<void>(
      '/dm/channels/$dmChannelId/messages',
      data: {'text': text},
    );
  }
}

/// Minimal message model used inside the DM feature.
class _DmMessage {
  const _DmMessage({
    required this.id,
    required this.dmChannelId,
    required this.authorId,
    required this.authorName,
    this.authorAvatarUrl,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String dmChannelId;
  final String authorId;
  final String authorName;
  final String? authorAvatarUrl;
  final String text;
  final DateTime createdAt;

  factory _DmMessage.fromJson(Map<String, dynamic> json) => _DmMessage(
        id: json['id'] as String,
        dmChannelId: json['dmChannelId'] as String,
        authorId: json['authorId'] as String,
        authorName: json['authorName'] as String,
        authorAvatarUrl: json['authorAvatarUrl'] as String?,
        text: json['text'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
