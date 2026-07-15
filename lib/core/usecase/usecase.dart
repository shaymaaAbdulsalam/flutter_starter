import 'package:flutter_starter/core/typedefs/typedefs.dart';

/// Base contract for every use case (interactor) in the app.
///
/// A use case represents exactly **one** business action (LogIn, LogOut,
/// GetCurrentUser…). It has a single [call] method so it can be invoked like a
/// function: `await loginUseCase(params)`. This is the unit the presentation
/// layer talks to — never a repository directly.
///
/// [T]      — the success type returned inside the [FutureEither].
/// [Params] — the input. Use [NoParams] when the action takes no arguments.
abstract interface class UseCase<T, Params> {
  FutureEither<T> call(Params params);
}

/// Placeholder params object for use cases that take no input. Explicit and
/// `const`-constructible so call sites read `useCase(const NoParams())`.
final class NoParams {
  const NoParams();
}
