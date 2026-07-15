part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Load (or reload, on retry) the current user's profile.
final class ProfileRequested extends ProfileEvent {
  const ProfileRequested();
}
