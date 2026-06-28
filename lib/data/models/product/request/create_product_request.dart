import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ventry_flutter/data/models/product/request/create_product_sku_request.dart';

part 'create_product_request.freezed.dart';
part 'create_product_request.g.dart';

@freezed
class CreateProductRequest with _$CreateProductRequest {
  @JsonSerializable(includeIfNull: false)
  const factory CreateProductRequest({
    required String name,
    String? categoryUid,
    String? description,
    String? brand,
    String? imageKey,
    String? currency,
    String? unitOfMeasure,
    @Default([]) List<String> globalAttributeValueUids,
    @Default([]) List<CreateProductSkuRequest> skus,
  }) = _CreateProductRequest;

  factory CreateProductRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateProductRequestFromJson(json);
}
