import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/update_sku_params.dart';
import 'package:ventry_flutter/domain/repositories/product/product_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class UpdateSkuUseCase implements UseCase<SkuEntity, UpdateSkuParams> {
  final ProductRepository _repository;

  const UpdateSkuUseCase(this._repository);

  @override
  Future<Either<Failure, SkuEntity>> call(UpdateSkuParams params) {
    return _repository.updateSku(params);
  }
}
