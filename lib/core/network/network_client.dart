import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:flutter_starter/core/network/api_endpoints.dart';
import 'package:flutter_starter/core/network/token_store.dart';
import 'package:flutter_starter/core/session/session_event_bus.dart';

/// The single, shared HTTP client for the whole app.
///
/// Responsibilities kept *here* so no feature re-implements them:
/// * base URL + default headers
/// * attaching the bearer token to every request (read from [TokenStore])
/// * detecting an expired/invalid session (401/403) and signalling the app via
///   [SessionEventBus] exactly once — the client does **not** know about BLoCs
///   or navigation, it just emits an event.
/// * pretty request/response logging in debug builds only
///
/// Design notes vs. the previous `DioFactory`:
/// * `dio` is `final` and configured at construction — no reassignable public
///   field, no "did someone remember to call getDio()?" foot-gun.
/// * We keep Dio's default `validateStatus` (throw on >= 400) so error statuses
///   surface as [DioException] and get mapped to typed exceptions, rather than
///   the old `status >= 200` hack that made every response look "successful".
class NetworkClient {
  NetworkClient({
    required TokenStore tokenStore,
    required SessionEventBus sessionEventBus,
    Dio? dio,
  })  : _tokenStore = tokenStore,
        _sessionEventBus = sessionEventBus,
        dio = dio ?? Dio() {
    _configure();
  }

  final Dio dio;
  final TokenStore _tokenStore;
  final SessionEventBus _sessionEventBus;

  void _configure() {
    dio.options
      ..baseUrl = ApiEndpoints.baseUrl
      ..connectTimeout = const Duration(seconds: 20)
      ..receiveTimeout = const Duration(seconds: 20)
      ..headers.addAll({
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      });

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStore.readAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) {
          final status = error.response?.statusCode;
          if (status == 401 || status == 403) {
            // Signal the app once; do not navigate or clear storage here —
            // that is the AuthBloc's job. Keeps the network layer decoupled.
            _sessionEventBus.emit(SessionEvent.unauthorized);
          }
          handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          error: true,
          compact: true,
        ),
      );
    }
  }
}
