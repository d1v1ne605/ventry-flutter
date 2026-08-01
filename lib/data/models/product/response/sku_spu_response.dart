import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ventry_flutter/data/models/category/response/category_response.dart';
import 'package:ventry_flutter/data/models/product/response/unit_response.dart';

part 'sku_spu_response.freezed.dart';
part 'sku_spu_response.g.dart';

@freezed
class SkuSpuResponse with _$SkuSpuResponse {
  const factory SkuSpuResponse({
    @Default('') String uid,
    String? name,
    String? status,
    String? currency,
    String? unitOfMeasure,
    UnitResponse? baseUnit,
    String? description,
    @Default(1) int version,
    CategoryResponse? category,
  }) = _SkuSpuResponse;

  factory SkuSpuResponse.fromJson(Map<String, dynamic> json) =>
      _$SkuSpuResponseFromJson(json);
}
