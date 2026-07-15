import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_starter/core/ui/forms/field_value.dart';
import 'package:flutter_starter/core/ui/forms/form_validation.dart';
import 'package:flutter_starter/core/ui/state/result.dart';
import 'package:flutter_starter/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_starter/features/auth/domain/usecases/login_usecase.dart';
import 'package:flutter_starter/features/auth/presentation/bloc/auth/auth_bloc.dart';

part 'login_event.dart';
part 'login_state.dart';
part 'login_validator.dart';

/// Short-lived login form bloc (registered as a factory). Demonstrates the
/// ported form stack end-to-end:
///   * fields are [FieldValue]s (value + error) in the state;
///   * validation lives in the bloc ([LoginValidation.validate]), not the UI;
///   * the submission is a [Result] slice driven by `linkWithState`, so the one
///     call emits loading → success/failure and forwards the session to the
///     app-level [AuthBloc].
class LoginBloc extends Bloc<LoginEvent, LoginState> with FormValidationMixin {
  LoginBloc({
    required LoginUseCase login,
    required AuthBloc authBloc,
  })  : _login = login,
        _authBloc = authBloc,
        super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  final LoginUseCase _login;
  final AuthBloc _authBloc;

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: state.email.setValue(event.email)));
  }

  void _onPasswordChanged(LoginPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: state.password.setValue(event.password)));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (!validate(emit)) return;

    await _login(
      LoginParams(
        email: state.email.value.trim(),
        password: state.password.value,
      ),
    ).linkWithState(
      (result) => emit(state.copyWith(submission: result)),
      onSuccess: (session) => _authBloc.add(AuthLoggedIn(session)),
    );
  }
}
