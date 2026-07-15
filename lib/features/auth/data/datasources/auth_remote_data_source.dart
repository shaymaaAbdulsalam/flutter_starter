import 'package:dio/dio.dart';

import 'package:flutter_starter/core/network/api_endpoints.dart';
import 'package:flutter_starter/core/network/dio_exception_mapper.dart';
import 'package:flutter_starter/core/network/network_client.dart';
import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_starter/features/auth/data/models/auth_session_dto.dart';

/// Talks to the auth HTTP endpoints. Knows about Dio and JSON; knows nothing
/// about domain entities or `Failure`. On transport errors it throws typed
/// [AppException]s via [mapDioException] — the repository converts those to
/// [Failure]s. This class never returns a `null`-on-error or a String message.
abstract interface class AuthRemoteDataSource {
  Future<AuthSessionDto> login({required String email, required String password});
  Future<AuthSessionDto> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._client);

  final NetworkClient _client;

  @override
  Future<AuthSessionDto> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.dio.post<DataMap>(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      return AuthSessionDto.fromJson(response.data ?? const {});
    } on DioException catch (e) {
      mapDioException(e);
    }
  }

  @override
  Future<AuthSessionDto> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.dio.post<DataMap>(
        ApiEndpoints.register,
        data: {'name': name, 'email': email, 'password': password},
      );
      return AuthSessionDto.fromJson(response.data ?? const {});
    } on DioException catch (e) {
      mapDioException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _client.dio.post<void>(ApiEndpoints.logout);
    } on DioException catch (e) {
      mapDioException(e);
    }
  }
}
