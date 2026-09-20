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
