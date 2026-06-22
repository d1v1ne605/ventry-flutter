import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String username;
  final String name;
  final String shopUid;

  const UserEntity({
    required this.uid,
    required this.username,
    required this.name,
    required this.shopUid,
  });

  @override
  List<Object?> get props => [uid, username, name, shopUid];
}
