import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/base/base_view_model.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/domain/usecases/auth/login_usecase.dart';
import 'package:ventry_flutter/domain/entities/auth/login_params.dart';
import 'login_event.dart';
import 'login_state.dart';

@injectable
class LoginBloc extends BaseViewModel<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc(AppLogger logger, this._loginUseCase)
    : super(const LoginState(), logger) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(email: event.email, status: BaseStatus.initial));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(password: event.password, status: BaseStatus.initial));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.email.isEmpty || state.password.isEmpty) {
      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorMessage: 'Email and Password cannot be empty',
        ),
      );
      return;
    }

    emit(state.copyWith(status: BaseStatus.loading));

    final deviceId =
        '${Platform.operatingSystem}_device_id'; // Normally use device_info_plus

    final result = await _loginUseCase(
      LoginParams(
        username: state.email,
        password: state.password,
        deviceId: deviceId,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BaseStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (user) {
        emit(state.copyWith(status: BaseStatus.success));
      },
    );
  }
}
