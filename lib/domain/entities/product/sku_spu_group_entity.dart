import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';

enum SkuSpuGroupStockStatus {
  inStock,
  lowStock,
  outOfStock;

  bool get isOutOfStock => this == SkuSpuGroupStockStatus.outOfStock;
}

class SkuSpuGroupEntity extends Equatable {
  final String spuUid;
  final String spuName;
  final String spuStatus;
  final int spuVersion;
  final String? spuDescription;
  final String? categoryUid;
  final String? categoryName;
  final String? categoryImageUrl;
  final String? currency;
  final String? unitOfMeasure;
  final UnitEntity? baseUnit;
  final List<SkuEntity> skus;

  const SkuSpuGroupEntity({
    required this.spuUid,
    required this.spuName,
    required this.spuStatus,
    required this.spuVersion,
    this.spuDescription,
    this.categoryUid,
    this.categoryName,
    this.categoryImageUrl,
    this.currency,
    this.unitOfMeasure,
    this.baseUnit,
    this.skus = const [],
  });

  SkuEntity? get representativeSku => summarySku;

  List<SkuEntity> get sortedSkus {
    final sorted = [...skus]
      ..sort((left, right) {
        final leftCode = left.skuCode ?? left.uid;
        final rightCode = right.skuCode ?? right.uid;
        return _compareSkuCodes(leftCode, rightCode);
      });

    return sorted;
  }

  SkuEntity? get summarySku {
    return sortedSkus.isEmpty ? null : sortedSkus.first;
  }

  String? get primaryImageUrl {
    final skuImageUrl = representativeSku?.primaryImageUrl;
    if (skuImageUrl != null && skuImageUrl.isNotEmpty) {
      return skuImageUrl;
    }

    return categoryImageUrl;
  }

  int get variantCount => skus.length;

  List<SkuSpuGroupAttributeSummary> get attributeSummaries {
    final valuesByName = <String, Set<String>>{};

    for (final sku in skus) {
      for (final attribute in sku.attributes) {
        final name = attribute.attributeName.trim();
        final value = attribute.value.trim();
        if (name.isEmpty || value.isEmpty) {
          continue;
        }

        valuesByName.putIfAbsent(name, () => <String>{}).add(value);
      }
    }

    return valuesByName.entries
        .map(
          (entry) => SkuSpuGroupAttributeSummary(
            attributeName: entry.key,
            value: entry.value.join('/'),
          ),
        )
        .toList();
  }

  int get totalStock => skus
      .where((sku) => sku.status == 'ACTIVE')
      .fold(0, (total, sku) => total + sku.stockQuantity);

  int get lowStockCount => skus
      .where(
        (sku) =>
            sku.status == 'ACTIVE' &&
            sku.stockQuantity > 0 &&
            sku.stockQuantity <= sku.minStockQuantity,
      )
      .length;

  bool get isOutOfStock =>
      skus.isEmpty || skus.every((sku) => sku.stockQuantity <= 0);

  SkuSpuGroupStockStatus get stockStatus {
    if (isOutOfStock) return SkuSpuGroupStockStatus.outOfStock;
    if (lowStockCount > 0) return SkuSpuGroupStockStatus.lowStock;
    return SkuSpuGroupStockStatus.inStock;
  }

  double? get minSellingPrice {
    final prices =
        skus.map((sku) => sku.sellingPrice).whereType<double>().toList()
          ..sort();
    return prices.isEmpty ? null : prices.first;
  }

  List<UnitEntity> get activeUnits {
    final units = <int, UnitEntity>{};
    for (final sku in skus.where((sku) => sku.status == 'ACTIVE')) {
      final unit = sku.unit;
      if (unit != null) {
        units[unit.id] = unit;
      }
    }
    return units.values.toList(growable: false);
  }

