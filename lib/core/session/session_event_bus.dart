import 'dart:async';

/// Cross-cutting session signals that originate *below* the presentation layer
/// (e.g. the network interceptor detecting an expired token) and need to reach
/// the app-level [AuthBloc] without the data layer importing presentation.
enum SessionEvent {
  /// The server rejected our credentials (401/403). The app must force logout.
  unauthorized,
}

/// A tiny broadcast bus that decouples "something detected the session died"
/// from "the app reacts to it".
///
/// Why this exists: the Dio interceptor lives in the data/network layer and
/// must not know about BLoCs. It emits [SessionEvent.unauthorized] here; the
/// [AuthBloc] (presentation) subscribes and drives the logout. One direction,
/// no circular dependency, single source of truth for session state.
class SessionEventBus {
  final _controller = StreamController<SessionEvent>.broadcast();

  Stream<SessionEvent> get stream => _controller.stream;

  void emit(SessionEvent event) {
    if (!_controller.isClosed) _controller.add(event);
  }

  Future<void> dispose() => _controller.close();
}
