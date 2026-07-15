import 'package:equatable/equatable.dart';

/// Domain entity representing an authenticated user.
///
/// Pure Dart: no `fromJson`/`toJson`, no Flutter, no `dio`, no knowledge of how
/// it is stored or transported. That is the whole point of an entity — it is
/// the shape the *business rules* care about. The data layer's `UserDto` maps
/// to/from this; the presentation layer renders it. Neither concern leaks here.
class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
  });

  final String id;
  final String name;
  final String email;

  @override
  List<Object?> get props => [id, name, email];
}
