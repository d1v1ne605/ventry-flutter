import 'package:freezed_annotation/freezed_annotation.dart';

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
    String? categoryUid,
    String? currency,
    String? unitOfMeasure,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _SpuResponse;

  factory SpuResponse.fromJson(Map<String, dynamic> json) =>
      _$SpuResponseFromJson(json);
}
