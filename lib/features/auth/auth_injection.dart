import 'package:get_it/get_it.dart';

import 'package:flutter_starter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_starter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_starter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_starter/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_starter/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_starter/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_starter/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_starter/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_starter/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter_starter/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:flutter_starter/features/auth/presentation/bloc/register/register_bloc.dart';

/// Auth feature composition root. Each feature owns its own registration
/// function; `setupGetIt()` just calls them. This keeps DI modular — deleting a
/// feature means deleting one folder and one call, not editing a 300-line
/// god-file.
///
/// DI scoping rules demonstrated here (copy these per feature):
/// * data sources / repositories / use cases → **lazySingleton** (stateless,
///   cheap to share, created on first use).
/// * [AuthBloc] (session-holding, app-wide) → **singleton** — exactly one, it
///   IS the session; the router and every screen read the same instance.
/// * form blocs ([LoginBloc], [RegisterBloc]) → **factory** — a new instance
///   per screen, disposed with the route. Never share these; that is how you
///   get a "previous screen's validation error" ghost.
void registerAuthFeature(GetIt sl) {
  sl
    // Data sources
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(tokenStore: sl(), secureStorage: sl()),
    )
    // Repository
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: sl(), local: sl()),
    )
    // Use cases
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerLazySingleton(() => RegisterUseCase(sl()))
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    ..registerLazySingleton(() => GetCurrentUserUseCase(sl()))
    // App-level session bloc (single source of truth for auth state)
    ..registerSingleton<AuthBloc>(
      AuthBloc(
        getCurrentUser: sl(),
        logout: sl(),
        sessionEventBus: sl(),
      ),
    )
    // Form blocs — new instance per screen
    ..registerFactory(() => LoginBloc(login: sl(), authBloc: sl()))
    ..registerFactory(() => RegisterBloc(register: sl(), authBloc: sl()));
}
