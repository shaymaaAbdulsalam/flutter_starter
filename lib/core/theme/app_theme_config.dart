import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'tokens/app_borders.dart';

/// Fill treatment for text/select fields app-wide.
enum AppInputStyle { filled, outlined }

/// **Everything a project changes to rebrand the kit, in one value object.**
///
/// `AppTheme` reads *only* from this config and the derived [ColorScheme] —
/// no magic numbers live in the builder. To restyle an entire app you edit
/// the single config passed in `app.dart`:
///
/// ```dart
/// const config = AppThemeConfig(
///   seedColor: Color(0xFF0B6E4F),
///   fontFamily: 'Cairo',
///   inputStyle: AppInputStyle.outlined,
///   buttonRadius: AppBorders.full,          // pill buttons everywhere
/// );
/// ```
///
/// Color precedence: [lightScheme]/[darkScheme] (full brand palette) beat
/// [seedColor] + [schemeVariant] (derived).
class AppThemeConfig {
  const AppThemeConfig({
    // ── Color ────────────────────────────────────────────────────────────
    this.seedColor = const Color(0xFF5B5BD6),
    this.schemeVariant = DynamicSchemeVariant.content,
    this.lightScheme,
    this.darkScheme,
    this.lightAppColors = AppPalettes.light,
    this.darkAppColors = AppPalettes.dark,
    // ── Type ─────────────────────────────────────────────────────────────
    this.fontFamily,
    // ── Shape ────────────────────────────────────────────────────────────
    this.inputRadius = AppBorders.input,
    this.buttonRadius = AppBorders.button,
    this.cardRadius = AppBorders.card,
    this.chipRadius = AppBorders.chip,
    this.dialogRadius = AppBorders.dialog,
    this.bottomSheetRadius = AppBorders.bottomSheet,
    // ── Inputs ───────────────────────────────────────────────────────────
    this.inputStyle = AppInputStyle.filled,
    this.inputContentPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    this.inputBorderWidth = 1,
    this.inputFocusedBorderWidth = 2,
    // ── Buttons ──────────────────────────────────────────────────────────
    this.buttonMinimumSize = const Size(64, 52),
    this.buttonPadding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    // ── Chrome ───────────────────────────────────────────────────────────
    this.appBarCenterTitle = false,
    this.visualDensity,
  });

  /// Brand color. With [schemeVariant] = `content` (the default) the derived
  /// primary stays true to this hue instead of Material's muted tonal remap —
  /// the brand actually shows up in the UI.
  final Color seedColor;

  /// How `ColorScheme.fromSeed` interprets [seedColor]
  /// (`content`, `vibrant`, `expressive`, `tonalSpot`, …).
  final DynamicSchemeVariant schemeVariant;

  /// Full scheme overrides for projects with a complete brand palette.
  final ColorScheme? lightScheme;
  final ColorScheme? darkScheme;

  /// Semantic status colors (success / warning / info) per brightness.
  final AppColorsExtension lightAppColors;
  final AppColorsExtension darkAppColors;

  /// App-wide font family (declare it in pubspec). `null` = platform default.
  final String? fontFamily;

  final BorderRadius inputRadius;
  final BorderRadius buttonRadius;
  final BorderRadius cardRadius;
  final BorderRadius chipRadius;
  final BorderRadius dialogRadius;
  final BorderRadius bottomSheetRadius;

  final AppInputStyle inputStyle;
  final EdgeInsets inputContentPadding;
  final double inputBorderWidth;
  final double inputFocusedBorderWidth;

  final Size buttonMinimumSize;
  final EdgeInsets buttonPadding;

  /// Start-aligned titles by default — the kit's editorial app-bar voice.
  final bool appBarCenterTitle;

  final VisualDensity? visualDensity;

  AppThemeConfig copyWith({
    Color? seedColor,
    DynamicSchemeVariant? schemeVariant,
    ColorScheme? lightScheme,
    ColorScheme? darkScheme,
    AppColorsExtension? lightAppColors,
    AppColorsExtension? darkAppColors,
    String? fontFamily,
    BorderRadius? inputRadius,
    BorderRadius? buttonRadius,
    BorderRadius? cardRadius,
    BorderRadius? chipRadius,
    BorderRadius? dialogRadius,
    BorderRadius? bottomSheetRadius,
    AppInputStyle? inputStyle,
    EdgeInsets? inputContentPadding,
    double? inputBorderWidth,
    double? inputFocusedBorderWidth,
    Size? buttonMinimumSize,
    EdgeInsets? buttonPadding,
    bool? appBarCenterTitle,
    VisualDensity? visualDensity,
  }) {
    return AppThemeConfig(
      seedColor: seedColor ?? this.seedColor,
      schemeVariant: schemeVariant ?? this.schemeVariant,
      lightScheme: lightScheme ?? this.lightScheme,
      darkScheme: darkScheme ?? this.darkScheme,
      lightAppColors: lightAppColors ?? this.lightAppColors,
      darkAppColors: darkAppColors ?? this.darkAppColors,
      fontFamily: fontFamily ?? this.fontFamily,
      inputRadius: inputRadius ?? this.inputRadius,
      buttonRadius: buttonRadius ?? this.buttonRadius,
      cardRadius: cardRadius ?? this.cardRadius,
      chipRadius: chipRadius ?? this.chipRadius,
      dialogRadius: dialogRadius ?? this.dialogRadius,
      bottomSheetRadius: bottomSheetRadius ?? this.bottomSheetRadius,
      inputStyle: inputStyle ?? this.inputStyle,
      inputContentPadding: inputContentPadding ?? this.inputContentPadding,
      inputBorderWidth: inputBorderWidth ?? this.inputBorderWidth,
      inputFocusedBorderWidth:
          inputFocusedBorderWidth ?? this.inputFocusedBorderWidth,
      buttonMinimumSize: buttonMinimumSize ?? this.buttonMinimumSize,
      buttonPadding: buttonPadding ?? this.buttonPadding,
      appBarCenterTitle: appBarCenterTitle ?? this.appBarCenterTitle,
      visualDensity: visualDensity ?? this.visualDensity,
    );
  }
}
