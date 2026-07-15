part of 'login_bloc.dart';

/// Form state: each field is a [FieldValue] (value + inline error), and the
/// network submission is a [Result] slice. No ad-hoc `isLoading`/`errorMessage`
/// booleans — the [Result] carries the whole submit lifecycle.
class LoginState extends Equatable {
  const LoginState({
    this.email = const FieldValue(''),
    this.password = const FieldValue(''),
    this.submission = const Result.idle(),
  });

  final FieldValue<String> email;
  final FieldValue<String> password;
  final Result<AuthSession> submission;

  bool get isSubmitting => submission.isLoading;

  LoginState copyWith({
    FieldValue<String>? email,
    FieldValue<String>? password,
    Result<AuthSession>? submission,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      submission: submission ?? this.submission,
    );
  }

  @override
  List<Object?> get props => [email, password, submission];
}
