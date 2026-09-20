import 'package:dio/dio.dart';

import 'package:flutter_starter/core/network/api_endpoints.dart';
import 'package:flutter_starter/core/session/session_event_bus.dart';
import 'package:flutter_starter/core/storage/secure_storage.dart';
import 'package:flutter_starter/core/typedefs/typedefs.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required Dio client,
    required Dio refreshClient,
    required SecureStorage storage,
    required SessionEventBus sessionEventBus,
    this.maxRefreshRetries = 1,
  }) : _client = client,
       _refreshClient = refreshClient,
       _storage = storage,
       _sessionEventBus = sessionEventBus;

  final Dio _client;
  final Dio _refreshClient;
  final SecureStorage _storage;
  final SessionEventBus _sessionEventBus;
  final int maxRefreshRetries;

  static const _retryCountKey = 'refreshRetryCount';
  Future<bool>? _refreshFuture;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.readAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    final status = err.response?.statusCode;
    final retryCount = (requestOptions.extra[_retryCountKey] as int?) ?? 0;

    if (status != 401 || retryCount >= maxRefreshRetries) {
      return handler.next(err);
    }

    final refreshToken = await _storage.readRefreshToken();
    if (refreshToken == null) return handler.next(err);

    requestOptions.extra[_retryCountKey] = retryCount + 1;
    _refreshFuture ??= _refreshAccessToken(
      refreshToken,
    ).whenComplete(() => _refreshFuture = null);

    final bool refreshed;
    try {
      refreshed = await _refreshFuture!;
    } on DioException {
      return handler.next(err);
    }

    if (!refreshed) {
      await _storage.clear();
      _sessionEventBus.emit(SessionEvent.unauthorized);
      return handler.next(err);
    }

    if (requestOptions.cancelToken?.isCancelled ?? false) {
      return handler.next(err);
    }
    final data = requestOptions.data;
    if (data is FormData) requestOptions.data = data.clone();
    try {
      handler.resolve(await _client.fetch<dynamic>(requestOptions));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  Future<bool> _refreshAccessToken(String refreshToken) async {
    try {
      final response = await _refreshClient.post<DataMap>(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );
      final newAccessToken = response.data?['access_token'] as String?;
      if (newAccessToken == null) return false;

      await _storage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: response.data?['refresh_token'] as String?,
      );
      return true;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status != null && status >= 400 && status < 500) return false;
      rethrow;
    }
  }
}
