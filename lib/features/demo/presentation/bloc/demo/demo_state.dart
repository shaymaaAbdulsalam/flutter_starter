part of 'demo_bloc.dart';

/// Fake list row — stands in for a real feature's entity.
class DemoItem extends Equatable {
  const DemoItem({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  final int id;
  final String title;
  final String subtitle;

  @override
  List<Object?> get props => [id, title, subtitle];
}

/// The canonical multi-slice state shape: one `Result`/`PaginatedResult` field
/// per fetchable slice, plus whatever plain fields the screen needs.
class DemoState extends Equatable {
  const DemoState({
    this.quote = const Result.idle(),
    this.quoteScenario = DemoQuoteScenario.success,
    this.items = const PaginatedResult.initial(),
    this.listScenario = DemoListScenario.success,
  });

  final Result<String> quote;
  final DemoQuoteScenario quoteScenario;
  final PaginatedResult<DemoItem> items;
  final DemoListScenario listScenario;

  DemoState copyWith({
    Result<String>? quote,
    DemoQuoteScenario? quoteScenario,
    PaginatedResult<DemoItem>? items,
    DemoListScenario? listScenario,
  }) {
    return DemoState(
      quote: quote ?? this.quote,
      quoteScenario: quoteScenario ?? this.quoteScenario,
      items: items ?? this.items,
      listScenario: listScenario ?? this.listScenario,
    );
  }

  @override
  List<Object?> get props => [quote, quoteScenario, items, listScenario];
}
