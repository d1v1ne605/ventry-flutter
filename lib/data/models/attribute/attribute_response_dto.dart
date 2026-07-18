import 'package:json_annotation/json_annotation.dart';
import 'attribute_value_response_dto.dart';

part 'attribute_response_dto.g.dart';

@JsonSerializable()
class AttributeResponseDto {
  final String uid;
  final String name;
  final List<AttributeValueResponseDto> values;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AttributeResponseDto({
    required this.uid,
    required this.name,
    this.values = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttributeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AttributeResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeResponseDtoToJson(this);
}
