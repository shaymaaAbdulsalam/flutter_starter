import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_starter/core/error/exceptions.dart';
import 'package:flutter_starter/core/storage/secure_storage.dart';
import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_starter/features/auth/data/models/auth_session_dto.dart';
import 'package:flutter_starter/features/auth/data/models/user_dto.dart';

abstract interface class AuthLocalDataSource {
  Future<void> cacheSession(AuthSessionDto session);
  Future<UserDto?> readCachedUser();
  Future<void> clear();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl({
    required SecureStorage localStorage,
    required FlutterSecureStorage secureStorage,
  })  : _localStorage = localStorage,
        _secureStorage = secureStorage;

  final SecureStorage _localStorage;
  final FlutterSecureStorage _secureStorage;

  static const _userKey = 'auth.user';

  @override
  Future<void> cacheSession(AuthSessionDto session) async {
    try {
      await _localStorage.saveTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      await _secureStorage.write(
        key: _userKey,
        value: jsonEncode(session.user.toJson()),
      );
    } catch (_) {
      throw const CacheException('Failed to persist session');
    }
  }

  @override
  Future<UserDto?> readCachedUser() async {
    try {
      final token = await _localStorage.readAccessToken();
      final rawUser = await _secureStorage.read(key: _userKey);
      if (token == null || rawUser == null) return null;
      return UserDto.fromJson(jsonDecode(rawUser) as DataMap);
    } catch (_) {
      throw const CacheException('Failed to read cached session');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _localStorage.clear();
      await _secureStorage.delete(key: _userKey);
    } catch (_) {
      throw const CacheException('Failed to clear session');
    }
  }
}
