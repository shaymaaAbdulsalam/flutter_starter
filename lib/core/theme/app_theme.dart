import 'package:flutter/material.dart';

import 'app_theme_config.dart';
import 'app_typography.dart';
import 'app_colors.dart';

abstract final class AppTheme {
  AppTheme._();

  static ThemeData light([AppThemeConfig config = const AppThemeConfig()]) {
    final scheme = config.lightScheme ??
        ColorScheme.fromSeed(
          seedColor: config.seedColor,
          dynamicSchemeVariant: config.schemeVariant,
        );
    return _build(scheme, config.lightAppColors, config);
  }

  static ThemeData dark([AppThemeConfig config = const AppThemeConfig()]) {
    final scheme = config.darkScheme ??
        ColorScheme.fromSeed(
          seedColor: config.seedColor,
          brightness: Brightness.dark,
          dynamicSchemeVariant: config.schemeVariant,
        );
    return _build(scheme, config.darkAppColors, config);
  }

  static ThemeData _build(
    ColorScheme colors,
    AppColorsExtension appColors,
    AppThemeConfig config,
  ) {
    final textTheme =
        AppTypography.textTheme.apply(fontFamily: config.fontFamily);
    final filled = config.inputStyle == AppInputStyle.filled;
    final hairline = colors.outlineVariant.withValues(alpha: 0.7);

    OutlineInputBorder inputBorder(Color color, [double? width]) =>
        OutlineInputBorder(
          borderRadius: config.inputRadius,
          borderSide: BorderSide(
            color: color,
            width: width ?? config.inputBorderWidth,
          ),
        );

    ButtonStyle baseButton({
      Color? background,
      Color? foreground,
      BorderSide? side,
    }) =>
        ButtonStyle(
          backgroundColor:
              background == null ? null : WidgetStatePropertyAll(background),
          foregroundColor:
              foreground == null ? null : WidgetStatePropertyAll(foreground),
          minimumSize: WidgetStatePropertyAll(config.buttonMinimumSize),
          padding: WidgetStatePropertyAll(config.buttonPadding),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
          elevation: const WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: config.buttonRadius),
          ),
          side: side == null ? null : WidgetStatePropertyAll(side),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      textTheme: textTheme,
      fontFamily: config.fontFamily,
      visualDensity: config.visualDensity,
      extensions: [appColors],

      scaffoldBackgroundColor: colors.surface,
      dividerTheme: DividerThemeData(color: hairline, thickness: 1, space: 1),
      iconTheme: IconThemeData(color: colors.onSurface, size: 24),
      splashFactory: InkSparkle.splashFactory,

      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: colors.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: config.appBarCenterTitle,
        titleTextStyle:
            textTheme.titleLarge?.copyWith(color: colors.onSurface),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: baseButton(
          background: colors.primary,
          foreground: colors.onPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: baseButton(
          background: colors.primaryContainer,
          foreground: colors.onPrimaryContainer,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: baseButton(
          foreground: colors.primary,
          side: BorderSide(color: colors.outline),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: textTheme.labelLarge,
          shape: RoundedRectangleBorder(borderRadius: config.chipRadius),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: colors.onSurfaceVariant),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: filled,
        fillColor: filled
            ? colors.surfaceContainerHighest.withValues(alpha: 0.45)
            : null,
        contentPadding: config.inputContentPadding,
        border: inputBorder(colors.outline),
        enabledBorder:
            inputBorder(filled ? Colors.transparent : colors.outline),
        focusedBorder:
            inputBorder(colors.primary, config.inputFocusedBorderWidth),
        errorBorder: inputBorder(colors.error),
        focusedErrorBorder:
            inputBorder(colors.error, config.inputFocusedBorderWidth),
        disabledBorder:
            inputBorder(filled ? Colors.transparent : hairline),
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: colors.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        errorStyle: textTheme.bodySmall?.copyWith(color: colors.error),
        prefixIconColor: colors.onSurfaceVariant,
        suffixIconColor: colors.onSurfaceVariant,
      ),

      cardTheme: CardThemeData(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: hairline),
          borderRadius: config.cardRadius,
        ),
        color: colors.surfaceContainerLow,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: config.chipRadius),
        side: BorderSide(color: hairline),
        backgroundColor: colors.surfaceContainerLow,
        selectedColor: colors.secondaryContainer,
        labelStyle: textTheme.labelMedium?.copyWith(color: colors.onSurface),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: config.cardRadius),
        iconColor: colors.onSurfaceVariant,
        titleTextStyle: textTheme.titleMedium,
        subtitleTextStyle:
            textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
      ),

      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: config.dialogRadius),
        elevation: 0,
        backgroundColor: colors.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.headlineSmall,
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        showDragHandle: true,
        elevation: 0,
        backgroundColor: colors.surfaceContainerLow,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: config.bottomSheetRadius),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: config.inputRadius),
        elevation: 0,
        backgroundColor: colors.inverseSurface,
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: colors.onInverseSurface),
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: colors.primary,
        unselectedLabelColor: colors.onSurfaceVariant,
        indicatorColor: colors.primary,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: hairline,
        labelStyle: textTheme.titleSmall,
        unselectedLabelStyle:
            textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colors.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: colors.secondaryContainer,
        elevation: 0,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => textTheme.labelMedium?.copyWith(
            color: states.contains(WidgetState.selected)
                ? colors.onSurface
                : colors.onSurfaceVariant,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: config.cardRadius),
      ),

      checkboxTheme: CheckboxThemeData(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        side: BorderSide(color: colors.outline, width: 1.5),
      ),
      switchTheme: SwitchThemeData(
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.transparent
              : colors.outline,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.primary,
        linearTrackColor: colors.surfaceContainerHighest,
        circularTrackColor: Colors.transparent,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.inverseSurface,
          borderRadius: config.chipRadius,
        ),
        textStyle:
            textTheme.labelSmall?.copyWith(color: colors.onInverseSurface),
      ),
    );
  }
}
