import 'package:flutter/material.dart';

/// Semantic color tokens not covered by [ColorScheme] (success/warning),
/// exposed via `Theme.of(context).extension<AppThemeExtension>()`.
@immutable
class AppThemeExtension extends ThemeExtension<AppThemeExtension> {
  const AppThemeExtension({
    required this.success,
    required this.warning,
    required this.border,
  });

  final Color success;
  final Color warning;
  final Color border;

  @override
  AppThemeExtension copyWith({Color? success, Color? warning, Color? border}) {
    return AppThemeExtension(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      border: border ?? this.border,
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
      border: Color.lerp(border, other.border, t)!,
    );
  }
}
