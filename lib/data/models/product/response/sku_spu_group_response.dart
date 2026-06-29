import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ventry_flutter/data/models/product/response/pagination_metadata.dart';
import 'package:ventry_flutter/data/models/product/response/sku_response.dart';
import 'package:ventry_flutter/data/models/product/response/sku_spu_response.dart';

part 'sku_spu_group_response.freezed.dart';
part 'sku_spu_group_response.g.dart';

@freezed
class SkuSpuGroupListResponse with _$SkuSpuGroupListResponse {
  const factory SkuSpuGroupListResponse({
    @Default([]) List<SkuSpuGroupResponse> items,
    @Default(PaginationMetadata()) PaginationMetadata pagination,
  }) = _SkuSpuGroupListResponse;

  factory SkuSpuGroupListResponse.fromJson(Map<String, dynamic> json) =>
      _$SkuSpuGroupListResponseFromJson(json);
}

@freezed
class SkuSpuGroupResponse with _$SkuSpuGroupResponse {
  const factory SkuSpuGroupResponse({
    required SkuSpuResponse spu,
    @Default([]) List<SkuResponse> skus,
  }) = _SkuSpuGroupResponse;

  factory SkuSpuGroupResponse.fromJson(Map<String, dynamic> json) =>
      _$SkuSpuGroupResponseFromJson(json);
}
