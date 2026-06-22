import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/onboarding/register_owner_entity.dart';
import 'register_status.dart';

const Object _unsetValue = Object();

class RegisterState extends Equatable {
  final String name;
  final String username;
  final String password;
  final String confirmPassword;
  final String shopName;
  final RegisterStatus status;
  final String? errorMessage;
  final RegisterOwnerEntity? owner;

  const RegisterState({
    this.name = '',
    this.username = '',
    this.password = '',
    this.confirmPassword = '',
    this.shopName = '',
    this.status = RegisterStatus.initial,
    this.errorMessage,
    this.owner,
  });

  RegisterState copyWith({
    String? name,
    String? username,
    String? password,
    String? confirmPassword,
    String? shopName,
    RegisterStatus? status,
    Object? errorMessage = _unsetValue,
    Object? owner = _unsetValue,
  }) {
    return RegisterState(
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      shopName: shopName ?? this.shopName,
      status: status ?? this.status,
      errorMessage: identical(errorMessage, _unsetValue)
          ? this.errorMessage
          : errorMessage as String?,
      owner: identical(owner, _unsetValue)
          ? this.owner
          : owner as RegisterOwnerEntity?,
    );
  }

  @override
  List<Object?> get props => [
    name,
    username,
    password,
    confirmPassword,
    shopName,
    status,
    errorMessage,
    owner,
  ];
}
