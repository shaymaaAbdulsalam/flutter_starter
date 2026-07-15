import 'package:equatable/equatable.dart';

/// Domain-level, transport-agnostic error type.
///
/// A [Failure] is what the *domain* and *presentation* layers see. It is a
/// sealed hierarchy, so BLoCs and widgets can `switch` on the concrete type
/// and react differently (retry vs. re-login vs. show field errors) with
/// exhaustiveness checked by the compiler.
///
/// Rules for the whole codebase:
/// * The data layer throws [AppException]s; repositories translate those into
///   [Failure]s. Exceptions never escape the data layer.
/// * [message] is a *developer/debug* fallback string, never shown to users
///   directly. The presentation layer maps the failure *type* to a localized,
///   user-facing message (see `failure_message.dart`).
sealed class Failure extends Equatable {
  const Failure({required this.message, this.code});

  /// Developer-facing description. Not for display — localize by type instead.
  final String message;

  /// Optional transport/status code (e.g. HTTP status) for logging/telemetry.
  final int? code;

  @override
  List<Object?> get props => [message, code];
}

/// No connectivity / timeout / socket error. Safe to offer "retry".
final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network unavailable', super.code});
}

/// The server returned an error response (5xx, or a handled 4xx that isn't
/// auth/validation). Carries the status [code] when known.
final class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Authentication/authorization failed (401/403). Presentation should route
/// the user back to login. Distinct type so guards can react specifically.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'Session expired',
    super.code,
  });
}

/// Local persistence (secure storage / cache) failed.
final class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Local storage error', super.code});
}

/// Server-side field validation failed. [fieldErrors] maps a field name to its
/// error messages so forms can highlight individual inputs.
final class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    this.fieldErrors,
    super.code,
  });

  final Map<String, List<String>>? fieldErrors;

  @override
  List<Object?> get props => [message, code, fieldErrors];
}

/// Anything we did not anticipate. The catch-all; keeps the sealed switch
/// exhaustive without swallowing unknowns silently.
final class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Something went wrong', super.code});
}
