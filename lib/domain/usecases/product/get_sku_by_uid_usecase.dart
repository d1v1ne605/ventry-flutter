import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/repositories/product/product_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class GetSkuByUidUseCase implements UseCase<SkuEntity, String> {
  final ProductRepository _repository;

  const GetSkuByUidUseCase(this._repository);

  @override
  Future<Either<Failure, SkuEntity>> call(String skuUid) {
    return _repository.getSkuByUid(skuUid);
  }
}
