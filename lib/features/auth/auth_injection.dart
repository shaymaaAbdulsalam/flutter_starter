import 'package:get_it/get_it.dart';

import 'package:flutter_starter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_starter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_starter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_starter/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_starter/features/auth/domain/usecases/fetch_profile_usecase.dart';
import 'package:flutter_starter/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_starter/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_starter/features/auth/domain/usecases/logout_usecase.dart';
import 'package:flutter_starter/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_starter/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter_starter/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:flutter_starter/features/auth/presentation/bloc/register/register_bloc.dart';

void registerAuthFeature(GetIt sl) {
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(localStorage: sl(), secureStorage: sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: sl(), local: sl()),
    )
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerLazySingleton(() => RegisterUseCase(sl()))
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    ..registerLazySingleton(() => GetCurrentUserUseCase(sl()))
    ..registerLazySingleton(() => FetchProfileUseCase(sl()))
    ..registerSingleton<AuthBloc>(
      AuthBloc(
        getCurrentUser: sl(),
        logout: sl(),
        sessionEventBus: sl(),
      ),
    )
    ..registerFactory(() => LoginBloc(login: sl(), authBloc: sl()))
    ..registerFactory(() => RegisterBloc(register: sl(), authBloc: sl()));
}
