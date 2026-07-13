import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String tokenKey = 'token';

class AppPreferences {
  final FlutterSecureStorage _storage;
  final SharedPreferences _preference;

  AppPreferences(
    this._storage,
    this._preference,
  );
  Future<void> setToken(String token) async {
    try {
      await _storage.write(key: tokenKey, value: token);
    } on PlatformException catch (_) {
      debugPrint('An PlatformException error occurred while setting the token');
    } catch (e) {
      debugPrint('an error occurred while setting the token: $e');
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: tokenKey);
      if (token != null) {
        return token;
      } else {}
    } on PlatformException catch (_) {
      debugPrint('An PlatformException error occurred while getting the token');
    } catch (e) {
      debugPrint('An error occurred while getting the token: $e');
    }
    return null;
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: tokenKey);
  }

  Future<void> cleanUP() async {
    try {
      await _storage.deleteAll();
      await _preference.clear();
    } catch (e) {
      debugPrint('An error occurred while cleaning up: $e');
    }
  }
}
