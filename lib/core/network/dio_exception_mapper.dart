import 'package:dio/dio.dart';

import 'package:flutter_starter/core/error/exceptions.dart';
import 'package:flutter_starter/core/typedefs/typedefs.dart';

/// Translates a low-level [DioException] into a typed [AppException].
///
/// Every remote data source funnels its `catch (DioException)` through this one
/// function, so the transport→exception mapping is defined **once** instead of
/// being re-invented (and diverging) in every feature. Returns [Never] because
/// it always throws — call it as `throw mapDioException(e);` or simply
/// `mapDioException(e);` as the last statement of a catch block.
Never mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      throw const NetworkException();

    case DioExceptionType.badCertificate:
      throw const NetworkException('Secure connection failed');

    case DioExceptionType.cancel:
      throw const ServerException('Request cancelled');

    case DioExceptionType.badResponse:
      final response = e.response;
      final status = response?.statusCode;
      final message = _extractMessage(response?.data) ?? 'Server error';

      if (status == 401 || status == 403) {
        throw UnauthorizedException(message, statusCode: status);
      }
      if (status == 422) {
        throw ValidationException(
          message,
          statusCode: status,
          fieldErrors: _extractFieldErrors(response?.data),
        );
      }
      throw ServerException(message, statusCode: status);

    case DioExceptionType.unknown:
    default:
      throw ServerException(e.message ?? 'Unexpected error');
  }
}

/// Best-effort extraction of a human-readable message from common API error
/// body shapes: `{message: "..."}` or `{error: "..."}` or `{detail: "..."}`.
/// Adapt this to your backend's contract in one place.
String? _extractMessage(dynamic data) {
  if (data is DataMap) {
    final candidate = data['message'] ?? data['error'] ?? data['detail'];
    if (candidate is String && candidate.isNotEmpty) return candidate;
  }
  if (data is String && data.isNotEmpty) return data;
  return null;
}

/// Extracts `{errors: {field: [..]}}` style validation payloads if present.
Map<String, List<String>>? _extractFieldErrors(dynamic data) {
  if (data is DataMap && data['errors'] is DataMap) {
    return (data['errors'] as DataMap).map(
      (key, value) => MapEntry(
        key,
        (value is List) ? value.map((e) => e.toString()).toList() : [value.toString()],
      ),
    );
  }
  return null;
}
