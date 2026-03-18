import 'package:flutter/material.dart';

import 'color_palette.dart';
import 'typography.dart';

/// Builds [ThemeData] for light and dark modes.
abstract final class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: RelayColors.primaryLight,
      onPrimary: RelayColors.onPrimaryLight,
      primaryContainer: RelayColors.primaryContainerLight,
      onPrimaryContainer: RelayColors.onPrimaryLight,
      secondary: RelayColors.presenceGreenLight,
      onSecondary: Colors.white,
      secondaryContainer: RelayColors.presenceGreenLight.withOpacity(0.15),
      onSecondaryContainer: RelayColors.presenceGreenLight,
      surface: RelayColors.surfaceLight,
      onSurface: const Color(0xFF1D1C1D),
      surfaceContainerHighest: RelayColors.surfaceVariantLight,
      onSurfaceVariant: const Color(0xFF616061),
      error: RelayColors.error,
      onError: Colors.white,
      errorContainer: RelayColors.error.withOpacity(0.15),
      onErrorContainer: RelayColors.error,
      outline: const Color(0xFFDDDBDB),
      shadow: Colors.black26,
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: RelayColors.primaryDark,
      onPrimary: RelayColors.onPrimaryDark,
      primaryContainer: RelayColors.primaryContainerDark,
      onPrimaryContainer: RelayColors.onPrimaryDark,
      secondary: RelayColors.presenceGreenDark,
      onSecondary: Colors.black,
      secondaryContainer: RelayColors.presenceGreenDark.withOpacity(0.15),
      onSecondaryContainer: RelayColors.presenceGreenDark,
      surface: RelayColors.surfaceDark,
      onSurface: RelayColors.onPrimaryDark,
      surfaceContainerHighest: RelayColors.surfaceVariantDark,
      onSurfaceVariant: const Color(0xFF868686),
      error: RelayColors.error,
      onError: Colors.white,
      errorContainer: RelayColors.error.withOpacity(0.15),
      onErrorContainer: RelayColors.error,
      outline: const Color(0xFF383838),
      shadow: Colors.black54,
    );

    return _buildTheme(colorScheme);
  }

  static ThemeData _buildTheme(ColorScheme colorScheme) {
    final textTheme = RelayTypography.buildTextTheme(colorScheme);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          color: colorScheme.onPrimary,
        ),
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RelayColors.radiusMd),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RelayColors.radiusMd),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: RelayColors.spacingMd,
          vertical: RelayColors.spacingSm,
        ),
      ),

      // Elevated buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          minimumSize: const Size(0, RelayColors.minTouchTarget),
          padding: const EdgeInsets.symmetric(
            horizontal: RelayColors.spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RelayColors.radiusMd),
          ),
        ),
      ),

      // Dividers
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
        space: 1,
      ),

      // Chips (emoji reactions)
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primaryContainer.withOpacity(0.3),
        side: BorderSide(color: colorScheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RelayColors.radiusPill),
        ),
      ),
    );
  }
}
