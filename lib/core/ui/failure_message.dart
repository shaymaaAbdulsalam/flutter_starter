import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_starter/core/error/failure.dart';

/// Maps a typed [Failure] to a **localized, user-facing** message.
///
/// This is the single place where failure *types* become display strings. The
/// data layer never builds user text (that would bake English into the wrong
/// layer and make localization impossible); it only produces typed failures.
/// The presentation layer translates them here, exhaustively — add a new
/// `Failure` subtype and the compiler forces you to handle it.
extension FailureMessageX on Failure {
  String toMessage() => switch (this) {
        NetworkFailure() => 'errors.network'.tr(),
        UnauthorizedFailure() => 'errors.unauthorized'.tr(),
        ValidationFailure() => 'errors.validation'.tr(),
        ServerFailure() => 'errors.server'.tr(),
        CacheFailure() => 'errors.cache'.tr(),
        UnknownFailure() => 'errors.unknown'.tr(),
      };
}
