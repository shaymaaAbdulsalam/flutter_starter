import 'package:flutter_starter/core/ui/forms/field_value.dart';
import 'package:flutter_starter/core/ui/forms/form_validation.dart';
import 'package:flutter_test/flutter_test.dart';

class _Validator with FormValidationMixin {}

void main() {
  group('FieldValue', () {
    test('setValue clears the previous error', () {
      const field = FieldValue('old', error: 'Required');
      expect(field.hasError, isTrue);
      expect(field.setValue('new').hasError, isFalse);
      expect(field.setValue('new').value, 'new');
    });
  });

  group('FormValidationMixin.checkValidation', () {
    test('returns true and emits nothing when all rules pass', () {
      final errors = <String>[];
      final ok = _Validator().checkValidation([
        ValidationCondition(
            failsWhen: false, message: 'a', onError: errors.add),
        ValidationCondition(
            failsWhen: false, message: 'b', onError: errors.add),
      ]);
      expect(ok, isTrue);
      expect(errors, isEmpty);
    });

    test('returns false and emits each failing rule message', () {
      final errors = <String>[];
      final ok = _Validator().checkValidation([
        ValidationCondition(
            failsWhen: true, message: 'name required', onError: errors.add),
        ValidationCondition(
            failsWhen: false, message: 'ok', onError: errors.add),
        ValidationCondition(
            failsWhen: true, message: 'password too short', onError: errors.add),
      ]);
      expect(ok, isFalse);
      expect(errors, ['name required', 'password too short']);
    });
  });
}
