part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.name = const FieldValue(''),
    this.email = const FieldValue(''),
    this.password = const FieldValue(''),
    this.submission = const Result.idle(),
  });

  final FieldValue<String> name;
  final FieldValue<String> email;
  final FieldValue<String> password;
  final Result<AuthSession> submission;

  bool get isSubmitting => submission.isLoading;

  RegisterState copyWith({
    FieldValue<String>? name,
    FieldValue<String>? email,
    FieldValue<String>? password,
    Result<AuthSession>? submission,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      submission: submission ?? this.submission,
    );
  }

  @override
  List<Object?> get props => [name, email, password, submission];
}
