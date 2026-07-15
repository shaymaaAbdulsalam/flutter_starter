import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Narrow contract for reading/writing auth tokens.
///
/// Deliberately small so the [NetworkClient] can depend on *just* token access
/// without pulling in the rest of the auth feature. The auth data layer uses
/// the same abstraction to persist tokens after login. Anything that needs the
/// access token (interceptors, refresh logic) talks to this — not directly to
/// secure storage.
abstract interface class TokenStore {
  Future<String?> readAccessToken();
  Future<String?> readRefreshToken();
  Future<void> saveTokens({required String accessToken, String? refreshToken});
  Future<void> clear();
}

/// [FlutterSecureStorage]-backed implementation (Keychain / EncryptedSharedPrefs).
///
/// Deliberately does **not** swallow storage read errors into `null`: a
/// transient keychain error returning `null` is indistinguishable from
/// "logged out" and would silently sign users out. We let the exception
/// propagate so it is mapped into a [CacheFailure] upstream.
class SecureTokenStore implements TokenStore {
  SecureTokenStore(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'auth.access_token';
  static const _refreshTokenKey = 'auth.refresh_token';

  @override
  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  @override
  Future<void> clear() async {
    // Scoped delete of *auth* keys only — never nuke all storage/prefs, which
    // would also wipe theme, locale, onboarding flags, etc.
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
