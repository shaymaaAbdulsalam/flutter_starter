import 'package:equatable/equatable.dart';

/// A single form field's value plus its (optional, already-localized) error
/// message. Ported from clinic360's `FieldValue<T>`.
///
/// Holding value+error together in the bloc state is what makes
/// "validation-in-the-bloc" clean: the bloc sets [error] when a validator
/// fails, and `AppTextField` renders it — the widget owns no validation logic.
class FieldValue<T> extends Equatable {
  const FieldValue(this.value, {this.error});

  final T value;
  final String? error;

  bool get hasError => error != null;

  /// Update the value and **clear any error** — typing should dismiss the
  /// previous validation message. Use this from `onChanged`.
  FieldValue<T> setValue(T value) => FieldValue(value);

  FieldValue<T> copyWith({
    T? value,
    String? error,
    bool clearError = false,
  }) {
    return FieldValue(
      value ?? this.value,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [value, error];
}
