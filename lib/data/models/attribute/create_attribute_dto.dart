import 'package:json_annotation/json_annotation.dart';

part 'create_attribute_dto.g.dart';

@JsonSerializable()
class CreateAttributeDto {
  final String name;

  const CreateAttributeDto({required this.name});

  factory CreateAttributeDto.fromJson(Map<String, dynamic> json) =>
      _$CreateAttributeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAttributeDtoToJson(this);
}
