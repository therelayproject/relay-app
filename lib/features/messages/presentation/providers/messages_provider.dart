import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/http_client.dart';
import '../../../../core/api/ws_client.dart';
import '../../domain/models/message.dart';

part 'messages_provider.g.dart';

/// Provides a live message list for [channelId] backed by the REST API
/// with WebSocket updates applied on top.
@riverpod
class MessageList extends _$MessageList {
  @override
  Future<List<Message>> build({required String channelId}) async {
    // Initial load from REST API
    final messages = await _fetchMessages();

    // Subscribe to WebSocket events for this channel
    final ws = ref.watch(wsClientProvider);
    final sub = ws.events.listen((event) {
      switch (event.type) {
        case WsEventType.messageCreated:
          _handleCreated(event.payload);
        case WsEventType.messageUpdated:
          _handleUpdated(event.payload);
        case WsEventType.messageDeleted:
          _handleDeleted(event.payload);
        case WsEventType.reactionAdded || WsEventType.reactionRemoved:
          _handleReaction(event.payload);
      }
    });
    ref.onDispose(sub.cancel);

    return messages;
  }

  Future<List<Message>> _fetchMessages() async {
    final dio = ref.read(httpClientProvider);
    final response = await dio.get<List<dynamic>>(
      '/channels/$channelId/messages',
      queryParameters: {'limit': 50},
    );
    return (response.data ?? [])
        .cast<Map<String, dynamic>>()
        .map(Message.fromJson)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  void _handleCreated(Map<String, dynamic> payload) {
    final msg = Message.fromJson(payload);
    if (msg.channelId != channelId) return;
    state.whenData((list) {
      state = AsyncData([...list, msg]);
    });
  }

  void _handleUpdated(Map<String, dynamic> payload) {
    final updated = Message.fromJson(payload);
    if (updated.channelId != channelId) return;
    state.whenData((list) {
      state = AsyncData([
        for (final m in list)
          if (m.id == updated.id) updated else m,
      ]);
    });
  }

  void _handleDeleted(Map<String, dynamic> payload) {
    final id = payload['id'] as String?;
    if (id == null) return;
    state.whenData((list) {
      state = AsyncData(list.where((m) => m.id != id).toList());
    });
  }

  void _handleReaction(Map<String, dynamic> payload) {
    final msgId = payload['messageId'] as String?;
    if (msgId == null) return;
    // Re-fetch from server to get updated reaction counts
    ref.invalidateSelf();
  }

  Future<void> sendMessage(String text) async {
    final dio = ref.read(httpClientProvider);
    await dio.post<void>(
      '/channels/$channelId/messages',
      data: {'text': text},
    );
    // WebSocket event will update the list; optimistic update optional
  }
}
