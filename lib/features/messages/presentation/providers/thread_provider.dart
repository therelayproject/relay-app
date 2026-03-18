import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/http_client.dart';
import '../../../../core/api/ws_client.dart';
import '../../domain/models/message.dart';

part 'thread_provider.g.dart';

/// Provides the reply list for a given thread (parent message).
///
/// Backs ThreadPanelScreen (THR-01/02/03).
@riverpod
class ThreadMessages extends _$ThreadMessages {
  @override
  Future<List<Message>> build({required String threadId}) async {
    final messages = await _fetch();

    final ws = ref.watch(wsClientProvider);
    final sub = ws.events.listen((event) {
      switch (event.type) {
        case WsEventType.messageCreated:
          _handleCreated(event.payload);
        case WsEventType.messageUpdated:
          _handleUpdated(event.payload);
        case WsEventType.messageDeleted:
          _handleDeleted(event.payload);
      }
    });
    ref.onDispose(sub.cancel);

    return messages;
  }

  Future<List<Message>> _fetch() async {
    final dio = ref.read(httpClientProvider);
    final response = await dio.get<List<dynamic>>(
      '/threads/$threadId/messages',
      queryParameters: {'limit': 100},
    );
    return (response.data ?? [])
        .cast<Map<String, dynamic>>()
        .map(Message.fromJson)
        .toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  void _handleCreated(Map<String, dynamic> payload) {
    final msg = Message.fromJson(payload);
    if (msg.threadId != threadId) return;
    state.whenData((list) => state = AsyncData([...list, msg]));
  }

  void _handleUpdated(Map<String, dynamic> payload) {
    final updated = Message.fromJson(payload);
    if (updated.threadId != threadId) return;
    state.whenData((list) {
      state = AsyncData([
        for (final m in list) if (m.id == updated.id) updated else m,
      ]);
    });
  }

  void _handleDeleted(Map<String, dynamic> payload) {
    final id = payload['id'] as String?;
    if (id == null) return;
    state.whenData(
      (list) => state = AsyncData(list.where((m) => m.id != id).toList()),
    );
  }

  Future<void> sendReply({
    required String text,
    required bool alsoSendToChannel,
    required String channelId,
  }) async {
    final dio = ref.read(httpClientProvider);
    await dio.post<void>(
      '/threads/$threadId/messages',
      data: {
        'text': text,
        'broadcastToChannel': alsoSendToChannel,
        'channelId': channelId,
      },
    );
  }
}
