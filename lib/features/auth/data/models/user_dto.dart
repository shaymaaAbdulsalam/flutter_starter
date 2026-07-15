import 'package:flutter_starter/core/typedefs/typedefs.dart';
import 'package:flutter_starter/features/auth/domain/entities/user.dart';

/// Data Transfer Object for [User].
///
/// Lives in the *data* layer and owns all serialization concerns. Mapping to
/// the domain entity is explicit and isolated in [toEntity] — the domain never
/// imports this, and this never leaks into the domain. That isolation is what
/// lets the API's JSON shape change without touching business logic.
///
/// JSON is hand-written (rather than `json_serializable`) so the reference
/// feature compiles with zero code-gen steps. Swap in `@JsonSerializable` per
/// feature if you prefer — the boundary ([toEntity]) stays identical.
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
