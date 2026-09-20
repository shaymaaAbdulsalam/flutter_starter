import 'package:fpdart/fpdart.dart';

import 'package:flutter_starter/core/error/failure.dart';

typedef FutureEither<T> = Future<Either<Failure, T>>;

typedef FutureVoid = FutureEither<Unit>;

typedef DataMap = Map<String, dynamic>;
