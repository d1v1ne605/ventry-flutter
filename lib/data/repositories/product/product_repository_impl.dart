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
import 'package:ventry_flutter/data/models/product/request/create_sku_request.dart';
import 'package:ventry_flutter/data/models/product/request/update_sku_images_request.dart';
import 'package:ventry_flutter/data/models/product/request/update_sku_request.dart';
import 'package:ventry_flutter/domain/entities/product/product_entity.dart';
import 'package:ventry_flutter/domain/entities/product/create_sku_params.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/sku_spu_group_entity.dart';
import 'package:ventry_flutter/domain/entities/product/sku_spu_group_list_entity.dart';
import 'package:ventry_flutter/domain/entities/product/update_sku_images_params.dart';
import 'package:ventry_flutter/domain/entities/product/update_sku_params.dart';
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
  Future<Either<Failure, SkuSpuGroupListEntity>> getSkus(
    SkuQueryParams params,
  ) async {
    try {
      final response = await _productApi.getSkus(
        search: params.search,
        spuUid: params.spuUid,
        categoryUid: params.categoryUid,
        status: params.status,
        isSellable: params.isSellable,
        isStockAlert: params.isStockAlert,
        page: params.page,
        limit: params.limit,
      );
      final meta = response.pagination;
      final total = meta.total;
      final page = meta.page;
      final limit = meta.limit;
      final totalPages = _resolveTotalPages(
        responseTotalPages: null,
        metadataTotalPages: meta.totalPages,
        total: total,
        limit: limit,
      );

      return Right(
        SkuSpuGroupListEntity(
          items: response.items
              .map(
                (group) => SkuSpuGroupEntity(
                  spuUid: group.spu.uid,
                  spuName: group.spu.name ?? '',
                  spuStatus: group.spu.status ?? 'UNKNOWN',
                  categoryName: group.spu.category?.name,
                  categoryImageUrl: group.spu.category?.imageUrl,
                  skus: group.skus
                      .map(
                        (sku) => _mapSkuToEntity(sku, fallbackSpu: group.spu),
                      )
                      .toList(),
                ),
              )
              .toList(),
          total: total,
          page: page,
          limit: limit,
          totalPages: totalPages,
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
  Future<Either<Failure, SkuEntity>> createSku(AddSkuParams params) async {
    try {
      final response = await _productApi.createSku(
        CreateSkuRequest(
          spuUid: params.spuUid,
          skuCode: params.skuCode,
          barCode: params.barCode,
          sellingPrice: params.sellingPrice,
          costPrice: params.costPrice,
          stockQuantity: params.stockQuantity,
          minStockQuantity: params.minStockQuantity,
          imageKeys: params.imageKeys,
          isSellable: params.isSellable,
          attributeValueUids: params.attributeValueUids,
        ),
      );
      return Right(_mapSkuToEntity(response));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(ServerFailure(AppErrors.unexpected));
    }
  }

  @override
  Future<Either<Failure, SkuEntity>> updateSku(UpdateSkuParams params) async {
    try {
      final response = await _productApi.updateSku(
        params.skuUid,
        UpdateSkuRequest(
          version: params.version,
          skuCode: params.skuCode,
          barCode: params.barCode,
          sellingPrice: params.sellingPrice,
          costPrice: params.costPrice,
          stockQuantity: params.stockQuantity,
          minStockQuantity: params.minStockQuantity,
          isSellable: params.isSellable,
          attributeValueUids: params.attributeValueUids,
        ),
      );
      return Right(_mapSkuToEntity(response));
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(ServerFailure(AppErrors.unexpected));
    }
  }

  @override
  Future<Either<Failure, SkuEntity>> updateSkuImages(
    UpdateSkuImagesParams params,
  ) async {
    try {
      final response = await _productApi.updateSkuImages(
        params.skuUid,
        UpdateSkuImagesRequest(
          version: params.version,
          imageKeys: params.imageKeys,
        ),
      );
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
          categoryUid: response.spu.category?.uid,
          currency: response.spu.currency,
          unitOfMeasure: response.spu.unitOfMeasure,
          status: response.spu.status,
          skus: response.skus
              .map((sku) => _mapSkuToEntity(sku, fallbackSpu: response.spu))
              .toList(),
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

  int _resolveTotalPages({
    required int? responseTotalPages,
    required int? metadataTotalPages,
    required int total,
    required int limit,
  }) {
    final explicitTotalPages = responseTotalPages ?? metadataTotalPages;
    if (explicitTotalPages != null && explicitTotalPages > 0) {
      return explicitTotalPages;
    }

    if (total <= 0 || limit <= 0) {
      return 0;
    }

    return (total / limit).ceil();
  }

  SkuEntity _mapSkuToEntity(dynamic response, {dynamic fallbackSpu}) {
    final spu = response.spu ?? fallbackSpu;

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
      spuUid: spu?.uid ?? '',
      spuName: spu?.name ?? 'Unknown',
      spuStatus: spu?.status ?? 'UNKNOWN',
      spuDescription: spu?.description,
      spuCategoryName: spu?.category?.name,
      spuCurrency: spu?.currency,
      spuUnitOfMeasure: spu?.unitOfMeasure,
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
