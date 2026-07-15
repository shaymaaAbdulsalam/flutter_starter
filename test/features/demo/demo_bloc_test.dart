import 'package:flutter_starter/core/error/failure.dart';
import 'package:flutter_starter/core/ui/state/result.dart';
import 'package:flutter_starter/features/demo/presentation/bloc/demo/demo_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Verifies the showcase bloc actually walks through the states the demo
/// screen claims to display — loading → data / typed failure, and the
/// paginated first-page → next-page → reached-end sequence.
void main() {
  DemoBloc bloc() => DemoBloc(latency: Duration.zero);

  group('DemoBloc quote', () {
    test('success scenario: loading → success', () async {
      final b = bloc();
      addTearDown(b.close);
      final statuses = <ResultStatus>[];
      final sub = b.stream.listen((s) => statuses.add(s.quote.status));

      b.add(const DemoQuoteRequested(DemoQuoteScenario.success));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(statuses, contains(ResultStatus.loading));
      expect(b.state.quote.isSuccess, isTrue);
      expect(b.state.quote.data, contains('Dijkstra'));
      await sub.cancel();
    });

    test('network scenario: ends in NetworkFailure', () async {
      final b = bloc();
      addTearDown(b.close);
      b.add(const DemoQuoteRequested(DemoQuoteScenario.networkError));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(b.state.quote.hasError, isTrue);
      expect(b.state.quote.failure, isA<NetworkFailure>());
    });
  });

  group('DemoBloc list', () {
    test('first page, next page, then reached end at totalItems', () async {
      final b = bloc();
      addTearDown(b.close);

      b.add(const DemoItemsFetched(isRefresh: true));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(b.state.items.items.length, DemoBloc.pageSize);
      expect(b.state.items.hasReachedEnd, isFalse);

      b.add(const DemoItemsFetched(isRefresh: false));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      b.add(const DemoItemsFetched(isRefresh: false));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(b.state.items.items.length, DemoBloc.totalItems);
      expect(b.state.items.hasReachedEnd, isTrue);

      // Further load-more requests are no-ops once the end is reached.
      b.add(const DemoItemsFetched(isRefresh: false));
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(b.state.items.items.length, DemoBloc.totalItems);
    });

    test('empty scenario yields isEmpty', () async {
      final b = bloc();
      addTearDown(b.close);
      b.add(const DemoListScenarioChanged(DemoListScenario.empty));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(b.state.items.isEmpty, isTrue);
    });

    test('error scenario yields a typed failure', () async {
      final b = bloc();
      addTearDown(b.close);
      b.add(const DemoListScenarioChanged(DemoListScenario.error));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(b.state.items.hasError, isTrue);
      expect(b.state.items.failure, isA<NetworkFailure>());
    });
  });
}
