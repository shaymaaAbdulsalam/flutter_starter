import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_starter/core/di/setup.dart';
import 'package:flutter_starter/core/extensions/context_extension.dart';
import 'package:flutter_starter/core/ui/failure_message.dart';
import 'package:flutter_starter/core/usecase/usecase.dart';
import 'package:flutter_starter/features/auth/domain/usecases/fetch_profile_usecase.dart';
import 'package:flutter_starter/features/auth/presentation/bloc/auth/auth_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isFetching = false;

  Future<void> _fetchProfile() async {
    setState(() => _isFetching = true);
    final result = await getIt<FetchProfileUseCase>().call(const NoParams());
    if (!mounted) return;
    setState(() => _isFetching = false);
    result.fold(
      (failure) => context.showErrorSnackBar(failure.toMessage()),
      (user) =>
          context.showSuccessSnackBar('home.profile_fetched'.tr(args: [user.name])),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthBloc>().state.user;
    return Scaffold(
      appBar: AppBar(title: Text('home.title'.tr())),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  user?.name ?? '',
                  style: context.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: context.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _isFetching ? null : _fetchProfile,
                  child: _isFetching
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('home.fetch_profile'.tr()),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () =>
                      context.read<AuthBloc>().add(const AuthLoggedOut()),
                  child: Text('home.logout'.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
