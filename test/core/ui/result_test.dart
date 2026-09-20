import 'package:flutter_starter/core/error/failure.dart';
import 'package:flutter_starter/core/ui/state/result.dart';
import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

void main() {
  group('Result', () {
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
