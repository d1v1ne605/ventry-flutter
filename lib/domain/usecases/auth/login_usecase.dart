import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../repositories/auth/auth_repository.dart';
import '../usecase.dart';
import '../../entities/auth/user_entity.dart';
import '../../entities/auth/login_params.dart';

@lazySingleton
class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return _repository.login(
      username: params.username,
      password: params.password,
      deviceId: params.deviceId,
    );
  }
}
