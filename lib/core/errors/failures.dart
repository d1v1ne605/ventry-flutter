import 'package:equatable/equatable.dart';

import 'package:ventry_flutter/core/constants/app_errors.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure([this.message = AppErrors.unexpected]);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = AppErrors.noInternetConnection]);
}
