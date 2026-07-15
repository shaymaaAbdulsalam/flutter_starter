import 'package:flutter/material.dart';

import 'package:flutter_starter/core/extensions/context_extension.dart';

/// The chrome every kit input shares: top-aligned label (with required
/// marker), optional description, the input itself, and the error message
/// below. Ported from clinic360's `InputFieldHeader` + error footer.
///
/// Design decision: the kit uses **top labels**, not Material floating labels.
/// Top labels stay legible with prefilled values, RTL text, and long labels,
/// and they keep the label styling independent of the input's own decoration —
/// which is exactly what makes the fields easy to re-skin per project.
///
/// All strings arrive pre-localized; the shell never calls `.tr()` itself, so
/// it works in any project regardless of localization package.
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

  /// Set false when a parent (e.g. a form row) renders the error itself.
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
