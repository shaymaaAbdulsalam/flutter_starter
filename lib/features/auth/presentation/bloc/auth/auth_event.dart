part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthLoggedIn extends AuthEvent {
  const AuthLoggedIn(this.session);

  final AuthSession session;

  @override
  List<Object?> get props => [session];
}

final class AuthLoggedOut extends AuthEvent {
  const AuthLoggedOut();
}
