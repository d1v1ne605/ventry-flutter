import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_spu_request.freezed.dart';
part 'update_spu_request.g.dart';

@freezed
class UpdateSpuRequest with _$UpdateSpuRequest {
  const factory UpdateSpuRequest({
    required int version,
    String? name,
    String? categoryUid,
    String? description,
    String? currency,
    String? unitOfMeasure,
  }) = _UpdateSpuRequest;

  factory UpdateSpuRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateSpuRequestFromJson(json);
}
