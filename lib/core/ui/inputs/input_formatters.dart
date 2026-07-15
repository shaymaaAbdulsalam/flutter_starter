import 'package:flutter/services.dart';

/// Normalizes Arabic-Indic (٠١٢٣٤٥٦٧٨٩) and Eastern Arabic/Persian (۰۱۲۳۴۵۶۷۸۹)
/// digits to ASCII so numeric parsing works regardless of the user's keyboard.
/// Ported from clinic360's inline regex into a reusable formatter.
class ArabicDigitsToAsciiFormatter extends TextInputFormatter {
  const ArabicDigitsToAsciiFormatter();

  static String normalize(String input) => input.replaceAllMapped(
        RegExp('[٠-٩۰-۹]'),
        (match) {
          final code = match.group(0)!.codeUnitAt(0);
          final zero = code >= 0x06F0 ? 0x06F0 : 0x0660;
          return String.fromCharCode(code - zero + 0x30);
        },
      );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final normalized = normalize(newValue.text);
    if (normalized == newValue.text) return newValue;
    return newValue.copyWith(text: normalized);
  }
}

/// Groups the integer part of a number with a separator while typing:
/// `1234567` → `1,234,567`. Keeps the cursor at the end (sufficient for
/// amount entry). The *raw* value (separators stripped) is what should reach
/// the bloc — `AppTextField` handles that before calling `onChanged`.
class ThousandsSeparatorFormatter extends TextInputFormatter {
  const ThousandsSeparatorFormatter({this.separator = ','});

  final String separator;

  static String strip(String formatted, {String separator = ','}) =>
      formatted.replaceAll(separator, '');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp('[^0-9]'), '');
    if (digits.isEmpty) return TextEditingValue.empty;

    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(separator);
      buffer.write(digits[i]);
    }
    final text = buffer.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// Allows digits plus at most one decimal point.
class DecimalTextInputFormatter extends TextInputFormatter {
  const DecimalTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final valid = RegExp(r'^\d*\.?\d*$').hasMatch(newValue.text);
    return valid ? newValue : oldValue;
  }
}
