import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_starter/core/ui/forms/field_value.dart';
import 'package:flutter_starter/core/ui/inputs/input_field_shell.dart';
import 'package:flutter_starter/core/ui/inputs/input_formatters.dart';

/// Semantic input variants. Each maps to a keyboard + formatter set in one
/// place, so "a price field" is identical on every screen of every project.
enum AppTextFieldType { text, multiline, number, decimal, phone, price }

/// The kit's standard text input — the design-system port of clinic360's
/// `CustomInputField`, minus its GetX/SVG/currency-package coupling.
///
/// Customization model (three layers, most projects only touch the first):
///   1. **Theme** — colors, fill, borders, radius, padding all come from
///      `InputDecorationTheme`, which `AppThemeConfig` controls app-wide.
///   2. **Variant** — the named constructors ([AppTextField.number],
///      [AppTextField.price], [AppTextField.phone], [AppTextField.multiline],
///      [AppTextField.decimal]) pick keyboard + formatters.
///   3. **Per-instance** — [decoration] fully overrides the decoration when a
///      one-off design is genuinely needed.
///
/// Binds a [FieldValue]: the bloc-validator's error renders under the field
/// automatically and turns the border red (the `error: SizedBox.shrink()`
/// trick keeps M3's error border without duplicating the message inside the
/// decoration — the shell owns the message).
///
/// [onChanged] always receives the **raw** value: price grouping separators
/// are stripped and Arabic-Indic digits normalized before the bloc sees them.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.field,
    required this.onChanged,
    this.type = AppTextFieldType.text,
    this.label,
    this.description,
    this.hint,
    this.isRequired = false,
    this.enabled = true,
    this.readOnly = false,
    this.obscureText = false,
    this.autofocus = false,
    this.showError = true,
    this.maxLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.currencyLabel,
    this.controller,
    this.decoration,
    this.extraFormatters,
  });

  const AppTextField.multiline({
    super.key,
    required this.field,
    required this.onChanged,
    this.label,
    this.description,
    this.hint,
    this.isRequired = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.showError = true,
    this.maxLines = 4,
    this.maxLength,
    this.onSubmitted,
    this.controller,
    this.decoration,
    this.extraFormatters,
  })  : type = AppTextFieldType.multiline,
        obscureText = false,
        keyboardType = TextInputType.multiline,
        textInputAction = TextInputAction.newline,
        prefixIcon = null,
        suffixIcon = null,
        currencyLabel = null;

  const AppTextField.number({
    super.key,
    required this.field,
    required this.onChanged,
    this.label,
    this.description,
    this.hint,
    this.isRequired = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.showError = true,
    this.maxLength,
    this.textInputAction,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.decoration,
    this.extraFormatters,
  })  : type = AppTextFieldType.number,
        obscureText = false,
        maxLines = 1,
        keyboardType = TextInputType.number,
        currencyLabel = null;

  const AppTextField.decimal({
    super.key,
    required this.field,
    required this.onChanged,
    this.label,
    this.description,
    this.hint,
    this.isRequired = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.showError = true,
    this.maxLength,
    this.textInputAction,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.decoration,
    this.extraFormatters,
  })  : type = AppTextFieldType.decimal,
        obscureText = false,
        maxLines = 1,
        keyboardType = const TextInputType.numberWithOptions(decimal: true),
        currencyLabel = null;

  const AppTextField.phone({
    super.key,
    required this.field,
    required this.onChanged,
    this.label,
    this.description,
    this.hint,
    this.isRequired = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.showError = true,
    this.maxLength = 15,
    this.textInputAction,
    this.onSubmitted,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.decoration,
    this.extraFormatters,
  })  : type = AppTextFieldType.phone,
        obscureText = false,
        maxLines = 1,
        keyboardType = TextInputType.phone,
        currencyLabel = null;

  /// Amount field with thousands grouping (display only — the bloc receives
  /// the raw digits). [currencyLabel] renders as a suffix ("IQD", "$", …).
  const AppTextField.price({
    super.key,
    required this.field,
    required this.onChanged,
    this.label,
    this.description,
    this.hint,
    this.isRequired = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.showError = true,
    this.maxLength,
    this.textInputAction,
    this.onSubmitted,
    this.prefixIcon,
    this.currencyLabel,
    this.controller,
    this.decoration,
    this.extraFormatters,
  })  : type = AppTextFieldType.price,
        obscureText = false,
        maxLines = 1,
        keyboardType = TextInputType.number,
        suffixIcon = null;

  final FieldValue<String> field;

  /// Receives the raw (separator-stripped, digit-normalized) value.
  final ValueChanged<String> onChanged;

  final AppTextFieldType type;
  final String? label;
  final String? description;
  final String? hint;
  final bool isRequired;
  final bool enabled;
  final bool readOnly;
  final bool obscureText;
  final bool autofocus;
  final bool showError;
  final int? maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final VoidCallback? onSubmitted;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  /// Suffix text for [AppTextField.price] (e.g. "IQD", "$").
  final String? currencyLabel;

  final TextEditingController? controller;

  /// Full decoration override for one-off designs. Prefer theme/config first.
  final InputDecoration? decoration;

  /// Appended after the variant's own formatters.
  final List<TextInputFormatter>? extraFormatters;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller = widget.controller ??
      TextEditingController(text: _initialText());
  late bool _obscured = widget.obscureText;

  String _initialText() {
    final value = widget.field.value;
    if (widget.type == AppTextFieldType.price && value.isNotEmpty) {
      // Re-apply display grouping to a prefilled raw value.
      return const ThousandsSeparatorFormatter()
          .formatEditUpdate(
            TextEditingValue.empty,
            TextEditingValue(text: value),
          )
          .text;
    }
    return value;
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  bool get _isNumeric => switch (widget.type) {
        AppTextFieldType.number ||
        AppTextFieldType.decimal ||
        AppTextFieldType.phone ||
        AppTextFieldType.price =>
          true,
        _ => false,
      };

  List<TextInputFormatter> get _formatters => [
        if (_isNumeric) const ArabicDigitsToAsciiFormatter(),
        switch (widget.type) {
          AppTextFieldType.number ||
          AppTextFieldType.phone =>
            FilteringTextInputFormatter.digitsOnly,
          AppTextFieldType.decimal => const DecimalTextInputFormatter(),
          AppTextFieldType.price => const ThousandsSeparatorFormatter(),
          _ => null,
        },
        ...?widget.extraFormatters,
      ].whereType<TextInputFormatter>().toList();

  void _handleChanged(String value) {
    var raw = value;
    if (widget.type == AppTextFieldType.price) {
      raw = ThousandsSeparatorFormatter.strip(raw);
    }
    widget.onChanged(raw);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.field.hasError;

    return InputFieldShell(
      label: widget.label,
      description: widget.description,
      error: widget.field.error,
      isRequired: widget.isRequired,
      enabled: widget.enabled,
      showError: widget.showError,
      child: TextField(
        controller: _controller,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        autofocus: widget.autofocus,
        obscureText: _obscured,
        maxLines: widget.obscureText ? 1 : (widget.maxLines ?? 1),
        maxLength: widget.maxLength,
        keyboardType: widget.keyboardType,
        inputFormatters: _formatters,
        textInputAction: widget.textInputAction ??
            (widget.type == AppTextFieldType.multiline
                ? TextInputAction.newline
                : TextInputAction.done),
        onChanged: _handleChanged,
        onSubmitted:
            widget.onSubmitted == null ? null : (_) => widget.onSubmitted!(),
        buildCounter: (context,
                {required currentLength,
                required isFocused,
                required maxLength}) =>
            null,
        decoration: widget.decoration ??
            InputDecoration(
              hintText: widget.hint,
              // Red border on error without an in-decoration message — the
              // shell renders the message below the field.
              error: hasError ? const SizedBox.shrink() : null,
              prefixIcon: widget.prefixIcon,
              suffixIcon: _buildSuffix(),
              suffixText: widget.currencyLabel,
            ),
      ),
    );
  }

  Widget? _buildSuffix() {
    if (widget.suffixIcon != null) return widget.suffixIcon;
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(_obscured ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => _obscured = !_obscured),
      );
    }
    return null;
  }
}
