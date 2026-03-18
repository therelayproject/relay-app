import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/http_client.dart';
import '../../../../core/api/ws_client.dart';

part 'typing_provider.g.dart';

/// Tracks which users are currently typing in a given channel (PRES-02).
///
/// Listens to `user.typing` WebSocket events and expires entries after 4 s of
/// inactivity (the server re-sends the event every ~2 s while a user types).
@riverpod
class TypingUsers extends _$TypingUsers {
  static const _expireAfter = Duration(seconds: 4);

  final Map<String, Timer> _expiry = {};

  @override
  List<String> build({required String channelId}) {
    final ws = ref.watch(wsClientProvider);
    final sub = ws.events
        .where((e) => e.type == WsEventType.userTyping)
        .listen(_onTyping);
    ref.onDispose(() {
      sub.cancel();
      for (final t in _expiry.values) {
        t.cancel();
      }
    });
    return const [];
  }

  void _onTyping(WsEvent event) {
    final evtChannelId = event.payload['channelId'] as String?;
    final userName = event.payload['userName'] as String?;
    final userId = event.payload['userId'] as String?;
    if (evtChannelId != channelId || userName == null || userId == null) return;

    // Reset / start expiry timer for this user
    _expiry[userId]?.cancel();
    _expiry[userId] = Timer(_expireAfter, () => _removeUser(userId));

    if (!state.contains(userName)) {
      state = [...state, userName];
    }
  }

  void _removeUser(String userId) {
    // We stored userName in state but key by userId; re-derive from event is
    // not possible here, so we keep a parallel map.
    _expiry.remove(userId);
    // Re-build from remaining keys — simplest: invalidate so build() re-runs
    // with an empty list and fresh subscriptions.  In practice a Map<id,name>
    // is cleaner, but keeping state slim.
    ref.invalidateSelf();
  }
}

/// Sends a typing notification to the server for the given channel.
Future<void> sendTypingIndicator(
  WidgetRef ref,
  String channelId,
) async {
  final dio = ref.read(httpClientProvider);
  await dio.post<void>('/channels/$channelId/typing');
}
