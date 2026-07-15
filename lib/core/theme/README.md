# Theme system

Import **one** file everywhere: `core/theme/theme.dart`.

## Rebrand in 60 seconds

All styling flows from a single value object. Edit the config in `app.dart`:

```dart
const themeConfig = AppThemeConfig(
  seedColor: Color(0xFF0B6E4F),          // your brand color
  fontFamily: 'Cairo',                   // declare it in pubspec first
  inputStyle: AppInputStyle.outlined,    // or filled (default)
  buttonRadius: AppBorders.full,         // pill buttons everywhere
);
```

Have a complete brand palette? Skip the seed and pass full schemes:

```dart
AppThemeConfig(
  lightScheme: ColorScheme(...),
  darkScheme: ColorScheme(...),
  lightAppColors: AppColorsExtension(...),  // success / warning / info
  darkAppColors: AppColorsExtension(...),
)
```

Light and dark are always built from the **same** config — dark-mode parity
is structural, you cannot restyle one and forget the other.

## Files

| File | Owns |
|---|---|
| `app_theme_config.dart` | `AppThemeConfig` — every rebrand knob (colors, font, radii, input & button geometry, density) |
| `app_theme.dart` | `AppTheme.light/dark(config)` — all component themes; reads only config + scheme |
| `app_colors.dart` | `AppColorsExtension` (semantic success/warning/info) + default `AppPalettes` — read via `context.appColors` |
| `app_typography.dart` | The type scale (M3-compatible slots, modern voice) |
| `tokens/` | Raw scales: `AppSpacing`, `AppBorders`, `AppShadows`, `AppDurations`, `AppCurves` |

## Usage in widgets

```dart
context.colors.primary          // ColorScheme role
context.appColors.success       // semantic status color
context.textTheme.titleMedium   // type scale
AppSpacing.md · AppBorders.card · AppDurations.fast
```

## Rules

- **Never** hardcode a color, radius, or text style in a widget — read from
  the theme/tokens above.
- Adding a component theme in `app_theme.dart`? Take values from `config`
  and the `ColorScheme` only. A literal there is a bug: it can't be rebranded.
- The kit's visual signature: flat bordered surfaces (no elevation tint),
  true-hue brand color (`DynamicSchemeVariant.content`), generous radii,
  bold tight-tracked headings. Change it deliberately, in the config.
