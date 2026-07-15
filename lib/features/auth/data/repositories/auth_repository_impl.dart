import 'package:fpdart/fpdart.dart';

import 'package:flutter_starter/core/error/repository_safe_call.dart';
import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_starter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_starter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_starter/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_starter/features/auth/domain/entities/user.dart';
import 'package:flutter_starter/features/auth/domain/repositories/auth_repository.dart';

/// Concrete [AuthRepository]. Orchestrates remote + local data sources and
/// converts data-layer exceptions into domain [Failure]s via [safeCall].
///
/// This is the *only* class that knows both sides (network and cache) exist.
/// Note how thin and declarative each method is — that readability is exactly
/// what makes this a good pattern to copy into every future feature.
class AuthRepositoryImpl with RepositorySafeCall implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  FutureEither<AuthSession> login({
    required String email,
    required String password,
  }) =>
      safeCall(() async {
        final dto = await _remote.login(email: email, password: password);
        await _local.cacheSession(dto);
        return dto.toEntity();
      });

  @override
  FutureEither<AuthSession> register({
    required String name,
    required String email,
    required String password,
  }) =>
      safeCall(() async {
        final dto = await _remote.register(
          name: name,
          email: email,
          password: password,
        );
        await _local.cacheSession(dto);
        return dto.toEntity();
      });

  @override
  FutureVoid logout() => safeCall(() async {
        // Best-effort server logout, then always clear local session.
        try {
          await _remote.logout();
        } finally {
          await _local.clear();
        }
        return unit;
      });

  @override
  FutureEither<User?> currentUser() => safeCall(() async {
        final dto = await _local.readCachedUser();
        return dto?.toEntity();
      });
}
