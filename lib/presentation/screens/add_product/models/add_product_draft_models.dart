import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';

class VariantOptionValue extends Equatable {
  const VariantOptionValue({required this.value, this.uid, this.isNew = false});

  final String value;
  final String? uid;
  final bool isNew;

  @override
  List<Object?> get props => [value, uid, isNew];
}

class VariantOptionGroup extends Equatable {
  const VariantOptionGroup({
    required this.id,
    required this.name,
    this.attributeUid,
    this.values = const [],
  });

  final String id;
  final String name;
  final String? attributeUid;
  final List<VariantOptionValue> values;

  VariantOptionGroup copyWith({
    String? name,
    String? attributeUid,
    bool clearAttributeUid = false,
    List<VariantOptionValue>? values,
  }) {
    return VariantOptionGroup(
      id: id,
      name: name ?? this.name,
      attributeUid: clearAttributeUid
          ? null
          : (attributeUid ?? this.attributeUid),
      values: values ?? this.values,
    );
  }

  @override
  List<Object?> get props => [id, name, attributeUid, values];
}

class GeneratedSku extends Equatable {
  const GeneratedSku({
    required this.name,
    this.skuCode = '',
    this.barcode = '',
    this.price = 0.0,
    this.costPrice = 0.0,
    this.stock = 0,
    this.unitId,
    this.unitName,
    this.conversionFactor,
    this.options = const [],
  });

  final String name;
  final String skuCode;
  final String barcode;
  final double price;
  final double costPrice;
  final int stock;
  final int? unitId;
  final String? unitName;
  final double? conversionFactor;
  final List<VariantOptionValue> options;

  GeneratedSku copyWith({
    String? name,
    String? skuCode,
    String? barcode,
    double? price,
    double? costPrice,
    int? stock,
    int? unitId,
    String? unitName,
    double? conversionFactor,
    List<VariantOptionValue>? options,
  }) {
    return GeneratedSku(
      name: name ?? this.name,
      skuCode: skuCode ?? this.skuCode,
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      stock: stock ?? this.stock,
      unitId: unitId ?? this.unitId,
      unitName: unitName ?? this.unitName,
      conversionFactor: conversionFactor ?? this.conversionFactor,
      options: options ?? this.options,
    );
  }

  @override
  List<Object?> get props => [
    name,
    skuCode,
    barcode,
    price,
    costPrice,
    stock,
    unitId,
    unitName,
    conversionFactor,
    options,
  ];
}

class ProductUnitDraft extends Equatable {
  const ProductUnitDraft({
    required this.id,
    required this.unit,
    required this.conversionFactor,
    this.sellingPrice = 0,
  });

  final String id;
  final UnitEntity unit;
  final double conversionFactor;
  final double sellingPrice;

  ProductUnitDraft copyWith({
    UnitEntity? unit,
    double? conversionFactor,
    double? sellingPrice,
  }) {
    return ProductUnitDraft(
      id: id,
      unit: unit ?? this.unit,
      conversionFactor: conversionFactor ?? this.conversionFactor,
      sellingPrice: sellingPrice ?? this.sellingPrice,
    );
  }

  @override
  List<Object?> get props => [id, unit, conversionFactor, sellingPrice];
}
