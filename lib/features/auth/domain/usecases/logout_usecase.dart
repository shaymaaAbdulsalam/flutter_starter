import 'package:fpdart/fpdart.dart';

import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_starter/core/usecase/usecase.dart';
import 'package:flutter_starter/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase implements UseCase<Unit, NoParams> {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  FutureVoid call(NoParams params) => _repository.logout();
}
