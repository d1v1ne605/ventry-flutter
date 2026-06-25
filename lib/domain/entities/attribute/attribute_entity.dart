import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_value_entity.dart';

class AttributeEntity extends Equatable {
  final String uid;
  final String name;
  final List<AttributeValueEntity> values;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AttributeEntity({
    required this.uid,
    required this.name,
    this.values = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [uid, name, values, createdAt, updatedAt];
}
