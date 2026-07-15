import 'package:equatable/equatable.dart';

import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_starter/core/usecase/usecase.dart';
import 'package:flutter_starter/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_starter/features/auth/domain/repositories/auth_repository.dart';

/// Single-responsibility use case: register a new account.
class RegisterUseCase implements UseCase<AuthSession, RegisterParams> {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  @override
  FutureEither<AuthSession> call(RegisterParams params) => _repository.register(
        name: params.name,
        email: params.email,
        password: params.password,
      );
}

class RegisterParams extends Equatable {
  const RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  @override
  List<Object?> get props => [name, email, password];
}
