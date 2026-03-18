import 'package:flutter/material.dart';

/// Typography scale for Relay.
///
/// System fonts: SF Pro (iOS), Roboto (Android), Inter (Web/Desktop).
/// Inter is bundled as a fallback for web/desktop via pubspec.yaml assets.
abstract final class RelayTypography {
  static const String _fontFamilyFallback = 'Inter';

  static TextTheme buildTextTheme(ColorScheme colorScheme) {
    final onSurface = colorScheme.onSurface;
    final muted = onSurface.withOpacity(0.6);

    return TextTheme(
      // Channel header — 18sp semibold
      titleLarge: TextStyle(
        fontFamily: _fontFamilyFallback,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      // Section labels, user names in sidebar
      titleMedium: TextStyle(
        fontFamily: _fontFamilyFallback,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleSmall: TextStyle(
        fontFamily: _fontFamilyFallback,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      // Message body — 15sp / 1.46 line-height
      bodyLarge: TextStyle(
        fontFamily: _fontFamilyFallback,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.46,
        color: onSurface,
      ),
      bodyMedium: TextStyle(
        fontFamily: _fontFamilyFallback,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),
      bodySmall: TextStyle(
        fontFamily: _fontFamilyFallback,
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),
      // Timestamps / metadata — 12sp muted
      labelSmall: TextStyle(
        fontFamily: _fontFamilyFallback,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: muted,
      ),
      labelMedium: TextStyle(
        fontFamily: _fontFamilyFallback,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
    );
  }
}
