import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_starter/core/network/network_client.dart';
import 'package:flutter_starter/core/network/token_store.dart';
import 'package:flutter_starter/core/routing/app_router.dart';
import 'package:flutter_starter/core/session/session_event_bus.dart';
import 'package:flutter_starter/features/auth/auth_injection.dart';
import 'package:flutter_starter/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter_starter/features/demo/demo_injection.dart';
import 'package:flutter_starter/features/home/home_injection.dart';

/// Global service locator.
final getIt = GetIt.instance;

/// Composition root. Order: core infrastructure → feature modules → app shell.
/// Each feature contributes via its own `register*Feature` function, so this
/// file stays small no matter how many features are added.
///
/// `async` is retained deliberately: real apps add async init here (e.g.
/// `Hive.initFlutter()`, remote config) and `main` already awaits this.
Future<void> setupGetIt() async {
  _registerCore();
  registerAuthFeature(getIt);
  registerHomeFeature(getIt);
  registerDemoFeature(getIt); // kit showcase — delete in real projects
  _registerAppShell();
}

void _registerCore() {
  getIt
    // Secure storage — used by SecureTokenStore and the auth local data source.
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    )
    // Session signalling (network → AuthBloc), single broadcast bus.
    ..registerLazySingleton<SessionEventBus>(() => SessionEventBus())
    // Token access, shared by the network client and the auth data layer.
    ..registerLazySingleton<TokenStore>(() => SecureTokenStore(getIt()))
    // The one HTTP client for the whole app.
    ..registerLazySingleton<NetworkClient>(
      () => NetworkClient(tokenStore: getIt(), sessionEventBus: getIt()),
    );
}

void _registerAppShell() {
  // Router depends on the singleton AuthBloc (registered by the auth feature).
  // Lazy, so it resolves after all features are registered.
  getIt.registerLazySingleton<GoRouter>(
    () => createAppRouter(getIt<AuthBloc>()),
  );
}
