import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_starter/core/di/setup.dart';
import 'package:flutter_starter/core/routing/app_routes.dart';
import 'package:flutter_starter/core/extensions/context_extension.dart';
import 'package:flutter_starter/core/ui/widgets/result_builder.dart';
import 'package:flutter_starter/features/auth/domain/entities/user.dart';
import 'package:flutter_starter/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:flutter_starter/features/home/presentation/bloc/profile/profile_bloc.dart';

/// Authenticated landing screen. Doubles as the working proof that the ported
/// `Result` + `ResultBuilder` pattern holds up end-to-end: it
/// fetches the profile through a real use case and renders loading / success /
/// error (with retry) in one declarative block — no manual `if (loading) …`.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (_) => getIt<ProfileBloc>()..add(const ProfileRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('home.title'.tr()),
          actions: [
            // Kit showcase entry — delete with features/demo/.
            IconButton(
              tooltip: 'demo.open'.tr(),
              icon: const Icon(Icons.widgets_outlined),
              onPressed: () => context.push(AppRoutes.demo),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () =>
                  context.read<AuthBloc>().add(const AuthLoggedOut()),
            ),
          ],
        ),
        body: ResultBuilder<ProfileBloc, ProfileState, User>(
          selector: (state) => state.user,
          onRetry: (bloc) => bloc.add(const ProfileRequested()),
          builder: (context, user) => Center(
            child: Text(
              'home.greeting'.tr(args: [user.name]),
              style: context.textTheme.titleLarge,
            ),
          ),
        ),
      ),
    );
  }
}
