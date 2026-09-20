import 'package:equatable/equatable.dart';

class FieldValue<T> extends Equatable {
  const FieldValue(this.value, {this.error});

  final T value;
  final String? error;

  bool get hasError => error != null;

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
