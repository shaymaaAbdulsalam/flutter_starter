import 'package:flutter/material.dart';

import 'app_borders.dart';
import 'color_schemes.dart';
import 'text_theme.dart';
import 'theme.dart';

/// Everything a project changes to rebrand the kit, in one value object.
///
/// The component themes in [AppTheme] read *only* from this config and the
/// derived [ColorScheme] — no magic numbers inside the builder. To restyle an
/// entire app you edit the single `AppThemeConfig` passed in `app.dart`:
///
/// ```dart
/// const config = AppThemeConfig(
///   seedColor: Color(0xFF0B6E4F),
///   fontFamily: 'Cairo',
///   inputStyle: AppInputStyle.outlined,
///   buttonRadius: AppBorders.full,        // pill buttons everywhere
/// );
/// MaterialApp(theme: AppTheme.light(config), darkTheme: AppTheme.dark(config));
/// ```
///
/// Precedence for colors: [lightScheme]/[darkScheme] (full control) beat
/// [seedColor] (derived via `ColorScheme.fromSeed`).
class AppThemeConfig {
  const AppThemeConfig({
    this.seedColor = const Color(0xFF6750A4),
    this.lightScheme,
    this.darkScheme,
    this.lightAppColors = AppPalettes.light,
    this.darkAppColors = AppPalettes.dark,
    this.fontFamily,
    // Shape
    this.inputRadius = AppBorders.input,
    this.buttonRadius = AppBorders.button,
    this.cardRadius = AppBorders.card,
    this.chipRadius = AppBorders.sm,
    this.dialogRadius = AppBorders.dialog,
    this.bottomSheetRadius = AppBorders.bottomSheet,
    // Inputs
    this.inputStyle = AppInputStyle.filled,
    this.inputContentPadding =
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    this.inputBorderWidth = 1,
    this.inputFocusedBorderWidth = 2,
    // Buttons
    this.buttonMinimumSize = const Size(88, 48),
    this.buttonPadding =
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    // Density
    this.visualDensity,
  });

  /// Brand color the Material 3 palette is derived from (via
  /// `ColorScheme.fromSeed`) when no explicit scheme is given.
  final Color seedColor;

  /// Full scheme overrides for projects with a complete brand palette.
  final ColorScheme? lightScheme;
  final ColorScheme? darkScheme;

  /// Semantic colors (success / warning / info) per brightness.
  final AppColorsExtension lightAppColors;
  final AppColorsExtension darkAppColors;

  /// App-wide font family (must be declared in pubspec). `null` = platform.
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

  final VisualDensity? visualDensity;

  AppThemeConfig copyWith({
    Color? seedColor,
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
    VisualDensity? visualDensity,
  }) {
    return AppThemeConfig(
      seedColor: seedColor ?? this.seedColor,
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
      visualDensity: visualDensity ?? this.visualDensity,
    );
  }
}

/// Fill treatment for text fields and select fields app-wide.
enum AppInputStyle { filled, outlined }

/// Builds the app's [ThemeData] from an [AppThemeConfig].
///
/// Light and dark are generated from the *same* config, so dark-mode parity is
/// automatic — a project can't restyle light and forget dark.
abstract final class AppTheme {
  AppTheme._();

  static ThemeData light([AppThemeConfig config = const AppThemeConfig()]) {
    final scheme = config.lightScheme ??
        ColorScheme.fromSeed(seedColor: config.seedColor);
    return _build(scheme, config.lightAppColors, config);
  }

  static ThemeData dark([AppThemeConfig config = const AppThemeConfig()]) {
    final scheme = config.darkScheme ??
        ColorScheme.fromSeed(
          seedColor: config.seedColor,
          brightness: Brightness.dark,
        );
    return _build(scheme, config.darkAppColors, config);
  }

