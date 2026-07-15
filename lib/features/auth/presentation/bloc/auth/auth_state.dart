part of 'auth_bloc.dart';

/// Tri-state session status. `unknown` is the crucial third state: at startup
/// we do not yet know if there is a session, so the router shows a splash
/// instead of flashing the login screen before the cache is read.
enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState._({required this.status, this.user});

  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  final AuthStatus status;
  final User? user;

  bool get isAuthenticated => status == AuthStatus.authenticated;

  @override
  List<Object?> get props => [status, user];
}
