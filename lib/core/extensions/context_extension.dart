import 'package:flutter/material.dart';

import '../theme/theme.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colors => theme.colorScheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  AppColorsExtension get appColors =>
      theme.extension<AppColorsExtension>() ??
      (isDarkMode ? AppPalettes.dark : AppPalettes.light);

  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: appColors.success,
        ),
      );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: colors.error,
        ),
      );
  }
}
