import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Responder = FutureOr<ResponseBody> Function(RequestOptions options);

class FakeHttpClientAdapter implements HttpClientAdapter {
  FakeHttpClientAdapter(this.responder);

  final Responder responder;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    if (requestStream != null) await requestStream.drain<void>();
    return responder(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonResponse(
  int statusCode, [
  Map<String, Object?> body = const {},
]) =>
    ResponseBody.fromString(
      jsonEncode(body),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

Future<DioException> captureDioException(
  Future<Object?> Function() action,
) async {
  try {
    await action();
  } on DioException catch (e) {
    return e;
  }
  fail('Expected a DioException to be thrown');
}
