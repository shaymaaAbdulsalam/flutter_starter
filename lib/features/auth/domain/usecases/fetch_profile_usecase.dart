import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_starter/core/usecase/usecase.dart';
import 'package:flutter_starter/features/auth/domain/entities/user.dart';
import 'package:flutter_starter/features/auth/domain/repositories/auth_repository.dart';

class FetchProfileUseCase implements UseCase<User, NoParams> {
  const FetchProfileUseCase(this._repository);

  final AuthRepository _repository;

  @override
  FutureEither<User> call(NoParams params) => _repository.fetchProfile();
}
