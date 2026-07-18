import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/core/base/base_status.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final BaseStatus status;
  final String? errorMessage;

  const LoginState({
    this.email = '',
    this.password = '',
    this.status = BaseStatus.initial,
    this.errorMessage,
  });

  LoginState copyWith({
    String? email,
    String? password,
    BaseStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, password, status, errorMessage];
}
