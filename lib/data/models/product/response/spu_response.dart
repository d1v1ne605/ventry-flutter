import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ventry_flutter/data/models/category/response/category_response.dart';

part 'spu_response.freezed.dart';
part 'spu_response.g.dart';

@freezed
class SpuResponse with _$SpuResponse {
  const factory SpuResponse({
    required String uid,
    required String name,
    String? brand,
    String? description,
    String? imageKey,
    String? imageUrl,
    CategoryResponse? category,
    String? currency,
    String? unitOfMeasure,
    required String status,
    required int version,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default([]) List<Map<String, dynamic>> attributes,
  }) = _SpuResponse;

  factory SpuResponse.fromJson(Map<String, dynamic> json) =>
      _$SpuResponseFromJson(json);
}
