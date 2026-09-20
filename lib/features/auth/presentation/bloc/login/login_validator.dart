part of 'login_bloc.dart';

extension LoginValidation on LoginBloc {
  bool validate(Emitter<LoginState> emit) {
    return checkValidation([
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
