import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_state.dart';

abstract class AddProductEvent extends Equatable {
  const AddProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadAttributesEvent extends AddProductEvent {}

class LoadUnitsEvent extends AddProductEvent {}

class SelectBaseUnitEvent extends AddProductEvent {
  const SelectBaseUnitEvent(this.unit);

  final UnitEntity unit;

  @override
  List<Object?> get props => [unit];
}

class ClearBaseUnitEvent extends AddProductEvent {}

class CreateProductUnitEvent extends AddProductEvent {
  const CreateProductUnitEvent(
    this.name, {
    this.selectAsBase = true,
    this.draftId,
  });

  final String name;
  final bool selectAsBase;
  final String? draftId;

  @override
  List<Object?> get props => [name, selectAsBase, draftId];
}

class AddProductUnitDraftEvent extends AddProductEvent {
  const AddProductUnitDraftEvent(this.draft);

  final ProductUnitDraft draft;

  @override
  List<Object?> get props => [draft];
}

class UpdateProductUnitDraftEvent extends AddProductEvent {
  const UpdateProductUnitDraftEvent({
    required this.id,
    this.unit,
    this.conversionFactor,
    this.sellingPrice,
  });

  final String id;
  final UnitEntity? unit;
  final double? conversionFactor;
  final double? sellingPrice;

  @override
  List<Object?> get props => [id, unit, conversionFactor, sellingPrice];
}

class RemoveProductUnitDraftEvent extends AddProductEvent {
  const RemoveProductUnitDraftEvent(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}

class AddVariantGroupEvent extends AddProductEvent {}

class RemoveVariantGroupEvent extends AddProductEvent {
  final String groupId;
  const RemoveVariantGroupEvent(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class UpdateVariantGroupNameEvent extends AddProductEvent {
  final String groupId;
  final String name;
  const UpdateVariantGroupNameEvent(this.groupId, this.name);

  @override
  List<Object?> get props => [groupId, name];
}

class AddVariantOptionValueEvent extends AddProductEvent {
  final String groupId;
  final String value;
  const AddVariantOptionValueEvent(this.groupId, this.value);

  @override
  List<Object?> get props => [groupId, value];
}

class RemoveVariantOptionValueEvent extends AddProductEvent {
  final String groupId;
  final VariantOptionValue value;
  const RemoveVariantOptionValueEvent(this.groupId, this.value);

  @override
  List<Object?> get props => [groupId, value];
}

class RemoveGeneratedSkuEvent extends AddProductEvent {
  final String skuName;
  const RemoveGeneratedSkuEvent(this.skuName);

  @override
  List<Object?> get props => [skuName];
}

class UpdateGeneratedSkuEvent extends AddProductEvent {
  final String skuName;
  final String skuCode;
  final String barcode;
  final double price;
  final double costPrice;
  final int stock;

  const UpdateGeneratedSkuEvent({
    required this.skuName,
    required this.skuCode,
    required this.barcode,
    required this.price,
    required this.costPrice,
    required this.stock,
  });

  @override
  List<Object?> get props => [
    skuName,
    skuCode,
    barcode,
    price,
    costPrice,
    stock,
  ];
}

class UpdateGlobalPriceEvent extends AddProductEvent {
  final double price;
  const UpdateGlobalPriceEvent(this.price);

  @override
  List<Object?> get props => [price];
}

class UpdateGlobalCostPriceEvent extends AddProductEvent {
  final double costPrice;
  const UpdateGlobalCostPriceEvent(this.costPrice);

  @override
  List<Object?> get props => [costPrice];
}

class UpdateGlobalStockEvent extends AddProductEvent {
  final int stock;
  const UpdateGlobalStockEvent(this.stock);

  @override
  List<Object?> get props => [stock];
}

class UpdateGlobalIsSellableEvent extends AddProductEvent {
  final bool isSellable;
  const UpdateGlobalIsSellableEvent(this.isSellable);

  @override
  List<Object?> get props => [isSellable];
}

class UpdateGlobalSkuCodeEvent extends AddProductEvent {
  final String skuCode;
  const UpdateGlobalSkuCodeEvent(this.skuCode);

  @override
  List<Object?> get props => [skuCode];
}

class UpdateGlobalBarcodeEvent extends AddProductEvent {
  final String barcode;
  const UpdateGlobalBarcodeEvent(this.barcode);

  @override
  List<Object?> get props => [barcode];
}
