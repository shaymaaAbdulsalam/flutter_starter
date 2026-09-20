sealed class AppException implements Exception {
  const AppException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => '$runtimeType($statusCode): $message';
}

final class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode});
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message, {super.statusCode});
}

final class CacheException extends AppException {
  const CacheException([super.message = 'Cache error']);
}

final class ValidationException extends AppException {
  const ValidationException(
    super.message, {
    this.fieldErrors,
    super.statusCode,
  });

  final Map<String, List<String>>? fieldErrors;
}
