import 'package:flutter_starter/core/error/failure.dart';
import 'package:flutter_starter/core/ui/state/result.dart';
import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  group('Result', () {
    test('when() dispatches to the matching branch', () {
      String label(Result<int> r) => r.when(
            idle: () => 'idle',
            loading: () => 'loading',
            success: (d) => 'success:$d',
            failure: (f) => 'failure:${f.message}',
          );

      expect(label(const Result.idle()), 'idle');
      expect(label(const Result.loading()), 'loading');
      expect(label(const Result.success(42)), 'success:42');
      expect(
        label(const Result.failure(NetworkFailure())),
        'failure:Network unavailable',
      );
    });

    test('map transforms the success value only', () {
      expect(const Result.success(2).map((v) => v * 10).data, 20);
      expect(const Result<int>.loading().map((v) => v * 10).isLoading, isTrue);
    });

    test('fromEither maps Right/Left', () {
      expect(Result<int>.fromEither(const Right(7)).data, 7);
      expect(
        Result<int>.fromEither(const Left(ServerFailure(message: 'x'))).failure,
        isA<ServerFailure>(),
      );
    });

    test('linkWithState emits loading then success, and fires onSuccess', () async {
      final emitted = <Result<int>>[];
      var successValue = 0;

      FutureEither<int> useCase() async => const Right(99);

      await useCase().linkWithState(
        emitted.add,
        onSuccess: (v) => successValue = v,
      );

      expect(emitted.map((e) => e.status).toList(),
          [ResultStatus.loading, ResultStatus.success]);
      expect(emitted.last.data, 99);
      expect(successValue, 99);
    });

    test('linkWithState emits loading then failure, and fires onError', () async {
      final emitted = <Result<int>>[];
      Failure? caught;

      FutureEither<int> useCase() async =>
          const Left(NetworkFailure());

      await useCase().linkWithState(emitted.add, onError: (f) => caught = f);

      expect(emitted.map((e) => e.status).toList(),
          [ResultStatus.loading, ResultStatus.failure]);
      expect(caught, isA<NetworkFailure>());
    });
  });
}
