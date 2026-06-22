import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/onboarding/register_owner_entity.dart';
import 'package:ventry_flutter/domain/entities/onboarding/register_owner_params.dart';
import 'package:ventry_flutter/domain/repositories/onboarding/onboarding_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class RegisterOwner
    implements UseCase<RegisterOwnerEntity, RegisterOwnerParams> {
  final OnboardingRepository _repository;

  const RegisterOwner(this._repository);

  @override
  Future<Either<Failure, RegisterOwnerEntity>> call(
    RegisterOwnerParams params,
  ) {
    return _repository.registerOwner(params);
  }
}
