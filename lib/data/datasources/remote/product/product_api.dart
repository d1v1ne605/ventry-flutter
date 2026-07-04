import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ventry_flutter/data/models/product/request/create_presigned_upload_request.dart';
import 'package:ventry_flutter/data/models/product/request/create_product_request.dart';
import 'package:ventry_flutter/data/models/product/request/create_sku_request.dart';
import 'package:ventry_flutter/data/models/product/request/update_sku_images_request.dart';
import 'package:ventry_flutter/data/models/product/request/update_sku_request.dart';
import 'package:ventry_flutter/data/models/product/request/update_spu_request.dart';
import 'package:ventry_flutter/data/models/product/response/product_response.dart';
import 'package:ventry_flutter/data/models/product/response/presigned_upload_response.dart';
import 'package:ventry_flutter/data/models/product/response/sku_response.dart';
import 'package:ventry_flutter/data/models/product/response/sku_spu_group_response.dart';
import 'package:ventry_flutter/data/models/product/response/spu_response.dart';

part 'product_api.g.dart';

@RestApi()
abstract class ProductApi {
  factory ProductApi(Dio dio, {String baseUrl}) = _ProductApi;

  @POST('/products')
  Future<ProductResponse> createProduct(@Body() CreateProductRequest request);

  @GET('/skus/spu-groups')
  Future<SkuSpuGroupListResponse> getSkus({
    @Query('search') String? search,
    @Query('spuUid') String? spuUid,
    @Query('categoryUid') String? categoryUid,
    @Query('status') String? status,
    @Query('isSellable') bool? isSellable,
    @Query('isStockAlert') bool? isStockAlert,
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  @GET('/skus/{skuUid}')
  Future<SkuResponse> getSkuByUid(@Path('skuUid') String skuUid);

  @GET('/spus/{spuUid}')
  Future<SpuResponse> getSpuByUid(@Path('spuUid') String spuUid);

  @POST('/skus')
  Future<SkuResponse> createSku(@Body() CreateSkuRequest request);

  @PATCH('/skus/{skuUid}')
  Future<SkuResponse> updateSku(
    @Path('skuUid') String skuUid,
    @Body() UpdateSkuRequest request,
  );

  @PATCH('/skus/{skuUid}/images')
  Future<SkuResponse> updateSkuImages(
    @Path('skuUid') String skuUid,
    @Body() UpdateSkuImagesRequest request,
  );

  @PATCH('/spus/{spuUid}')
  Future<SpuResponse> updateSpu(
    @Path('spuUid') String spuUid,
    @Body() UpdateSpuRequest request,
  );

  @GET('/skus/generated-code/latest')
  Future<dynamic> getLatestGeneratedSkuCode();

  @POST('/media/uploads/presigned-url')
  Future<PresignedUploadResponse> createPresignedUploadUrl(
    @Body() CreatePresignedUploadRequest request,
  );
}
