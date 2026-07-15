import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_starter/core/usecase/usecase.dart';
import 'package:flutter_starter/features/auth/domain/entities/user.dart';
import 'package:flutter_starter/features/auth/domain/repositories/auth_repository.dart';

/// Single-responsibility use case: resolve the currently logged-in user (from
/// the local cache). Returns `null` when there is no session. Used at startup
/// to pick the initial route.
class GetCurrentUserUseCase implements UseCase<User?, NoParams> {
  const GetCurrentUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  FutureEither<User?> call(NoParams params) => _repository.currentUser();
}
