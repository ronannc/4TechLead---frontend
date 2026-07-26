import 'package:flutter/material.dart';

/// Color tokens for the design system: a near-monochrome zinc (grafite)
/// neutral scale with a single orange accent reserved for primary actions —
/// a "dev tool" palette (sober, dense-data-friendly) rather than a bright
/// consumer-app one. Widgets must read colors via `Theme.of(context)` (see
/// [AppTheme]) rather than referencing this class directly, so light/dark
/// mode is respected automatically.
class AppColors {
  AppColors._();

  // Accent (orange) — the only saturated color in the system, reserved for
  // primary actions/selection so it stays meaningful against the neutral base.
  static const accent = Color(0xFFEA580C);
  static const accentDark = Color(0xFFFB923C);
  static const onAccent = Color(0xFFFFFFFF);
  static const onAccentDark = Color(0xFF431407);

  // Neutrals (zinc scale) — background/surface/text/border tokens.
  static const zinc50 = Color(0xFFFAFAFA);
  static const zinc100 = Color(0xFFF4F4F5);
  static const zinc200 = Color(0xFFE4E4E7);
  static const zinc300 = Color(0xFFD4D4D8);
  static const zinc400 = Color(0xFFA1A1AA);
  static const zinc500 = Color(0xFF71717A);
  static const zinc700 = Color(0xFF3F3F46);
  static const zinc800 = Color(0xFF27272A);
  static const zinc900 = Color(0xFF18181B);
  static const zinc950 = Color(0xFF09090B);

  static const background = zinc50;
  static const surface = Color(0xFFFFFFFF);
  static const border = zinc200;
  static const textPrimary = zinc900;
  static const textSecondary = zinc500;

  static const backgroundDark = zinc950;
  static const surfaceDark = zinc900;
  static const borderDark = zinc700;
  static const textPrimaryDark = zinc50;
  static const textSecondaryDark = zinc400;

  // Semantic status colors — used sparingly (alerts, badges), never as the
  // primary action color.
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const error = Color(0xFFDC2626);

  static const successDark = Color(0xFF4ADE80);
  static const warningDark = Color(0xFFFBBF24);
  static const errorDark = Color(0xFFF87171);
}
