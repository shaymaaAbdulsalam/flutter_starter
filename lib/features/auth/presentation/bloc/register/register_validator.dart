part of 'register_bloc.dart';

extension RegisterValidation on RegisterBloc {
  bool validate(Emitter<RegisterState> emit) {
    return checkValidation([
      ValidationCondition(
        failsWhen: state.name.value.trim().length < 2,
        message: 'auth.name_required'.tr(),
        onError: (message) =>
            emit(state.copyWith(name: state.name.copyWith(error: message))),
      ),
      ValidationCondition(
        failsWhen: !state.email.value.contains('@'),
        message: 'auth.email_invalid'.tr(),
        onError: (message) =>
            emit(state.copyWith(email: state.email.copyWith(error: message))),
      ),
      ValidationCondition(
        failsWhen: state.password.value.length < 6,
        message: 'auth.password_too_short'.tr(),
        onError: (message) => emit(
          state.copyWith(password: state.password.copyWith(error: message)),
        ),
      ),
    ]);
  }
}
