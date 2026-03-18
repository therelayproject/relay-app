import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/api/http_client.dart';
import '../../../../core/api/ws_client.dart';

part 'notifications_provider.g.dart';

/// Notification settings for a single channel.
class ChannelNotificationPrefs {
  const ChannelNotificationPrefs({
    required this.channelId,
    required this.channelName,
    required this.level,
  });

  final String channelId;
  final String channelName;

  /// Notification level: 'all', 'mentions', 'muted'.
  final String level;

  factory ChannelNotificationPrefs.fromJson(Map<String, dynamic> json) =>
      ChannelNotificationPrefs(
        channelId: json['channelId'] as String,
        channelName: json['channelName'] as String? ?? json['channelId'] as String,
        level: json['level'] as String? ?? 'all',
      );

  ChannelNotificationPrefs copyWith({String? level}) =>
      ChannelNotificationPrefs(
        channelId: channelId,
        channelName: channelName,
        level: level ?? this.level,
      );
}

/// Notification preference icon labels.
extension NotifLevelLabel on String {
  String get label => switch (this) {
        'all' => 'All messages',
        'mentions' => 'Mentions only',
        'muted' => 'Muted',
        _ => this,
      };
}

/// In-app notification item (NOTIF-01).
class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.createdAt,
    this.channelId,
    this.messageId,
    this.isRead = false,
  });

  final String id;

  /// 'mention', 'thread_reply', 'dm', etc.
  final String type;
  final String title;
  final String body;
  final DateTime createdAt;
  final String? channelId;
  final String? messageId;
  final bool isRead;

  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      AppNotification(
        id: json['id'] as String,
        type: json['type'] as String? ?? 'mention',
        title: json['title'] as String,
        body: json['body'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        channelId: json['channelId'] as String?,
        messageId: json['messageId'] as String?,
        isRead: json['isRead'] as bool? ?? false,
      );
}

/// Provides the current user's in-app notifications list (NOTIF-01).
///
/// Updates in real-time via WebSocket when new notifications arrive.
@riverpod
class NotificationList extends _$NotificationList {
  @override
  Future<List<AppNotification>> build() async {
    final notifications = await _fetch();

    // Subscribe to real-time notification events
    final ws = ref.watch(wsClientProvider);
    final sub = ws.events
        .where((e) => e.type == WsEventType.notificationCreated)
        .listen((_) => ref.invalidateSelf());
    ref.onDispose(sub.cancel);

    return notifications;
  }

  Future<List<AppNotification>> _fetch() async {
    final dio = ref.read(httpClientProvider);
    final resp = await dio.get<List<dynamic>>('/notifications');
    return (resp.data ?? [])
        .cast<Map<String, dynamic>>()
        .map(AppNotification.fromJson)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> markRead(String notificationId) async {
    final dio = ref.read(httpClientProvider);
    await dio.patch<void>('/notifications/$notificationId/read');
    state.whenData((list) {
      state = AsyncData([
        for (final n in list)
          if (n.id == notificationId)
            AppNotification(
              id: n.id,
              type: n.type,
              title: n.title,
              body: n.body,
              createdAt: n.createdAt,
              channelId: n.channelId,
              messageId: n.messageId,
              isRead: true,
            )
          else
            n,
      ]);
    });
  }

  Future<void> markAllRead() async {
    final dio = ref.read(httpClientProvider);
    await dio.post<void>('/notifications/read-all');
    ref.invalidateSelf();
  }
}

/// Total count of unread notifications (NOTIF-01).
@riverpod
int unreadNotificationCount(Ref ref) {
  final notifications = ref.watch(notificationListProvider);
  return notifications.valueOrNull
          ?.where((n) => !n.isRead)
          .length ??
      0;
}

/// Per-channel notification preferences (NOTIF-02/03).
@riverpod
Future<List<ChannelNotificationPrefs>> channelNotificationPrefs(
  Ref ref, {
  required String workspaceId,
}) async {
  final dio = ref.watch(httpClientProvider);
  final resp = await dio.get<List<dynamic>>(
    '/workspaces/$workspaceId/notification-prefs',
  );
  return (resp.data ?? [])
      .cast<Map<String, dynamic>>()
      .map(ChannelNotificationPrefs.fromJson)
      .toList();
}

/// Updates notification level for a single channel.
@riverpod
Future<void> updateChannelNotificationPref(
  Ref ref, {
  required String workspaceId,
  required String channelId,
  required String level,
}) async {
  final dio = ref.watch(httpClientProvider);
  await dio.patch<void>(
    '/workspaces/$workspaceId/notification-prefs/$channelId',
    data: {'level': level},
  );
  ref.invalidate(channelNotificationPrefsProvider(workspaceId: workspaceId));
}
