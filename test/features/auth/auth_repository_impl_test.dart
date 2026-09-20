import 'package:flutter_starter/core/error/exceptions.dart';
import 'package:flutter_starter/core/error/failure.dart';
import 'package:flutter_starter/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_starter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_starter/features/auth/data/models/auth_session_dto.dart';
import 'package:flutter_starter/features/auth/data/models/user_dto.dart';
import 'package:flutter_starter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

/// Demonstrates the payoff of the architecture: because the repository depends
/// on *abstractions*, we test it with plain hand-written fakes — no mock
/// framework, no network, no platform channels. And because exceptions are
/// mapped to typed [Failure]s at the boundary, we can assert exactly which
/// failure the domain sees. This is "bug isolation" made verifiable.

class _FakeRemote implements AuthRemoteDataSource {
  _FakeRemote({this.onLogin});

  final Future<AuthSessionDto> Function()? onLogin;

  @override
  Future<AuthSessionDto> login({required String email, required String password}) =>
      onLogin!();

  @override
  Future<AuthSessionDto> register({
    required String name,
    required String email,
    required String password,
  }) =>
      onLogin!();

  @override
  Future<void> logout() async {}

  @override
  Future<UserDto> getCurrentUser() => onLogin!().then((s) => s.user);
}

class _FakeLocal implements AuthLocalDataSource {
  AuthSessionDto? cached;

  @override
  Future<void> cacheSession(AuthSessionDto session) async => cached = session;

  @override
  Future<void> clear() async => cached = null;

  @override
  Future<UserDto?> readCachedUser() async => cached?.user;
}

AuthSessionDto _session() => const AuthSessionDto(
      accessToken: 'token-123',
      user: UserDto(id: '1', name: 'Ada', email: 'ada@example.com'),
    );

void main() {
  group('AuthRepositoryImpl.login', () {
    test('returns Right(session) and caches it on success', () async {
      final local = _FakeLocal();
      final repo = AuthRepositoryImpl(
        remote: _FakeRemote(onLogin: () async => _session()),
        local: local,
      );

      final result = await repo.login(email: 'ada@example.com', password: 'secret1');

      expect(result.isRight(), isTrue);
      result.match(
        (l) => fail('expected Right, got $l'),
        (session) => expect(session.user.name, 'Ada'),
      );
      expect(local.cached, isNotNull, reason: 'session must be persisted');
    });

    test('maps UnauthorizedException to UnauthorizedFailure', () async {
      final repo = AuthRepositoryImpl(
        remote: _FakeRemote(
          onLogin: () async => throw const UnauthorizedException('bad creds', statusCode: 401),
        ),
        local: _FakeLocal(),
      );

      final result = await repo.login(email: 'x@y.z', password: 'nope123');

      expect(result.isLeft(), isTrue);
      final failure = result.getLeft().toNullable();
      expect(failure, isA<UnauthorizedFailure>());
      expect(failure?.code, 401);
    });

    test('maps NetworkException to NetworkFailure (no leak of exceptions)', () async {
      final repo = AuthRepositoryImpl(
        remote: _FakeRemote(onLogin: () async => throw const NetworkException()),
        local: _FakeLocal(),
      );

      final result = await repo.login(email: 'x@y.z', password: 'nope123');

      expect(result.getLeft().toNullable(), isA<NetworkFailure>());
    });
  });
}
