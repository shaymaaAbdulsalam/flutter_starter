import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_starter/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_starter/features/auth/domain/entities/user.dart';

/// Auth repository **contract**, owned by the domain layer.
///
/// This interface is the seam of Clean Architecture: the domain defines *what*
/// auth operations exist; the data layer decides *how* (Dio, secure storage).
/// Presentation depends only on this abstraction, so the backend can change
/// without touching a single BLoC.
///
/// Every method returns [FutureEither]/[FutureVoid] — no throwing across the
/// boundary, no `Stream<bool> shouldLogout` reactive plumbing leaking into the
/// contract (session-expiry signalling lives in `SessionEventBus`, a concern of
/// the infrastructure, not the domain).
abstract interface class AuthRepository {
  /// Authenticates with email + password and persists the resulting session.
  FutureEither<AuthSession> login({
    required String email,
    required String password,
  });

  /// Creates a new account and persists the resulting session.
  FutureEither<AuthSession> register({
    required String name,
    required String email,
    required String password,
  });

  /// Clears the local session (and best-effort notifies the server).
  FutureVoid logout();

  /// Returns the locally-cached user if a valid session exists, else `null`.
  /// Used on app start to decide the initial route without a network call.
  FutureEither<User?> currentUser();
}
