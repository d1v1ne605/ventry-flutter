import 'package:equatable/equatable.dart';

/// Params for [CreateProductUseCase] — a plain data class that carries all
/// inputs needed to create a product (SPU + at least one SKU).
class CreateProductParams extends Equatable {
  final String name;
  final String? categoryUid;
  final String? description;
  final String? brand;
  final List<String> imageKeys;
  final String? currency;
  final String? unitOfMeasure;
  final int? baseUnitId;
  final List<String> globalAttributeValueUids;
  final List<CreateSkuParams> skus;

  const CreateProductParams({
    required this.name,
    this.categoryUid,
    this.description,
    this.brand,
    this.imageKeys = const [],
    this.currency,
    this.unitOfMeasure,
    this.baseUnitId,
    this.globalAttributeValueUids = const [],
    this.skus = const [],
  });

  String? get primaryImageKey => imageKeys.isNotEmpty ? imageKeys.first : null;

  @override
  List<Object?> get props => [
    name,
    categoryUid,
    description,
    brand,
    imageKeys,
    currency,
    unitOfMeasure,
    baseUnitId,
    globalAttributeValueUids,
    skus,
  ];
}

/// Params for a single SKU within [CreateProductParams].
class CreateSkuParams extends Equatable {
  final String? skuCode;
  final String? barCode;
  final double? sellingPrice;
  final double? costPrice;
  final int? stockQuantity;
  final int? minStockQuantity;
  final int? unitId;
  final double? conversionFactor;
  final List<String> imageKeys;
  final bool isSellable;
  final List<String> attributeValueUids;

  const CreateSkuParams({
    this.skuCode,
    this.barCode,
    this.sellingPrice,
    this.costPrice,
    this.stockQuantity,
    this.minStockQuantity,
    this.unitId,
    this.conversionFactor,
    this.imageKeys = const [],
    this.isSellable = true,
    this.attributeValueUids = const [],
  });

  @override
  List<Object?> get props => [
    skuCode,
    barCode,
    sellingPrice,
    costPrice,
    stockQuantity,
    minStockQuantity,
    unitId,
    conversionFactor,
    imageKeys,
    isSellable,
    attributeValueUids,
  ];
}

/// Params for [GetSkusUseCase].
class SkuQueryParams extends Equatable {
  final String? search;
  final String? spuUid;
  final String? categoryUid;
  final String? status;
  final bool? isSellable;
  final bool? isStockAlert;
  final int page;
  final int limit;

  const SkuQueryParams({
    this.search,
    this.spuUid,
    this.categoryUid,
    this.status,
    this.isSellable,
    this.isStockAlert,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [
    search,
    spuUid,
    categoryUid,
    status,
    isSellable,
    isStockAlert,
    page,
    limit,
  ];
}
