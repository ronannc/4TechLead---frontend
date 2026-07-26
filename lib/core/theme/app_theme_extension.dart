import 'package:flutter/material.dart';

/// Semantic color tokens not covered by [ColorScheme] (success/warning),
/// exposed via `Theme.of(context).extension<AppThemeExtension>()`.
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({required this.success, required this.warning});

  final Color success;
  final Color warning;

  @override
  AppThemeExtension copyWith({Color? success, Color? warning}) {
    return AppThemeExtension(
      success: success ?? this.success,
      warning: warning ?? this.warning,
    );
  }

  @override
  AppThemeExtension lerp(ThemeExtension<AppThemeExtension>? other, double t) {
    if (other is! AppThemeExtension) {
      return this;
    }

    return AppThemeExtension(
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}
