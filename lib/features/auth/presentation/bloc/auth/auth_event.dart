part of 'auth_bloc.dart';

/// Base class for every [AuthBloc] event. Sealed → handlers stay exhaustive;
/// `const` + Equatable → cheap, value-comparable, no duplicate rebuilds.
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once at startup to resolve the cached session and pick the first route.
final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

/// Fired by a form bloc (e.g. [LoginBloc]) after a successful authentication,
/// handing the established session to the single source of truth.
final class AuthLoggedIn extends AuthEvent {
  const AuthLoggedIn(this.session);

  final AuthSession session;

  @override
  List<Object?> get props => [session];
}

/// Fired on explicit logout, or automatically on a forced (token-expired) one.
final class AuthLoggedOut extends AuthEvent {
  const AuthLoggedOut();
}
