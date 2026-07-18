import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/constants/app_errors.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/dio_exception_extension.dart';
import '../../../../domain/entities/auth/user_entity.dart';
import '../../../../domain/repositories/auth/auth_repository.dart';
import '../../datasources/local/auth/auth_local_datasource.dart';
import '../../datasources/remote/auth/auth_api.dart';
import '../../models/auth/request/login_request.dart';
import '../../models/auth/response/authenticated_user_response.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _authApi;
  final AuthLocalDataSource _localDataSource;

  final _userController = StreamController<UserEntity?>.broadcast();
  UserEntity? _currentUser;

  AuthRepositoryImpl(this._authApi, this._localDataSource);

  @override
  Stream<UserEntity?> get userStream => _userController.stream;

  @override
  UserEntity? get currentUser => _currentUser;

  void _updateUser(UserEntity? user) {
    _currentUser = user;
    _userController.add(user);
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
    required String deviceId,
  }) async {
    try {
      final request = LoginRequest(
        username: username,
        password: password,
        deviceId: deviceId,
      );
      final response = await _authApi.login(request);
      await _localDataSource.saveAccessToken(response.accessToken);

      final userEntity = response.user.toEntity();
      _updateUser(userEntity);

      return Right(userEntity);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(ServerFailure(AppErrors.unexpected));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _authApi.logout();
      await _localDataSource.clearAll();
      _updateUser(null);
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(ServerFailure(AppErrors.unexpected));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getMe() async {
    try {
      final response = await _authApi.getMe();
      final userEntity = response.toEntity();
      _updateUser(userEntity);
      return Right(userEntity);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(ServerFailure(AppErrors.unexpected));
    }
  }

  @override
  void forceLogout() {
    _localDataSource.clearAll();
    _updateUser(null);
  }
}
