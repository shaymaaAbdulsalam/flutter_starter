import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:flutter_starter/core/error/failure.dart';
import 'package:flutter_starter/core/extensions/context_extension.dart';
import 'package:flutter_starter/core/ui/failure_message.dart';

/// Canonical error state for a data slice. Renders the *localized* message for
/// the failure type (never the raw `Failure.message`) and an optional retry.
///
/// Ported from clinic360's `ErrorResultBuilder`, keeping its nice touch of
/// showing a distinct icon for connectivity errors — but driven by the typed
/// [Failure] hierarchy instead of substring-matching an English string
/// (`error.contains('no internet')`), which is both robust and localizable.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.failure,
    this.onRetry,
    this.isCompact = false,
  });

  final Failure failure;
  final VoidCallback? onRetry;
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCompact ? null : double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisSize: isCompact ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            failure is NetworkFailure
                ? Icons.wifi_off_outlined
                : Icons.error_outline,
            color: context.colors.error,
            size: 72,
          ),
          const SizedBox(height: 16),
          Text(
            failure.toMessage(),
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text('common.retry'.tr()),
            ),
          ],
        ],
      ),
    );
  }
}
