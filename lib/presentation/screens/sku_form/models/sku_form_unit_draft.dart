import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';

class SkuFormUnitDraft extends Equatable {
  const SkuFormUnitDraft({
    required this.id,
    required this.unit,
    required this.skuCode,
    required this.conversionFactor,
    required this.sellingPrice,
  });

  final String id;
  final UnitEntity unit;
  final String skuCode;
  final double conversionFactor;
  final double sellingPrice;

  SkuFormUnitDraft copyWith({
    UnitEntity? unit,
    String? skuCode,
    double? conversionFactor,
    double? sellingPrice,
  }) {
    return SkuFormUnitDraft(
      id: id,
      unit: unit ?? this.unit,
      skuCode: skuCode ?? this.skuCode,
      conversionFactor: conversionFactor ?? this.conversionFactor,
      sellingPrice: sellingPrice ?? this.sellingPrice,
    );
  }

  @override
  List<Object?> get props => [
    id,
    unit,
    skuCode,
    conversionFactor,
    sellingPrice,
  ];
}
