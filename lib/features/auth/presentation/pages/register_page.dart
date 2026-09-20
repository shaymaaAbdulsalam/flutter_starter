import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_starter/core/di/setup.dart';
import 'package:flutter_starter/core/extensions/context_extension.dart';
import 'package:flutter_starter/core/ui/failure_message.dart';
import 'package:flutter_starter/core/ui/inputs/app_text_field.dart';
import 'package:flutter_starter/features/auth/presentation/bloc/register/register_bloc.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (_) => getIt<RegisterBloc>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatelessWidget {
  const _RegisterView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('auth.register_title'.tr())),
      body: SafeArea(
        child: BlocConsumer<RegisterBloc, RegisterState>(
          listenWhen: (prev, curr) =>
              prev.submission.status != curr.submission.status,
          listener: (context, state) {
            if (state.submission.hasError) {
              context.showErrorSnackBar(state.submission.failure!.toMessage());
            }
          },
          builder: (context, state) {
            final bloc = context.read<RegisterBloc>();
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    field: state.name,
                    onChanged: (v) => bloc.add(RegisterNameChanged(v)),
                    label: 'auth.name'.tr(),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    field: state.email,
                    onChanged: (v) => bloc.add(RegisterEmailChanged(v)),
                    label: 'auth.email'.tr(),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),
                  AppTextField(
                    field: state.password,
                    onChanged: (v) => bloc.add(RegisterPasswordChanged(v)),
                    label: 'auth.password'.tr(),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: () => bloc.add(const RegisterSubmitted()),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: state.isSubmitting
                        ? null
                        : () => bloc.add(const RegisterSubmitted()),
                    child: state.isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text('auth.register_cta'.tr()),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
