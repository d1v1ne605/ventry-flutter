import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ventry_flutter/data/models/product/response/sku_spu_response.dart';

part 'sku_response.freezed.dart';
part 'sku_response.g.dart';

@freezed
class SkuResponse with _$SkuResponse {
  const factory SkuResponse({
    required String uid,
    String? skuCode,
    String? barCode,
    double? sellingPrice,
    double? costPrice,
    required int stockQuantity,
    required int minStockQuantity,
    @Default([]) List<String> imageKeys,
    @Default([]) List<String> imageUrls,
    required String status,
    @Default(true) bool isSellable,
    @Default(0) int version,
    SkuSpuResponse? spu,
    @Default([]) List<Map<String, dynamic>> attributes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _SkuResponse;

  factory SkuResponse.fromJson(Map<String, dynamic> json) =>
      _$SkuResponseFromJson(json);
}
