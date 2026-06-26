import 'package:freezed_annotation/freezed_annotation.dart';

part 'sku_spu_response.freezed.dart';
part 'sku_spu_response.g.dart';

@freezed
class SkuSpuResponse with _$SkuSpuResponse {
  const factory SkuSpuResponse({
    required String uid,
    String? name,
    String? status,
  }) = _SkuSpuResponse;

  factory SkuSpuResponse.fromJson(Map<String, dynamic> json) =>
      _$SkuSpuResponseFromJson(json);
}
