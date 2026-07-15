/// Data-layer exceptions.
///
/// Data sources (remote/local) throw these. They are an *internal* data-layer
/// vocabulary and must never cross into domain/presentation — repositories
/// catch them and translate to [Failure] (see `RepositorySafeCall`).
///
/// Keeping a separate exception hierarchy (rather than throwing `Failure`)
/// preserves the direction of dependency: the domain defines `Failure`, the
/// data layer defines `AppException`, and only the data layer knows how to map
/// between them.
sealed class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => '$runtimeType($statusCode): $message';
}

/// Server responded with an error status (or a malformed body).
final class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}

/// Connectivity/timeout/socket-level problem — request never got a response.
final class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

/// 401/403 from the server.
final class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message, {super.statusCode});
}

/// Local storage read/write failure.
final class CacheException extends AppException {
  const CacheException([super.message = 'Cache error']);
}

/// 422-style field validation error from the server.
final class ValidationException extends AppException {
  const ValidationException(
    super.message, {
    this.fieldErrors,
    super.statusCode,
  });

  final Map<String, List<String>>? fieldErrors;
}
