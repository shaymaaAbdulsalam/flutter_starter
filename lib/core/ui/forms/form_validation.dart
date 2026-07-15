/// A single validation rule: when [failsWhen] is true, [onError] is invoked
/// with the (already-localized) [message] so the bloc can attach it to the
/// right field. Ported from clinic360's `ValidationCondition`.
class ValidationCondition {
  const ValidationCondition({
    required this.failsWhen,
    required this.message,
    required this.onError,
  });

  final bool failsWhen;
  final String message;
  final void Function(String message) onError;
}

/// Mixed into a form bloc to give it a declarative validator. Keeping
/// validation *in the bloc* (not the widget) means the same rules are testable
/// without a widget harness and can't be bypassed by a different UI.
///
/// Convention: put the rules in a `<feature>_validator.dart` bloc extension
/// (e.g. `extension LoginValidation on LoginBloc`) that calls
/// [checkValidation]. Each failing rule emits its field's error; the method
/// returns whether every rule passed.
mixin FormValidationMixin {
  bool checkValidation(List<ValidationCondition> conditions) {
    for (final condition in conditions) {
      if (condition.failsWhen) condition.onError(condition.message);
    }
    return conditions.every((c) => !c.failsWhen);
  }
}
