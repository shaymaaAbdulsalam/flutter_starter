import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_starter/app.dart';
import 'package:flutter_starter/core/di/setup.dart';
import 'package:flutter_starter/features/auth/presentation/bloc/auth/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  // Build the dependency graph before the first frame.
  await setupGetIt();

  // Kick off session resolution: reads the cached session and moves the router
  // off the splash screen to either login or home.
  getIt<AuthBloc>().add(const AuthStarted());

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const App(),
    ),
  );
}
