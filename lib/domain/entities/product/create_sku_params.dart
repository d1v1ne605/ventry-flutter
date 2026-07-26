import 'package:equatable/equatable.dart';

class AddSkuParams extends Equatable {
  const AddSkuParams({
    required this.spuUid,
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

  final String spuUid;
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

  @override
  List<Object?> get props => [
    spuUid,
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
