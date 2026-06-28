// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_metadata.freezed.dart';
part 'pagination_metadata.g.dart';

@freezed
class PaginationMetadata with _$PaginationMetadata {
  const factory PaginationMetadata({
    @JsonKey(name: 'totalItems') @Default(0) int total,
    @JsonKey(name: 'currentPage') @Default(1) int page,
    @JsonKey(name: 'itemsPerPage') @Default(20) int limit,
    @JsonKey(name: 'totalPages') @Default(0) int totalPages,
  }) = _PaginationMetadata;

  factory PaginationMetadata.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetadataFromJson(json);
}
