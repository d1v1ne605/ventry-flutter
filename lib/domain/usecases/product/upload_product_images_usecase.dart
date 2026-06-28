import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/upload_product_image_params.dart';
import 'package:ventry_flutter/domain/entities/product/uploaded_product_image_entity.dart';
import 'package:ventry_flutter/domain/repositories/product/product_repository.dart';

@lazySingleton
class UploadProductImagesUseCase {
  final ProductRepository _repository;

  const UploadProductImagesUseCase(this._repository);

  Future<Either<Failure, List<UploadedProductImageEntity>>> call(
    List<UploadProductImageParams> params,
  ) {
    return _repository.uploadProductImages(params);
  }
}
