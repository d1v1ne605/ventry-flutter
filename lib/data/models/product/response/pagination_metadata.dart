import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_metadata.freezed.dart';
part 'pagination_metadata.g.dart';

@freezed
class PaginationMetadata with _$PaginationMetadata {
  const factory PaginationMetadata({
    required int total,
    required int page,
    required int limit,
    required int totalPages,
  }) = _PaginationMetadata;

  factory PaginationMetadata.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetadataFromJson(json);
}
