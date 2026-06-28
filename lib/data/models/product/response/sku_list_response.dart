// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ventry_flutter/data/models/product/response/pagination_metadata.dart';
import 'package:ventry_flutter/data/models/product/response/sku_response.dart';

part 'sku_list_response.freezed.dart';
part 'sku_list_response.g.dart';

@freezed
class SkuListResponse with _$SkuListResponse {
  const factory SkuListResponse({
    @Default([]) List<SkuResponse> items,
    @JsonKey(name: 'meta') PaginationMetadata? meta,
    @JsonKey(name: 'pagination') PaginationMetadata? pagination,
  }) = _SkuListResponse;

  factory SkuListResponse.fromJson(Map<String, dynamic> json) =>
      _$SkuListResponseFromJson(json);
}
