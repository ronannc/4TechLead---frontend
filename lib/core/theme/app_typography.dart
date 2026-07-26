import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography tokens for the design system — Inter, chosen for legibility on
/// dense data screens (dashboards, tables), the same rationale as most B2B
/// tooling (Linear, GitHub, Vercel). Regular (400) for body copy, Medium
/// (500) for labels/card titles, SemiBold (600) reserved for screen headers
/// — never a heavier weight in body text, it fatigues on data-dense screens.
class AppTypography {
  AppTypography._();

  static TextStyle _inter(double fontSize, FontWeight weight, {double? height}) =>
      GoogleFonts.inter(fontSize: fontSize, fontWeight: weight, height: height);

  static final displaySmall = _inter(28, FontWeight.w600, height: 1.15);
  static final titleLarge = _inter(22, FontWeight.w600, height: 1.2);
  static final titleMedium = _inter(18, FontWeight.w600, height: 1.25);
  static final titleSmall = _inter(16, FontWeight.w500, height: 1.3);
  static final bodyLarge = _inter(16, FontWeight.w400, height: 1.4);
  static final bodyMedium = _inter(14, FontWeight.w400, height: 1.4);
  static final bodySmall = _inter(12, FontWeight.w400, height: 1.4);
  static final labelLarge = _inter(14, FontWeight.w500, height: 1.2);
  static final labelMedium = _inter(12, FontWeight.w500, height: 1.2);
  static final labelSmall = _inter(11, FontWeight.w500, height: 1.2);
}
