/// Centralized route path constants for GoRouter.
///
/// Use these constants instead of raw strings throughout the app.
/// Example: `context.go(AppRoutes.home)` instead of `context.go('/')`.
///
/// This table holds only routes that actually exist. When you add a screen,
/// add its constant here *and* its `GoRoute` in `app_router.dart` — never one
/// without the other. That 1:1 discipline is what keeps deep links honest.
abstract final class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';

  /// Kit showcase (see `features/demo/`). Guard-exempt so it is reachable
  /// before login. Delete with the demo feature in real projects.
  static const String demo = '/demo';
}
