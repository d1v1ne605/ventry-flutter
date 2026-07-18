// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_sku_request.freezed.dart';
part 'update_sku_request.g.dart';

@freezed
class UpdateSkuRequest with _$UpdateSkuRequest {
  @JsonSerializable(includeIfNull: false)
  const factory UpdateSkuRequest({
    required int version,
    String? skuCode,
    String? barCode,
    double? sellingPrice,
    double? costPrice,
    int? stockQuantity,
    int? minStockQuantity,
    bool? isSellable,
    @Default([]) List<String> attributeValueUids,
  }) = _UpdateSkuRequest;

  factory UpdateSkuRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateSkuRequestFromJson(json);
}
