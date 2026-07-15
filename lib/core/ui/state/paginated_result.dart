import 'package:equatable/equatable.dart';

import 'package:flutter_starter/core/error/failure.dart';

/// One page of results: the page's [items] and the server's [total] count.
class PaginatedPage<T> extends Equatable {
  const PaginatedPage({required this.items, required this.total});

  final List<T> items;
  final int total;

  @override
  List<Object?> get props => [items, total];
}

/// Presentation-layer state for an infinite, refreshable list — the kit's
/// version of clinic360's `PaginatedResult`, with a typed [Failure], the
/// `hasReachedEnd` bug fixed (`>=` not `<=`), and intention-revealing page
/// transitions instead of copyWith-with-manual-error-reset plumbing.
class PaginatedResult<T> extends Equatable {
  const PaginatedResult({
    this.items = const [],
    this.failure,
    this.isLoading = false,
    this.total = 0,
    this.isFetched = false,
  });

  const PaginatedResult.initial() : this();

  final List<T> items;
  final Failure? failure;
  final bool isLoading;
  final int total;

  /// True once at least one fetch has completed. Distinguishes "never loaded"
  /// from "loaded and genuinely empty".
  final bool isFetched;

  bool get hasError => failure != null;
  bool get isInitialLoading => isLoading && items.isEmpty;
  bool get isLoadingMore => isLoading && items.isNotEmpty;
  bool get hasReachedEnd => items.length >= total;
  bool get isEmpty =>
      isFetched && !isLoading && failure == null && items.isEmpty;

  PaginatedResult<T> toLoading() => copyWith(isLoading: true, clearFailure: true);

  PaginatedResult<T> withFirstPage(PaginatedPage<T> page) => PaginatedResult(
        items: page.items,
        total: page.total,
        isLoading: false,
        isFetched: true,
      );

  PaginatedResult<T> withNextPage(PaginatedPage<T> page) => PaginatedResult(
        items: [...items, ...page.items],
        total: page.total,
        isLoading: false,
        isFetched: true,
      );

  PaginatedResult<T> withFailure(Failure failure) => copyWith(
        isLoading: false,
        isFetched: true,
        failure: failure,
      );

  PaginatedResult<T> copyWith({
    List<T>? items,
    Failure? failure,
    bool clearFailure = false,
    bool? isLoading,
    int? total,
    bool? isFetched,
  }) {
    return PaginatedResult(
      items: items ?? this.items,
      failure: clearFailure ? null : (failure ?? this.failure),
      isLoading: isLoading ?? this.isLoading,
      total: total ?? this.total,
      isFetched: isFetched ?? this.isFetched,
    );
  }

  @override
  List<Object?> get props => [items, failure, isLoading, total, isFetched];
}
