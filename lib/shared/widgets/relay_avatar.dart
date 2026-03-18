import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../app/theme/color_palette.dart';

/// User/channel avatar widget (PRES-01, sidebar).
/// Shows [avatarUrl] if available; falls back to initials with a color derived
/// from [displayName].
class RelayAvatar extends StatelessWidget {
  const RelayAvatar({
    super.key,
    required this.displayName,
    this.avatarUrl,
    this.size = 36,
  });

  final String displayName;
  final String? avatarUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$displayName avatar',
      child: SizedBox.square(
        dimension: size,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(RelayColors.radiusSm),
          child: avatarUrl != null
              ? CachedNetworkImage(
                  imageUrl: avatarUrl!,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => _Initials(
                    name: displayName,
                    size: size,
                  ),
                  errorWidget: (_, __, ___) => _Initials(
                    name: displayName,
                    size: size,
                  ),
                )
              : _Initials(name: displayName, size: size),
        ),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.name, required this.size});
  final String name;
  final double size;

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  Color _bgColor() {
    // Deterministic color from name hash
    const colors = [
      Color(0xFF4A154B),
      Color(0xFF007A5A),
      Color(0xFF1264A3),
      Color(0xFF825C06),
      Color(0xFF7B2C2C),
    ];
    return colors[name.hashCode.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        color: _bgColor(),
        child: Center(
          child: Text(
            _initials,
            style: TextStyle(
              color: Colors.white,
              fontSize: size * 0.38,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}
