import 'package:equatable/equatable.dart';

import 'package:flutter_starter/features/auth/domain/entities/user.dart';

/// The result of a successful authentication: the tokens plus the user they
/// belong to.
///
/// The old contract returned only a `User` from `login`, with no token — which
/// meant login could never actually establish a session. Making the session an
/// explicit entity forces every auth flow to account for the credential.
class AuthSession extends Equatable {
  const AuthSession({
    required this.accessToken,
    required this.user,
    this.refreshToken,
  });

  final String accessToken;
  final String? refreshToken;
  final User user;

  @override
  List<Object?> get props => [accessToken, refreshToken, user];
}
