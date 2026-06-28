import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_product_sku_request.freezed.dart';
part 'create_product_sku_request.g.dart';

@freezed
class CreateProductSkuRequest with _$CreateProductSkuRequest {
  @JsonSerializable(includeIfNull: false)
  const factory CreateProductSkuRequest({
    String? skuCode,
    String? barCode,
    double? sellingPrice,
    double? costPrice,
    int? stockQuantity,
    int? minStockQuantity,
    @Default([]) List<String> imageKeys,
    @Default(true) bool isSellable,
    @Default([]) List<String> attributeValueUids,
  }) = _CreateProductSkuRequest;

  factory CreateProductSkuRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProductSkuRequestFromJson(json);
}
