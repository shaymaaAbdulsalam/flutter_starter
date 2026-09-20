import 'package:easy_localization/easy_localization.dart';

import 'package:flutter_starter/core/error/failure.dart';

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
