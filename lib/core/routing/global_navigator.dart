import 'package:flutter/material.dart';

/// Global [NavigatorState] key used by the app's root [Navigator].
///
/// Wired into the [GoRouter]'s `navigatorKey` in `app_router.dart` so that
/// navigation and overlays (e.g. global dialogs/toasts) can be triggered
/// without a local [BuildContext] reference.
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// Convenient accessor for the current root [BuildContext].
///
/// Returns `null` before the app is mounted. Check for `null` before
/// using this in background services or repositories.
BuildContext? get rootContext => rootNavigatorKey.currentContext;

