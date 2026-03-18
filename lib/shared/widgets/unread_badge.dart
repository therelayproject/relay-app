import 'package:flutter/material.dart';

import '../../app/theme/color_palette.dart';

/// Unread message count badge (NOTIF-02).
class UnreadBadge extends StatelessWidget {
  const UnreadBadge({super.key, required this.count, this.isMention = false});

  final int count;

  /// When true, uses a mention highlight color instead of the default badge.
  final bool isMention;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final label = count > 99 ? '99+' : '$count';
    final bgColor = isMention
        ? RelayColors.error
        : theme.colorScheme.primary;

    return Semantics(
      label: '$count unread messages',
      child: Container(
        constraints: const BoxConstraints(
          minWidth: RelayColors.spacingMd,
          minHeight: RelayColors.spacingMd,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(RelayColors.radiusPill),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
