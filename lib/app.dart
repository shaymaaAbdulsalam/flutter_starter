import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_starter/core/di/setup.dart';
import 'package:flutter_starter/core/theme/theme.dart';

import 'package:flutter_starter/features/auth/presentation/bloc/auth/auth_bloc.dart';

/// Root widget. Wires the app-level [AuthBloc] above the router (so both the
/// guard and every screen share one instance), applies theming, ScreenUtil, and
/// localization, and hands off to `MaterialApp.router`.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>.value(
      // The singleton session bloc from DI — never recreated.
      value: getIt<AuthBloc>(),
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        builder: (context, _) {
          final router = getIt<GoRouter>();
          // The ONE place to rebrand the app — see AppThemeConfig for every
          // knob (full color schemes, font, radii, input & button geometry).
          const themeConfig = AppThemeConfig(
            seedColor: Color(0xFF6750A4),
          );
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            theme: AppTheme.light(themeConfig),
            darkTheme: AppTheme.dark(themeConfig),
            themeMode: ThemeMode.system,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
          );
        },
      ),
    );
  }
}
