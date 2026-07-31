import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_sku_response.freezed.dart';
part 'delete_sku_response.g.dart';

@freezed
class DeleteSkuResponse with _$DeleteSkuResponse {
  const factory DeleteSkuResponse({@Default('') String uid}) =
      _DeleteSkuResponse;

  factory DeleteSkuResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteSkuResponseFromJson(json);
}
