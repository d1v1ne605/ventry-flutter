import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';

class SkuFormCurrentUnitEdit extends Equatable {
  const SkuFormCurrentUnitEdit({
    this.unit,
    this.conversionFactor,
    this.sellingPrice,
    this.isRemoved = false,
  });

  final UnitEntity? unit;
  final double? conversionFactor;
  final double? sellingPrice;
  final bool isRemoved;

  SkuFormCurrentUnitEdit copyWith({
    UnitEntity? unit,
    double? conversionFactor,
    double? sellingPrice,
    bool? isRemoved,
  }) {
    return SkuFormCurrentUnitEdit(
      unit: unit ?? this.unit,
      conversionFactor: conversionFactor ?? this.conversionFactor,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      isRemoved: isRemoved ?? this.isRemoved,
    );
  }

  @override
  List<Object?> get props => [unit, conversionFactor, sellingPrice, isRemoved];
}
