// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_sku_images_request.freezed.dart';
part 'update_sku_images_request.g.dart';

@freezed
class UpdateSkuImagesRequest with _$UpdateSkuImagesRequest {
  @JsonSerializable(includeIfNull: false)
  const factory UpdateSkuImagesRequest({
    required int version,
    @Default([]) List<String> imageKeys,
  }) = _UpdateSkuImagesRequest;

  factory UpdateSkuImagesRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateSkuImagesRequestFromJson(json);
}
