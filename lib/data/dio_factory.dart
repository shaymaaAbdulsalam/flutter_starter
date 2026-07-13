import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_starter/core/utils/app_preferences.dart';
import 'package:flutter_starter/data/app_base_url.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioFactory {
  final AppPreferences _appPreferences;

  DioFactory(this._appPreferences);
  Dio dio = Dio();
  Future<Dio> getDio() async {
    dio.options.validateStatus = (status) {
      return status! >= 200;
    };
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          await _appPreferences.getToken().then(
            (value) {
              if (value != null) {
                options.headers['Authorization'] = 'Bearer $value';
              }
            },
          );
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.statusCode == 401 &&
              response.data['detail'] == 'Token expired') {
            _cleanUP();
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          final response = e.response;
          if (response?.statusCode == 401 &&
              response?.data['detail'] == 'Token expired') {
            _cleanUP();
          }

          return handler.next(e);
        },
      ),
    );
    dio.options.baseUrl = AppBaseUrl.baseUrl;
    dio.options.headers['accept'] = 'Application/Json';
    dio.options.headers['Content-Type'] = 'application/json';

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          error: true,
        ),
      );
    }

    return dio;
  }

  void _cleanUP() {
    _appPreferences.cleanUP();
  }
}
