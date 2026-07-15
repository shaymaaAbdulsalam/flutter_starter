part of 'profile_bloc.dart';

/// A state that holds a single async slice — the canonical shape a
/// `ResultBuilder` consumes: the bloc exposes one (or several) `Result<T>`
/// fields, and the UI selects the one it renders.
class ProfileState extends Equatable {
  const ProfileState({this.user = const Result.idle()});

  final Result<User> user;

  ProfileState copyWith({Result<User>? user}) =>
      ProfileState(user: user ?? this.user);

  @override
  List<Object?> get props => [user];
}
