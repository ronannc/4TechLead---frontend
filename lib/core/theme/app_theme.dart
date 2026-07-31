import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';
import 'app_theme_extension.dart';
import 'app_typography.dart';

/// Builds the app's light and dark [ThemeData] from the design system's
/// color/typography/shape tokens. Widgets must consume these via
/// `Theme.of(context)` rather than the token classes directly.
class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(brightness: Brightness.light);

  static ThemeData dark() => _build(brightness: Brightness.dark);

  static ThemeData _build({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: isDark ? AppColors.accentDark : AppColors.accent,
      onPrimary: isDark ? AppColors.onAccentDark : AppColors.onAccent,
      secondary: isDark ? AppColors.accentDark : AppColors.accent,
      onSecondary: isDark ? AppColors.onAccentDark : AppColors.onAccent,
      error: isDark ? AppColors.errorDark : AppColors.error,
      onError: isDark ? AppColors.zinc950 : AppColors.surface,
      surface: isDark ? AppColors.surfaceDark : AppColors.surface,
      onSurface: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      surfaceContainerHighest: isDark ? AppColors.zinc800 : AppColors.zinc100,
      onSurfaceVariant: isDark
          ? AppColors.textSecondaryDark
          : AppColors.textSecondary,
      outline: isDark ? AppColors.borderDark : AppColors.border,
    );

    final textTheme = _textTheme(colorScheme.onSurface);
    final border = isDark ? AppColors.borderDark : AppColors.border;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.background,
      textTheme: textTheme,
      extensions: [
        AppThemeExtension(
          success: isDark ? AppColors.successDark : AppColors.success,
          warning: isDark ? AppColors.warningDark : AppColors.warning,
          border: border,
        ),
      ],
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + AppSpacing.xs,
        ),
        labelStyle: textTheme.bodyMedium,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          elevation: 0,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          side: BorderSide(color: border),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(textStyle: textTheme.labelLarge),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? AppColors.zinc800 : AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: border),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
        indicatorColor: colorScheme.primary.withValues(
          alpha: isDark ? 0.24 : 0.12,
        ),
        labelTextStyle: WidgetStateProperty.all(textTheme.labelSmall),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surface,
        indicatorColor: colorScheme.primary.withValues(
          alpha: isDark ? 0.24 : 0.12,
        ),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium,
      ),
      dividerTheme: DividerThemeData(color: border, space: 1),
    );
  }

  static TextTheme _textTheme(Color onSurface) {
    TextStyle apply(TextStyle style) => style.copyWith(color: onSurface);

    return TextTheme(
      displaySmall: apply(AppTypography.displaySmall),
      titleLarge: apply(AppTypography.titleLarge),
      titleMedium: apply(AppTypography.titleMedium),
      titleSmall: apply(AppTypography.titleSmall),
      bodyLarge: apply(AppTypography.bodyLarge),
      bodyMedium: apply(AppTypography.bodyMedium),
      bodySmall: apply(AppTypography.bodySmall),
      labelLarge: apply(AppTypography.labelLarge),
      labelMedium: apply(AppTypography.labelMedium),
      labelSmall: apply(AppTypography.labelSmall),
    );
  }
}
