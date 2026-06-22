import 'package:dartz/dartz.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/onboarding/register_owner_entity.dart';
import 'package:ventry_flutter/domain/entities/onboarding/register_owner_params.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, RegisterOwnerEntity>> registerOwner(
    RegisterOwnerParams params,
  );
}
