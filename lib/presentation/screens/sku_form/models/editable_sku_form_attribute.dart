import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';

class EditableSkuFormAttribute extends Equatable {
  const EditableSkuFormAttribute({
    required this.id,
    required this.name,
    required this.value,
  });

  final String id;
  final String name;
  final String value;

  EditableSkuFormAttribute copyWith({String? id, String? name, String? value}) {
    return EditableSkuFormAttribute(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  SkuAttributeEntity toEntity() {
    return SkuAttributeEntity(uid: id, attributeName: name, value: value);
  }

  static EditableSkuFormAttribute fromEntity(SkuAttributeEntity entity) {
    return EditableSkuFormAttribute(
      id: entity.uid,
      name: entity.attributeName,
      value: entity.value,
    );
  }

  @override
  List<Object?> get props => [id, name, value];
}
