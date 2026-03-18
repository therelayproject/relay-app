import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/color_palette.dart';
import '../../../auth/domain/models/user.dart';
import '../providers/presence_provider.dart';

/// Green dot / status indicator for a user (PRES-01).
class PresenceIndicator extends ConsumerWidget {
  const PresenceIndicator({
    super.key,
    required this.userId,
    this.size = 10,
  });

  final String userId;
  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presence = ref.watch(
      presenceMapProvider.select((map) => map[userId] ?? UserPresence.offline),
    );

    final color = _colorFor(presence, Theme.of(context).colorScheme);
    if (color == null) return const SizedBox.shrink();

    return Semantics(
      label: '${presence.name} status',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Theme.of(context).colorScheme.surface,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Color? _colorFor(UserPresence presence, ColorScheme scheme) =>
      switch (presence) {
        UserPresence.online => RelayColors.presenceGreenLight,
        UserPresence.away => const Color(0xFFECB22E), // amber
        UserPresence.dnd => RelayColors.error,
        UserPresence.offline => null, // no dot for offline
      };
}
