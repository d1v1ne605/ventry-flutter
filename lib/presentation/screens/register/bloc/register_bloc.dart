import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/base/base_view_model.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/domain/entities/onboarding/register_owner_params.dart';
import 'package:ventry_flutter/domain/usecases/onboarding/register_owner.dart';
import 'register_confirm_password_changed.dart';
import 'register_event.dart';
import 'register_name_changed.dart';
import 'register_password_changed.dart';
import 'register_shop_name_changed.dart';
import 'register_state.dart';
import 'register_status.dart';
import 'register_submitted.dart';
import 'register_username_changed.dart';

@injectable
class RegisterBloc extends BaseViewModel<RegisterEvent, RegisterState> {
  final RegisterOwner _registerOwner;

  RegisterBloc(this._registerOwner, AppLogger logger)
    : super(const RegisterState(), logger) {
    on<RegisterNameChanged>(_onNameChanged);
    on<RegisterUsernameChanged>(_onUsernameChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<RegisterShopNameChanged>(_onShopNameChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  void _onNameChanged(RegisterNameChanged event, Emitter<RegisterState> emit) {
    emit(_resetState(name: event.name));
  }

  void _onUsernameChanged(
    RegisterUsernameChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(_resetState(username: event.username));
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(_resetState(password: event.password));
  }

  void _onConfirmPasswordChanged(
    RegisterConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(_resetState(confirmPassword: event.confirmPassword));
  }

  void _onShopNameChanged(
    RegisterShopNameChanged event,
    Emitter<RegisterState> emit,
  ) {
    emit(_resetState(shopName: event.shopName));
  }

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    final validationMessage = _validateForm();
    if (validationMessage != null) {
      emit(_failureState(validationMessage));
      return;
    }

    emit(state.copyWith(status: RegisterStatus.loading, errorMessage: null));

    final result = await _registerOwner(_request);
    result.fold(
      (failure) => emit(_failureState(failure.message)),
      (response) => emit(
        state.copyWith(
          status: RegisterStatus.success,
          errorMessage: null,
          owner: response,
        ),
      ),
    );
  }

  RegisterState _resetState({
    String? name,
    String? username,
    String? password,
    String? confirmPassword,
    String? shopName,
  }) {
    return state.copyWith(
      name: name,
      username: username,
      password: password,
      confirmPassword: confirmPassword,
      shopName: shopName,
      status: RegisterStatus.initial,
      errorMessage: null,
      owner: null,
    );
  }

  RegisterState _failureState(String message) {
    return state.copyWith(
      status: RegisterStatus.failure,
      errorMessage: message,
      owner: null,
    );
  }

  String? _validateForm() {
    if (state.name.trim().isEmpty ||
        state.username.trim().isEmpty ||
        state.password.isEmpty ||
        state.confirmPassword.isEmpty ||
        state.shopName.trim().isEmpty) {
      return AppStrings.register.errorRequiredFields;
    }

    if (state.password != state.confirmPassword) {
      return AppStrings.register.errorPasswordMismatch;
    }

    return null;
  }

  RegisterOwnerParams get _request {
    return RegisterOwnerParams(
      username: state.username.trim(),
      password: state.password,
      shopName: state.shopName.trim(),
      name: state.name.trim(),
    );
  }
}
