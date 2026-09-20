import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_starter/core/ui/splash_page.dart';
import 'package:flutter_starter/core/routing/app_routes.dart';
import 'package:flutter_starter/core/routing/global_navigator.dart';
import 'package:flutter_starter/core/routing/go_router_refresh_stream.dart';
import 'package:flutter_starter/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter_starter/features/auth/presentation/pages/home_page.dart';
import 'package:flutter_starter/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_starter/features/auth/presentation/pages/register_page.dart';

GoRouter createAppRouter(AuthBloc authBloc) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final status = authBloc.state.status;
      final location = state.matchedLocation;

      final onSplash = location == AppRoutes.splash;
      final onAuthPage =
          location == AppRoutes.login || location == AppRoutes.signup;

      switch (status) {
        case AuthStatus.unknown:
          return onSplash ? null : AppRoutes.splash;
        case AuthStatus.unauthenticated:
          return onAuthPage ? null : AppRoutes.login;
        case AuthStatus.authenticated:
          return (onAuthPage || onSplash) ? AppRoutes.home : null;
      }
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (context, state) => const RegisterPage(),
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Route not found: ${state.uri}'))),
  );
}
