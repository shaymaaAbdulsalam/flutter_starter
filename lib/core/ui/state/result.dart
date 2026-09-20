import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:flutter_starter/core/error/failure.dart';
import 'package:flutter_starter/core/typedefs/typedefs.dart';

enum ResultStatus { idle, loading, success, failure }

final class Result<T> extends Equatable {
  const Result._({
    this.status = ResultStatus.idle,
    this.data,
    this.failure,
  });

  const Result.idle() : this._();

  const Result.loading({T? previousData})
      : this._(status: ResultStatus.loading, data: previousData);

  const Result.success(T data)
      : this._(status: ResultStatus.success, data: data);

  const Result.failure(Failure failure)
      : this._(status: ResultStatus.failure, failure: failure);

  factory Result.fromEither(Either<Failure, T> either) => either.match(
        (failure) => Result<T>.failure(failure),
        (data) => Result<T>.success(data),
      );

  final ResultStatus status;
  final T? data;
  final Failure? failure;

  bool get isLoading => status == ResultStatus.loading;
  bool get hasError => status == ResultStatus.failure;

  @override
  List<Object?> get props => [status, data, failure];
}

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
