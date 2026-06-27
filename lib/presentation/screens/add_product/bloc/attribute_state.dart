import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';

class VariantOptionValue extends Equatable {
  final String value;
  final String? uid;
  final bool isNew;

  const VariantOptionValue({required this.value, this.uid, this.isNew = false});

  @override
  List<Object?> get props => [value, uid, isNew];
}

class VariantOptionGroup extends Equatable {
  final String id;
  final String name;
  final String? attributeUid;
  final List<VariantOptionValue> values;

  const VariantOptionGroup({
    required this.id,
    required this.name,
    this.attributeUid,
    this.values = const [],
  });

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
  final String name;
  final String skuCode;
  final String barcode;
  final double price;
  final double costPrice;
  final int stock;
  final List<VariantOptionValue> options;

  const GeneratedSku({
    required this.name,
    this.skuCode = '',
    this.barcode = '',
    this.price = 0.0,
    this.costPrice = 0.0,
    this.stock = 0,
    this.options = const [],
  });

  GeneratedSku copyWith({
    String? name,
    String? skuCode,
    String? barcode,
    double? price,
    double? costPrice,
    int? stock,
    List<VariantOptionValue>? options,
  }) {
    return GeneratedSku(
      name: name ?? this.name,
      skuCode: skuCode ?? this.skuCode,
      barcode: barcode ?? this.barcode,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      stock: stock ?? this.stock,
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
    options,
  ];
}

class AttributeState extends Equatable {
  final BaseStatus status;
  final List<AttributeEntity> localAttributes;
  final List<VariantOptionGroup> variantGroups;
  final List<GeneratedSku> generatedSkus;
  final String? errorMessage;
  final double globalPrice;
  final double globalCostPrice;
  final int globalStock;
  final bool globalIsSellable;
  final String globalSkuCode;
  final String globalBarcode;

  const AttributeState({
    this.status = BaseStatus.initial,
    this.localAttributes = const [],
    this.variantGroups = const [],
    this.generatedSkus = const [],
    this.errorMessage,
    this.globalPrice = 0.0,
    this.globalCostPrice = 0.0,
    this.globalStock = 0,
    this.globalIsSellable = true,
    this.globalSkuCode = '',
    this.globalBarcode = '',
  });

  AttributeState copyWith({
    BaseStatus? status,
    List<AttributeEntity>? localAttributes,
    List<VariantOptionGroup>? variantGroups,
    List<GeneratedSku>? generatedSkus,
    String? errorMessage,
    double? globalPrice,
    double? globalCostPrice,
    int? globalStock,
    bool? globalIsSellable,
    String? globalSkuCode,
    String? globalBarcode,
  }) {
    return AttributeState(
      status: status ?? this.status,
      localAttributes: localAttributes ?? this.localAttributes,
      variantGroups: variantGroups ?? this.variantGroups,
      generatedSkus: generatedSkus ?? this.generatedSkus,
      errorMessage: errorMessage ?? this.errorMessage,
      globalPrice: globalPrice ?? this.globalPrice,
      globalCostPrice: globalCostPrice ?? this.globalCostPrice,
      globalStock: globalStock ?? this.globalStock,
      globalIsSellable: globalIsSellable ?? this.globalIsSellable,
      globalSkuCode: globalSkuCode ?? this.globalSkuCode,
      globalBarcode: globalBarcode ?? this.globalBarcode,
    );
  }

  @override
  List<Object?> get props => [
    status,
    localAttributes,
    variantGroups,
    generatedSkus,
    errorMessage,
    globalPrice,
    globalCostPrice,
    globalStock,
    globalIsSellable,
    globalSkuCode,
    globalBarcode,
  ];
}
