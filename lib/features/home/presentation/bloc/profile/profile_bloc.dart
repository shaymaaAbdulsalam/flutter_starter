import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_starter/core/error/failure.dart';
import 'package:flutter_starter/core/ui/state/result.dart';
import 'package:flutter_starter/core/usecase/usecase.dart';
import 'package:flutter_starter/features/auth/domain/entities/user.dart';
import 'package:flutter_starter/features/auth/domain/usecases/get_current_user_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

/// Demonstrates the `Result` + `ResultBuilder` pattern on a real fetch. It maps
/// a `null` cached user to an [UnknownFailure] (a business rule), which is why
/// it folds the result explicitly rather than using `linkWithState` — the
/// auth login/register blocs show the `linkWithState` one-liner instead.
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._getCurrentUser) : super(const ProfileState()) {
    on<ProfileRequested>(_onRequested);
  }

  final GetCurrentUserUseCase _getCurrentUser;

  Future<void> _onRequested(
    ProfileRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(user: const Result.loading()));

    final result = await _getCurrentUser(const NoParams());

    emit(state.copyWith(
      user: result.fold(
        (failure) => Result.failure(failure),
        (user) => user != null
            ? Result.success(user)
            : const Result.failure(
                UnknownFailure(message: 'No profile found'),
              ),
      ),
    ));
  }
}
