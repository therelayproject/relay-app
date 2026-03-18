import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../config/app_config.dart';

part 'ws_client.g.dart';

// ── Event model ──────────────────────────────────────────────────────────────

/// Strongly-typed WebSocket event.
class WsEvent {
  const WsEvent({required this.type, required this.payload});

  final String type;
  final Map<String, dynamic> payload;

  factory WsEvent.fromJson(Map<String, dynamic> json) => WsEvent(
        type: json['type'] as String,
        payload: (json['payload'] as Map<String, dynamic>?) ?? {},
      );
}

// ── Known event type constants ────────────────────────────────────────────────

abstract final class WsEventType {
  static const String messageCreated = 'message.created';
  static const String messageUpdated = 'message.updated';
  static const String messageDeleted = 'message.deleted';
  static const String reactionAdded = 'reaction.added';
  static const String reactionRemoved = 'reaction.removed';
  static const String userPresenceChanged = 'user.presence_changed';
  static const String userTyping = 'user.typing';
  static const String channelMemberJoined = 'channel.member_joined';
  static const String notificationPush = 'notification.push';
}

// ── Client ───────────────────────────────────────────────────────────────────

enum WsConnectionState { disconnected, connecting, connected, reconnecting }

/// WebSocket client with HTTP long-poll fallback.
///
/// Consumers watch [WsClient.events] for a broadcast stream of [WsEvent]s.
class WsClient {
  WsClient();

  WebSocketChannel? _channel;
  StreamController<WsEvent>? _controller;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;

  String? _token;
  int _reconnectAttempts = 0;
  bool _disposed = false;

  final _stateController =
      StreamController<WsConnectionState>.broadcast();

  Stream<WsEvent> get events => _controller!.stream;
  Stream<WsConnectionState> get connectionState => _stateController.stream;

  Future<void> connect(String token) async {
    _token = token;
    _controller ??= StreamController<WsEvent>.broadcast();
    _reconnectAttempts = 0;
    await _doConnect();
  }

  Future<void> _doConnect() async {
    _stateController.add(WsConnectionState.connecting);

    try {
      final uri = Uri.parse(
        '${AppConfig.wsBaseUrl}/ws?token=$_token',
      );
      _channel = WebSocketChannel.connect(uri);
      await _channel!.ready;

      _stateController.add(WsConnectionState.connected);
      _reconnectAttempts = 0;
      _startHeartbeat();

      _channel!.stream.listen(
        _onMessage,
        onError: _onError,
        onDone: _onDone,
      );
    } catch (e) {
      debugPrint('[WS] Connection failed: $e');
      _scheduleReconnect();
    }
  }

  void _onMessage(dynamic raw) {
    try {
      final json = jsonDecode(raw as String) as Map<String, dynamic>;
      _controller?.add(WsEvent.fromJson(json));
    } catch (e) {
      debugPrint('[WS] Parse error: $e');
    }
  }

  void _onError(Object error) {
    debugPrint('[WS] Error: $error');
    _scheduleReconnect();
  }

  void _onDone() {
    if (!_disposed) {
      _stateController.add(WsConnectionState.reconnecting);
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    final delay = Duration(
      seconds: (1 << _reconnectAttempts.clamp(0, 6)),
    );
    _reconnectAttempts++;
    _reconnectTimer = Timer(delay, _doConnect);
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      send(const WsMessage(type: 'ping', payload: {}));
    });
  }

  void send(WsMessage message) {
    _channel?.sink.add(jsonEncode(message.toJson()));
  }

  Future<void> disconnect() async {
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    await _channel?.sink.close();
    _channel = null;
    _stateController.add(WsConnectionState.disconnected);
  }

  Future<void> dispose() async {
    _disposed = true;
    await disconnect();
    await _controller?.close();
    await _stateController.close();
  }
}

class WsMessage {
  const WsMessage({required this.type, required this.payload});
  final String type;
  final Map<String, dynamic> payload;

  Map<String, dynamic> toJson() => {'type': type, 'payload': payload};
}

// ── Provider ─────────────────────────────────────────────────────────────────

@riverpod
WsClient wsClient(Ref ref) {
  final client = WsClient();
  ref.onDispose(client.dispose);
  return client;
}
