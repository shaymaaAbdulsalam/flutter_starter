import 'package:flutter/material.dart';

export 'app_theme.dart';

/// Design-token theme extension, readable via `context.designTokens`.
///
/// Note: the app's [ThemeData] is built by `AppTheme.light/dark(AppThemeConfig)`
/// in `app_theme.dart` — that config object is the single place a project
/// edits to rebrand the kit.
class AppDesignTokens extends ThemeExtension<AppDesignTokens> {
  const AppDesignTokens({
    required this.paddingSmall,
    required this.paddingMedium,
    required this.paddingLarge,
    required this.borderRadiusSmall,
    required this.borderRadiusMedium,
    required this.borderRadiusLarge,
    required this.cardElevation,
  });

  final double paddingSmall;
  final double paddingMedium;
  final double paddingLarge;
  final double borderRadiusSmall;
  final double borderRadiusMedium;
  final double borderRadiusLarge;
  final double cardElevation;

  static const fallback = AppDesignTokens(
    paddingSmall: 8,
    paddingMedium: 16,
    paddingLarge: 24,
    borderRadiusSmall: 4,
    borderRadiusMedium: 12,
    borderRadiusLarge: 24,
    cardElevation: 0,
  );

  @override
  ThemeExtension<AppDesignTokens> copyWith({
    double? paddingSmall,
    double? paddingMedium,
    double? paddingLarge,
    double? borderRadiusSmall,
    double? borderRadiusMedium,
    double? borderRadiusLarge,
    double? cardElevation,
  }) {
    return AppDesignTokens(
      paddingSmall: paddingSmall ?? this.paddingSmall,
      paddingMedium: paddingMedium ?? this.paddingMedium,
      paddingLarge: paddingLarge ?? this.paddingLarge,
      borderRadiusSmall: borderRadiusSmall ?? this.borderRadiusSmall,
      borderRadiusMedium: borderRadiusMedium ?? this.borderRadiusMedium,
      borderRadiusLarge: borderRadiusLarge ?? this.borderRadiusLarge,
      cardElevation: cardElevation ?? this.cardElevation,
    );
  }

  @override
  ThemeExtension<AppDesignTokens> lerp(
    covariant ThemeExtension<AppDesignTokens>? other,
    double t,
  ) {
    if (other is! AppDesignTokens) return this;
    double lerpDouble(double a, double b) => a + (b - a) * t;
    return AppDesignTokens(
      paddingSmall: lerpDouble(paddingSmall, other.paddingSmall),
      paddingMedium: lerpDouble(paddingMedium, other.paddingMedium),
      paddingLarge: lerpDouble(paddingLarge, other.paddingLarge),
      borderRadiusSmall:
          lerpDouble(borderRadiusSmall, other.borderRadiusSmall),
      borderRadiusMedium:
          lerpDouble(borderRadiusMedium, other.borderRadiusMedium),
      borderRadiusLarge:
          lerpDouble(borderRadiusLarge, other.borderRadiusLarge),
      cardElevation: lerpDouble(cardElevation, other.cardElevation),
    );
  }
}
