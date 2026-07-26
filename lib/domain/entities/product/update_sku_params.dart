import 'package:equatable/equatable.dart';

class UpdateSkuParams extends Equatable {
  const UpdateSkuParams({
    required this.skuUid,
    required this.version,
    this.skuCode,
    this.barCode,
    this.sellingPrice,
    this.costPrice,
    this.stockQuantity,
    this.minStockQuantity,
    this.unitId,
    this.conversionFactor,
    this.isSellable,
    this.attributeValueUids = const [],
  });

  final String skuUid;
  final int version;
  final String? skuCode;
  final String? barCode;
  final double? sellingPrice;
  final double? costPrice;
  final int? stockQuantity;
  final int? minStockQuantity;
  final int? unitId;
  final double? conversionFactor;
  final bool? isSellable;
  final List<String> attributeValueUids;

  @override
  List<Object?> get props => [
    skuUid,
    version,
    skuCode,
    barCode,
    sellingPrice,
    costPrice,
    stockQuantity,
    minStockQuantity,
    unitId,
    conversionFactor,
    isSellable,
    attributeValueUids,
  ];
}
