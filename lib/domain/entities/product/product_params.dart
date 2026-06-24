import 'package:equatable/equatable.dart';

/// Params for [CreateProductUseCase] — a plain data class that carries all
/// inputs needed to create a product (SPU + at least one SKU).
class CreateProductParams extends Equatable {
  final String name;
  final String? categoryUid;
  final String? description;
  final String? brand;
  final String? imageUrl;
  final String? currency;
  final String? unitOfMeasure;
  final List<String> globalAttributeValueUids;
  final List<CreateSkuParams> skus;

  const CreateProductParams({
    required this.name,
    this.categoryUid,
    this.description,
    this.brand,
    this.imageUrl,
    this.currency,
    this.unitOfMeasure,
    this.globalAttributeValueUids = const [],
    this.skus = const [],
  });

  @override
  List<Object?> get props => [name, categoryUid];
}

/// Params for a single SKU within [CreateProductParams].
class CreateSkuParams extends Equatable {
  final String? skuCode;
  final String? barCode;
  final double? sellingPrice;
  final double? costPrice;
  final int? stockQuantity;
  final int? minStockQuantity;
  final List<String> imageUrls;
  final bool isSellable;
  final List<String> attributeValueUids;

  const CreateSkuParams({
    this.skuCode,
    this.barCode,
    this.sellingPrice,
    this.costPrice,
    this.stockQuantity,
    this.minStockQuantity,
    this.imageUrls = const [],
    this.isSellable = true,
    this.attributeValueUids = const [],
  });

  @override
  List<Object?> get props => [skuCode, barCode];
}

/// Params for [GetSkusUseCase].
class SkuQueryParams extends Equatable {
  final String? search;
  final String? categoryUid;
  final String? status;
  final bool? isSellable;
  final bool? isStockAlert;
  final int page;
  final int limit;

  const SkuQueryParams({
    this.search,
    this.categoryUid,
    this.status,
    this.isSellable,
    this.isStockAlert,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [search, categoryUid, status, isSellable, isStockAlert, page, limit];
}
