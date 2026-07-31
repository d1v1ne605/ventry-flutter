// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_sku_request.freezed.dart';
part 'create_sku_request.g.dart';

@freezed
class CreateSkuRequest with _$CreateSkuRequest {
  @JsonSerializable(includeIfNull: false)
  const factory CreateSkuRequest({
    required String spuUid,
    String? skuCode,
    String? barCode,
    double? sellingPrice,
    double? costPrice,
    int? stockQuantity,
    int? minStockQuantity,
    int? unitId,
    double? conversionFactor,
    @Default([]) List<String> imageKeys,
    @Default(true) bool isSellable,
    @Default([]) List<String> attributeValueUids,
  }) = _CreateSkuRequest;

  factory CreateSkuRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateSkuRequestFromJson(json);
}
