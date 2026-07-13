import 'package:go_router/go_router.dart';
import 'package:flutter_starter/core/routing/global_navigator.dart';
import 'package:flutter_starter/core/routing/app_routes.dart';


final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.onboarding,
  routes: <RouteBase>[
    // GoRoute(
    //   path: AppRoutes.onboarding,
    //   name: 'onboarding',
    //   builder: (context, state) => const OnboardingPage(),
    // ),
    // GoRoute(
    //   path: AppRoutes.login,
    //   name: 'login',
    //   builder: (context, state) => const LoginScreen(),
    // ),
    // GoRoute(
    //   path: AppRoutes.signup,
    //   name: 'signup',
    //   builder: (context, state) => const SignupScreen(),
    // ),
    // GoRoute(
    //   path: AppRoutes.forgotPassword,
    //   name: 'forgotPassword',
    //   builder: (context, state) => const ForgotPasswordScreen(),
    // ),
    // GoRoute(
    //   path: AppRoutes.home,
    //   name: 'home',
    //   builder: (context, state) => const HomePage(),
    // ),
  ],
);
