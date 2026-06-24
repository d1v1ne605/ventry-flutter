import 'package:equatable/equatable.dart';

/// Represents a single SKU (Stock Keeping Unit) entity in the domain layer.
///
/// Maps from [SkuResponse] in the data layer. All list fields are non-null
/// (empty list by default) to guarantee safe UI rendering.
class SkuEntity extends Equatable {
  final String uid;
  final String? skuCode;
  final String? barCode;
  final double? sellingPrice;
  final double? costPrice;
  final int stockQuantity;
  final int minStockQuantity;
  final List<String> imageUrls;
  final String status;
  final bool isSellable;
  final int version;

  /// Denormalized SPU fields for display — avoids extra lookups in UI
  final String spuUid;
  final String spuName;
  final String spuStatus;

  final DateTime createdAt;
  final DateTime updatedAt;

  const SkuEntity({
    required this.uid,
    this.skuCode,
    this.barCode,
    this.sellingPrice,
    this.costPrice,
    required this.stockQuantity,
    required this.minStockQuantity,
    this.imageUrls = const [],
    required this.status,
    required this.isSellable,
    required this.version,
    required this.spuUid,
    required this.spuName,
    required this.spuStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Derived stock status for UI display logic
  SkuStockStatus get stockStatus {
    if (stockQuantity <= 0) return SkuStockStatus.outOfStock;
    if (stockQuantity <= minStockQuantity) return SkuStockStatus.lowStock;
    return SkuStockStatus.inStock;
  }

  String? get primaryImageUrl => imageUrls.isNotEmpty ? imageUrls.first : null;

  @override
  List<Object?> get props => [uid, skuCode, status, stockQuantity, version];
}

/// Stock status derived from quantity thresholds.
enum SkuStockStatus {
  inStock,
  lowStock,
  outOfStock;

  bool get isOutOfStock => this == SkuStockStatus.outOfStock;
}
