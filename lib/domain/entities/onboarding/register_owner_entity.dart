import 'package:equatable/equatable.dart';

class RegisterOwnerEntity extends Equatable {
  final String shopUid;
  final String userUid;
  final String username;
  final String name;
  final String role;

  const RegisterOwnerEntity({
    required this.shopUid,
    required this.userUid,
    required this.username,
    required this.name,
    required this.role,
  });

  @override
  List<Object> get props => [shopUid, userUid, username, name, role];
}
