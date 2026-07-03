import 'package:dartz/dartz.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/create_sku_params.dart';
import 'package:ventry_flutter/domain/entities/product/product_entity.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/sku_spu_group_list_entity.dart';
import 'package:ventry_flutter/domain/entities/product/update_sku_images_params.dart';
import 'package:ventry_flutter/domain/entities/product/update_sku_params.dart';
import 'package:ventry_flutter/domain/entities/product/upload_product_image_params.dart';
import 'package:ventry_flutter/domain/entities/product/uploaded_product_image_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, SkuSpuGroupListEntity>> getSkus(SkuQueryParams params);

  Future<Either<Failure, SkuEntity>> getSkuByUid(String skuUid);

  Future<Either<Failure, SkuEntity>> createSku(AddSkuParams params);

  Future<Either<Failure, SkuEntity>> updateSku(UpdateSkuParams params);

  Future<Either<Failure, SkuEntity>> updateSkuImages(
    UpdateSkuImagesParams params,
  );

  Future<Either<Failure, String?>> getLatestGeneratedSkuCode();

  Future<Either<Failure, List<UploadedProductImageEntity>>> uploadProductImages(
    List<UploadProductImageParams> params,
  );

  /// Creates a new product (SPU + SKUs). Returns [ProductEntity] on success.
  /// After success, the caller (Bloc) is responsible for dispatching [LoadSkus]
  /// to refresh the list — Single Responsibility Principle.
  Future<Either<Failure, ProductEntity>> createProduct(
    CreateProductParams params,
  );
}
