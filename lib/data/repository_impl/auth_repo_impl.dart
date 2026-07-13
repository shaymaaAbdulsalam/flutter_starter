import 'package:flutter_starter/core/helpers/result.dart';
import 'package:flutter_starter/data/app_base_url.dart';
import 'package:flutter_starter/data/dto/user_dto.dart';
import 'package:flutter_starter/data/repository_impl/base.dart';
import 'package:flutter_starter/domain/models/user_model.dart';
import 'package:flutter_starter/domain/repository/auth_repo.dart';

class AuthRepositoryImpl extends BaseRepo implements AuthRepository {
  AuthRepositoryImpl({required super.dioFactory});

  @override
  FutureResult<UserModel> login({
    required String email,
    required String password,
  }) async {
    final result = await dioFactory.dio.post<Map<String, dynamic>>(
      AppBaseUrl.login,
      data: {
        'email': email,
        'password': password,
      },
    );
    return handleMappedResponse(result.data, UserDTO.fromJson);
  }

  @override
  FutureResult<bool> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  // TODO: implement shouldLogout
  Stream<bool> get shouldLogout => throw UnimplementedError();
}
