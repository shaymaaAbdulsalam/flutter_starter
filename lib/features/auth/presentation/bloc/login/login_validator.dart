part of 'login_bloc.dart';

/// Login validation rules, kept in the bloc (per the kit convention) as an
/// extension that calls [FormValidationMixin.checkValidation]. Each failing
/// rule attaches its localized message to the offending [FieldValue]; the UI
/// renders it automatically via `AppTextField`.
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
