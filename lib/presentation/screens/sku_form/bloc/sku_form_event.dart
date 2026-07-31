import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/models/editable_sku_form_image.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/models/sku_form_current_unit_edit.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/models/sku_form_unit_draft.dart';

abstract class SkuFormEvent extends Equatable {
  const SkuFormEvent();

  @override
  List<Object?> get props => [];
}

class SkuFormNameChanged extends SkuFormEvent {
  const SkuFormNameChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class SkuFormCategoryChanged extends SkuFormEvent {
  const SkuFormCategoryChanged(this.category);

  final CategoryEntity category;

  @override
  List<Object?> get props => [category];
}

class SkuFormBarcodeChanged extends SkuFormEvent {
  const SkuFormBarcodeChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class SkuFormCodeChanged extends SkuFormEvent {
  const SkuFormCodeChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class SkuFormCostPriceChanged extends SkuFormEvent {
  const SkuFormCostPriceChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class SkuFormSellingPriceChanged extends SkuFormEvent {
  const SkuFormSellingPriceChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class SkuFormCurrencyChanged extends SkuFormEvent {
  const SkuFormCurrencyChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class SkuFormUnitOfMeasureChanged extends SkuFormEvent {
  const SkuFormUnitOfMeasureChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class SkuFormSellableChanged extends SkuFormEvent {
  const SkuFormSellableChanged(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

class SkuFormDescriptionChanged extends SkuFormEvent {
  const SkuFormDescriptionChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class SkuFormSubmitted extends SkuFormEvent {
  const SkuFormSubmitted();
}

class SkuFormSourceSynced extends SkuFormEvent {
  const SkuFormSourceSynced(this.sku);

  final SkuEntity sku;

  @override
  List<Object?> get props => [sku];
}

class SkuFormAttributesChanged extends SkuFormEvent {
  const SkuFormAttributesChanged(this.attributes);

  final List<SkuAttributeEntity> attributes;

  @override
  List<Object?> get props => [attributes];
}

class SkuFormImagesChanged extends SkuFormEvent {
  const SkuFormImagesChanged(this.images);

  final List<EditableSkuFormImage> images;

  @override
  List<Object?> get props => [images];
}

class SkuFormUnitDataRequested extends SkuFormEvent {
  const SkuFormUnitDataRequested();
}

class SkuFormUnitDraftAdded extends SkuFormEvent {
  const SkuFormUnitDraftAdded(this.draft);

  final SkuFormUnitDraft draft;

  @override
  List<Object?> get props => [draft];
}

class SkuFormUnitDraftChanged extends SkuFormEvent {
  const SkuFormUnitDraftChanged({
    required this.id,
    this.unit,
    this.skuCode,
    this.conversionFactor,
    this.sellingPrice,
  });

  final String id;
  final UnitEntity? unit;
  final String? skuCode;
  final double? conversionFactor;
  final double? sellingPrice;

  @override
  List<Object?> get props => [
    id,
    unit,
    skuCode,
    conversionFactor,
    sellingPrice,
  ];
}

class SkuFormUnitDraftRemoved extends SkuFormEvent {
  const SkuFormUnitDraftRemoved(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class SkuFormUnitPriceChanged extends SkuFormEvent {
  const SkuFormUnitPriceChanged({
    required this.skuUid,
    required this.sellingPrice,
  });

  final String skuUid;
  final double sellingPrice;

  @override
  List<Object?> get props => [skuUid, sellingPrice];
}

class SkuFormCurrentUnitChanged extends SkuFormEvent {
  const SkuFormCurrentUnitChanged(this.edit);

  final SkuFormCurrentUnitEdit edit;

  @override
  List<Object?> get props => [edit];
}

class SkuFormUnitConfigurationSubmitted extends SkuFormEvent {
  const SkuFormUnitConfigurationSubmitted();
}
