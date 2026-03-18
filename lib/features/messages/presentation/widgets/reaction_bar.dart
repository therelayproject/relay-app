import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/color_palette.dart';
import '../../../../core/api/http_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/models/reaction.dart';

/// Displays emoji reactions for a message (MSG-05).
class ReactionBar extends ConsumerWidget {
  const ReactionBar({
    super.key,
    required this.messageId,
    required this.reactions,
  });

  final String messageId;
  final List<Reaction> reactions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId =
        ref.watch(authStateProvider).valueOrNull?.user?.id;

    return Wrap(
      spacing: RelayColors.spacingXs,
      runSpacing: RelayColors.spacingXs,
      children: reactions
          .map(
            (r) => _ReactionChip(
              messageId: messageId,
              reaction: r,
              currentUserId: currentUserId,
            ),
          )
          .toList(),
    );
  }
}

class _ReactionChip extends ConsumerWidget {
  const _ReactionChip({
    required this.messageId,
    required this.reaction,
    required this.currentUserId,
  });

  final String messageId;
  final Reaction reaction;
  final String? currentUserId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isReacted =
        currentUserId != null && reaction.userIds.contains(currentUserId);

    return Semantics(
      label: '${reaction.emoji} reaction, ${reaction.count} people',
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(RelayColors.radiusPill),
        onTap: () => _toggleReaction(ref),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: RelayColors.spacingSm,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: isReacted
                ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                : theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(RelayColors.radiusPill),
            border: Border.all(
              color: isReacted
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(reaction.emoji, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 3),
              Text(
                '${reaction.count}',
                style: theme.textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleReaction(WidgetRef ref) async {
    final dio = ref.read(httpClientProvider);
    final currentUserId = ref.read(authStateProvider).valueOrNull?.user?.id;
    if (currentUserId == null) return;

    final isReacted = reaction.userIds.contains(currentUserId);
    try {
      if (isReacted) {
        await dio.delete<void>(
          '/messages/$messageId/reactions/${reaction.emoji}',
        );
      } else {
        await dio.post<void>(
          '/messages/$messageId/reactions',
          data: {'emoji': reaction.emoji},
        );
      }
    } catch (_) {
      // WebSocket event will reconcile state; no local optimistic update needed
    }
  }
}
