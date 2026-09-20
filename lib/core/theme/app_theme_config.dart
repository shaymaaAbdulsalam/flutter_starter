import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'tokens/app_borders.dart';

enum AppInputStyle { filled, outlined }

class AppThemeConfig {
  const AppThemeConfig({
    this.seedColor = const Color(0xFF5B5BD6),
    this.schemeVariant = DynamicSchemeVariant.content,
    this.lightScheme,
    this.darkScheme,
    this.lightAppColors = AppPalettes.light,
    this.darkAppColors = AppPalettes.dark,
    this.fontFamily,
    this.inputRadius = AppBorders.input,
    this.buttonRadius = AppBorders.button,
    this.cardRadius = AppBorders.card,
    this.chipRadius = AppBorders.chip,
    this.dialogRadius = AppBorders.dialog,
    this.bottomSheetRadius = AppBorders.bottomSheet,
    this.inputStyle = AppInputStyle.filled,
    this.inputContentPadding =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    this.inputBorderWidth = 1,
    this.inputFocusedBorderWidth = 2,
    this.buttonMinimumSize = const Size(64, 52),
    this.buttonPadding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    this.appBarCenterTitle = false,
    this.visualDensity,
  });

  final Color seedColor;

  final DynamicSchemeVariant schemeVariant;

  final ColorScheme? lightScheme;
  final ColorScheme? darkScheme;

  final AppColorsExtension lightAppColors;
  final AppColorsExtension darkAppColors;

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
