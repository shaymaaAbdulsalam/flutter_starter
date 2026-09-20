import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_starter/core/network/network_client.dart';
import 'package:flutter_starter/core/storage/secure_storage.dart';
import 'package:flutter_starter/core/routing/app_router.dart';
import 'package:flutter_starter/core/session/session_event_bus.dart';
import 'package:flutter_starter/features/auth/auth_injection.dart';
import 'package:flutter_starter/features/auth/presentation/bloc/auth/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  _registerCore();
  registerAuthFeature(getIt);
  _registerAppShell();
}

void _registerCore() {
  getIt
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    )
    ..registerLazySingleton<SessionEventBus>(() => SessionEventBus())
    ..registerLazySingleton<SecureStorage>(() => SecureStorageImpl(getIt()))
    ..registerLazySingleton<NetworkClient>(
      () => NetworkClient(localStorage: getIt(), sessionEventBus: getIt()),
    );
}

void _registerAppShell() {
  getIt.registerLazySingleton<GoRouter>(
    () => createAppRouter(getIt<AuthBloc>()),
  );
}
