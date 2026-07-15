part of 'demo_bloc.dart';

/// Scenario the fake single-result API should play out.
enum DemoQuoteScenario { success, networkError, serverError }

/// Scenario the fake list API should play out.
enum DemoListScenario { success, empty, error }

sealed class DemoEvent extends Equatable {
  const DemoEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch the single result with the given scenario (also used by retry).
final class DemoQuoteRequested extends DemoEvent {
  const DemoQuoteRequested(this.scenario);

  final DemoQuoteScenario scenario;

  @override
  List<Object?> get props => [scenario];
}

/// Switch the list scenario — resets the list and refetches page one.
final class DemoListScenarioChanged extends DemoEvent {
  const DemoListScenarioChanged(this.scenario);

  final DemoListScenario scenario;

  @override
  List<Object?> get props => [scenario];
}

/// Dispatched by `PaginatedResultBuilder.onFetch` — first page / refresh when
/// [isRefresh] is true, next page otherwise.
final class DemoItemsFetched extends DemoEvent {
  const DemoItemsFetched({required this.isRefresh});

  final bool isRefresh;

  @override
  List<Object?> get props => [isRefresh];
}
