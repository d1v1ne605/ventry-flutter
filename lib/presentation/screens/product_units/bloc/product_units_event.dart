import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/presentation/screens/add_product/models/add_product_draft_models.dart';

abstract class ProductUnitsEvent extends Equatable {
  const ProductUnitsEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductUnits extends ProductUnitsEvent {
  const LoadProductUnits(this.spuUid);

  final String spuUid;

  @override
  List<Object?> get props => [spuUid];
}

class QueueProductUnitCreation extends ProductUnitsEvent {
  const QueueProductUnitCreation(this.draft);

  final ProductUnitDraft draft;

  @override
  List<Object?> get props => [draft];
}

class QueueProductUnitRemoval extends ProductUnitsEvent {
  const QueueProductUnitRemoval(this.unitId);

  final int unitId;

  @override
  List<Object?> get props => [unitId];
}

class SaveProductUnitConfiguration extends ProductUnitsEvent {
  const SaveProductUnitConfiguration();
}
