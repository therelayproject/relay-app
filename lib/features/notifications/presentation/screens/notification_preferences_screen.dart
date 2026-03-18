import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/color_palette.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../features/workspaces/presentation/providers/workspace_provider.dart';
import '../providers/notifications_provider.dart';

/// In-app notification list + per-channel preferences (NOTIF-01/02/03).
class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            Consumer(
              builder: (context, ref, _) {
                final unread = ref.watch(unreadNotificationCountProvider);
                return unread > 0
                    ? TextButton(
                        onPressed: () => ref
                            .read(notificationListProvider.notifier)
                            .markAllRead(),
                        child: const Text('Mark all read'),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Inbox'),
              Tab(text: 'Preferences'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _NotificationInbox(),
            _NotificationPreferences(),
          ],
        ),
      ),
    );
  }
}

// ─── Notification Inbox ──────────────────────────────────────────────────────

class _NotificationInbox extends ConsumerWidget {
  const _NotificationInbox();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationListProvider);

    return notificationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (notifications) {
        if (notifications.isEmpty) {
          return const Center(child: _EmptyInbox());
        }
        return ListView.separated(
          itemCount: notifications.length,
          separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
          itemBuilder: (context, index) {
            final notif = notifications[index];
            return _NotificationTile(notification: notif);
          },
        );
      },
    );
  }
}

class _EmptyInbox extends StatelessWidget {
  const _EmptyInbox();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(RelayColors.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_none,
                size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: RelayColors.spacingMd),
            Text("You're all caught up!",
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: RelayColors.spacingSm),
            Text(
              'No new notifications.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      );
}

class _NotificationTile extends ConsumerWidget {
  const _NotificationTile({required this.notification});
  final AppNotification notification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isUnread = !notification.isRead;

    return InkWell(
      onTap: () {
        if (isUnread) {
          ref
              .read(notificationListProvider.notifier)
              .markRead(notification.id);
        }
      },
      child: Container(
        color: isUnread
            ? theme.colorScheme.primaryContainer.withOpacity(0.15)
            : null,
        padding: const EdgeInsets.symmetric(
          horizontal: RelayColors.spacingMd,
          vertical: RelayColors.spacingSm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification type icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _iconFor(notification.type),
                size: 18,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: RelayColors.spacingSm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: isUnread
                                ? FontWeight.w700
                                : FontWeight.normal,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        DateFormatter.messageTimestamp(notification.createdAt),
                        style: theme.textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notification.body,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (isUnread)
              Padding(
                padding: const EdgeInsets.only(
                    left: RelayColors.spacingXs, top: RelayColors.spacingXs),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String type) => switch (type) {
        'mention' => Icons.alternate_email,
        'thread_reply' => Icons.chat_bubble_outline,
        'dm' => Icons.mail_outline,
        'reaction' => Icons.emoji_emotions_outlined,
        _ => Icons.notifications_outlined,
      };
}

// ─── Notification Preferences ────────────────────────────────────────────────

class _NotificationPreferences extends ConsumerWidget {
  const _NotificationPreferences();

  static const _levels = ['all', 'mentions', 'muted'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspace = ref.watch(currentWorkspaceProvider);

    if (workspace == null) {
      return const Center(child: Text('No workspace selected'));
    }

    final prefsAsync = ref.watch(
      channelNotificationPrefsProvider(workspaceId: workspace.id),
    );

    return prefsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (prefs) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(RelayColors.spacingMd),
            child: Text(
              'Choose how you are notified for each channel.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: prefs.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: RelayColors.spacingMd),
              itemBuilder: (context, index) {
                final pref = prefs[index];
                return ListTile(
                  title: Text('#${pref.channelName}'),
                  trailing: DropdownButton<String>(
                    value: pref.level,
                    underline: const SizedBox.shrink(),
                    items: _levels
                        .map(
                          (l) => DropdownMenuItem(
                            value: l,
                            child: Text(l.label),
                          ),
                        )
                        .toList(),
                    onChanged: (newLevel) {
                      if (newLevel != null) {
                        ref.read(
                          updateChannelNotificationPrefProvider(
                            workspaceId: workspace.id,
                            channelId: pref.channelId,
                            level: newLevel,
                          ).future,
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
