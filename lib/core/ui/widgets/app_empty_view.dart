import 'package:flutter/material.dart';

import 'package:flutter_starter/core/extensions/context_extension.dart';

/// Content for an empty state. Strings are passed already-resolved (localize at
/// the call site) so this widget stays presentation-pure and test-friendly.
class EmptyViewData {
  const EmptyViewData({
    required this.title,
    this.description,
    this.action,
  });

  final String title;
  final String? description;
  final Widget? action;
}

/// Canonical empty state for a data slice. Ported from clinic360's
/// `EmptyResultBuilder`, minus its GetX `.tr` coupling and device-type
/// branching.
class AppEmptyView extends StatelessWidget {
  const AppEmptyView({super.key, required this.data});

  final EmptyViewData data;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium,
          ),
          if (data.description != null) ...[
            const SizedBox(height: 8),
            Text(
              data.description!,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
          if (data.action != null) ...[
            const SizedBox(height: 16),
            data.action!,
          ],
        ],
      ),
    );
  }
}
