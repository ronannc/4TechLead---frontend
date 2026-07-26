import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_theme_extension.dart';
import 'app_typography.dart';

/// Builds the app's light and dark [ThemeData] from the design system's
/// color/typography tokens. Widgets must consume these via `Theme.of(context)`
/// rather than the token classes directly.
class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(seedColor: AppColors.primary);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      textTheme: _textTheme,
      extensions: const [
        AppThemeExtension(success: AppColors.success, warning: AppColors.warning),
      ],
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surfaceDark,
      textTheme: _textTheme,
      extensions: const [
        AppThemeExtension(success: AppColors.successDark, warning: AppColors.warningDark),
      ],
    );
  }

  static const _textTheme = TextTheme(
    headlineMedium: AppTypography.heading1,
    titleLarge: AppTypography.heading2,
    titleMedium: AppTypography.heading3,
    bodyLarge: AppTypography.body,
    bodyMedium: AppTypography.bodyStrong,
    bodySmall: AppTypography.caption,
  );
}
