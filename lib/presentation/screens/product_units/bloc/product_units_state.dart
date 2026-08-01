import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';
import 'package:ventry_flutter/domain/entities/product/product_unit_configuration_params.dart';
import 'package:ventry_flutter/domain/entities/product/sku_spu_group_entity.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';

class ProductUnitsState extends Equatable {
  const ProductUnitsState({
    this.status = BaseStatus.initial,
    this.saveStatus = BaseStatus.initial,
    this.group,
    this.units = const [],
    this.pendingCreateSkus = const [],
    this.pendingDiscontinueSkus = const [],
    this.errorMessage,
  });

  final BaseStatus status;
  final BaseStatus saveStatus;
  final SkuSpuGroupEntity? group;
  final List<UnitEntity> units;
  final List<CreateSkuParams> pendingCreateSkus;
  final List<ProductUnitSkuDiscontinueParams> pendingDiscontinueSkus;
  final String? errorMessage;

  bool get hasPendingChanges =>
      pendingCreateSkus.isNotEmpty || pendingDiscontinueSkus.isNotEmpty;

  Set<int> get pendingRemovedUnitIds {
    final removedSkuUids = pendingDiscontinueSkus
        .map((item) => item.skuUid)
        .toSet();
    return group?.skus
            .where((sku) => removedSkuUids.contains(sku.uid))
            .map((sku) => sku.unit?.id)
            .whereType<int>()
            .toSet() ??
        {};
  }

  ProductUnitsState copyWith({
    BaseStatus? status,
    BaseStatus? saveStatus,
    SkuSpuGroupEntity? group,
    List<UnitEntity>? units,
    List<CreateSkuParams>? pendingCreateSkus,
    List<ProductUnitSkuDiscontinueParams>? pendingDiscontinueSkus,
    String? errorMessage,
  }) {
    return ProductUnitsState(
      status: status ?? this.status,
      saveStatus: saveStatus ?? this.saveStatus,
      group: group ?? this.group,
      units: units ?? this.units,
      pendingCreateSkus: pendingCreateSkus ?? this.pendingCreateSkus,
      pendingDiscontinueSkus:
          pendingDiscontinueSkus ?? this.pendingDiscontinueSkus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    saveStatus,
    group,
    units,
    pendingCreateSkus,
    pendingDiscontinueSkus,
    errorMessage,
  ];
}
