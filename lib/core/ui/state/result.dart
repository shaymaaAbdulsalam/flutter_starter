import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:flutter_starter/core/error/failure.dart';
import 'package:flutter_starter/core/typedefs/typedefs.dart';

/// The lifecycle status of an async data slice held in a BLoC state.
enum ResultStatus { idle, loading, success, failure }

/// **Presentation-layer** async-state slice: idle → loading → success(T) /
/// failure([Failure]).
///
/// This is the kit's version of clinic360's `Result<T>`, kept because its
/// ergonomics (`when`, `map`, `linkWithState`) make bloc/UI code terse and
/// uniform — but corrected in two ways:
///   1. it carries a typed [Failure], not a bare `String`, so it stays
///      consistent with the kit's error model and localizes by type;
///   2. there is **no** global `static errorHandler` (global mutable state is a
///      testability and coupling hazard).
///
/// It is a UI state type, distinct from the domain's [FutureEither]: a use case
/// returns `FutureEither<T>`; a bloc folds that into a `Result<T>` it stores in
/// state (usually via [FutureEitherLink.linkWithState]); the UI renders it with
/// a `ResultBuilder`.
final class Result<T> extends Equatable {
  const Result._({
    this.status = ResultStatus.idle,
    this.data,
    this.failure,
  });

  const Result.idle() : this._();

  /// Loading. Optionally keep [previousData] to show stale content while
  /// refreshing instead of flashing a spinner.
  const Result.loading({T? previousData})
      : this._(status: ResultStatus.loading, data: previousData);

  const Result.success(T data)
      : this._(status: ResultStatus.success, data: data);

  const Result.failure(Failure failure)
      : this._(status: ResultStatus.failure, failure: failure);

  /// Fold the terminal result of a use case straight into a `Result`.
  factory Result.fromEither(Either<Failure, T> either) => either.match(
        (failure) => Result<T>.failure(failure),
        (data) => Result<T>.success(data),
      );

  final ResultStatus status;
  final T? data;
  final Failure? failure;

  bool get isIdle => status == ResultStatus.idle;
  bool get isLoading => status == ResultStatus.loading;
  bool get isSuccess => status == ResultStatus.success;
  bool get hasError => status == ResultStatus.failure;
  bool get hasData => data != null;

  /// Exhaustive mapping — the primary consumer is `ResultBuilder`. [idle] falls
  /// back to [loading] when omitted.
  R when<R>({
    required R Function() loading,
    required R Function(T data) success,
    required R Function(Failure failure) failure,
    R Function()? idle,
  }) {
    switch (status) {
      case ResultStatus.idle:
        return (idle ?? loading)();
      case ResultStatus.loading:
        return loading();
      case ResultStatus.success:
        return success(data as T);
      case ResultStatus.failure:
        return failure(this.failure!);
    }
  }

  /// Partial mapping with a required [orElse] fallback.
  R maybeWhen<R>({
    R Function()? idle,
    R Function()? loading,
    R Function(T data)? success,
    R Function(Failure failure)? failure,
    required R Function() orElse,
  }) {
    switch (status) {
      case ResultStatus.idle:
        return idle?.call() ?? orElse();
      case ResultStatus.loading:
        return loading?.call() ?? orElse();
      case ResultStatus.success:
        return success?.call(data as T) ?? orElse();
      case ResultStatus.failure:
        return failure?.call(this.failure!) ?? orElse();
    }
  }

  /// Transform the success value, preserving status/failure.
  Result<R> map<R>(R Function(T data) transform) => Result<R>._(
        status: status,
        data: data == null ? null : transform(data as T),
        failure: failure,
      );

  @override
  List<Object?> get props => [status, data, failure];
}

/// Bridges a use case's [FutureEither] to a bloc's `Result` slice in one call —
/// the kit's take on clinic360's `linkWithState`.
///
/// Emits `Result.loading()`, awaits the use case, then emits the terminal
/// `Result`. Optional [onSuccess]/[onError] hooks fire after emission (e.g. to
/// notify another bloc or trigger navigation).
///
/// ```dart
/// await _login(params).linkWithState(
///   (result) => emit(state.copyWith(submission: result)),
///   onSuccess: (session) => _authBloc.add(AuthLoggedIn(session)),
/// );
/// ```
extension FutureEitherLink<T> on FutureEither<T> {
  Future<Result<T>> linkWithState(
    void Function(Result<T> result) emit, {
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onError,
  }) async {
    emit(Result<T>.loading());
    final either = await this;
    final result = Result<T>.fromEither(either);
    emit(result);
    either.match(
      (failure) => onError?.call(failure),
      (data) => onSuccess?.call(data),
    );
    return result;
  }
}
