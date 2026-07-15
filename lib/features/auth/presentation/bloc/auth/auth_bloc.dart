import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_starter/core/session/session_event_bus.dart';
import 'package:flutter_starter/core/usecase/usecase.dart';
import 'package:flutter_starter/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_starter/features/auth/domain/entities/user.dart';
import 'package:flutter_starter/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_starter/features/auth/domain/usecases/logout_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// **App-level, long-lived** session bloc. Registered as a *singleton* and
/// provided above the router. It is the single source of truth for "is the user
/// logged in?", and the router's redirect reads its state.
///
/// It is deliberately NOT the login *form* bloc — form state (fields,
/// validation, submit spinners) belongs in the short-lived `LoginBloc`, created
/// per-page as a *factory*. This split is the key opinionated decision:
/// a session object must outlive any screen, while form objects must not.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required GetCurrentUserUseCase getCurrentUser,
    required LogoutUseCase logout,
    required SessionEventBus sessionEventBus,
  })  : _getCurrentUser = getCurrentUser,
        _logout = logout,
        super(const AuthState.unknown()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoggedIn>(_onLoggedIn);
    on<AuthLoggedOut>(_onLoggedOut);

    // Forced logout signalled from the network layer (expired/invalid token).
    _sessionSub = sessionEventBus.stream.listen((event) {
      if (event == SessionEvent.unauthorized) add(const AuthLoggedOut());
    });
  }

  final GetCurrentUserUseCase _getCurrentUser;
  final LogoutUseCase _logout;
  late final StreamSubscription<SessionEvent> _sessionSub;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final result = await _getCurrentUser(const NoParams());
    result.fold(
      (_) => emit(const AuthState.unauthenticated()),
      (user) => emit(
        user != null
            ? AuthState.authenticated(user)
            : const AuthState.unauthenticated(),
      ),
    );
  }

  void _onLoggedIn(AuthLoggedIn event, Emitter<AuthState> emit) {
    emit(AuthState.authenticated(event.session.user));
  }

  Future<void> _onLoggedOut(AuthLoggedOut event, Emitter<AuthState> emit) async {
    await _logout(const NoParams());
    emit(const AuthState.unauthenticated());
  }

  @override
  Future<void> close() {
    _sessionSub.cancel();
    return super.close();
  }
}
