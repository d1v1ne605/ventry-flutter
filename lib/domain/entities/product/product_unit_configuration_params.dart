import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';

class ProductUnitConfigurationParams extends Equatable {
  const ProductUnitConfigurationParams({
    required this.spuUid,
    required this.version,
    this.baseUnitId,
    this.createSkus = const [],
    this.updateSkus = const [],
    this.discontinueSkus = const [],
  });

  final String spuUid;
  final int version;
  final int? baseUnitId;
  final List<CreateSkuParams> createSkus;
  final List<ProductUnitSkuUpdateParams> updateSkus;
  final List<ProductUnitSkuDiscontinueParams> discontinueSkus;

  @override
  List<Object?> get props => [
    spuUid,
    version,
    baseUnitId,
    createSkus,
    updateSkus,
    discontinueSkus,
  ];
}

class ProductUnitSkuUpdateParams extends Equatable {
  const ProductUnitSkuUpdateParams({
    required this.skuUid,
    required this.version,
    this.unitId,
    this.conversionFactor,
  });

  final String skuUid;
  final int version;
  final int? unitId;
  final double? conversionFactor;

  @override
  List<Object?> get props => [skuUid, version, unitId, conversionFactor];
}

class ProductUnitSkuDiscontinueParams extends Equatable {
  const ProductUnitSkuDiscontinueParams({
    required this.skuUid,
    required this.version,
  });

  final String skuUid;
  final int version;

  @override
  List<Object?> get props => [skuUid, version];
}
