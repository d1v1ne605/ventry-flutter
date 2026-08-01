// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit_requests.freezed.dart';
part 'unit_requests.g.dart';

@freezed
class CreateUnitRequest with _$CreateUnitRequest {
  @JsonSerializable(includeIfNull: false)
  const factory CreateUnitRequest({required String name}) = _CreateUnitRequest;

  factory CreateUnitRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUnitRequestFromJson(json);
}

@freezed
class ProductUnitConfigurationRequest with _$ProductUnitConfigurationRequest {
  @JsonSerializable(includeIfNull: false)
  const factory ProductUnitConfigurationRequest({
    required int version,
    int? baseUnitId,
    List<Map<String, dynamic>>? createSkus,
    List<Map<String, dynamic>>? updateSkus,
    List<Map<String, dynamic>>? discontinueSkus,
  }) = _ProductUnitConfigurationRequest;

  factory ProductUnitConfigurationRequest.fromJson(Map<String, dynamic> json) =>
      _$ProductUnitConfigurationRequestFromJson(json);
}
