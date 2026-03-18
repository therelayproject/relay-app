import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/ws_client.dart';
import '../../../auth/domain/models/user.dart';

part 'presence_provider.g.dart';

/// Maps userId → [UserPresence].  Updated in real-time from WebSocket (PRES-01).
@riverpod
class PresenceMap extends _$PresenceMap {
  @override
  Map<String, UserPresence> build() {
    final ws = ref.watch(wsClientProvider);
    final sub = ws.events
        .where((e) => e.type == WsEventType.userPresenceChanged)
        .listen(_onPresenceChanged);
    ref.onDispose(sub.cancel);
    return {};
  }

  void _onPresenceChanged(WsEvent event) {
    final userId = event.payload['userId'] as String?;
    final presenceStr = event.payload['presence'] as String?;
    if (userId == null || presenceStr == null) return;

    final presence = UserPresence.values.firstWhere(
      (p) => p.name == presenceStr,
      orElse: () => UserPresence.offline,
    );

    state = {...state, userId: presence};
  }

  UserPresence presenceOf(String userId) =>
      state[userId] ?? UserPresence.offline;
}
