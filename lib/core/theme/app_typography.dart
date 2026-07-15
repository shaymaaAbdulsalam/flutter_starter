import 'package:flutter/material.dart';

/// The kit's type scale.
///
/// Size slots stay Material-3-compatible (so every Material widget picks the
/// right role), but the *voice* is modernized:
///   * display/headline get real weight (w700) and tight negative tracking —
///     the single biggest step away from the default-Material look;
///   * body gets a 1.5 line-height for comfortable reading;
///   * labels are w600 with a touch of positive tracking so buttons and chips
///     read crisp at small sizes.
///
/// Font family is applied by `AppTheme` from `AppThemeConfig.fontFamily` —
/// don't hardcode one here.
abstract final class AppTypography {
  AppTypography._();

  static const TextTheme textTheme = TextTheme(
    // ── Display — hero numbers, splash statements ─────────────────────────
    displayLarge: TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.5,
      height: 1.1,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      letterSpacing: -1,
      height: 1.15,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.75,
      height: 1.2,
    ),

    // ── Headline — page titles, section heroes ────────────────────────────
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      height: 1.25,
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
      height: 1.25,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      height: 1.3,
    ),

    // ── Title — cards, list headers, app bars ─────────────────────────────
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
      height: 1.3,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      height: 1.4,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      height: 1.4,
    ),

    // ── Body — reading text ────────────────────────────────────────────────
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.2,
      height: 1.45,
    ),

    // ── Label — buttons, chips, badges, tab bars ──────────────────────────
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
      height: 1.4,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
      height: 1.35,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
      height: 1.35,
    ),
  );
}
