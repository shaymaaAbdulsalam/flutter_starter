import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_starter/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_starter/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  FutureEither<AuthSession> login({
    required String email,
    required String password,
  });

  FutureEither<AuthSession> register({
    required String name,
    required String email,
    required String password,
  });

  FutureVoid logout();

  FutureEither<User?> currentUser();

  FutureEither<User> fetchProfile();
}
