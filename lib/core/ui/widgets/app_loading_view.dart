import 'package:flutter/material.dart';

/// The kit's single, canonical loading indicator for data slices. Centralizing
/// it means swapping in a skeletonizer/shimmer later is a one-file change that
/// every `ResultBuilder`/`PaginatedResultBuilder` inherits for free.
class AppLoadingView extends StatelessWidget {
  const AppLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
