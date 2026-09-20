import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure({required this.message, this.code});

  final String message;
  final int? code;

  @override
  List<Object?> get props => [message, code];
}

final class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network unavailable', super.code});
}

final class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({super.message = 'Session expired', super.code});
}

final class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Local storage error', super.code});
}

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

final class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'Something went wrong', super.code});
}
