
import 'package:flutter_starter/core/helpers/result.dart';

typedef FuturePaginatedResult<T> = Future<PaginatedResult<T>>;

class PaginatedResult<T> {
  static const pageSize = 10;

  final List<T> items;
  final String? error;
  final bool _isLoading;
  final int total;
  final bool isFetched;

  bool get isSuccess => error == null && !_isLoading;
  bool get hasError => error != null;
  bool get isLoadingMore => _isLoading && items.isNotEmpty;
  bool get isInitialLoading => _isLoading && items.isEmpty;
  bool get hasReachedEnd => items.length <= total;

  PaginatedResult({
    required this.items,
    required this.error,
    required bool isLoading,
    required this.total,
    required this.isFetched,
  }) : _isLoading = isLoading;

  const PaginatedResult.loading()
      : items = const [],
        error = null,
        _isLoading = false,
        total = 0,
        isFetched = false;

  const PaginatedResult.success(this.items, this.total)
      : error = null,
        _isLoading = false,
        isFetched = true;

  const PaginatedResult.failure(this.error)
      : items = const [],
        _isLoading = false,
        total = 0,
        isFetched = true;

  static PaginatedResult<T> fromResult<T>(Result<List<T>> result) {
    if (result.isLoading) {
      return PaginatedResult.loading();
    } else if (result.hasError) {
      return PaginatedResult.failure(result.error!);
    } else {
      return PaginatedResult.success(result.data!, result.data!.length);
    }
  }

  PaginatedResult<T> where(bool Function(T) test) {
    final items = this.items.where(test).toList();
    return PaginatedResult(
      items: items,
      error: error,
      isLoading: _isLoading,
      total: items.length,
      isFetched: isFetched,
    );
  }

  PaginatedResult<T> copyWith({
    List<T>? items,
    String? error,
    bool? isLoading,
    int? total,
    bool? isFetched,
  }) {
    return PaginatedResult(
      items: items ?? this.items,
      error: error,
      isLoading: isLoading ?? _isLoading,
      total: total ?? this.total,
      isFetched: isFetched ?? this.isFetched,
    );
  }

  static Future<void> linkWithState<T>({
    required PaginatedResult<T> result,
    required void Function(PaginatedResult<T> e) onData,
    required Future<PaginatedResult<T>> Function(int page) onFetch,
    required bool isRefresh,
    bool showLoadingOnRefresh = true,
    int? pageSize,
  }) async {
    if ((result.hasReachedEnd && !isRefresh) || result._isLoading) {
      return;
    }
    if (isRefresh || result.items.isEmpty) {
      return await onFetch(1).when(
        onStart: () {
          if (showLoadingOnRefresh) {
            onData(PaginatedResult(
                isLoading: true,
                error: null,
                items: [],
                total: result.total,
                isFetched: true));
          }
        },
        onSuccess: (items, count) => onData(result.copyWith(
          items: items,
          isLoading: false,
          total: count,
          isFetched: true,
        )),
        onError: (error) => onData(result.copyWith(
            error: error,
            isLoading: false,
            isFetched: true,
            total: result.total)),
      );
    }
    onData(result.copyWith(isLoading: true));
    final currentPage =
        result.items.length ~/ (pageSize ?? PaginatedResult.pageSize);

    await onFetch(currentPage + 1).when(
      onSuccess: (data, count) => onData(result.copyWith(
        items: [...result.items, ...data],
        isLoading: false,
        total: count,
        isFetched: true,
      )),
      onError: (error) => onData(result.copyWith(
        error: error,
        isLoading: false,
        isFetched: true,
      )),
    );
  }

  Future when({
    Function()? onStart,
    required Function(List<T> items, int count)? onSuccess,
    required Function(String error)? onError,
  }) async {
    if (_isLoading && onStart != null) {
      return await onStart();
    } else if (isSuccess) {
      return await onSuccess?.call(items, total);
    } else {
      return await onError?.call(error!);
    }
  }

  @override
  String toString() {
    return 'PaginatedResult(hasItems: ${items.isNotEmpty}, error: $error, hasReachedEnd: $hasReachedEnd, isInitialLoading: $isInitialLoading, isLoadingMore: $isLoadingMore, total: $total)';
  }
}

extension PaginatedResultX<S> on Future<PaginatedResult<S>> {
  Future when({
    Function()? onStart,
    required Function(List<S> items, int count)? onSuccess,
    Function(String error)? onError,
    Function()? onDone,
    Function(bool isLoading)? onLoading,
  }) async {
    try {
      await onStart?.call();
      await onLoading?.call(true);
      await (await this).when(
        onSuccess: (items, count) async => await onSuccess?.call(items, count),
        onError: (error) async => await (onError != null
            ? onError(error)
            : Result.errorHandler?.call(error)),
      );
      await onDone?.call();
      await onLoading?.call(false);
    } catch (e) {
      await onLoading?.call(false);
      await (onError != null
          ? onError('Something went wrong')
          : Result.errorHandler?.call('Something went wrong'));
      rethrow;
    }
  }
}
