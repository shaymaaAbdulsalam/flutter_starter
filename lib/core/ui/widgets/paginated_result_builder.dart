import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_starter/core/ui/state/paginated_result.dart';
import 'package:flutter_starter/core/ui/widgets/app_empty_view.dart';
import 'package:flutter_starter/core/ui/widgets/app_error_view.dart';
import 'package:flutter_starter/core/ui/widgets/app_loading_view.dart';

/// Generic, BLoC-aware infinite-scroll list — the kit's port of clinic360's
/// `PaginatedResultBuilder`. Handles the whole lifecycle in one place: initial
/// load, load-more on scroll, pull-to-refresh, and empty / error / loading — so
/// no feature re-implements paging plumbing.
///
/// Same generic contract as `ResultBuilder`: [selector] exposes a
/// `PaginatedResult<T>` from the bloc state; [onFetch] dispatches the fetch
/// event (`isRefresh == true` for first-page/refresh, `false` for next page).
class PaginatedResultBuilder<B extends StateStreamable<S>, S, T>
    extends StatefulWidget {
  const PaginatedResultBuilder({
    super.key,
    required this.selector,
    required this.itemBuilder,
    required this.onFetch,
    this.separatorBuilder,
    this.emptyData,
    this.errorBuilder,
    this.placeholderBuilder,
    this.controller,
    this.padding,
    this.gridDelegate,
    this.loadMoreThreshold = 200,
  });

  final PaginatedResult<T> Function(S state) selector;
  final Widget Function(BuildContext context, T item) itemBuilder;

  /// `isRefresh`: true for first page / pull-to-refresh, false for next page.
  final void Function(BuildContext context, bool isRefresh) onFetch;

  final IndexedWidgetBuilder? separatorBuilder;
  final EmptyViewData? emptyData;
  final Widget Function(BuildContext context, Object failure)? errorBuilder;
  final IndexedWidgetBuilder? placeholderBuilder;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;

  /// If provided, renders a grid instead of a list.
  final SliverGridDelegate? gridDelegate;
  final double loadMoreThreshold;

  @override
  State<PaginatedResultBuilder<B, S, T>> createState() =>
      _PaginatedResultBuilderState<B, S, T>();
}

class _PaginatedResultBuilderState<B extends StateStreamable<S>, S, T>
    extends State<PaginatedResultBuilder<B, S, T>> {
  late final ScrollController _controller =
      widget.controller ?? ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    final bloc = context.read<B>();
    if (!widget.selector(bloc.state).isFetched) {
      widget.onFetch(context, true);
    }
  }

  void _onScroll() {
    if (!_controller.hasClients) return;
    final position = _controller.position;
    if (position.pixels >= position.maxScrollExtent - widget.loadMoreThreshold) {
      widget.onFetch(context, false);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<B, S, PaginatedResult<T>>(
      selector: widget.selector,
      builder: (context, state) {
        if (state.isInitialLoading) {
          return _buildInitialLoading();
        }
        if (state.hasError && state.items.isEmpty) {
          if (widget.errorBuilder != null) {
            return widget.errorBuilder!(context, state.failure!);
          }
          return AppErrorView(
            failure: state.failure!,
            onRetry: () => widget.onFetch(context, true),
          );
        }
        if (state.isEmpty) {
          return AppEmptyView(
            data: widget.emptyData ?? const EmptyViewData(title: 'No data yet'),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => widget.onFetch(context, true),
          child: _buildCollection(state),
        );
      },
    );
  }

  Widget _buildInitialLoading() {
    if (widget.placeholderBuilder == null) return const AppLoadingView();
    return _CollectionView(
      itemCount: 12,
      padding: widget.padding,
      gridDelegate: widget.gridDelegate,
      separatorBuilder: widget.separatorBuilder,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: widget.placeholderBuilder!,
    );
  }

  Widget _buildCollection(PaginatedResult<T> state) {
    final showFooter = !state.hasReachedEnd;
    final itemCount = state.items.length + (showFooter ? 1 : 0);

    return _CollectionView(
      controller: _controller,
      padding: widget.padding,
      gridDelegate: widget.gridDelegate,
      separatorBuilder: widget.separatorBuilder,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index >= state.items.length) {
          return widget.placeholderBuilder?.call(context, index) ??
              const Padding(
                padding: EdgeInsets.all(16),
                child: AppLoadingView(),
              );
        }
        return widget.itemBuilder(context, state.items[index]);
      },
    );
  }
}

/// Renders either a separated [ListView] or a [GridView] from the same inputs.
class _CollectionView extends StatelessWidget {
  const _CollectionView({
    required this.itemCount,
    required this.itemBuilder,
    this.separatorBuilder,
    this.gridDelegate,
    this.controller,
    this.padding,
    this.physics,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final SliverGridDelegate? gridDelegate;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    if (gridDelegate != null) {
      return GridView.builder(
        controller: controller,
        padding: padding,
        physics: physics,
        gridDelegate: gridDelegate!,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      );
    }
    return ListView.separated(
      controller: controller,
      padding: padding,
      physics: physics,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder ??
          (BuildContext context, int index) => const SizedBox.shrink(),
    );
  }
}
