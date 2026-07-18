import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/create_sku_params.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/repositories/product/product_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class CreateSkuUseCase implements UseCase<SkuEntity, AddSkuParams> {
  const CreateSkuUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<Either<Failure, SkuEntity>> call(AddSkuParams params) {
    return _repository.createSku(params);
  }
}
