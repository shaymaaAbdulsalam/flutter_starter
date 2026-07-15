import 'package:fpdart/fpdart.dart';

import 'package:flutter_starter/core/error/failure.dart';

/// The canonical **domain/data** result of a fallible operation.
///
/// `Left`  = a typed [Failure] (the operation failed).
/// `Right` = the success value.
///
/// Every repository and use case returns this. It is named [FutureEither] (not
/// "ResultFuture") on purpose: it is a `Future<Either<...>>`, NOT a
/// `Future<Result<...>>`. The presentation-layer `Result<T>` type
/// (`core/ui/state/result.dart`) is a different thing — a UI async
/// state slice that *consumes* a [FutureEither] via `linkWithState`.
typedef FutureEither<T> = Future<Either<Failure, T>>;

/// A [FutureEither] for operations that return no meaningful value. Uses
/// fpdart's [Unit] so the success branch still carries a value.
typedef FutureVoid = FutureEither<Unit>;

/// Alias for the ubiquitous decoded-JSON map. Keeps DTO signatures terse.
typedef DataMap = Map<String, dynamic>;
