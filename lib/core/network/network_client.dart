import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:flutter_starter/core/network/api_endpoints.dart';
import 'package:flutter_starter/core/network/auth_interceptor.dart';
import 'package:flutter_starter/core/storage/secure_storage.dart';
import 'package:flutter_starter/core/session/session_event_bus.dart';

class NetworkClient {
  NetworkClient({
    required SecureStorage localStorage,
    required SessionEventBus sessionEventBus,
    Dio? dio,
    Dio? refreshClient,
    int maxRefreshRetries = 1,
  }) : dio = dio ?? Dio(),
       _refreshClient = refreshClient ?? Dio() {
    _configure(
      localStorage: localStorage,
      sessionEventBus: sessionEventBus,
      maxRefreshRetries: maxRefreshRetries,
    );
  }

  final Dio dio;
  final Dio _refreshClient;

  void _configure({
    required SecureStorage localStorage,
    required SessionEventBus sessionEventBus,
    required int maxRefreshRetries,
  }) {
    for (final client in [dio, _refreshClient]) {
      client.options
        ..baseUrl = ApiEndpoints.baseUrl
        ..connectTimeout = const Duration(seconds: 20)
        ..receiveTimeout = const Duration(seconds: 20)
        ..headers.addAll({
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        });
      if (kDebugMode) {
        client.interceptors.add(
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

    dio.interceptors.add(
      AuthInterceptor(
        client: dio,
        refreshClient: _refreshClient,
        storage: localStorage,
        sessionEventBus: sessionEventBus,
        maxRefreshRetries: maxRefreshRetries,
      ),
    );
  }
}
