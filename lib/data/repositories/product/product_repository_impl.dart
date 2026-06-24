import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/core/network/dio_exception_extension.dart';
import 'package:ventry_flutter/data/datasources/remote/product/product_api.dart';
import 'package:ventry_flutter/data/models/product/request/create_product_request.dart';
import 'package:ventry_flutter/data/models/product/request/create_product_sku_request.dart';
import 'package:ventry_flutter/domain/entities/product/product_entity.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/sku_list_entity.dart';
import 'package:ventry_flutter/domain/repositories/product/product_repository.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductApi _productApi;

  const ProductRepositoryImpl(this._productApi);

  @override
  Future<Either<Failure, SkuListEntity>> getSkus(SkuQueryParams params) async {
    try {
      final response = await _productApi.getSkus(
        search: params.search,
        categoryUid: params.categoryUid,
        status: params.status,
        isSellable: params.isSellable,
        isStockAlert: params.isStockAlert,
        page: params.page,
        limit: params.limit,
      );
      return Right(
        SkuListEntity(
          items: response.items.map(_mapSkuToEntity).toList(),
          total: response.pagination.total,
          page: response.pagination.page,
          limit: response.pagination.limit,
          totalPages: response.pagination.totalPages,
        ),
      );
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, SkuEntity>> getSkuByUid(String skuUid) async {
    try {
      final response = await _productApi.getSkuByUid(skuUid);
      return Right(_mapSkuToEntity(response));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> createProduct(
    CreateProductParams params,
  ) async {
    try {
      final request = CreateProductRequest(
        name: params.name,
        categoryUid: params.categoryUid,
        description: params.description,
        brand: params.brand,
        imageUrl: params.imageUrl,
        currency: params.currency,
        unitOfMeasure: params.unitOfMeasure,
        globalAttributeValueUids: params.globalAttributeValueUids,
        skus: params.skus.map(_mapSkuParamsToRequest).toList(),
      );
      final response = await _productApi.createProduct(request);
      return Right(
        ProductEntity(
          spuUid: response.spu.uid,
          spuName: response.spu.name,
          brand: response.spu.brand,
          description: response.spu.description,
          imageUrl: response.spu.imageUrl,
          categoryUid: response.spu.categoryUid,
          currency: response.spu.currency,
          unitOfMeasure: response.spu.unitOfMeasure,
          status: response.spu.status,
          skus: response.skus.map(_mapSkuToEntity).toList(),
          createdAt: response.spu.createdAt,
          updatedAt: response.spu.updatedAt,
        ),
      );
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  SkuEntity _mapSkuToEntity(dynamic response) {
    return SkuEntity(
      uid: response.uid,
      skuCode: response.skuCode,
      barCode: response.barCode,
      sellingPrice: response.sellingPrice?.toDouble(),
      costPrice: response.costPrice?.toDouble(),
      stockQuantity: response.stockQuantity,
      minStockQuantity: response.minStockQuantity,
      imageUrls: List<String>.from(response.imageUrls),
      status: response.status,
      isSellable: response.isSellable,
      version: response.version,
      spuUid: response.spu.uid,
      spuName: response.spu.name,
      spuStatus: response.spu.status,
      createdAt: response.createdAt,
      updatedAt: response.updatedAt,
    );
  }

  CreateProductSkuRequest _mapSkuParamsToRequest(CreateSkuParams params) {
    return CreateProductSkuRequest(
      skuCode: params.skuCode,
      barCode: params.barCode,
      sellingPrice: params.sellingPrice,
      costPrice: params.costPrice,
      stockQuantity: params.stockQuantity,
      minStockQuantity: params.minStockQuantity,
      imageUrls: params.imageUrls,
      isSellable: params.isSellable,
      attributeValueUids: params.attributeValueUids,
    );
  }
}
