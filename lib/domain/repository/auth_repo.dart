import 'package:flutter_starter/core/helpers/result.dart';
import 'package:flutter_starter/domain/models/user_model.dart';

abstract class AuthRepository {
  FutureResult<UserModel> login({
    required String email,
    required String password,
  });
  FutureResult<bool> logout();
  Stream<bool> get shouldLogout;
}
