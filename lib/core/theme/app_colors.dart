import 'package:flutter/material.dart';

/// Color tokens for the design system. Widgets should read colors via
/// `Theme.of(context)` (see [AppTheme]) rather than referencing this class
/// directly, so light/dark mode is respected automatically.
class AppColors {
  AppColors._();

  static const primary = Color(0xFF2E5AAC);
  static const secondary = Color(0xFF6C63FF);
  static const surface = Color(0xFFFFFFFF);
  static const error = Color(0xFFB3261E);
  static const textPrimary = Color(0xFF1A1C1E);
  static const textSecondary = Color(0xFF5F6368);
  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFED6C02);

  static const surfaceDark = Color(0xFF121212);
  static const textPrimaryDark = Color(0xFFE3E2E6);
  static const textSecondaryDark = Color(0xFFA9ACB0);
  static const successDark = Color(0xFF66BB6A);
  static const warningDark = Color(0xFFFFA726);
}
