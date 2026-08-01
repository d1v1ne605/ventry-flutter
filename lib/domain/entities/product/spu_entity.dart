import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';

class SpuEntity extends Equatable {
  final String uid;
  final String name;
  final String? description;
  final String? brand;
  final String? imageKey;
  final String? imageUrl;
  final String? currency;
  final String? unitOfMeasure;
  final UnitEntity? baseUnit;
  final String status;
  final int version;
  final String? categoryUid;
  final String? categoryName;
  final String? categoryImageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SpuEntity({
    required this.uid,
    required this.name,
    this.description,
    this.brand,
    this.imageKey,
    this.imageUrl,
    this.currency,
    this.unitOfMeasure,
    this.baseUnit,
    required this.status,
    required this.version,
    this.categoryUid,
    this.categoryName,
    this.categoryImageUrl,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    uid,
    name,
    description,
    brand,
    imageKey,
    imageUrl,
    currency,
    unitOfMeasure,
    baseUnit,
    status,
    version,
    categoryUid,
    categoryName,
    categoryImageUrl,
    createdAt,
    updatedAt,
  ];
}
