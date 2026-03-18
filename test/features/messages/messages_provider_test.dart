import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:relay/core/api/http_client.dart';
import 'package:relay/core/api/ws_client.dart';
import 'package:relay/features/messages/presentation/providers/messages_provider.dart';

import '../../helpers/test_helpers.dart';

// ---------------------------------------------------------------------------
// Controllable WsClient for pushing events in tests
// ---------------------------------------------------------------------------

class _ControllableWsClient extends WsClient {
  final _ctrl = StreamController<WsEvent>.broadcast();

  void emit(WsEvent event) => _ctrl.add(event);

  @override
  Stream<WsEvent> get events => _ctrl.stream;

  @override
  Stream<WsConnectionState> get connectionState => const Stream.empty();

  @override
  Future<void> connect(String token) async {}

  @override
  Future<void> disconnect() async {}

  @override
  Future<void> dispose() async => _ctrl.close();
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

ProviderContainer _makeContainer({
  List<Map<String, dynamic>> messages = const [],
  _ControllableWsClient? ws,
}) {
  final fakeWs = ws ?? _ControllableWsClient();
  final container = ProviderContainer(
    overrides: [
      httpClientProvider.overrideWithValue(
        testDio({
          '/channels/ch-1/messages': messages,
        }),
      ),
      wsClientProvider.overrideWithValue(fakeWs),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('MessageList provider — initial fetch', () {
    test('returns empty list when server has no messages', () async {
      final container = _makeContainer();

      final result =
          await container.read(messageListProvider(channelId: 'ch-1').future);

      expect(result, isEmpty);
    });

    test('returns sorted messages from the server', () async {
      final msgs = [
        messageJson(id: 'msg-2', createdAt: '2024-01-01T12:01:00.000Z'),
        messageJson(id: 'msg-1', createdAt: '2024-01-01T12:00:00.000Z'),
      ];
      final container = _makeContainer(messages: msgs);

      final result =
          await container.read(messageListProvider(channelId: 'ch-1').future);

      expect(result.length, 2);
      expect(result[0].id, 'msg-1'); // sorted ascending by createdAt
      expect(result[1].id, 'msg-2');
    });

    test('parses message fields correctly', () async {
      final container = _makeContainer(
        messages: [
          messageJson(
            id: 'msg-1',
            text: 'Hello world',
            authorName: 'Alice',
          ),
        ],
      );

      final result =
          await container.read(messageListProvider(channelId: 'ch-1').future);
      final msg = result.first;

      expect(msg.id, 'msg-1');
      expect(msg.text, 'Hello world');
      expect(msg.authorName, 'Alice');
    });
  });

  group('MessageList provider — WebSocket: messageCreated', () {
    test('appends new message for the correct channel', () async {
      final ws = _ControllableWsClient();
      final container = _makeContainer(ws: ws);

      // Await initial load.
      await container.read(messageListProvider(channelId: 'ch-1').future);

      // Emit a WS event for this channel.
      ws.emit(
        WsEvent(
          type: WsEventType.messageCreated,
          payload: messageJson(id: 'msg-new', text: 'New message'),
        ),
      );

      await Future<void>.delayed(Duration.zero);

      final state = container.read(messageListProvider(channelId: 'ch-1'));
      final list = state.valueOrNull ?? [];
      expect(list.any((m) => m.id == 'msg-new'), isTrue);
    });

    test('ignores messageCreated events for different channels', () async {
      final ws = _ControllableWsClient();
      final container = _makeContainer(ws: ws);

      await container.read(messageListProvider(channelId: 'ch-1').future);

      // Emit for a different channel.
      ws.emit(
        WsEvent(
          type: WsEventType.messageCreated,
          payload: messageJson(id: 'msg-other', channelId: 'ch-99'),
        ),
      );

      await Future<void>.delayed(Duration.zero);

      final list =
          container.read(messageListProvider(channelId: 'ch-1')).valueOrNull ??
              [];
      expect(list.any((m) => m.id == 'msg-other'), isFalse);
    });
  });

  group('MessageList provider — WebSocket: messageUpdated', () {
    test('replaces the updated message in state', () async {
      final ws = _ControllableWsClient();
      final msgs = [messageJson(id: 'msg-1', text: 'Original')];
      final container = _makeContainer(messages: msgs, ws: ws);

      await container.read(messageListProvider(channelId: 'ch-1').future);

      ws.emit(
        WsEvent(
          type: WsEventType.messageUpdated,
          payload: messageJson(id: 'msg-1', text: 'Updated', edited: true),
        ),
      );

      await Future<void>.delayed(Duration.zero);

      final list =
          container.read(messageListProvider(channelId: 'ch-1')).valueOrNull ??
              [];
      final updated = list.firstWhere((m) => m.id == 'msg-1');
      expect(updated.text, 'Updated');
      expect(updated.editedAt, isNotNull);
    });
  });

  group('MessageList provider — WebSocket: messageDeleted', () {
    test('removes the deleted message from state', () async {
      final ws = _ControllableWsClient();
      final msgs = [
        messageJson(id: 'msg-1'),
        messageJson(id: 'msg-2'),
      ];
      final container = _makeContainer(messages: msgs, ws: ws);

      await container.read(messageListProvider(channelId: 'ch-1').future);

      ws.emit(
        WsEvent(
          type: WsEventType.messageDeleted,
          payload: {'id': 'msg-1'},
        ),
      );

      await Future<void>.delayed(Duration.zero);

      final list =
          container.read(messageListProvider(channelId: 'ch-1')).valueOrNull ??
              [];
      expect(list.any((m) => m.id == 'msg-1'), isFalse);
      expect(list.any((m) => m.id == 'msg-2'), isTrue);
    });

    test('ignores deletion with null id', () async {
      final ws = _ControllableWsClient();
      final msgs = [messageJson(id: 'msg-1')];
      final container = _makeContainer(messages: msgs, ws: ws);

      await container.read(messageListProvider(channelId: 'ch-1').future);

      ws.emit(
        WsEvent(
          type: WsEventType.messageDeleted,
          payload: {'id': null},
        ),
      );

      await Future<void>.delayed(Duration.zero);

      final list =
          container.read(messageListProvider(channelId: 'ch-1')).valueOrNull ??
              [];
      expect(list.length, 1);
    });
  });

  group('MessageList provider — sendMessage', () {
    test('posts to the correct endpoint', () async {
      final sentRequests = <String>[];
      final fakeDio = testDio({'/channels/ch-1/messages': <dynamic>[]});
      fakeDio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (opts, handler) {
            if (opts.method == 'POST') sentRequests.add(opts.path);
            handler.next(opts);
          },
        ),
      );

      final container = ProviderContainer(
        overrides: [
          httpClientProvider.overrideWithValue(fakeDio),
          wsClientProvider.overrideWithValue(FakeWsClient()),
        ],
      );
      addTearDown(container.dispose);

      await container.read(messageListProvider(channelId: 'ch-1').future);

      await container
          .read(messageListProvider(channelId: 'ch-1').notifier)
          .sendMessage('Hello');

      expect(sentRequests, contains('/channels/ch-1/messages'));
    });
  });
}
