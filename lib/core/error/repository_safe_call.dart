import 'package:flutter/foundation.dart';

import 'package:flutter_starter/core/error/exceptions.dart';
import 'package:flutter_starter/core/error/failure.dart';
import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:fpdart/fpdart.dart';

/// Mixin every repository implementation uses to run a data-source action and
/// translate the data-layer [AppException] vocabulary into the domain-layer
/// [Failure] vocabulary — in one place, consistently, for every feature.
///
/// This is the boundary where exceptions stop and `Either` begins. After this,
/// nothing throws across a layer; callers pattern-match on [Failure].
///
/// Usage inside a repository:
/// ```dart
/// FutureEither<User> login(...) => safeCall(() async {
///   final dto = await _remote.login(...);
///   return dto.toEntity();
/// });
/// ```
mixin RepositorySafeCall {
  FutureEither<T> safeCall<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(message: e.message, code: e.statusCode));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(
        message: e.message,
        fieldErrors: e.fieldErrors,
        code: e.statusCode,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.statusCode));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } catch (e, s) {
      // Anything unmapped is a bug — surface it loudly in debug, degrade
      // gracefully in release. Never swallow silently.
      if (kDebugMode) {
        debugPrintStack(label: 'Unhandled repository error: $e', stackTrace: s);
      }
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
