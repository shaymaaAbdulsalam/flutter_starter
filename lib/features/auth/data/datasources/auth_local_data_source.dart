import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter_starter/core/error/exceptions.dart';
import 'package:flutter_starter/core/network/token_store.dart';
import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_starter/features/auth/data/models/auth_session_dto.dart';
import 'package:flutter_starter/features/auth/data/models/user_dto.dart';

/// Persists the session locally: tokens (via [TokenStore]) and a cached copy of
/// the user so the app can resolve auth state on cold start without a network
/// round-trip. Storage failures throw [CacheException] — they are never
/// swallowed into a `null` that would masquerade as "logged out".
abstract interface class AuthLocalDataSource {
  Future<void> cacheSession(AuthSessionDto session);
  Future<UserDto?> readCachedUser();
  Future<void> clear();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl({
    required TokenStore tokenStore,
    required FlutterSecureStorage secureStorage,
  })  : _tokenStore = tokenStore,
        _secureStorage = secureStorage;

  final TokenStore _tokenStore;
  final FlutterSecureStorage _secureStorage;

  static const _userKey = 'auth.user';

  @override
  Future<void> cacheSession(AuthSessionDto session) async {
    try {
      await _tokenStore.saveTokens(
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
      final token = await _tokenStore.readAccessToken();
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
      await _tokenStore.clear();
      await _secureStorage.delete(key: _userKey);
    } catch (_) {
      throw const CacheException('Failed to clear session');
    }
  }
}
