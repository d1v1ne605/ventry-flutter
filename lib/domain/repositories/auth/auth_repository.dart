import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../entities/auth/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get userStream;
  UserEntity? get currentUser;

  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
    required String deviceId,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, UserEntity>> getMe();

  /// Forces the user to be logged out locally (e.g. when token refresh fails)
  void forceLogout();
}
