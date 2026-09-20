import 'package:flutter_starter/core/typedefs/typedefs.dart';

abstract interface class UseCase<T, Params> {
  FutureEither<T> call(Params params);
}

final class NoParams {
  const NoParams();
}
