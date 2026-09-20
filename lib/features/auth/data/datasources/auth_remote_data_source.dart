import 'package:dio/dio.dart';

import 'package:flutter_starter/core/network/api_endpoints.dart';
import 'package:flutter_starter/core/network/dio_exception_mapper.dart';
import 'package:flutter_starter/core/network/network_client.dart';
import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_starter/features/auth/data/models/auth_session_dto.dart';
import 'package:flutter_starter/features/auth/data/models/user_dto.dart';

abstract interface class AuthRemoteDataSource {
  Future<AuthSessionDto> login({required String email, required String password});
  Future<AuthSessionDto> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<UserDto> getCurrentUser();
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

  @override
  Future<UserDto> getCurrentUser() async {
    try {
      final response =
          await _client.dio.get<DataMap>(ApiEndpoints.currentUser);
      return UserDto.fromJson(response.data ?? const {});
    } on DioException catch (e) {
      mapDioException(e);
    }
  }
}
