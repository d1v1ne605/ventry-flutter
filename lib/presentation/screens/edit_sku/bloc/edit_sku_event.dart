import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';

abstract class EditSkuEvent extends Equatable {
  const EditSkuEvent();

  @override
  List<Object?> get props => [];
}

class EditSkuNameChanged extends EditSkuEvent {
  const EditSkuNameChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class EditSkuCategoryChanged extends EditSkuEvent {
  const EditSkuCategoryChanged(this.category);

  final CategoryEntity category;

  @override
  List<Object?> get props => [category];
}

class EditSkuBarcodeChanged extends EditSkuEvent {
  const EditSkuBarcodeChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class EditSkuCodeChanged extends EditSkuEvent {
  const EditSkuCodeChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class EditSkuCostPriceChanged extends EditSkuEvent {
  const EditSkuCostPriceChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class EditSkuSellingPriceChanged extends EditSkuEvent {
  const EditSkuSellingPriceChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class EditSkuCurrencyChanged extends EditSkuEvent {
  const EditSkuCurrencyChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class EditSkuUnitOfMeasureChanged extends EditSkuEvent {
  const EditSkuUnitOfMeasureChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}

class EditSkuSellableChanged extends EditSkuEvent {
  const EditSkuSellableChanged(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

class EditSkuDescriptionChanged extends EditSkuEvent {
  const EditSkuDescriptionChanged(this.value);

  final String value;

  @override
  List<Object?> get props => [value];
}
