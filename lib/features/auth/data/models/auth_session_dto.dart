import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_starter/features/auth/data/models/user_dto.dart';
import 'package:flutter_starter/features/auth/domain/entities/auth_session.dart';

/// DTO for a successful auth response: tokens + the user payload.
///
/// Adjust [fromJson] to match your backend's login/register envelope. This is
/// the *only* place that knows the wire shape of an auth response.
class AuthSessionDto {
  const AuthSessionDto({
    required this.accessToken,
    required this.user,
    this.refreshToken,
  });

  final String accessToken;
  final String? refreshToken;
  final UserDto user;

  factory AuthSessionDto.fromJson(DataMap json) => AuthSessionDto(
        accessToken: (json['access_token'] ?? json['token'] ?? '') as String,
        refreshToken: json['refresh_token'] as String?,
        user: UserDto.fromJson(json['user'] as DataMap? ?? const {}),
      );

  DataMap toJson() => {
        'access_token': accessToken,
        if (refreshToken != null) 'refresh_token': refreshToken,
        'user': user.toJson(),
      };

  AuthSession toEntity() => AuthSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        user: user.toEntity(),
      );
}
