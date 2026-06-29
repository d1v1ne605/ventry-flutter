import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ventry_flutter/data/models/product/request/create_presigned_upload_request.dart';
import 'package:ventry_flutter/data/models/product/request/create_product_request.dart';
import 'package:ventry_flutter/data/models/product/response/product_response.dart';
import 'package:ventry_flutter/data/models/product/response/presigned_upload_response.dart';
import 'package:ventry_flutter/data/models/product/response/sku_response.dart';
import 'package:ventry_flutter/data/models/product/response/sku_spu_group_response.dart';

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

  @GET('/skus/generated-code/latest')
  Future<dynamic> getLatestGeneratedSkuCode();

  @POST('/media/uploads/presigned-url')
  Future<PresignedUploadResponse> createPresignedUploadUrl(
    @Body() CreatePresignedUploadRequest request,
  );
}
