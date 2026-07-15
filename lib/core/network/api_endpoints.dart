/// Central catalogue of API paths + base URL.
///
/// Base URL is a compile-time environment value so different flavors/CI builds
/// can inject it without a runtime `.env` read:
///   flutter run --dart-define=API_BASE_URL=https://staging.example.com
///
/// Endpoint paths are relative — the base URL is applied once, in
/// [NetworkClient]. Never concatenate the base URL into paths by hand.
abstract final class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://your-api-base-url.com',
  );

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String currentUser = '/auth/me';
}
