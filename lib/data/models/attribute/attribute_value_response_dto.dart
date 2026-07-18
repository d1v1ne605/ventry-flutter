import 'package:json_annotation/json_annotation.dart';

part 'attribute_value_response_dto.g.dart';

@JsonSerializable()
class AttributeValueResponseDto {
  final String uid;
  final String value;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AttributeValueResponseDto({
    required this.uid,
    required this.value,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AttributeValueResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AttributeValueResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AttributeValueResponseDtoToJson(this);
}
