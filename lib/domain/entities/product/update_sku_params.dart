import 'package:equatable/equatable.dart';

class UpdateSkuParams extends Equatable {
  final String skuUid;
  final int version;
  final String? skuCode;
  final String? barCode;
  final double? sellingPrice;
  final double? costPrice;
  final int? stockQuantity;
  final int? minStockQuantity;
  final bool? isSellable;
  final List<String> attributeValueUids;

  const UpdateSkuParams({
    required this.skuUid,
    required this.version,
    this.skuCode,
    this.barCode,
    this.sellingPrice,
    this.costPrice,
    this.stockQuantity,
    this.minStockQuantity,
    this.isSellable,
    this.attributeValueUids = const [],
  });

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
    isSellable,
    attributeValueUids,
  ];
}
