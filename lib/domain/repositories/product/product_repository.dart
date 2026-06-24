import 'package:dartz/dartz.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/product_entity.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/sku_list_entity.dart';

abstract class ProductRepository {
  Future<Either<Failure, SkuListEntity>> getSkus(SkuQueryParams params);

  Future<Either<Failure, SkuEntity>> getSkuByUid(String skuUid);

  /// Creates a new product (SPU + SKUs). Returns [ProductEntity] on success.
  /// After success, the caller (Bloc) is responsible for dispatching [LoadSkus]
  /// to refresh the list — Single Responsibility Principle.
  Future<Either<Failure, ProductEntity>> createProduct(CreateProductParams params);
}
