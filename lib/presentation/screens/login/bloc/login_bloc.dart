import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/base/base_view_model.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'login_email_changed.dart';
import 'login_event.dart';
import 'login_password_changed.dart';
import 'login_state.dart';
import 'login_status.dart';
import 'login_submitted.dart';

@injectable
class LoginBloc extends BaseViewModel<LoginEvent, LoginState> {
  LoginBloc(AppLogger logger) : super(const LoginState(), logger) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(
    LoginEmailChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(email: event.email, status: LoginStatus.initial));
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(state.copyWith(password: event.password, status: LoginStatus.initial));
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.email.isEmpty || state.password.isEmpty) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Email and Password cannot be empty',
      ));
      return;
    }

    emit(state.copyWith(status: LoginStatus.loading));

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (state.email == 'admin@storagepro.com' &&
          state.password == 'password') {
        emit(state.copyWith(status: LoginStatus.success));
      } else {
        emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Invalid credentials',
        ));
      }
    } catch (_) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'An error occurred',
      ));
    }
  }
}
