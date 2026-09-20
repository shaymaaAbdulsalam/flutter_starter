import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_starter/core/di/setup.dart';
import 'package:flutter_starter/core/extensions/context_extension.dart';
import 'package:flutter_starter/core/ui/failure_message.dart';
import 'package:flutter_starter/core/ui/inputs/app_text_field.dart';
import 'package:flutter_starter/core/routing/app_routes.dart';
import 'package:flutter_starter/features/auth/presentation/bloc/login/login_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (_) => getIt<LoginBloc>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<LoginBloc, LoginState>(
          listenWhen: (prev, curr) =>
              prev.submission.status != curr.submission.status,
          listener: (context, state) {
            if (state.submission.hasError) {
              context.showErrorSnackBar(state.submission.failure!.toMessage());
            }
          },
          builder: (context, state) {
            final bloc = context.read<LoginBloc>();
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'auth.login_title'.tr(),
                      style: context.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    AppTextField(
                      field: state.email,
                      onChanged: (v) => bloc.add(LoginEmailChanged(v)),
                      label: 'auth.email'.tr(),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    AppTextField(
                      field: state.password,
                      onChanged: (v) => bloc.add(LoginPasswordChanged(v)),
                      label: 'auth.password'.tr(),
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: () => bloc.add(const LoginSubmitted()),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () => bloc.add(const LoginSubmitted()),
                      child: state.isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('auth.login_cta'.tr()),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.signup),
                      child: Text('auth.go_to_register'.tr()),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
