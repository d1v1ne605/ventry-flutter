import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/data/datasources/remote/onboarding/onboarding_remote_datasource.dart';
import 'package:ventry_flutter/data/models/onboarding/request/register_owner_request_model.dart';
import 'package:ventry_flutter/data/models/onboarding/response/register_owner_response_model.dart';
import 'package:ventry_flutter/domain/entities/onboarding/register_owner_entity.dart';
import 'package:ventry_flutter/domain/entities/onboarding/register_owner_params.dart';
import 'package:ventry_flutter/domain/repositories/onboarding/onboarding_repository.dart';

import 'package:ventry_flutter/core/network/dio_exception_extension.dart';

@LazySingleton(as: OnboardingRepository)
class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingRemoteDataSource _remoteDataSource;

  const OnboardingRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, RegisterOwnerEntity>> registerOwner(
    RegisterOwnerParams params,
  ) async {
    try {
      final response = await _remoteDataSource.register(
        _toRequestModel(params),
      );
      return Right(_toEntity(response));
    } on DioException catch (error) {
      return Left(error.toFailure());
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  RegisterOwnerRequestModel _toRequestModel(RegisterOwnerParams params) {
    return RegisterOwnerRequestModel(
      username: params.username,
      password: params.password,
      shopName: params.shopName,
      name: params.name,
    );
  }

  RegisterOwnerEntity _toEntity(RegisterOwnerResponseModel model) {
    return RegisterOwnerEntity(
      shopUid: model.shopUid,
      userUid: model.userUid,
      username: model.username,
      name: model.name,
      role: model.role,
    );
  }
}
