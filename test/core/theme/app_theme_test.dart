import 'package:flutter/material.dart';
import 'package:flutter_starter/core/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    test('builds light and dark from the same config (parity is structural)',
        () {
      const config = AppThemeConfig(seedColor: Color(0xFF0B6E4F));
      final light = AppTheme.light(config);
      final dark = AppTheme.dark(config);

      expect(light.brightness, Brightness.light);
      expect(dark.brightness, Brightness.dark);
      // Both carry the semantic extension.
      expect(light.extension<AppColorsExtension>(), isNotNull);
      expect(dark.extension<AppColorsExtension>(), isNotNull);
    });

    test('config knobs actually propagate into component themes', () {
      const config = AppThemeConfig(
        buttonRadius: AppBorders.full,
        inputStyle: AppInputStyle.outlined,
        appBarCenterTitle: true,
      );
      final theme = AppTheme.light(config);

      final buttonShape = theme.filledButtonTheme.style!.shape!
          .resolve({}) as RoundedRectangleBorder;
      expect(buttonShape.borderRadius, AppBorders.full);

      expect(theme.inputDecorationTheme.filled, isFalse);
      expect(theme.appBarTheme.centerTitle, isTrue);
    });

    test('full scheme override beats the seed', () {
      final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFFB00020));
      final theme = AppTheme.light(AppThemeConfig(lightScheme: scheme));
      expect(theme.colorScheme, scheme);
    });

    test('no elevation tint smear: surfaces keep transparent surfaceTint', () {
      final theme = AppTheme.light();
      expect(theme.appBarTheme.surfaceTintColor, Colors.transparent);
      expect(theme.cardTheme.surfaceTintColor, Colors.transparent);
      expect(theme.appBarTheme.scrolledUnderElevation, 0);
    });
  });
}
