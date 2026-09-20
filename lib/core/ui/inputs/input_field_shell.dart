import 'package:flutter/material.dart';

import 'package:flutter_starter/core/extensions/context_extension.dart';

class InputFieldShell extends StatelessWidget {
  const InputFieldShell({
    super.key,
    required this.child,
    this.label,
    this.description,
    this.error,
    this.isRequired = false,
    this.enabled = true,
    this.showError = true,
  });

  final Widget child;
  final String? label;
  final String? description;
  final String? error;
  final bool isRequired;
  final bool enabled;

  final bool showError;

  bool get hasError => error != null && error!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text.rich(
            TextSpan(
              text: label,
              style: context.textTheme.bodyLarge?.copyWith(
                color: enabled
                    ? context.colors.onSurface
                    : context.colors.outline,
                fontWeight: FontWeight.w500,
              ),
              children: [
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: context.textTheme.labelLarge
                        ?.copyWith(color: context.colors.error),
                  ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
        ],
        if (description != null) ...[
          Text(
            description!,
            style: context.textTheme.labelLarge
                ?.copyWith(color: context.colors.onSurfaceVariant),
          ),
          const SizedBox(height: 6),
        ],
        IgnorePointer(ignoring: !enabled, child: child),
        if (hasError && showError)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error!,
              style: context.textTheme.bodySmall
                  ?.copyWith(color: context.colors.error),
            ),
          ),
      ],
    );
  }
}
