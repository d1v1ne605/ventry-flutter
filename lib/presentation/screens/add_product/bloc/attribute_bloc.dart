import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';
import 'package:ventry_flutter/domain/usecases/attribute/create_attribute_usecase.dart';
import 'package:ventry_flutter/domain/usecases/attribute/create_attribute_value_usecase.dart';
import 'package:ventry_flutter/domain/usecases/attribute/get_local_attributes_usecase.dart';
import 'package:ventry_flutter/domain/usecases/attribute/sync_attributes_usecase.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_event.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_state.dart';

@injectable
class AttributeBloc extends Bloc<AttributeEvent, AttributeState> {
  final GetLocalAttributesUseCase _getLocalAttributes;
  final SyncAttributesUseCase _syncAttributes;
  final CreateAttributeUseCase _createAttribute;
  final CreateAttributeValueUseCase _createAttributeValue;

  AttributeBloc(
    this._getLocalAttributes,
    this._syncAttributes,
    this._createAttribute,
    this._createAttributeValue,
  ) : super(const AttributeState()) {
    on<LoadAttributesEvent>(_onLoadAttributes);
    on<AddVariantGroupEvent>(_onAddVariantGroup);
    on<RemoveVariantGroupEvent>(_onRemoveVariantGroup);
    on<UpdateVariantGroupNameEvent>(_onUpdateVariantGroupName);
    on<AddVariantOptionValueEvent>(_onAddVariantOptionValue);
    on<RemoveVariantOptionValueEvent>(_onRemoveVariantOptionValue);
    on<RemoveGeneratedSkuEvent>(_onRemoveGeneratedSku);
    on<UpdateGeneratedSkuEvent>(_onUpdateGeneratedSku);
    on<UpdateGlobalPriceEvent>(_onUpdateGlobalPrice);
    on<UpdateGlobalCostPriceEvent>(_onUpdateGlobalCostPrice);
    on<UpdateGlobalStockEvent>(_onUpdateGlobalStock);
    on<UpdateGlobalIsSellableEvent>(_onUpdateGlobalIsSellable);
    on<UpdateGlobalSkuCodeEvent>(_onUpdateGlobalSkuCode);
    on<UpdateGlobalBarcodeEvent>(_onUpdateGlobalBarcode);
  }

  Future<void> _onLoadAttributes(
    LoadAttributesEvent event,
    Emitter<AttributeState> emit,
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

  void _onAddVariantGroup(
    AddVariantGroupEvent event,
    Emitter<AttributeState> emit,
  ) {
    final newGroup = VariantOptionGroup(id: const Uuid().v4(), name: '');
    final updatedGroups = List<VariantOptionGroup>.from(state.variantGroups)
      ..add(newGroup);
    emit(state.copyWith(variantGroups: updatedGroups));
    _generateSkus(emit, updatedGroups);
  }

  void _onRemoveVariantGroup(
    RemoveVariantGroupEvent event,
    Emitter<AttributeState> emit,
  ) {
    final updatedGroups = state.variantGroups
        .where((g) => g.id != event.groupId)
        .toList();
    emit(state.copyWith(variantGroups: updatedGroups));
    _generateSkus(emit, updatedGroups);
  }

  Future<void> _onUpdateVariantGroupName(
    UpdateVariantGroupNameEvent event,
    Emitter<AttributeState> emit,
  ) async {
    final groupIndex = state.variantGroups.indexWhere(
      (g) => g.id == event.groupId,
    );
    if (groupIndex == -1) return;

    final name = event.name.trim();
    if (name.isEmpty) {
      final updatedGroup = state.variantGroups[groupIndex].copyWith(
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

    final existing = state.localAttributes
        .where((a) => a.name.toLowerCase() == name.toLowerCase())
        .firstOrNull;

    VariantOptionGroup updatedGroup = state.variantGroups[groupIndex].copyWith(
      name: name,
    );

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
    Emitter<AttributeState> emit,
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
    Emitter<AttributeState> emit,
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
    Emitter<AttributeState> emit,
    List<VariantOptionGroup> groups,
  ) {
    final validGroups = groups.where((g) => g.values.isNotEmpty).toList();

    if (validGroups.isEmpty) {
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

    final skus = combinations.asMap().entries.map((entry) {
      final index = entry.key;
      final combo = entry.value;
      final name = combo.map((c) => c.value).join(' - ');
      final existingSku = state.generatedSkus
          .where((s) => s.name == name)
          .firstOrNull;

      if (existingSku != null) {
        return existingSku.copyWith(options: combo);
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

      return GeneratedSku(
        name: name,
        options: combo,
        price: state.globalPrice,
        costPrice: state.globalCostPrice,
        stock: state.globalStock,
        skuCode: newSkuCode,
        barcode: newBarcode,
      );
    }).toList();

    emit(state.copyWith(generatedSkus: skus));
  }

  void _onRemoveGeneratedSku(
    RemoveGeneratedSkuEvent event,
    Emitter<AttributeState> emit,
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
    Emitter<AttributeState> emit,
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
    Emitter<AttributeState> emit,
  ) {
    final updatedSkus = state.generatedSkus
        .map((sku) => sku.copyWith(price: event.price))
        .toList();
    emit(state.copyWith(globalPrice: event.price, generatedSkus: updatedSkus));
  }

  void _onUpdateGlobalCostPrice(
    UpdateGlobalCostPriceEvent event,
    Emitter<AttributeState> emit,
  ) {
    final updatedSkus = state.generatedSkus
        .map((sku) => sku.copyWith(costPrice: event.costPrice))
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
    Emitter<AttributeState> emit,
  ) {
    final updatedSkus = state.generatedSkus
        .map((sku) => sku.copyWith(stock: event.stock))
        .toList();
    emit(state.copyWith(globalStock: event.stock, generatedSkus: updatedSkus));
  }

  void _onUpdateGlobalIsSellable(
    UpdateGlobalIsSellableEvent event,
    Emitter<AttributeState> emit,
  ) {
    emit(state.copyWith(globalIsSellable: event.isSellable));
  }

  void _onUpdateGlobalSkuCode(
    UpdateGlobalSkuCodeEvent event,
    Emitter<AttributeState> emit,
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
    Emitter<AttributeState> emit,
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
}
