import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';
import 'package:ventry_flutter/presentation/screens/add_product/models/add_product_draft_models.dart';

export 'package:ventry_flutter/presentation/screens/add_product/models/add_product_draft_models.dart';

class AddProductState extends Equatable {
  final BaseStatus status;
  final BaseStatus unitStatus;
  final List<AttributeEntity> localAttributes;
  final List<UnitEntity> units;
  final UnitEntity? selectedBaseUnit;
  final List<ProductUnitDraft> productUnitDrafts;
  final List<VariantOptionGroup> variantGroups;
  final List<GeneratedSku> generatedSkus;
  final String? errorMessage;
  final double globalPrice;
  final double globalCostPrice;
  final int globalStock;
  final bool globalIsSellable;
  final String globalSkuCode;
  final String globalBarcode;

  const AddProductState({
    this.status = BaseStatus.initial,
    this.unitStatus = BaseStatus.initial,
    this.localAttributes = const [],
    this.units = const [],
    this.selectedBaseUnit,
    this.productUnitDrafts = const [],
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

  List<ProductUnitDraft> get unitRows {
    final baseUnit = selectedBaseUnit;
    if (baseUnit == null) {
      return productUnitDrafts;
    }
    if (baseUnit.id <= 0 || baseUnit.name.trim().isEmpty) {
      return const [];
    }

    final validDrafts = productUnitDrafts.where(
      (draft) =>
          draft.unit.id > 0 &&
          draft.unit.name.trim().isNotEmpty &&
          draft.conversionFactor > 0,
    );
    return [
      ProductUnitDraft(
        id: 'base-${baseUnit.id}',
        unit: baseUnit,
        conversionFactor: 1,
        sellingPrice: globalPrice,
      ),
      ...validDrafts.where((draft) => draft.unit.id != baseUnit.id),
    ];
  }

  AddProductState copyWith({
    BaseStatus? status,
    BaseStatus? unitStatus,
    List<AttributeEntity>? localAttributes,
    List<UnitEntity>? units,
    UnitEntity? selectedBaseUnit,
    List<ProductUnitDraft>? productUnitDrafts,
    List<VariantOptionGroup>? variantGroups,
    List<GeneratedSku>? generatedSkus,
    String? errorMessage,
    double? globalPrice,
    double? globalCostPrice,
    int? globalStock,
    bool? globalIsSellable,
    String? globalSkuCode,
    String? globalBarcode,
    bool clearSelectedBaseUnit = false,
  }) {
    return AddProductState(
      status: status ?? this.status,
      unitStatus: unitStatus ?? this.unitStatus,
      localAttributes: localAttributes ?? this.localAttributes,
      units: units ?? this.units,
      selectedBaseUnit: clearSelectedBaseUnit
          ? null
          : (selectedBaseUnit ?? this.selectedBaseUnit),
      productUnitDrafts: productUnitDrafts ?? this.productUnitDrafts,
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
    unitStatus,
    localAttributes,
    units,
    selectedBaseUnit,
    productUnitDrafts,
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
