import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';

class EditableSkuAttribute extends Equatable {
  const EditableSkuAttribute({
    required this.id,
    required this.name,
    required this.value,
  });

  final String id;
  final String name;
  final String value;

  EditableSkuAttribute copyWith({String? id, String? name, String? value}) {
    return EditableSkuAttribute(
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  SkuAttributeEntity toEntity() {
    return SkuAttributeEntity(uid: id, attributeName: name, value: value);
  }

  static EditableSkuAttribute fromEntity(SkuAttributeEntity entity) {
    return EditableSkuAttribute(
      id: entity.uid,
      name: entity.attributeName,
      value: entity.value,
    );
  }

  @override
  List<Object?> get props => [id, name, value];
}
