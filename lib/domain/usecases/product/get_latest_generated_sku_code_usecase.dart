import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/repositories/product/product_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class GetLatestGeneratedSkuCodeUseCase implements UseCase<String?, NoParams> {
  final ProductRepository _repository;

  const GetLatestGeneratedSkuCodeUseCase(this._repository);

  @override
  Future<Either<Failure, String?>> call(NoParams params) {
    return _repository.getLatestGeneratedSkuCode();
  }
}
