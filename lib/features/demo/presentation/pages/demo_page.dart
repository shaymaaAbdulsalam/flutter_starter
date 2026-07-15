import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_starter/core/di/setup.dart';
import 'package:flutter_starter/core/extensions/context_extension.dart';
import 'package:flutter_starter/core/ui/widgets/app_empty_view.dart';
import 'package:flutter_starter/core/ui/widgets/paginated_result_builder.dart';
import 'package:flutter_starter/core/ui/widgets/result_builder.dart';
import 'package:flutter_starter/features/demo/presentation/bloc/demo/demo_bloc.dart';
import 'package:flutter_starter/features/demo/presentation/pages/inputs_gallery_tab.dart';

/// **Kit showcase screen.** Lets you flip through every async-UI state the
/// shared widgets produce — loading, data, typed-failure error (with retry),
/// empty, skeleton placeholders, infinite scroll and pull-to-refresh — all
/// driven through the real `FutureEither` → `linkWithState` → `Result` path.
///
/// Tab 1: `Result` + `ResultBuilder` (single async slice).
/// Tab 2: `PaginatedResult` + `PaginatedResultBuilder` (list slice).
///
/// Delete `features/demo/` when starting a real project.
class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DemoBloc>(
      // Kick off the happy path immediately so the first thing you see is the
      // loading → data transition.
      create: (_) => getIt<DemoBloc>()
        ..add(const DemoQuoteRequested(DemoQuoteScenario.success)),
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('demo.title'.tr()),
            bottom: TabBar(
              tabs: [
                Tab(text: 'demo.tab_result'.tr()),
                Tab(text: 'demo.tab_list'.tr()),
                Tab(text: 'demo.tab_inputs'.tr()),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              _ResultDemoTab(),
              _ListDemoTab(),
              InputsGalleryTab(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Tab 1: single Result slice ───────────────────────────────────────────────

class _ResultDemoTab extends StatelessWidget {
  const _ResultDemoTab();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DemoBloc>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'demo.hint_result'.tr(),
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              BlocBuilder<DemoBloc, DemoState>(
                buildWhen: (p, c) => p.quoteScenario != c.quoteScenario,
                builder: (context, state) => Wrap(
                  spacing: 8,
                  children: [
                    for (final scenario in DemoQuoteScenario.values)
                      ChoiceChip(
                        label: Text(_quoteScenarioLabel(scenario)),
                        selected: state.quoteScenario == scenario,
                        onSelected: (_) =>
                            bloc.add(DemoQuoteRequested(scenario)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // The whole point: ONE declarative block renders loading, data and
        // error-with-retry. No if (isLoading) chains in feature code.
        Expanded(
          child: ResultBuilder<DemoBloc, DemoState, String>(
            selector: (state) => state.quote,
            onRetry: (bloc) =>
                bloc.add(DemoQuoteRequested(bloc.state.quoteScenario)),
            builder: (context, quote) => Center(
              child: Card(
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.format_quote,
                          size: 40, color: context.colors.primary),
                      const SizedBox(height: 12),
                      Text(
                        quote,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _quoteScenarioLabel(DemoQuoteScenario scenario) => switch (scenario) {
        DemoQuoteScenario.success => 'demo.success'.tr(),
        DemoQuoteScenario.networkError => 'demo.network_error'.tr(),
        DemoQuoteScenario.serverError => 'demo.server_error'.tr(),
      };
}

// ── Tab 2: paginated list slice ──────────────────────────────────────────────

class _ListDemoTab extends StatelessWidget {
  const _ListDemoTab();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<DemoBloc>();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'demo.hint_list'.tr(),
                style: context.textTheme.bodySmall?.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              BlocBuilder<DemoBloc, DemoState>(
                buildWhen: (p, c) => p.listScenario != c.listScenario,
                builder: (context, state) => Wrap(
                  spacing: 8,
                  children: [
                    for (final scenario in DemoListScenario.values)
                      ChoiceChip(
                        label: Text(_listScenarioLabel(scenario)),
                        selected: state.listScenario == scenario,
                        onSelected: (_) =>
                            bloc.add(DemoListScenarioChanged(scenario)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: PaginatedResultBuilder<DemoBloc, DemoState, DemoItem>(
            selector: (state) => state.items,
            onFetch: (context, isRefresh) =>
                bloc.add(DemoItemsFetched(isRefresh: isRefresh)),
            emptyData: EmptyViewData(
              title: 'demo.empty_title'.tr(),
              description: 'demo.empty_description'.tr(),
            ),
            // Skeleton rows during initial load & as the load-more footer.
            placeholderBuilder: (context, index) => const _SkeletonTile(),
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, item) => ListTile(
              leading: CircleAvatar(child: Text('${item.id}')),
              title: Text(item.title),
              subtitle: Text(item.subtitle),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        ),
      ],
    );
  }

  String _listScenarioLabel(DemoListScenario scenario) => switch (scenario) {
        DemoListScenario.success => 'demo.success'.tr(),
        DemoListScenario.empty => 'demo.empty'.tr(),
        DemoListScenario.error => 'demo.network_error'.tr(),
      };
}

/// Minimal skeleton row — shows how `placeholderBuilder` slots in. Swap for a
/// shimmer/skeletonizer treatment app-wide by changing this one widget style.
class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();

  @override
  Widget build(BuildContext context) {
    final color = context.colors.surfaceContainerHighest;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12,
                  width: 140,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 10,
                  width: 220,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
