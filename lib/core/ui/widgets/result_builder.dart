import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_starter/core/error/failure.dart';
import 'package:flutter_starter/core/ui/state/result.dart';
import 'package:flutter_starter/core/ui/widgets/app_error_view.dart';
import 'package:flutter_starter/core/ui/widgets/app_loading_view.dart';

/// One-line, consistent state→UI mapping for a [Result] slice held in a BLoC's
/// state. The kit's port of clinic360's `ResultBuilder`.
///
/// The "BLoC-in-component" coupling here is deliberate and *generic*, not tied
/// to one BLoC: [B] is any `StateStreamable<S>`, [selector] extracts the
/// `Result<T>` slice, and the widget maps loading/success/failure to the
/// standard views (wiring retry back to the bloc). The only contract is "your
/// state exposes a `Result<T>` via a selector".
///
/// ```dart
/// ResultBuilder<ProfileBloc, ProfileState, User>(
///   selector: (s) => s.user,
///   onRetry: (bloc) => bloc.add(const ProfileRequested()),
///   builder: (context, user) => Text(user.name),
/// )
/// ```
class ResultBuilder<B extends StateStreamable<S>, S, T>
    extends StatelessWidget {
  const ResultBuilder({
    super.key,
    required this.selector,
    required this.builder,
    this.onRetry,
    this.loadingBuilder,
    this.errorBuilder,
  });

  final Result<T> Function(S state) selector;
  final Widget Function(BuildContext context, T data) builder;
  final void Function(B bloc)? onRetry;
  final WidgetBuilder? loadingBuilder;
  final Widget Function(BuildContext context, Failure failure)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B, S>(
      buildWhen: (previous, current) => selector(previous) != selector(current),
      builder: (context, state) {
        return selector(state).when(
          loading: () => loadingBuilder?.call(context) ?? const AppLoadingView(),
          success: (data) => builder(context, data),
          failure: (failure) =>
              errorBuilder?.call(context, failure) ??
              AppErrorView(
                failure: failure,
                onRetry: onRetry == null
                    ? null
                    : () => onRetry!(context.read<B>()),
              ),
        );
      },
    );
  }
}
