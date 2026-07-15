import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/error/failure.dart';
import 'package:flutter_starter/core/ui/state/paginated_result.dart';
import 'package:flutter_starter/core/ui/widgets/app_empty_view.dart';
import 'package:flutter_starter/core/ui/widgets/paginated_result_builder.dart';
import 'package:flutter_test/flutter_test.dart';

/// Drives the ported `PaginatedResultBuilder` with a tiny fake cubit so the
/// whole lifecycle (auto initial-fetch → render → empty) is exercised for real.
class _FakeListCubit extends Cubit<PaginatedResult<String>> {
  _FakeListCubit(this._pageItems) : super(const PaginatedResult.initial());

  final List<String> _pageItems;

  void loadFirst() => emit(state.toLoading().withFirstPage(
        PaginatedPage(items: _pageItems, total: _pageItems.length),
      ));
}

Widget _host(_FakeListCubit cubit, {EmptyViewData? empty}) {
  return MaterialApp(
    home: Scaffold(
      body: BlocProvider<_FakeListCubit>.value(
        value: cubit,
        child: SizedBox(
          height: 600,
          child:
              PaginatedResultBuilder<_FakeListCubit, PaginatedResult<String>, String>(
            selector: (state) => state,
            onFetch: (context, isRefresh) => cubit.loadFirst(),
            emptyData: empty,
            errorBuilder: (context, failure) =>
                Text('ERR:${(failure as Failure).message}'),
            itemBuilder: (context, item) => ListTile(title: Text(item)),
          ),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('auto-fetches the first page and renders items', (tester) async {
    final cubit = _FakeListCubit(['Alpha', 'Beta', 'Gamma']);
    addTearDown(cubit.close);
    await tester.pumpWidget(_host(cubit));
    await tester.pumpAndSettle();

    expect(find.text('Alpha'), findsOneWidget);
    expect(find.text('Beta'), findsOneWidget);
    expect(find.text('Gamma'), findsOneWidget);
  });

  testWidgets('shows the empty view when a completed fetch has no items',
      (tester) async {
    final cubit = _FakeListCubit(const []);
    addTearDown(cubit.close);
    await tester.pumpWidget(
      _host(cubit, empty: const EmptyViewData(title: 'No records')),
    );
    await tester.pumpAndSettle();

    expect(find.text('No records'), findsOneWidget);
    expect(find.byType(ListTile), findsNothing);
  });
}
