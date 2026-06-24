import 'package:freezed_annotation/freezed_annotation.dart';

part 'sku_spu_response.freezed.dart';
part 'sku_spu_response.g.dart';

@freezed
class SkuSpuResponse with _$SkuSpuResponse {
  const factory SkuSpuResponse({
    required String uid,
    required String name,
    required String status,
  }) = _SkuSpuResponse;

  factory SkuSpuResponse.fromJson(Map<String, dynamic> json) =>
      _$SkuSpuResponseFromJson(json);
}
