import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/update_sku_images_params.dart';
import 'package:ventry_flutter/domain/repositories/product/product_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class UpdateSkuImagesUseCase
    implements UseCase<SkuEntity, UpdateSkuImagesParams> {
  final ProductRepository _repository;

  const UpdateSkuImagesUseCase(this._repository);

  @override
  Future<Either<Failure, SkuEntity>> call(UpdateSkuImagesParams params) {
    return _repository.updateSkuImages(params);
  }
}
