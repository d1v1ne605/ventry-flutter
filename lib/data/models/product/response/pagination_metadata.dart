// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_metadata.freezed.dart';
part 'pagination_metadata.g.dart';

@freezed
class PaginationMetadata with _$PaginationMetadata {
  const factory PaginationMetadata({
    @JsonKey(readValue: _readTotalValue) @Default(0) int total,
    @JsonKey(readValue: _readPageValue) @Default(1) int page,
    @JsonKey(readValue: _readLimitValue) @Default(20) int limit,
    @JsonKey(readValue: _readTotalPagesValue) @Default(0) int totalPages,
  }) = _PaginationMetadata;

  factory PaginationMetadata.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetadataFromJson(json);
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
