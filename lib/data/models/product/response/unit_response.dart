import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';

part 'unit_response.freezed.dart';
part 'unit_response.g.dart';

@freezed
class UnitResponse with _$UnitResponse {
  const UnitResponse._();

  const factory UnitResponse({
    required int id,
    @Default('') String name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UnitResponse;

  factory UnitResponse.fromJson(Map<String, dynamic> json) =>
      _$UnitResponseFromJson(json);

  UnitEntity toEntity() {
    return UnitEntity(
      id: id,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