  List<SkuSpuUnitGroupEntity> get unitGroups {
    final skusByUnitId = <int, List<SkuEntity>>{};
    for (final sku in sortedSkus.where((sku) => sku.status == 'ACTIVE')) {
      final unitId = sku.unit?.id ?? -1;
      skusByUnitId.putIfAbsent(unitId, () => <SkuEntity>[]).add(sku);
    }

    final groups = skusByUnitId.values
        .map(
          (unitSkus) => SkuSpuUnitGroupEntity(
            parent: this,
            unit: unitSkus.first.unit,
            conversionFactor: unitSkus.first.conversionFactor ?? 1,
            skus: unitSkus,
          ),
        )
        .toList();
    groups.sort((left, right) {
      final factorCompare = right.conversionFactor.compareTo(
        left.conversionFactor,
      );
      if (factorCompare != 0) return factorCompare;
      return left.unitName.compareTo(right.unitName);
    });
    return groups;
  }

  @override
  List<Object?> get props => [
    spuUid,
    spuName,
    spuStatus,
    spuVersion,
    spuDescription,
    categoryUid,
    categoryName,
    categoryImageUrl,
    currency,
    unitOfMeasure,
    baseUnit,
    skus,
  ];
}

class SkuSpuUnitGroupEntity extends Equatable {
  const SkuSpuUnitGroupEntity({
    required this.parent,
    required this.unit,
    required this.conversionFactor,
    required this.skus,
  });

  final SkuSpuGroupEntity parent;
  final UnitEntity? unit;
  final double conversionFactor;
  final List<SkuEntity> skus;

  SkuEntity? get summarySku => skus.isEmpty ? null : skus.first;

  String get unitName => unit?.name ?? parent.unitOfMeasure ?? '';

  String? get primaryImageUrl =>
      summarySku?.primaryImageUrl ?? parent.primaryImageUrl;

  int get variantCount => skus.length;

  int get totalStock => skus.fold(0, (total, sku) => total + sku.stockQuantity);

  double? get minSellingPrice {
    final prices =
        skus.map((sku) => sku.sellingPrice).whereType<double>().toList()
          ..sort();
    return prices.isEmpty ? null : prices.first;
  }

  List<SkuSpuGroupAttributeSummary> get attributeSummaries {
    final valuesByName = <String, Set<String>>{};
    for (final sku in skus) {
      for (final attribute in sku.attributes) {
        final name = attribute.attributeName.trim();
        final value = attribute.value.trim();
        if (name.isEmpty || value.isEmpty) continue;
        valuesByName.putIfAbsent(name, () => <String>{}).add(value);
      }
    }
    return valuesByName.entries
        .map(
          (entry) => SkuSpuGroupAttributeSummary(
            attributeName: entry.key,
            value: entry.value.join('/'),
          ),
        )
        .toList();
  }

  bool get isOutOfStock =>
      skus.isEmpty || skus.every((sku) => sku.stockQuantity <= 0);

  int get lowStockCount => skus
      .where(
        (sku) =>
            sku.stockQuantity > 0 && sku.stockQuantity <= sku.minStockQuantity,
      )
      .length;

  SkuSpuGroupStockStatus get stockStatus {
    if (isOutOfStock) return SkuSpuGroupStockStatus.outOfStock;
    if (lowStockCount > 0) return SkuSpuGroupStockStatus.lowStock;
    return SkuSpuGroupStockStatus.inStock;
  }

  @override
  List<Object?> get props => [parent, unit, conversionFactor, skus];
}

class SkuSpuGroupAttributeSummary extends Equatable {
  final String attributeName;
  final String value;

  const SkuSpuGroupAttributeSummary({
    required this.attributeName,
    required this.value,
  });

  @override
  List<Object?> get props => [attributeName, value];
}

int _compareSkuCodes(String left, String right) {
  final leftNumber = _trailingNumber(left);
  final rightNumber = _trailingNumber(right);

  if (leftNumber != null && rightNumber != null && leftNumber != rightNumber) {
    return leftNumber.compareTo(rightNumber);
  }

  return left.compareTo(right);
}

int? _trailingNumber(String value) {
  final match = RegExp(r'(\d+)$').firstMatch(value);
  if (match == null) {
    return null;
  }

  return int.tryParse(match.group(1) ?? '');
}
