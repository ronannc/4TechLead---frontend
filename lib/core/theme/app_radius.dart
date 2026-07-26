/// Border-radius tokens for the design system's shape language: small for
/// inputs/buttons, medium for cards, large for modals/bottom sheets. Kept
/// deliberately soft-but-not-round — sharp corners read as legacy/cold,
/// heavy rounding reads as consumer/playful; 8-12px is the B2B-tool norm.
class AppRadius {
  AppRadius._();

  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 20.0;
}
