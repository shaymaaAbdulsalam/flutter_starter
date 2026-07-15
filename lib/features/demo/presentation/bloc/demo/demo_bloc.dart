import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import 'package:flutter_starter/core/error/failure.dart';
import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_starter/core/ui/state/paginated_result.dart';
import 'package:flutter_starter/core/ui/state/result.dart';

part 'demo_event.dart';
part 'demo_state.dart';

/// **Showcase bloc** — exists purely to demonstrate the kit's async-state
/// stack with a fake in-memory "API" (simulated latency, switchable
/// scenarios). It exercises the *real* plumbing end-to-end:
///
///   * a `Result<String>` slice driven by `linkWithState`
///     (loading → success / typed-`Failure` error, rendered by `ResultBuilder`);
///   * a `PaginatedResult<DemoItem>` slice with first-page / next-page / empty
///     / error transitions (rendered by `PaginatedResultBuilder`).
///
/// Delete this feature (folder + injection + route) when starting a real
/// project — nothing else depends on it.
class DemoBloc extends Bloc<DemoEvent, DemoState> {
  DemoBloc({this.latency = const Duration(milliseconds: 900)})
      : super(const DemoState()) {
    on<DemoQuoteRequested>(_onQuoteRequested);
    on<DemoListScenarioChanged>(_onListScenarioChanged);
    on<DemoItemsFetched>(_onItemsFetched);
  }

  /// Injectable so tests can pass [Duration.zero].
  final Duration latency;

  static const pageSize = 15;
  static const totalItems = 45;

  // ── Single result ─────────────────────────────────────────────────────────

  Future<void> _onQuoteRequested(
    DemoQuoteRequested event,
    Emitter<DemoState> emit,
  ) async {
    emit(state.copyWith(quoteScenario: event.scenario));
    // The canonical one-liner: loading → terminal Result, no manual booleans.
    await _fakeQuoteApi(event.scenario).linkWithState(
      (result) => emit(state.copyWith(quote: result)),
    );
  }

  // ── Paginated list ────────────────────────────────────────────────────────

  Future<void> _onListScenarioChanged(
    DemoListScenarioChanged event,
    Emitter<DemoState> emit,
  ) async {
    emit(state.copyWith(
      listScenario: event.scenario,
      items: const PaginatedResult.initial(),
    ));
    await _fetchItems(emit, refresh: true);
  }

  Future<void> _onItemsFetched(
    DemoItemsFetched event,
    Emitter<DemoState> emit,
  ) =>
      _fetchItems(emit, refresh: event.isRefresh);

  Future<void> _fetchItems(
    Emitter<DemoState> emit, {
    required bool refresh,
  }) async {
    final current = state.items;
    // Guards: the scroll listener fires repeatedly near the bottom — the state
    // itself makes duplicate fetches a no-op.
    if (current.isLoading) return;
    if (!refresh && current.hasReachedEnd) return;

    emit(state.copyWith(
      items: refresh
          ? const PaginatedResult<DemoItem>.initial().toLoading()
          : current.toLoading(),
    ));

    final page = refresh ? 1 : (current.items.length ~/ pageSize) + 1;
    final result = await _fakeItemsApi(page, state.listScenario);

    result.match(
      (failure) => emit(state.copyWith(items: state.items.withFailure(failure))),
      (pageData) => emit(state.copyWith(
        items: refresh
            ? state.items.withFirstPage(pageData)
            : state.items.withNextPage(pageData),
      )),
    );
  }

  // ── Fake API (stands in for a use case returning FutureEither) ───────────

  FutureEither<String> _fakeQuoteApi(DemoQuoteScenario scenario) async {
    await Future<void>.delayed(latency);
    return switch (scenario) {
      DemoQuoteScenario.success => const Right(
          'Simplicity is a great virtue but it requires hard work to achieve it '
          '— and education to appreciate it. — Edsger W. Dijkstra',
        ),
      DemoQuoteScenario.networkError => const Left(NetworkFailure()),
      DemoQuoteScenario.serverError =>
        const Left(ServerFailure(message: 'Demo 500', code: 500)),
    };
  }

  FutureEither<PaginatedPage<DemoItem>> _fakeItemsApi(
    int page,
    DemoListScenario scenario,
  ) async {
    await Future<void>.delayed(latency);
    switch (scenario) {
      case DemoListScenario.error:
        return const Left(NetworkFailure());
      case DemoListScenario.empty:
        return const Right(PaginatedPage(items: [], total: 0));
      case DemoListScenario.success:
        final start = (page - 1) * pageSize;
        final items = List.generate(
          pageSize,
          (i) => DemoItem(
            id: start + i + 1,
            title: 'Item #${start + i + 1}',
            subtitle: 'Page $page — fetched through PaginatedResult',
          ),
        );
        return Right(PaginatedPage(items: items, total: totalItems));
    }
  }
}
