import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_starter/core/utils/app_preferences.dart';
import 'package:flutter_starter/data/dio_factory.dart';
import 'package:flutter_starter/data/repository_impl/auth_repo_impl.dart';
import 'package:flutter_starter/domain/repository/auth_repo.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  await _setupCore();
  await _setupData();
  _setupDomain();
}

Future<void> _setupCore() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt
    ..registerLazySingleton<SharedPreferences>(() => sharedPreferences)
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    )
    ..registerLazySingleton<AppPreferences>(
      () => AppPreferences(getIt(), getIt()),
    );
}

Future<void> _setupData() async {
  final dioFactory = DioFactory(getIt());
  await dioFactory.getDio();
  getIt.registerLazySingleton<DioFactory>(() => dioFactory);
}

void _setupDomain() {
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(dioFactory: getIt()),
  );
}
