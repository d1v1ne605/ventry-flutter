import 'package:equatable/equatable.dart';

class RegisterOwnerParams extends Equatable {
  final String username;
  final String password;
  final String shopName;
  final String name;

  const RegisterOwnerParams({
    required this.username,
    required this.password,
    required this.shopName,
    required this.name,
  });

  @override
  List<Object> get props => [username, password, shopName, name];
}
