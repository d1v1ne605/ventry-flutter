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
    @JsonKey(readValue: _readTotalValue) int? total,
    @JsonKey(readValue: _readPageValue) int? page,
    @JsonKey(readValue: _readLimitValue) int? limit,
    @JsonKey(readValue: _readTotalPagesValue) int? totalPages,
  }) = _SkuListResponse;

  factory SkuListResponse.fromJson(Map<String, dynamic> json) =>
      _$SkuListResponseFromJson(json);
}

Object? _readTotalValue(Map<dynamic, dynamic> json, String key) {
  return json['totalItems'] ?? json['total'];
}

Object? _readPageValue(Map<dynamic, dynamic> json, String key) {
  return json['currentPage'] ?? json['page'];
}

Object? _readLimitValue(Map<dynamic, dynamic> json, String key) {
  return json['itemsPerPage'] ?? json['limit'];
}

Object? _readTotalPagesValue(Map<dynamic, dynamic> json, String key) {
  return json['totalPages'];
}
