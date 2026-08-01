import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_state.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/models/sku_form_unit_draft.dart';

List<SkuEntity> sameVariantUnitSkus(SkuFormState state) {
  final sourceUids = state.sourceAttributeValueUids.toSet();
  final skusByUid = <String, SkuEntity>{};

  for (final sku in state.siblingSkus) {
    if (sku.status != 'ACTIVE') continue;
    final skuUids = sku.attributes
        .map((attribute) => attribute.uid)
        .where((uid) => uid.trim().isNotEmpty)
        .toSet();
    final isSameVariant =
        sourceUids.length == skuUids.length &&
        sourceUids.every(skuUids.contains);
    if (isSameVariant) {
      skusByUid[sku.uid] = sku;
    }
  }

  if (state.sourceSku.status == 'ACTIVE') {
    skusByUid.putIfAbsent(state.sourceSku.uid, () => state.sourceSku);
  }

  final skus = skusByUid.values.toList();
  skus.sort(_compareSkuUnitCreatedAtAsc);
  return skus.toList(growable: false);
}

SkuEntity? baseUnitSkuForVariant(SkuFormState state) {
  final skus = sameVariantUnitSkus(state);
  final baseUnitId =
      state.sourceSku.spuBaseUnit?.id ??
      skus.map((sku) => sku.spuBaseUnit?.id).whereType<int>().firstOrNull;
  if (baseUnitId != null) {
    final baseSku = skus.where((sku) => sku.unit?.id == baseUnitId).firstOrNull;
    if (baseSku != null) return baseSku;
  }
  return skus.where((sku) => (sku.conversionFactor ?? 1) == 1).firstOrNull;
}

List<UnitEntity> availableUnitsForDraft(
  SkuFormState state,
  SkuFormUnitDraft draft,
) {
  final blockedIds = {
    ...sameVariantUnitSkus(
      state,
    ).map((sku) => sku.unit?.id).whereType<int>().where((id) => id > 0),
    ...state.unitDrafts
        .where((item) => item.id != draft.id && item.unit.id > 0)
        .map((item) => item.unit.id),
  };
  final units = state.units
      .where((unit) => !blockedIds.contains(unit.id))
      .toList();
  units.sort(_compareUnitCreatedAtAsc);
  return units.toList(growable: false);
}

UnitEntity unitFromText(List<UnitEntity> units, String name, int fallbackId) {
  final normalizedName = name.trim().toLowerCase();
  final existing = units
      .where((unit) => unit.name.trim().toLowerCase() == normalizedName)
      .firstOrNull;
  return existing ?? UnitEntity(id: fallbackId, name: name.trim());
}

int _compareSkuUnitCreatedAtAsc(SkuEntity left, SkuEntity right) {
  final createdAtCompare = _compareNullableDateTime(
    left.unit?.createdAt ?? left.createdAt,
    right.unit?.createdAt ?? right.createdAt,
  );
  if (createdAtCompare != 0) return createdAtCompare;

  final idCompare = (left.unit?.id ?? 0).compareTo(right.unit?.id ?? 0);
  if (idCompare != 0) return idCompare;

  return left.uid.compareTo(right.uid);
}

int _compareUnitCreatedAtAsc(UnitEntity left, UnitEntity right) {
  final createdAtCompare = _compareNullableDateTime(
    left.createdAt,
    right.createdAt,
  );
  if (createdAtCompare != 0) return createdAtCompare;
  return left.id.compareTo(right.id);
}

int _compareNullableDateTime(DateTime? left, DateTime? right) {
  if (left == null && right == null) return 0;
  if (left == null) return 1;
  if (right == null) return -1;
  return left.compareTo(right);
}
