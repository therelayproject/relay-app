import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/api/ws_client.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

part 'realtime_provider.g.dart';

/// Manages the WebSocket lifecycle tied to auth state.
/// Connects on login, disconnects on logout.
@riverpod
class RealtimeSession extends _$RealtimeSession {
  @override
  WsConnectionState build() {
    final authAsync = ref.watch(authStateProvider);
    final ws = ref.watch(wsClientProvider);

    authAsync.whenData((session) {
      if (session.isAuthenticated) {
        // Connect using the token from secure storage (already set by auth flow)
        // The WsClient reads the token directly in connect()
        ws.connect('').catchError((_) {});
      } else {
        ws.disconnect();
      }
    });

    final sub = ws.connectionState.listen((state) {
      this.state = state;
    });
    ref.onDispose(sub.cancel);

    return WsConnectionState.disconnected;
  }
}
