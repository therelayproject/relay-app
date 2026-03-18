import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/color_palette.dart';
import '../../../../shared/widgets/typing_indicator.dart';
import '../../../../shared/widgets/unread_badge.dart';
import '../../../messages/presentation/providers/messages_provider.dart';
import '../../../messages/presentation/providers/typing_provider.dart';
import '../../../messages/presentation/widgets/message_bubble.dart';
import '../../../messages/presentation/widgets/message_composer.dart';
import '../../../notifications/presentation/providers/notifications_provider.dart';

class ChannelFeedScreen extends ConsumerWidget {
  const ChannelFeedScreen({
    super.key,
    required this.workspaceId,
    this.channelId,
  });

  final String workspaceId;
  final String? channelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (channelId == null) {
      return const _NoChannelSelected();
    }
    return _ChannelView(workspaceId: workspaceId, channelId: channelId!);
  }
}

class _NoChannelSelected extends StatelessWidget {
  const _NoChannelSelected();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.tag,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: RelayColors.spacingMd),
              Text(
                'Select a channel',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      );
}

class _ChannelView extends ConsumerWidget {
  const _ChannelView({
    required this.workspaceId,
    required this.channelId,
  });

  final String workspaceId;
  final String channelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(
      messageListProvider(channelId: channelId),
    );
    final typingUsers = ref.watch(
      typingUsersProvider(channelId: channelId),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('#$channelId'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/app/search'),
            tooltip: 'Search',
          ),
          Consumer(
            builder: (context, ref, _) {
              final unread = ref.watch(unreadNotificationCountProvider);
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () => context.push('/app/notifications'),
                    tooltip: 'Notifications',
                  ),
                  if (unread > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: UnreadBadge(count: unread),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () =>
                context.push('/app/$workspaceId/$channelId/settings'),
            tooltip: 'Channel details',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (messages) => messages.isEmpty
                  ? _EmptyChannel(channelId: channelId)
                  : ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        vertical: RelayColors.spacingSm,
                      ),
                      itemCount: messages.length,
                      itemBuilder: (context, index) => MessageBubble(
                        message: messages[messages.length - 1 - index],
                      ),
                    ),
            ),
          ),
          // Live typing indicator (PRES-02)
          TypingIndicator(typingUserNames: typingUsers),
          MessageComposer(channelId: channelId),
        ],
      ),
    );
  }
}

class _EmptyChannel extends StatelessWidget {
  const _EmptyChannel({required this.channelId});
  final String channelId;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(RelayColors.spacingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.tag, size: 48),
              const SizedBox(height: RelayColors.spacingMd),
              Text(
                'This is the beginning of #$channelId',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}
