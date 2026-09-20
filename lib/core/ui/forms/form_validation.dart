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

mixin FormValidationMixin {
  bool checkValidation(List<ValidationCondition> conditions) {
    for (final condition in conditions) {
      if (condition.failsWhen) condition.onError(condition.message);
    }
    return conditions.every((c) => !c.failsWhen);
  }
}
