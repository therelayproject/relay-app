import 'package:flutter/material.dart';

/// Design token color palette (Slack-inspired).
/// Semantic tokens should be read from [AppTheme.light] / [AppTheme.dark]
/// via [Theme.of(context).colorScheme].  Access raw tokens only in theme
/// construction or when a semantic token is unavailable.
abstract final class RelayColors {
  // ── Light ───────────────────────────────────────────────────────────────
  static const Color primaryLight = Color(0xFF4A154B); // aubergine
  static const Color primaryContainerLight = Color(0xFF611F69);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceVariantLight = Color(0xFFF8F8F8);
  static const Color onPrimaryLight = Color(0xFFFFFFFF);

  // ── Dark ────────────────────────────────────────────────────────────────
  static const Color primaryDark = Color(0xFF1A1D21);
  static const Color primaryContainerDark = Color(0xFF222529);
  static const Color surfaceDark = Color(0xFF1A1D21);
  static const Color surfaceVariantDark = Color(0xFF222529);
  static const Color onPrimaryDark = Color(0xFFD1D2D3);

  // ── Semantic (shared) ───────────────────────────────────────────────────
  static const Color presenceGreenLight = Color(0xFF007A5A);
  static const Color presenceGreenDark = Color(0xFF38978D);
  static const Color error = Color(0xFFE01E5A);
  static const Color mentionHighlightLight = Color(0xFFFCF4D9);
  static const Color mentionHighlightDark = Color(0xFF3D3520);
  static const Color unreadBoldLight = Color(0xFF1D1C1D);
  static const Color unreadBoldDark = Color(0xFFFFFFFF);

  // ── Spacing tokens ──────────────────────────────────────────────────────
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;

  // ── Border radius ───────────────────────────────────────────────────────
  static const double radiusSm = 4;
  static const double radiusMd = 8;
  static const double radiusLg = 12;
  static const double radiusPill = 100;

  // ── Touch target minimum (WCAG 2.1 AA) ─────────────────────────────────
  static const double minTouchTarget = 44;
}
