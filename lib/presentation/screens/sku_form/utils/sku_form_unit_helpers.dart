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

  skusByUid.putIfAbsent(state.sourceSku.uid, () => state.sourceSku);
  return skusByUid.values.toList().reversed.toList(growable: false);
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
  return state.units.where((unit) => !blockedIds.contains(unit.id)).toList();
}

UnitEntity unitFromText(List<UnitEntity> units, String name, int fallbackId) {
  final normalizedName = name.trim().toLowerCase();
  final existing = units
      .where((unit) => unit.name.trim().toLowerCase() == normalizedName)
      .firstOrNull;
  return existing ?? UnitEntity(id: fallbackId, name: name.trim());
}
