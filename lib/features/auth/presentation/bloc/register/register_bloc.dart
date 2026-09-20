import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_starter/core/ui/forms/field_value.dart';
import 'package:flutter_starter/core/ui/forms/form_validation.dart';
import 'package:flutter_starter/core/ui/state/result.dart';
import 'package:flutter_starter/features/auth/domain/entities/auth_session.dart';
import 'package:flutter_starter/features/auth/domain/usecases/register_usecase.dart';
import 'package:flutter_starter/features/auth/presentation/bloc/auth/auth_bloc.dart';

part 'register_event.dart';
part 'register_state.dart';
part 'register_validator.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState>
    with FormValidationMixin {
  RegisterBloc({
    required RegisterUseCase register,
    required AuthBloc authBloc,
  })  : _register = register,
        _authBloc = authBloc,
        super(const RegisterState()) {
    on<RegisterNameChanged>(_onNameChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  final RegisterUseCase _register;
  final AuthBloc _authBloc;

  void _onNameChanged(RegisterNameChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(name: state.name.setValue(event.name)));
  }

  void _onEmailChanged(RegisterEmailChanged event, Emitter<RegisterState> emit) {
    emit(state.copyWith(email: state.email.setValue(event.email)));
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(password: state.password.setValue(event.password)));
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    if (!validate(emit)) return;

    await _register(
      RegisterParams(
        name: state.name.value.trim(),
        email: state.email.value.trim(),
        password: state.password.value,
      ),
    ).linkWithState(
      (result) => emit(state.copyWith(submission: result)),
      onSuccess: (session) => _authBloc.add(AuthLoggedIn(session)),
    );
  }
}
