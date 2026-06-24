import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';

/// Represents a newly created Product (SPU + its SKUs) returned after
/// [CreateProductUseCase] completes. Bloc dispatches [LoadSkus] after this.
class ProductEntity extends Equatable {
  final String spuUid;
  final String spuName;
  final String? brand;
  final String? description;
  final String? imageUrl;
  final String? categoryUid;
  final String? currency;
  final String? unitOfMeasure;
  final String status;
  final List<SkuEntity> skus;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductEntity({
    required this.spuUid,
    required this.spuName,
    this.brand,
    this.description,
    this.imageUrl,
    this.categoryUid,
    this.currency,
    this.unitOfMeasure,
    required this.status,
    this.skus = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [spuUid, spuName, status];
}
