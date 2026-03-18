import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/color_palette.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/relay_avatar.dart';
import '../../domain/models/message.dart';
import 'reaction_bar.dart';

/// Renders a single message (MSG-01/02/03/04/05).
class MessageBubble extends ConsumerWidget {
  const MessageBubble({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDeleted = message.deletedAt != null;

    if (isDeleted) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: RelayColors.spacingMd,
          vertical: RelayColors.spacingXs,
        ),
        child: Text(
          'This message was deleted.',
          style: theme.textTheme.bodySmall?.copyWith(
            fontStyle: FontStyle.italic,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Semantics(
      label:
          '${message.authorName} at ${DateFormatter.full(message.createdAt)}: ${message.text}',
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: RelayColors.spacingMd,
          vertical: RelayColors.spacingXs,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            RelayAvatar(
              displayName: message.authorName,
              avatarUrl: message.authorAvatarUrl,
              size: 36,
            ),
            const SizedBox(width: RelayColors.spacingSm),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author + timestamp
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          message.authorName,
                          style: theme.textTheme.titleSmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: RelayColors.spacingXs),
                      Text(
                        DateFormatter.messageTimestamp(message.createdAt),
                        style: theme.textTheme.labelSmall,
                      ),
                      if (message.editedAt != null) ...[
                        const SizedBox(width: RelayColors.spacingXs),
                        Text(
                          '(edited)',
                          style: theme.textTheme.labelSmall,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),

                  // Message text
                  SelectableText(
                    message.text,
                    style: theme.textTheme.bodyLarge,
                  ),

                  // Reactions
                  if (message.reactions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: RelayColors.spacingXs),
                      child: ReactionBar(
                        messageId: message.id,
                        reactions: message.reactions,
                      ),
                    ),

                  // Thread reply count — navigates to ThreadPanelScreen (THR-01)
                  if (message.replyCount > 0)
                    Padding(
                      padding:
                          const EdgeInsets.only(top: RelayColors.spacingXs),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(RelayColors.radiusSm),
                        onTap: () => _openThread(context),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: RelayColors.spacingXs,
                            vertical: 2,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 14,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${message.replyCount} '
                                '${message.replyCount == 1 ? 'reply' : 'replies'}',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openThread(BuildContext context) {
    // Navigate to thread panel (THR-01)
    context.push(
      '/app/thread/${message.threadId ?? message.id}',
      extra: {
        'channelId': message.channelId,
        'authorName': message.authorName,
        'authorAvatarUrl': message.authorAvatarUrl,
        'text': message.text,
        'createdAt': message.createdAt,
      },
    );
  }
}
