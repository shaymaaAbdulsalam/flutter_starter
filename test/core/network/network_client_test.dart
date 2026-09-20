import 'package:dio/dio.dart';
import 'package:flutter_starter/core/network/network_client.dart';
import 'package:flutter_starter/core/storage/secure_storage.dart';
import 'package:flutter_starter/core/session/session_event_bus.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_http_client_adapter.dart';

class _InMemorySecureStorage implements SecureStorage {
  String? accessToken = 'old';
  String? refreshToken = 'rt-old';

  @override
  Future<String?> readAccessToken() async => accessToken;

  @override
  Future<String?> readRefreshToken() async => refreshToken;

  @override
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    this.accessToken = accessToken;
    if (refreshToken != null) this.refreshToken = refreshToken;
  }

  @override
  Future<void> clear() async {
    accessToken = null;
    refreshToken = null;
  }
}

ResponseBody _okOnlyForFreshToken(RequestOptions options) =>
    options.headers['Authorization'] == 'Bearer new'
    ? jsonResponse(200, {'ok': true})
    : jsonResponse(401, {'message': 'expired'});

class _Harness {
  _Harness({
    Responder? apiResponder,
    Responder? refreshResponder,
    int maxRefreshRetries = 1,
  }) : store = _InMemorySecureStorage(),
       apiAdapter = FakeHttpClientAdapter(apiResponder ?? _okOnlyForFreshToken),
       refreshAdapter = FakeHttpClientAdapter(
         refreshResponder ?? (_) => jsonResponse(200, {'access_token': 'new'}),
       ) {
    final apiDio = Dio()..httpClientAdapter = apiAdapter;
    final tokenDio = Dio()..httpClientAdapter = refreshAdapter;
    client = NetworkClient(
      localStorage: store,
      sessionEventBus: sessionEventBus,
      dio: apiDio,
      refreshClient: tokenDio,
      maxRefreshRetries: maxRefreshRetries,
    );
    sessionEventBus.stream.listen((_) => sessionExpiredCount++);
  }

  final _InMemorySecureStorage store;
  final FakeHttpClientAdapter apiAdapter;
  final FakeHttpClientAdapter refreshAdapter;
  final sessionEventBus = SessionEventBus();
  late final NetworkClient client;
  int sessionExpiredCount = 0;

  List<String?> get sentTokens => apiAdapter.requests
      .map((r) => r.headers['Authorization'] as String?)
      .toList();
}

void main() {
  test('attaches the stored access token to outgoing requests', () async {
    final h = _Harness(apiResponder: (_) => jsonResponse(200));

    await h.client.dio.get<dynamic>('/me');

    expect(h.sentTokens, ['Bearer old']);
  });

  test('refreshes once on a 401 and replays the request', () async {
    final h = _Harness();

    final response = await h.client.dio.get<Map<String, dynamic>>('/me');

    expect(response.data, {'ok': true});
    expect(h.refreshAdapter.requests, hasLength(1));
    expect(h.sentTokens, ['Bearer old', 'Bearer new']);
    expect(await h.store.readAccessToken(), 'new');
    expect(h.sessionExpiredCount, 0);
  });

  test('concurrent 401s share a single refresh call', () async {
    final h = _Harness();

    final results = await Future.wait([
      h.client.dio.get<dynamic>('/a'),
      h.client.dio.get<dynamic>('/b'),
      h.client.dio.get<dynamic>('/c'),
    ]);

    expect(results.map((r) => r.data), everyElement({'ok': true}));
    expect(h.refreshAdapter.requests, hasLength(1));
  });

  test('gives up after one retry instead of looping forever', () async {
    final h = _Harness(apiResponder: (_) => jsonResponse(401));

    final error = await captureDioException(
      () => h.client.dio.get<dynamic>('/me'),
    );

    expect(error.response?.statusCode, 401);
    expect(h.refreshAdapter.requests, hasLength(1));
    expect(h.apiAdapter.requests, hasLength(2));
  });

  test(
    'a rejected refresh token clears the session and notifies once',
    () async {
      final h = _Harness(refreshResponder: (_) => jsonResponse(401));

      final errors = await Future.wait([
        captureDioException(() => h.client.dio.get<dynamic>('/a')),
        captureDioException(() => h.client.dio.get<dynamic>('/b')),
      ]);

      expect(errors.map((e) => e.response?.statusCode), everyElement(401));
      expect(await h.store.readAccessToken(), isNull);
      expect(h.sessionExpiredCount, 1);
    },
  );

  test('a transient refresh failure keeps the session intact', () async {
    final h = _Harness(refreshResponder: (_) => jsonResponse(503));

    final error = await captureDioException(
      () => h.client.dio.get<dynamic>('/me'),
    );

    expect(error.response?.statusCode, 401);
    expect(await h.store.readAccessToken(), 'old');
    expect(h.sessionExpiredCount, 0);
  });

  test(
    'never refreshes when no refresh token is stored (e.g. a failed login)',
    () async {
      final h = _Harness(apiResponder: (_) => jsonResponse(401));
      h.store.refreshToken = null;

      final error = await captureDioException(
        () => h.client.dio.get<dynamic>('/login'),
      );

      expect(error.response?.statusCode, 401);
      expect(h.refreshAdapter.requests, isEmpty);
      expect(h.sessionExpiredCount, 0);
    },
  );

  test(
    '403 is left alone: a permission error does not end the session',
    () async {
      final h = _Harness(apiResponder: (_) => jsonResponse(403));

      final error = await captureDioException(
        () => h.client.dio.get<dynamic>('/admin'),
      );

      expect(error.response?.statusCode, 403);
      expect(h.refreshAdapter.requests, isEmpty);
      expect(h.sessionExpiredCount, 0);
    },
  );

  test('replays multipart bodies by cloning the form data', () async {
    final h = _Harness();

    final response = await h.client.dio.post<Map<String, dynamic>>(
      '/upload',
      data: FormData.fromMap({'name': 'avatar'}),
    );

    expect(response.data, {'ok': true});
    expect(h.apiAdapter.requests, hasLength(2));
  });

  test('does not replay a request cancelled while refreshing', () async {
    final cancelToken = CancelToken();
    final h = _Harness(
      refreshResponder: (options) {
        cancelToken.cancel();
        return jsonResponse(200, {'access_token': 'new'});
      },
    );

    await expectLater(
      h.client.dio.get<dynamic>('/me', cancelToken: cancelToken),
      throwsA(isA<DioException>()),
    );

    expect(h.apiAdapter.requests, hasLength(1));
  });
}
