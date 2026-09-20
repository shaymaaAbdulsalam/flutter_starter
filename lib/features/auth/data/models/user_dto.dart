import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_starter/features/auth/domain/entities/user.dart';

class UserDto {
  const UserDto({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  factory UserDto.fromJson(DataMap json) => UserDto(
        id: json['id']?.toString() ?? '',
        name: json['name'] as String? ?? '',
        email: json['email'] as String? ?? '',
      );

  DataMap toJson() => {'id': id, 'name': name, 'email': email};

  User toEntity() => User(id: id, name: name, email: email);
}
