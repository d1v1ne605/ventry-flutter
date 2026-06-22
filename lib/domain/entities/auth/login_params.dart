import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  final String username;
  final String password;
  final String deviceId;

  const LoginParams({
    required this.username,
    required this.password,
    required this.deviceId,
  });

  @override
  List<Object?> get props => [username, password, deviceId];
}
