import 'package:json_annotation/json_annotation.dart';

part 'create_attribute_value_dto.g.dart';

@JsonSerializable()
class CreateAttributeValueDto {
  final String value;

  const CreateAttributeValueDto({required this.value});

  factory CreateAttributeValueDto.fromJson(Map<String, dynamic> json) =>
      _$CreateAttributeValueDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAttributeValueDtoToJson(this);
}