  static ThemeData _build(
    ColorScheme colors,
    AppColorsExtension appColors,
    AppThemeConfig config,
  ) {
    final textTheme = buildTextTheme().apply(fontFamily: config.fontFamily);
    final filled = config.inputStyle == AppInputStyle.filled;

    OutlineInputBorder inputBorder(Color color, [double? width]) =>
        OutlineInputBorder(
          borderRadius: config.inputRadius,
          borderSide: BorderSide(
            color: color,
            width: width ?? config.inputBorderWidth,
          ),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      textTheme: textTheme,
      fontFamily: config.fontFamily,
      visualDensity: config.visualDensity,
      extensions: [appColors, AppDesignTokens.fallback],

      // ── Basics ──────────────────────────────────────────────────────────
      scaffoldBackgroundColor: colors.surface,
      dividerTheme: DividerThemeData(
        color: colors.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      iconTheme: IconThemeData(color: colors.onSurface, size: 24),

      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: colors.onSurface,
        ),
      ),

      // ── Buttons — geometry from config, colors from the scheme ──────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          minimumSize: config.buttonMinimumSize,
          padding: config.buttonPadding,
          shape: RoundedRectangleBorder(borderRadius: config.buttonRadius),
          elevation: 0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: config.buttonMinimumSize,
          padding: config.buttonPadding,
          shape: RoundedRectangleBorder(borderRadius: config.buttonRadius),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: config.buttonMinimumSize,
          padding: config.buttonPadding,
          shape: RoundedRectangleBorder(borderRadius: config.buttonRadius),
          side: BorderSide(color: colors.outline, width: 1.5),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: Size(config.buttonMinimumSize.width, 40),
          shape: RoundedRectangleBorder(borderRadius: config.chipRadius),
        ),
      ),

      // ── Inputs — the single source every AppTextField/AppSelectField
      //    inherits. Change the config, every field in the app follows. ─────
      inputDecorationTheme: InputDecorationTheme(
        filled: filled,
        fillColor: filled
            ? colors.surfaceContainerHighest.withValues(alpha: 0.4)
            : null,
        contentPadding: config.inputContentPadding,
        border: inputBorder(colors.outline),
        enabledBorder: inputBorder(
          filled ? Colors.transparent : colors.outline,
        ),
        focusedBorder:
            inputBorder(colors.primary, config.inputFocusedBorderWidth),
        errorBorder: inputBorder(colors.error),
        focusedErrorBorder:
            inputBorder(colors.error, config.inputFocusedBorderWidth),
        disabledBorder: inputBorder(
          filled ? Colors.transparent : colors.outlineVariant,
        ),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colors.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: colors.error),
        suffixIconColor: colors.onSurfaceVariant,
        prefixIconColor: colors.onSurfaceVariant,
      ),

      cardTheme: CardThemeData(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colors.outlineVariant),
          borderRadius: config.cardRadius,
        ),
        color: colors.surfaceContainerLow,
      ),

      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: config.chipRadius),
        side: BorderSide(color: colors.outlineVariant),
        backgroundColor: colors.surfaceContainerLow,
        labelStyle: textTheme.labelMedium,
      ),

      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: config.cardRadius),
        titleTextStyle:
            textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        subtitleTextStyle:
            textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
      ),

      checkboxTheme: const CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppBorders.xs),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: config.cardRadius),
        backgroundColor: colors.inverseSurface,
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: colors.onInverseSurface),
      ),

      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: config.dialogRadius),
        elevation: 0,
        backgroundColor: colors.surface,
        titleTextStyle:
            textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        contentTextStyle: textTheme.bodyMedium,
      ),

      bottomSheetTheme: BottomSheetThemeData(
        showDragHandle: true,
        elevation: 0,
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: config.bottomSheetRadius),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: colors.primary,
        unselectedLabelColor: colors.onSurfaceVariant,
        indicatorColor: colors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: textTheme.titleSmall,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        indicatorColor: colors.secondaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: config.cardRadius),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return colors.primary;
          return colors.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colors.primaryContainer;
          }
          return colors.surfaceContainerHighest;
        }),
      ),
    );
  }
}
