import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/constants/app_errors.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/core/network/dio_exception_extension.dart';
import 'package:ventry_flutter/data/datasources/remote/product/product_api.dart';
import 'package:ventry_flutter/data/models/product/request/create_presigned_upload_request.dart';
import 'package:ventry_flutter/data/models/product/request/create_product_request.dart';
import 'package:ventry_flutter/data/models/product/request/create_product_sku_request.dart';
import 'package:ventry_flutter/domain/entities/product/product_entity.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/sku_list_entity.dart';
import 'package:ventry_flutter/domain/entities/product/upload_product_image_params.dart';
import 'package:ventry_flutter/domain/entities/product/uploaded_product_image_entity.dart';
import 'package:ventry_flutter/domain/repositories/product/product_repository.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductApi _productApi;
  static const List<String> _supportedMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/webp',
  ];

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
          total: response.meta?.total ?? response.pagination?.total ?? 0,
          page: response.meta?.page ?? response.pagination?.page ?? 1,
          limit: response.meta?.limit ?? response.pagination?.limit ?? 20,
          totalPages:
              response.meta?.totalPages ?? response.pagination?.totalPages ?? 0,
        ),
      );
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(ServerFailure(AppErrors.unexpected));
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
      return const Left(ServerFailure(AppErrors.unexpected));
    }
  }

  @override
  Future<Either<Failure, String?>> getLatestGeneratedSkuCode() async {
    try {
      final response = await _productApi.getLatestGeneratedSkuCode();
      String? code;
      if (response is String) {
        code = response;
      } else if (response is Map<String, dynamic>) {
        code = response['skuCode'] as String? ?? response['code'] as String?;
      }
      return Right(code);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(ServerFailure(AppErrors.unexpected));
    }
  }

  @override
  Future<Either<Failure, List<UploadedProductImageEntity>>> uploadProductImages(
    List<UploadProductImageParams> params,
  ) async {
    try {
      final uploadedImages = <UploadedProductImageEntity>[];

      for (final param in params) {
        if (!_supportedMimeTypes.contains(param.mimeType)) {
          return Left(
            ServerFailure(AppErrors.unsupportedImageFormat(param.mimeType)),
          );
        }

        final file = File(param.filePath);
        final fileSize = await file.length();
        final presignedUpload = await _productApi.createPresignedUploadUrl(
          CreatePresignedUploadRequest(
            mimeType: param.mimeType,
            fileSize: fileSize,
          ),
        );

        await _uploadToPresignedUrl(
          uploadUrl: presignedUpload.uploadUrl,
          headers: presignedUpload.headers,
          file: file,
        );

        uploadedImages.add(
          UploadedProductImageEntity(
            localPath: param.filePath,
            objectKey: presignedUpload.objectKey,
          ),
        );
      }

      return Right(uploadedImages);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(ServerFailure(AppErrors.uploadProductImagesFailed));
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
          imageKey: response.spu.imageKey,
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
      return const Left(ServerFailure(AppErrors.unexpected));
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
      imageKeys: List<String>.from(response.imageKeys),
      imageUrls: List<String>.from(response.imageUrls),
      status: response.status,
      isSellable: response.isSellable,
      version: response.version,
      spuUid: response.spu.uid,
      spuName: response.spu.name ?? 'Unknown',
      spuStatus: response.spu.status ?? 'UNKNOWN',
      attributes:
          (response.attributes as List<dynamic>?)
              ?.map(
                (attr) => SkuAttributeEntity(
                  uid: attr['uid'] as String? ?? '',
                  attributeName: attr['attributeName'] as String? ?? '',
                  value: attr['value'] as String? ?? '',
                ),
              )
              .toList() ??
          [],
      createdAt: response.createdAt ?? DateTime.now(),
      updatedAt: response.updatedAt ?? DateTime.now(),
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
      imageKeys: params.imageKeys,
      isSellable: params.isSellable,
      attributeValueUids: params.attributeValueUids,
    );
  }

  Future<void> _uploadToPresignedUrl({
    required String uploadUrl,
    required Map<String, String> headers,
    required File file,
  }) async {
    final uploadDio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        validateStatus: (status) =>
            status != null && status >= 200 && status < 300,
      ),
    );

    await uploadDio.put<void>(
      uploadUrl,
      data: await file.readAsBytes(),
      options: Options(headers: headers),
    );
  }
}
