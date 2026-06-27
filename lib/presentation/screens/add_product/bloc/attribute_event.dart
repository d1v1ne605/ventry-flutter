import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_state.dart';

abstract class AttributeEvent extends Equatable {
  const AttributeEvent();

  @override
  List<Object?> get props => [];
}

class LoadAttributesEvent extends AttributeEvent {}

class AddVariantGroupEvent extends AttributeEvent {}

class RemoveVariantGroupEvent extends AttributeEvent {
  final String groupId;
  const RemoveVariantGroupEvent(this.groupId);

  @override
  List<Object?> get props => [groupId];
}

class UpdateVariantGroupNameEvent extends AttributeEvent {
  final String groupId;
  final String name;
  const UpdateVariantGroupNameEvent(this.groupId, this.name);

  @override
  List<Object?> get props => [groupId, name];
}

class AddVariantOptionValueEvent extends AttributeEvent {
  final String groupId;
  final String value;
  const AddVariantOptionValueEvent(this.groupId, this.value);

  @override
  List<Object?> get props => [groupId, value];
}

class RemoveVariantOptionValueEvent extends AttributeEvent {
  final String groupId;
  final VariantOptionValue value;
  const RemoveVariantOptionValueEvent(this.groupId, this.value);

  @override
  List<Object?> get props => [groupId, value];
}

class RemoveGeneratedSkuEvent extends AttributeEvent {
  final String skuName;
  const RemoveGeneratedSkuEvent(this.skuName);

  @override
  List<Object?> get props => [skuName];
}

class UpdateGeneratedSkuEvent extends AttributeEvent {
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

class UpdateGlobalPriceEvent extends AttributeEvent {
  final double price;
  const UpdateGlobalPriceEvent(this.price);

  @override
  List<Object?> get props => [price];
}

class UpdateGlobalCostPriceEvent extends AttributeEvent {
  final double costPrice;
  const UpdateGlobalCostPriceEvent(this.costPrice);

  @override
  List<Object?> get props => [costPrice];
}

class UpdateGlobalStockEvent extends AttributeEvent {
  final int stock;
  const UpdateGlobalStockEvent(this.stock);

  @override
  List<Object?> get props => [stock];
}

class UpdateGlobalIsSellableEvent extends AttributeEvent {
  final bool isSellable;
  const UpdateGlobalIsSellableEvent(this.isSellable);

  @override
  List<Object?> get props => [isSellable];
}
