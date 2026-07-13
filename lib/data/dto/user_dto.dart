import 'package:json_annotation/json_annotation.dart';

import 'package:flutter_starter/data/dto/dto.dart';
import 'package:flutter_starter/domain/models/user_model.dart';

part 'user_dto.g.dart';

@JsonSerializable()
class UserDTO implements Dto<UserModel> {
  final String id;
  final String name;
  final String email;

  const UserDTO({required this.id, required this.name, required this.email});

  factory UserDTO.fromJson(Map<String, dynamic> json) =>
      _$UserDTOFromJson(json);

  Map<String, dynamic> toJson() => _$UserDTOToJson(this);

  factory UserDTO.fromModel(UserModel model) =>
      UserDTO(id: model.id, name: model.name, email: model.email);

  @override
  UserModel toModel() => UserModel(id: id, name: name, email: email);
}
