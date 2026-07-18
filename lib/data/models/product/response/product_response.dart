import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ventry_flutter/data/models/product/response/sku_response.dart';
import 'package:ventry_flutter/data/models/product/response/spu_response.dart';

part 'product_response.freezed.dart';
part 'product_response.g.dart';

@freezed
class ProductResponse with _$ProductResponse {
  const factory ProductResponse({
    required SpuResponse spu,
    @Default([]) List<SkuResponse> skus,
  }) = _ProductResponse;

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);
}
