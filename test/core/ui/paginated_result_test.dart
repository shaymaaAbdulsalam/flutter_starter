import 'package:flutter_starter/core/error/failure.dart';
import 'package:flutter_starter/core/ui/state/paginated_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PaginatedResult', () {
    test('hasReachedEnd is false while pages are still missing (fixed bug)', () {
      const state = PaginatedResult<int>(
        items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
        total: 100,
        isFetched: true,
      );
      expect(state.hasReachedEnd, isFalse);
    });

    test('hasReachedEnd is true once all items are loaded', () {
      const state =
          PaginatedResult<int>(items: [1, 2, 3], total: 3, isFetched: true);
      expect(state.hasReachedEnd, isTrue);
    });

    test('withFirstPage then withNextPage accumulates items', () {
      final state = const PaginatedResult<int>.initial()
          .toLoading()
          .withFirstPage(const PaginatedPage(items: [1, 2], total: 5))
          .withNextPage(const PaginatedPage(items: [3, 4], total: 5));
      expect(state.items, [1, 2, 3, 4]);
      expect(state.isLoading, isFalse);
      expect(state.hasReachedEnd, isFalse);
    });

    test('toLoading clears a previous failure', () {
      final failed =
          const PaginatedResult<int>.initial().withFailure(const NetworkFailure());
      expect(failed.hasError, isTrue);
      expect(failed.toLoading().hasError, isFalse);
    });

    test('isEmpty only after a completed fetch with no items', () {
      expect(const PaginatedResult<int>(isLoading: true).isEmpty, isFalse);
      expect(const PaginatedResult<int>(isFetched: true).isEmpty, isTrue);
    });
  });
}
