import 'package:equatable/equatable.dart';

import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_starter/core/usecase/usecase.dart';
import 'package:flutter_starter/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_starter/features/auth/domain/repositories/auth_repository.dart';

/// Single-responsibility use case: log a user in.
///
/// One action, one class. The presentation layer depends on this — not on the
/// repository — which keeps BLoCs thin and business intent explicit. If login
/// ever needs extra rules (rate limiting, analytics, feature flags), they live
/// here, not smeared across the UI.
class LoginUseCase implements UseCase<AuthSession, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  FutureEither<AuthSession> call(LoginParams params) =>
      _repository.login(email: params.email, password: params.password);
}

/// Typed, value-equal params. Prefer a params object over positional args so
/// the call site is self-documenting and easy to evolve.
class LoginParams extends Equatable {
  const LoginParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
