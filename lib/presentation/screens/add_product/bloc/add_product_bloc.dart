import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';
import 'package:ventry_flutter/domain/usecases/attribute/create_attribute_usecase.dart';
import 'package:ventry_flutter/domain/usecases/attribute/create_attribute_value_usecase.dart';
import 'package:ventry_flutter/domain/usecases/attribute/get_local_attributes_usecase.dart';
import 'package:ventry_flutter/domain/usecases/attribute/sync_attributes_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/create_unit_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/get_units_usecase.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_event.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_state.dart';

@injectable
class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final GetLocalAttributesUseCase _getLocalAttributes;
  final SyncAttributesUseCase _syncAttributes;
  final CreateAttributeUseCase _createAttribute;
  final CreateAttributeValueUseCase _createAttributeValue;
  final GetUnitsUseCase _getUnits;
  final CreateUnitUseCase _createUnit;

  AddProductBloc(
    this._getLocalAttributes,
    this._syncAttributes,
    this._createAttribute,
    this._createAttributeValue,
    this._getUnits,
    this._createUnit,
  ) : super(const AddProductState()) {
    on<LoadAttributesEvent>(_onLoadAttributes);
    on<LoadUnitsEvent>(_onLoadUnits);
    on<AddVariantGroupEvent>(_onAddVariantGroup);
    on<RemoveVariantGroupEvent>(_onRemoveVariantGroup);
    on<UpdateVariantGroupNameEvent>(
      _onUpdateVariantGroupName,
      transformer: sequential(),
    );
    on<AddVariantOptionValueEvent>(
      _onAddVariantOptionValue,
      transformer: sequential(),
    );
    on<RemoveVariantOptionValueEvent>(_onRemoveVariantOptionValue);
    on<RemoveGeneratedSkuEvent>(_onRemoveGeneratedSku);
    on<UpdateGeneratedSkuEvent>(_onUpdateGeneratedSku);
    on<UpdateGlobalPriceEvent>(_onUpdateGlobalPrice);
    on<UpdateGlobalCostPriceEvent>(_onUpdateGlobalCostPrice);
    on<UpdateGlobalStockEvent>(_onUpdateGlobalStock);
    on<UpdateGlobalIsSellableEvent>(_onUpdateGlobalIsSellable);
    on<UpdateGlobalSkuCodeEvent>(_onUpdateGlobalSkuCode);
    on<UpdateGlobalBarcodeEvent>(_onUpdateGlobalBarcode);
    on<SelectBaseUnitEvent>(_onSelectBaseUnit);
    on<ClearBaseUnitEvent>(_onClearBaseUnit);
    on<CreateProductUnitEvent>(_onCreateProductUnit);
    on<AddProductUnitDraftEvent>(_onAddProductUnitDraft);
    on<UpdateProductUnitDraftEvent>(_onUpdateProductUnitDraft);
    on<RemoveProductUnitDraftEvent>(_onRemoveProductUnitDraft);
  }

  Future<void> _onLoadAttributes(
    LoadAttributesEvent event,
    Emitter<AddProductState> emit,
  ) async {
    emit(state.copyWith(status: BaseStatus.loading));

    final localResult = await _getLocalAttributes(NoParams());
    localResult.fold(
      (failure) => emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (attributes) => emit(state.copyWith(localAttributes: attributes)),
    );

    // Sync in background
    final syncResult = await _syncAttributes(NoParams());
    if (syncResult.isRight()) {
      final updatedLocal = await _getLocalAttributes(NoParams());
      updatedLocal.fold(
        (_) {},
        (attributes) => emit(
          state.copyWith(
            status: BaseStatus.success,
            localAttributes: attributes,
          ),
        ),
      );
    } else {
      emit(state.copyWith(status: BaseStatus.success));
    }
  }

  Future<void> _onLoadUnits(
    LoadUnitsEvent event,
    Emitter<AddProductState> emit,
  ) async {
    emit(state.copyWith(unitStatus: BaseStatus.loading));

    final result = await _getUnits(NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          unitStatus: BaseStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (units) => emit(
        state.copyWith(
          unitStatus: BaseStatus.success,
          units: units,
          selectedBaseUnit: state.selectedBaseUnit,
        ),
      ),
    );

    _generateSkus(emit, state.variantGroups);
  }

  Future<void> _onCreateProductUnit(
    CreateProductUnitEvent event,
    Emitter<AddProductState> emit,
  ) async {
    final name = event.name.trim();
    if (name.isEmpty) return;

    emit(state.copyWith(unitStatus: BaseStatus.loading));
    final result = await _createUnit(name);
    result.fold(
      (failure) => emit(
        state.copyWith(
          unitStatus: BaseStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (unit) {
        final units = [...state.units, unit];
        final drafts = event.draftId == null
            ? state.productUnitDrafts
            : state.productUnitDrafts.map((draft) {
                if (draft.id != event.draftId) return draft;
                return draft.copyWith(unit: unit);
              }).toList();
        emit(
          state.copyWith(
            unitStatus: BaseStatus.success,
            units: units,
            productUnitDrafts: drafts,
            selectedBaseUnit: event.selectAsBase
                ? unit
                : state.selectedBaseUnit,
          ),
        );
      },
    );

    _generateSkus(emit, state.variantGroups);
  }

  void _onAddVariantGroup(
    AddVariantGroupEvent event,
    Emitter<AddProductState> emit,
  ) {
    final newGroup = VariantOptionGroup(id: const Uuid().v4(), name: '');
    final updatedGroups = List<VariantOptionGroup>.from(state.variantGroups)
      ..add(newGroup);
    emit(state.copyWith(variantGroups: updatedGroups));
    _generateSkus(emit, updatedGroups);
  }

  void _onRemoveVariantGroup(
    RemoveVariantGroupEvent event,
    Emitter<AddProductState> emit,
  ) {
    final updatedGroups = state.variantGroups
        .where((g) => g.id != event.groupId)
        .toList();
    emit(state.copyWith(variantGroups: updatedGroups));
    _generateSkus(emit, updatedGroups);
  }

  Future<void> _onUpdateVariantGroupName(
    UpdateVariantGroupNameEvent event,
    Emitter<AddProductState> emit,
  ) async {
    final groupIndex = state.variantGroups.indexWhere(
      (g) => g.id == event.groupId,
    );
    if (groupIndex == -1) return;

    final name = event.name.trim();
    final currentGroup = state.variantGroups[groupIndex];
    if (name.isEmpty) {
      final updatedGroup = currentGroup.copyWith(
        name: '',
        clearAttributeUid: true,
        values: [],
      );
      final updatedGroups = List<VariantOptionGroup>.from(state.variantGroups)
        ..[groupIndex] = updatedGroup;
      emit(state.copyWith(variantGroups: updatedGroups));
      _generateSkus(emit, updatedGroups);
      return;
    }

    final normalizedCurrentName = currentGroup.name.trim().toLowerCase();
    if (normalizedCurrentName == name.toLowerCase() &&
        currentGroup.attributeUid != null) {
      return;
    }

    final existing = state.localAttributes
        .where((a) => a.name.toLowerCase() == name.toLowerCase())
        .firstOrNull;

    VariantOptionGroup updatedGroup = currentGroup.copyWith(name: name);

    if (existing != null) {
      updatedGroup = updatedGroup.copyWith(attributeUid: existing.uid);
      final updatedGroups = List<VariantOptionGroup>.from(state.variantGroups)
        ..[groupIndex] = updatedGroup;
      emit(state.copyWith(variantGroups: updatedGroups));
    } else {
      emit(state.copyWith(status: BaseStatus.loading));
      final result = await _createAttribute(CreateAttributeParams(name: name));

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: BaseStatus.failure,
              errorMessage: failure.message,
            ),
          );
          emit(state.copyWith(status: BaseStatus.success));
        },
        (entity) {
          final updatedAttributes = List<AttributeEntity>.from(
            state.localAttributes,
          )..add(entity);
          updatedGroup = updatedGroup.copyWith(attributeUid: entity.uid);
          final updatedGroups = List<VariantOptionGroup>.from(
            state.variantGroups,
          )..[groupIndex] = updatedGroup;
          emit(
            state.copyWith(
              status: BaseStatus.success,
              localAttributes: updatedAttributes,
              variantGroups: updatedGroups,
            ),
          );
        },
      );
    }
  }

  Future<void> _onAddVariantOptionValue(
    AddVariantOptionValueEvent event,
    Emitter<AddProductState> emit,
  ) async {
    final groupIndex = state.variantGroups.indexWhere(
      (g) => g.id == event.groupId,
    );
    if (groupIndex == -1) return;

    final group = state.variantGroups[groupIndex];
    if (group.attributeUid == null) return;

    final value = event.value.trim();
    if (value.isEmpty) return;

    if (group.values.any((v) => v.value.toLowerCase() == value.toLowerCase())) {
      return;
    }

    final existingAttr = state.localAttributes.firstWhere(
      (a) => a.uid == group.attributeUid,
    );
    final existingVal = existingAttr.values
        .where((v) => v.value.toLowerCase() == value.toLowerCase())
        .firstOrNull;

    VariantOptionValue newValue;

    if (existingVal != null) {
      newValue = VariantOptionValue(
        value: existingVal.value,
        uid: existingVal.uid,
      );
      final updatedGroup = group.copyWith(
        values: List.from(group.values)..add(newValue),
      );
      final updatedGroups = List<VariantOptionGroup>.from(state.variantGroups)
        ..[groupIndex] = updatedGroup;
      emit(state.copyWith(variantGroups: updatedGroups));
      _generateSkus(emit, updatedGroups);
    } else {
      emit(state.copyWith(status: BaseStatus.loading));
      final result = await _createAttributeValue(
        CreateAttributeValueParams(
          attributeUid: group.attributeUid!,
          value: value,
        ),
      );

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: BaseStatus.failure,
              errorMessage: failure.message,
            ),
          );
          emit(state.copyWith(status: BaseStatus.success));
        },
        (entity) {
          newValue = VariantOptionValue(
            value: entity.value,
            uid: entity.uid,
            isNew: true,
          );
          final updatedGroup = group.copyWith(
            values: List.from(group.values)..add(newValue),
          );
          final updatedGroups = List<VariantOptionGroup>.from(
            state.variantGroups,
          )..[groupIndex] = updatedGroup;
          emit(
            state.copyWith(
              status: BaseStatus.success,
              variantGroups: updatedGroups,
            ),
          );
          _generateSkus(emit, updatedGroups);
        },
      );
    }
  }

  void _onRemoveVariantOptionValue(
    RemoveVariantOptionValueEvent event,
    Emitter<AddProductState> emit,
  ) {
    final groupIndex = state.variantGroups.indexWhere(
      (g) => g.id == event.groupId,
    );
    if (groupIndex == -1) return;

    final group = state.variantGroups[groupIndex];
    final updatedValues = group.values.where((v) => v != event.value).toList();
    final updatedGroup = group.copyWith(values: updatedValues);
    final updatedGroups = List<VariantOptionGroup>.from(state.variantGroups)
      ..[groupIndex] = updatedGroup;

    emit(state.copyWith(variantGroups: updatedGroups));
    _generateSkus(emit, updatedGroups);
  }

  void _generateSkus(
    Emitter<AddProductState> emit,
    List<VariantOptionGroup> groups,
  ) {
    final validGroups = groups.where((g) => g.values.isNotEmpty).toList();
    final unitRows = state.unitRows;

    if (validGroups.isEmpty && unitRows.isEmpty) {
      emit(state.copyWith(generatedSkus: const []));
      return;
    }

    List<List<VariantOptionValue>> combinations = [[]];

    for (var group in validGroups) {
      final List<List<VariantOptionValue>> newCombinations = [];
      for (var combination in combinations) {
        for (var value in group.values) {
          newCombinations.add(List.from(combination)..add(value));
        }
      }
      combinations = newCombinations;
    }

    if (validGroups.isEmpty) {
      combinations = [[]];
    }

    final skuSeeds = unitRows.isEmpty
        ? combinations.map((combo) => (combo: combo, unit: null)).toList()
        : [
            for (final combo in combinations)
              for (final unit in unitRows) (combo: combo, unit: unit),
          ];

    final skus = skuSeeds.asMap().entries.map((entry) {
      final index = entry.key;
      final combo = entry.value.combo;
      final unit = entry.value.unit;
      final optionName = combo.map((c) => c.value).join(' - ');
      final name = unit == null
          ? optionName
          : optionName.isEmpty
          ? unit.unit.name
          : '$optionName - ${unit.unit.name}';
      final existingSku = state.generatedSkus
          .where((s) => s.name == name)
          .firstOrNull;

      if (existingSku != null) {
        final factor = unit?.conversionFactor ?? 1;
        return existingSku.copyWith(
          options: combo,
          price: unit?.sellingPrice ?? state.globalPrice * factor,
          costPrice: state.globalCostPrice * factor,
          unitId: unit?.unit.id,
          unitName: unit?.unit.name,
          conversionFactor: unit?.conversionFactor,
        );
      }

      String newSkuCode = '';
      if (state.globalSkuCode.isNotEmpty) {
        newSkuCode = index == 0
            ? state.globalSkuCode
            : '${state.globalSkuCode}-${index + 1}';
      }

      String newBarcode = '';
      if (combinations.length == 1 && state.globalBarcode.isNotEmpty) {
        newBarcode = state.globalBarcode;
      }

      final factor = unit?.conversionFactor ?? 1;
      return GeneratedSku(
        name: name,
        options: combo,
        price: unit?.sellingPrice ?? state.globalPrice * factor,
        costPrice: state.globalCostPrice * factor,
        stock: state.globalStock,
        skuCode: newSkuCode,
        barcode: newBarcode,
        unitId: unit?.unit.id,
        unitName: unit?.unit.name,
        conversionFactor: unit?.conversionFactor,
      );
    }).toList();

    emit(state.copyWith(generatedSkus: skus));
  }

  void _onRemoveGeneratedSku(
    RemoveGeneratedSkuEvent event,
    Emitter<AddProductState> emit,
  ) {
    final updatedSkus = state.generatedSkus
        .where((s) => s.name != event.skuName)
        .toList();

    final usedValues = updatedSkus
        .expand((s) => s.options)
        .map((v) => v.value)
        .toSet();

    final updatedGroups = state.variantGroups.map((group) {
      final filteredValues = group.values
          .where((v) => usedValues.contains(v.value))
          .toList();
      return group.copyWith(values: filteredValues);
    }).toList();

    emit(
      state.copyWith(generatedSkus: updatedSkus, variantGroups: updatedGroups),
    );
  }

  void _onUpdateGeneratedSku(
    UpdateGeneratedSkuEvent event,
    Emitter<AddProductState> emit,
  ) {
    final updatedSkus = state.generatedSkus.map((sku) {
      if (sku.name == event.skuName) {
        return sku.copyWith(
          skuCode: event.skuCode,
          barcode: event.barcode,
          price: event.price,
          costPrice: event.costPrice,
          stock: event.stock,
        );
      }
      return sku;
    }).toList();

    emit(state.copyWith(generatedSkus: updatedSkus));
  }

  void _onUpdateGlobalPrice(
    UpdateGlobalPriceEvent event,
    Emitter<AddProductState> emit,
  ) {
    final updatedSkus = state.generatedSkus.map((sku) {
      if (sku.conversionFactor != null && sku.conversionFactor != 1) {
        return sku;
      }
      return sku.copyWith(price: event.price);
    }).toList();
    emit(state.copyWith(globalPrice: event.price, generatedSkus: updatedSkus));
  }

  void _onUpdateGlobalCostPrice(
    UpdateGlobalCostPriceEvent event,
    Emitter<AddProductState> emit,
  ) {
    final updatedSkus = state.generatedSkus
        .map(
          (sku) => sku.copyWith(costPrice: event.costPrice * _unitFactor(sku)),
        )
        .toList();
    emit(
      state.copyWith(
        globalCostPrice: event.costPrice,
        generatedSkus: updatedSkus,
      ),
    );
  }

  void _onUpdateGlobalStock(
    UpdateGlobalStockEvent event,
    Emitter<AddProductState> emit,
  ) {
    final updatedSkus = state.generatedSkus
        .map((sku) => sku.copyWith(stock: event.stock))
        .toList();
    emit(state.copyWith(globalStock: event.stock, generatedSkus: updatedSkus));
  }

  void _onUpdateGlobalIsSellable(
    UpdateGlobalIsSellableEvent event,
    Emitter<AddProductState> emit,
  ) {
    emit(state.copyWith(globalIsSellable: event.isSellable));
  }

  void _onUpdateGlobalSkuCode(
    UpdateGlobalSkuCodeEvent event,
    Emitter<AddProductState> emit,
  ) {
    final updatedSkus = state.generatedSkus.asMap().entries.map((entry) {
      final index = entry.key;
      final sku = entry.value;
      final newCode = index == 0
          ? event.skuCode
          : '${event.skuCode}-${index + 1}';
      return sku.copyWith(skuCode: newCode);
    }).toList();

    emit(
      state.copyWith(globalSkuCode: event.skuCode, generatedSkus: updatedSkus),
    );
  }

  void _onUpdateGlobalBarcode(
    UpdateGlobalBarcodeEvent event,
    Emitter<AddProductState> emit,
  ) {
    final updatedSkus = state.generatedSkus.map((sku) {
      if (state.generatedSkus.length == 1) {
        return sku.copyWith(barcode: event.barcode);
      }
      return sku;
    }).toList();

    emit(
      state.copyWith(globalBarcode: event.barcode, generatedSkus: updatedSkus),
    );
  }

  void _onSelectBaseUnit(
    SelectBaseUnitEvent event,
    Emitter<AddProductState> emit,
  ) {
    final drafts = state.productUnitDrafts
        .where((draft) => draft.unit.id != event.unit.id)
        .toList();
    emit(
      state.copyWith(selectedBaseUnit: event.unit, productUnitDrafts: drafts),
    );
    _generateSkus(emit, state.variantGroups);
  }

  void _onClearBaseUnit(
    ClearBaseUnitEvent event,
    Emitter<AddProductState> emit,
  ) {
    emit(
      state.copyWith(clearSelectedBaseUnit: true, productUnitDrafts: const []),
    );
    _generateSkus(emit, state.variantGroups);
  }

  void _onAddProductUnitDraft(
    AddProductUnitDraftEvent event,
    Emitter<AddProductState> emit,
  ) {
    final unit = event.draft.unit;
    if (unit.id > 0 && state.selectedBaseUnit?.id == unit.id) {
      return;
    }
    if (unit.id > 0 &&
        state.productUnitDrafts.any((draft) => draft.unit.id == unit.id)) {
      return;
    }

    emit(
      state.copyWith(
        productUnitDrafts: [...state.productUnitDrafts, event.draft],
      ),
    );
    _generateSkus(emit, state.variantGroups);
  }

  void _onRemoveProductUnitDraft(
    RemoveProductUnitDraftEvent event,
    Emitter<AddProductState> emit,
  ) {
    final drafts = state.productUnitDrafts
        .where((draft) => draft.id != event.id)
        .toList();
    emit(state.copyWith(productUnitDrafts: drafts));
    _generateSkus(emit, state.variantGroups);
  }

  void _onUpdateProductUnitDraft(
    UpdateProductUnitDraftEvent event,
    Emitter<AddProductState> emit,
  ) {
    final unit = event.unit;
    if (unit != null && unit.id > 0 && state.selectedBaseUnit?.id == unit.id) {
      return;
    }
    if (unit != null &&
        unit.id > 0 &&
        state.productUnitDrafts.any(
          (draft) => draft.id != event.id && draft.unit.id == unit.id,
        )) {
      return;
    }

    final drafts = state.productUnitDrafts.map((draft) {
      if (draft.id != event.id) return draft;
      return draft.copyWith(
        unit: unit,
        conversionFactor: event.conversionFactor,
        sellingPrice: event.sellingPrice,
      );
    }).toList();
    emit(state.copyWith(productUnitDrafts: drafts));
    _generateSkus(emit, state.variantGroups);
  }

  double _unitFactor(GeneratedSku sku) => sku.conversionFactor ?? 1;
}
