import 'package:flutter/services.dart';
import 'package:flutter_starter/core/ui/inputs/input_formatters.dart';
import 'package:flutter_test/flutter_test.dart';

TextEditingValue _fmt(TextInputFormatter f, String text) =>
    f.formatEditUpdate(TextEditingValue.empty, TextEditingValue(text: text));

void main() {
  group('ArabicDigitsToAsciiFormatter', () {
    test('normalizes Arabic-Indic digits', () {
      expect(_fmt(const ArabicDigitsToAsciiFormatter(), '٠٧٧١٢٣').text,
          '077123');
    });

    test('normalizes Eastern Arabic (Persian) digits', () {
      expect(
          _fmt(const ArabicDigitsToAsciiFormatter(), '۱۲۳۴۵').text, '12345');
    });

    test('leaves ASCII untouched', () {
      expect(_fmt(const ArabicDigitsToAsciiFormatter(), '123abc').text,
          '123abc');
    });
  });

  group('ThousandsSeparatorFormatter', () {
    test('groups thousands while typing', () {
      expect(_fmt(const ThousandsSeparatorFormatter(), '1234567').text,
          '1,234,567');
    });

    test('re-groups after edits and strips junk', () {
      expect(_fmt(const ThousandsSeparatorFormatter(), '1,2345').text,
          '12,345');
    });

    test('strip() returns the raw value', () {
      expect(ThousandsSeparatorFormatter.strip('1,234,567'), '1234567');
    });
  });

  group('DecimalTextInputFormatter', () {
    test('allows a single decimal point', () {
      expect(_fmt(const DecimalTextInputFormatter(), '12.5').text, '12.5');
    });

    test('rejects a second decimal point (keeps old value)', () {
      const f = DecimalTextInputFormatter();
      final result = f.formatEditUpdate(
        const TextEditingValue(text: '12.5'),
        const TextEditingValue(text: '12.5.'),
      );
      expect(result.text, '12.5');
    });
  });
}
