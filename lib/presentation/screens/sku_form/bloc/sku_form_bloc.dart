import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventry_flutter/core/base/base_view_model.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/constants/app_errors.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/core/utils/sku_code_generator.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';
import 'package:ventry_flutter/domain/entities/product/product_unit_configuration_params.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';
import 'package:ventry_flutter/domain/entities/product/update_sku_images_params.dart';
import 'package:ventry_flutter/domain/entities/product/update_sku_params.dart';
import 'package:ventry_flutter/domain/usecases/attribute/create_attribute_value_usecase.dart';
import 'package:ventry_flutter/domain/usecases/attribute/get_local_attributes_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/configure_product_units_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/create_product_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/create_unit_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/create_sku_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/get_latest_generated_sku_code_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/get_spu_by_uid_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/get_sku_by_uid_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/get_skus_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/get_units_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/update_sku_images_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/update_sku_usecase.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_event.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_state.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/models/sku_form_current_unit_edit.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/models/sku_form_unit_draft.dart';

class SkuFormBloc extends BaseViewModel<SkuFormEvent, SkuFormState> {
  final GetLocalAttributesUseCase _getLocalAttributesUseCase;
  final CreateAttributeValueUseCase _createAttributeValueUseCase;
  final CreateSkuUseCase _createSkuUseCase;
  final CreateProductUseCase _createProductUseCase;
  final GetLatestGeneratedSkuCodeUseCase _getLatestGeneratedSkuCodeUseCase;
  final UpdateSkuUseCase _updateSkuUseCase;
  final UpdateSkuImagesUseCase _updateSkuImagesUseCase;
  final GetUnitsUseCase _getUnitsUseCase;
  final CreateUnitUseCase _createUnitUseCase;
  final GetSkusUseCase _getSkusUseCase;
  final GetSpuByUidUseCase _getSpuByUidUseCase;
  final GetSkuByUidUseCase _getSkuByUidUseCase;
  final ConfigureProductUnitsUseCase _configureProductUnitsUseCase;

  SkuFormBloc(
    AppLogger logger,
    this._getLocalAttributesUseCase,
    this._createAttributeValueUseCase,
    this._createSkuUseCase,
    this._createProductUseCase,
    this._getLatestGeneratedSkuCodeUseCase,
    this._updateSkuUseCase, {
    required SkuFormMode mode,
    required SkuEntity initialSku,
    required UpdateSkuImagesUseCase updateSkuImagesUseCase,
    required GetUnitsUseCase getUnitsUseCase,
    required CreateUnitUseCase createUnitUseCase,
    required GetSkusUseCase getSkusUseCase,
    required GetSpuByUidUseCase getSpuByUidUseCase,
    required GetSkuByUidUseCase getSkuByUidUseCase,
    required ConfigureProductUnitsUseCase configureProductUnitsUseCase,
  }) : _updateSkuImagesUseCase = updateSkuImagesUseCase,
       _getUnitsUseCase = getUnitsUseCase,
       _createUnitUseCase = createUnitUseCase,
       _getSkusUseCase = getSkusUseCase,
       _getSpuByUidUseCase = getSpuByUidUseCase,
       _getSkuByUidUseCase = getSkuByUidUseCase,
       _configureProductUnitsUseCase = configureProductUnitsUseCase,
       super(
         mode.isCreate
             ? SkuFormState.create(initialSku)
             : SkuFormState.edit(initialSku),
         logger,
       ) {
    on<SkuFormNameChanged>(_onNameChanged);
    on<SkuFormCategoryChanged>(_onCategoryChanged);
    on<SkuFormBarcodeChanged>(_onBarcodeChanged);
    on<SkuFormCodeChanged>(_onSkuCodeChanged);
    on<SkuFormCostPriceChanged>(_onCostPriceChanged);
    on<SkuFormSellingPriceChanged>(_onSellingPriceChanged);
    on<SkuFormCurrencyChanged>(_onCurrencyChanged);
    on<SkuFormUnitOfMeasureChanged>(_onUnitChanged);
    on<SkuFormSellableChanged>(_onSellableChanged);
    on<SkuFormDescriptionChanged>(_onDescriptionChanged);
    on<SkuFormSubmitted>(_onSubmitted);
    on<SkuFormSourceSynced>(_onSourceSynced);
    on<SkuFormAttributesChanged>(_onAttributesChanged);
    on<SkuFormImagesChanged>(_onImagesChanged);
    on<SkuFormUnitDataRequested>(_onUnitDataRequested);
    on<SkuFormUnitDraftAdded>(_onUnitDraftAdded);
    on<SkuFormUnitDraftChanged>(_onUnitDraftChanged);
    on<SkuFormUnitDraftRemoved>(_onUnitDraftRemoved);
    on<SkuFormUnitPriceChanged>(_onUnitPriceChanged);
    on<SkuFormCurrentUnitChanged>(_onCurrentUnitChanged);
    on<SkuFormUnitConfigurationSubmitted>(_onUnitConfigurationSubmitted);
    add(const SkuFormUnitDataRequested());
  }

  void _onNameChanged(SkuFormNameChanged event, Emitter<SkuFormState> emit) {
    emit(
      state.copyWith(
        form: state.form.copyWith(skuName: event.value),
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  void _onCategoryChanged(
    SkuFormCategoryChanged event,
    Emitter<SkuFormState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(
          categoryName: event.category.name,
          categoryUid: event.category.uid,
        ),
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  void _onBarcodeChanged(
    SkuFormBarcodeChanged event,
    Emitter<SkuFormState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(barcode: event.value),
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  void _onSkuCodeChanged(SkuFormCodeChanged event, Emitter<SkuFormState> emit) {
    emit(
      state.copyWith(
        form: state.form.copyWith(skuCode: event.value),
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  void _onCostPriceChanged(
    SkuFormCostPriceChanged event,
    Emitter<SkuFormState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(costPrice: event.value),
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  void _onSellingPriceChanged(
    SkuFormSellingPriceChanged event,
    Emitter<SkuFormState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(sellingPrice: event.value),
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  void _onCurrencyChanged(
    SkuFormCurrencyChanged event,
    Emitter<SkuFormState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(currency: event.value),
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  void _onUnitChanged(
    SkuFormUnitOfMeasureChanged event,
    Emitter<SkuFormState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(unitOfMeasure: event.value),
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  void _onSellableChanged(
    SkuFormSellableChanged event,
    Emitter<SkuFormState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(isSellable: event.value),
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  void _onDescriptionChanged(
    SkuFormDescriptionChanged event,
    Emitter<SkuFormState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(description: event.value),
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  void _onSourceSynced(SkuFormSourceSynced event, Emitter<SkuFormState> emit) {
    emit(
      state.copyWith(
        sourceSku: event.sku,
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  void _onAttributesChanged(
    SkuFormAttributesChanged event,
    Emitter<SkuFormState> emit,
  ) {
    emit(
      state.copyWith(
        attributes: List<SkuAttributeEntity>.from(event.attributes),
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  void _onImagesChanged(
    SkuFormImagesChanged event,
    Emitter<SkuFormState> emit,
  ) {
    emit(
      state.copyWith(
        images: List.of(event.images),
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  Future<void> _onUnitDataRequested(
    SkuFormUnitDataRequested event,
    Emitter<SkuFormState> emit,
  ) async {
    if (state.isCreateMode) {
      return;
    }

    emit(
      state.copyWith(
        unitStatus: BaseStatus.loading,
        clearErrorMessage: true,
        clearUnitConfigurationSaved: true,
      ),
    );

    final unitsResult = await _getUnitsUseCase(NoParams());
    final units = unitsResult.fold<List<UnitEntity>?>((failure) {
      emit(
        state.copyWith(
          unitStatus: BaseStatus.failure,
          errorMessage: mapFailureToMessage(failure),
        ),
      );
      return null;
    }, (items) => items);

    if (units == null) {
      return;
    }

    final skusResult = await _getSkusUseCase(
      SkuQueryParams(
        spuUid: state.sourceSku.spuUid,
        status: 'ACTIVE',
        limit: 100,
      ),
    );

    skusResult.fold(
      (failure) {
        emit(
          state.copyWith(
            unitStatus: BaseStatus.failure,
            errorMessage: mapFailureToMessage(failure),
          ),
        );
      },
      (list) {
        final skus = list.items
            .expand((group) => group.skus)
            .toList(growable: false);
        final latestSourceSku = skus
            .where((sku) => sku.uid == state.sourceSku.uid)
            .firstOrNull;
        emit(
          state.copyWith(
            sourceSku: latestSourceSku ?? state.sourceSku,
            unitStatus: BaseStatus.success,
            units: units,
            siblingSkus: skus,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  void _onUnitDraftAdded(
    SkuFormUnitDraftAdded event,
    Emitter<SkuFormState> emit,
  ) {
    emit(
      state.copyWith(
        unitDrafts: [...state.unitDrafts, event.draft],
        clearErrorMessage: true,
        clearUnitConfigurationSaved: true,
      ),
    );
  }

  void _onUnitDraftChanged(
    SkuFormUnitDraftChanged event,
    Emitter<SkuFormState> emit,
  ) {
    emit(
      state.copyWith(
        unitDrafts: state.unitDrafts
            .map(
              (draft) => draft.id == event.id
                  ? draft.copyWith(
                      unit: event.unit,
                      skuCode: event.skuCode,
                      conversionFactor: event.conversionFactor,
                      sellingPrice: event.sellingPrice,
                    )
                  : draft,
            )
            .toList(growable: false),
        clearErrorMessage: true,
        clearUnitConfigurationSaved: true,
      ),
    );
  }

  void _onUnitDraftRemoved(
    SkuFormUnitDraftRemoved event,
    Emitter<SkuFormState> emit,
  ) {
    emit(
      state.copyWith(
        unitDrafts: state.unitDrafts
            .where((draft) => draft.id != event.id)
            .toList(growable: false),
        clearErrorMessage: true,
        clearUnitConfigurationSaved: true,
      ),
    );
  }

  void _onUnitPriceChanged(
    SkuFormUnitPriceChanged event,
    Emitter<SkuFormState> emit,
  ) {
    final originalSku = _findSameVariantSku(state, event.skuUid);
    final originalPrice = originalSku?.sellingPrice ?? 0;
    final edits = Map<String, double>.from(state.unitPriceEdits);
    if (event.sellingPrice == originalPrice) {
      edits.remove(event.skuUid);
    } else {
      edits[event.skuUid] = event.sellingPrice;
    }

    emit(
      state.copyWith(
        unitPriceEdits: edits,
        clearErrorMessage: true,
        clearUnitConfigurationSaved: true,
      ),
    );
  }

  void _onCurrentUnitChanged(
    SkuFormCurrentUnitChanged event,
    Emitter<SkuFormState> emit,
  ) {
    emit(
      state.copyWith(
        currentUnitEdit: event.edit,
        clearErrorMessage: true,
        clearUnitConfigurationSaved: true,
      ),
    );
  }

  Future<void> _onUnitConfigurationSubmitted(
    SkuFormUnitConfigurationSubmitted event,
    Emitter<SkuFormState> emit,
  ) async {
    final inputError = _validateUnitDrafts(state);
    if (inputError != null) {
      emit(
        state.copyWith(
          unitStatus: BaseStatus.failure,
          errorMessage: inputError,
          clearUnitConfigurationSaved: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        unitStatus: BaseStatus.loading,
        clearErrorMessage: true,
        clearUnitConfigurationSaved: true,
      ),
    );

    final currentPriceChanged = _currentPriceChanged(state);
    final currentInfoChanged = _currentUnitInfoChanged(state);
    final currentRemoved = state.currentUnitEdit.isRemoved;

    var workingState = state.copyWith(unitPriceEdits: const {});
    if (currentPriceChanged && !currentInfoChanged && !currentRemoved) {
      final latestSourceSku = await _resolveLatestSourceSku(state, emit);
      if (latestSourceSku == null) {
        return;
      }

      final updateResult = await _updateSkuUseCase(
        UpdateSkuParams(
          skuUid: latestSourceSku.uid,
          version: latestSourceSku.version,
          sellingPrice: _currentSellingPrice(state),
          attributeValueUids: _attributeValueUids(latestSourceSku),
        ),
      );
      SkuEntity? updatedPriceSku;
      final shouldStop = updateResult.fold(
        (failure) {
          emit(
            state.copyWith(
              unitStatus: BaseStatus.failure,
              errorMessage: mapFailureToMessage(failure),
            ),
          );
          return true;
        },
        (updatedSku) {
          updatedPriceSku = updatedSku;
          return false;
        },
      );

      if (shouldStop) {
        return;
      }
      if (updatedPriceSku != null) {
        workingState = workingState.copyWith(
          sourceSku: updatedPriceSku,
          siblingSkus: _replaceSku(state.siblingSkus, updatedPriceSku!),
        );
      }
      if (workingState.unitDrafts.isEmpty) {
        emit(
          workingState.copyWith(
            currentUnitEdit: const SkuFormCurrentUnitEdit(),
            unitStatus: BaseStatus.success,
            unitConfigurationSaved: true,
            unitSaveResult: SkuFormUnitSaveResult.updated,
            clearErrorMessage: true,
          ),
        );
        return;
      }
    }

    final resolvedCurrentUnit = await _resolveCurrentEditedUnit(
      workingState,
      emit,
    );
    if (resolvedCurrentUnit == null &&
        _currentEditedUnit(workingState) != null) {
      return;
    }
    if (resolvedCurrentUnit != null) {
      workingState = workingState.copyWith(
        currentUnitEdit: workingState.currentUnitEdit.copyWith(
          unit: resolvedCurrentUnit,
        ),
      );
    }

    final resolvedDrafts = [...workingState.unitDrafts];
    final resolvedUnits = [...workingState.units];
    for (var index = 0; index < resolvedDrafts.length; index++) {
      final draft = resolvedDrafts[index];
      if (draft.unit.id > 0) {
        continue;
      }

      final createResult = await _createUnitUseCase(draft.unit.name.trim());
      final shouldStop = createResult.fold(
        (failure) {
          emit(
            state.copyWith(
              unitStatus: BaseStatus.failure,
              errorMessage: mapFailureToMessage(failure),
            ),
          );
          return true;
        },
        (unit) {
          resolvedDrafts[index] = draft.copyWith(unit: unit);
          resolvedUnits.add(unit);
          return false;
        },
      );

      if (shouldStop) {
        return;
      }
    }

    final resolvedState = workingState.copyWith(
      units: resolvedUnits,
      unitDrafts: resolvedDrafts,
    );
    final resolvedError = _validateUnitDrafts(resolvedState);
    if (resolvedError != null) {
      emit(
        resolvedState.copyWith(
          unitStatus: BaseStatus.failure,
          errorMessage: resolvedError,
        ),
      );
      return;
    }

    if (_isSourceBaseSku(resolvedState) && currentInfoChanged) {
      await _createBaseUnitProductStructure(
        resolvedState,
        resolvedDrafts,
        emit,
      );
      return;
    }

    if (!currentRemoved && !currentInfoChanged && resolvedDrafts.isEmpty) {
      emit(
        resolvedState.copyWith(
          currentUnitEdit: const SkuFormCurrentUnitEdit(),
          unitStatus: BaseStatus.success,
          unitConfigurationSaved: true,
          clearErrorMessage: true,
        ),
      );
      return;
    }

    final pendingCreateSkus = [
      if (currentInfoChanged && !currentRemoved)
        _replacementCreateSku(workingState),
      ...resolvedDrafts.map((draft) => _draftCreateSku(resolvedState, draft)),
    ];
    final createSkus = await _resolveUnitCreateSkuCodes(
      pendingCreateSkus,
      resolvedState,
      emit,
    );
    if (createSkus == null) {
      return;
    }
    final latestSpuVersion = await _resolveLatestSpuVersion(
      resolvedState,
      emit,
    );
    if (latestSpuVersion == null) {
      return;
    }
    final replacementCreateSku = currentInfoChanged && !currentRemoved
        ? createSkus.firstOrNull
        : null;
    final unitSaveResult = _unitSaveResult(
      currentRemoved: currentRemoved,
      currentInfoChanged: currentInfoChanged,
      currentPriceChanged: currentPriceChanged,
      addedDraftCount: resolvedDrafts.length,
    );
    SkuEntity? latestSourceSku;
    if (currentRemoved || currentInfoChanged) {
      latestSourceSku = await _resolveLatestSourceSku(resolvedState, emit);
      if (latestSourceSku == null) {
        return;
      }
    }

    final result = await _configureProductUnitsUseCase(
      ProductUnitConfigurationParams(
        spuUid: resolvedState.sourceSku.spuUid,
        version: latestSpuVersion,
        createSkus: createSkus,
        discontinueSkus: [
          if (currentRemoved || currentInfoChanged)
            ProductUnitSkuDiscontinueParams(
              skuUid: latestSourceSku!.uid,
              version: latestSourceSku.version,
            ),
        ],
      ),
    );

    result.fold(
      (failure) {
        emit(
          resolvedState.copyWith(
            unitStatus: BaseStatus.failure,
            errorMessage: mapFailureToMessage(failure),
          ),
        );
      },
      (product) {
        final sourceSku = _postUnitSaveSourceSku(
          product.skus,
          resolvedState,
          replacementCreateSku: replacementCreateSku,
          currentRemoved: currentRemoved,
        );
        emit(
          resolvedState.copyWith(
            sourceSku: sourceSku,
            siblingSkus: product.skus,
            unitStatus: BaseStatus.success,
            unitDrafts: const [],
            currentUnitEdit: const SkuFormCurrentUnitEdit(),
            unitConfigurationSaved: true,
            unitSaveResult: unitSaveResult,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> _onSubmitted(
    SkuFormSubmitted event,
    Emitter<SkuFormState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BaseStatus.loading,
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );

    final attributeValueUidsResult = await _resolveAttributeValueUids(
      state.attributes,
    );

    final attributeValueUids = attributeValueUidsResult.fold((failure) {
      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorMessage: mapFailureToMessage(failure),
        ),
      );
      return null;
    }, (uids) => uids);

    if (attributeValueUids == null) {
      return;
    }

    if (state.isCreateMode) {
      await _createSku(attributeValueUids, emit);
      return;
    }

    await _updateSku(attributeValueUids, emit);
  }

  Future<void> _createSku(
    List<String> attributeValueUids,
    Emitter<SkuFormState> emit,
  ) async {
    final generatedSkuCode = await _resolveCreateSkuCode(emit);
    if (generatedSkuCode == null && state.form.skuCode.trim().isEmpty) {
      return;
    }

    final result = await _createSkuUseCase(
      state.toCreateSkuParams(
        attributeValueUids: attributeValueUids,
        skuCode: generatedSkuCode,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BaseStatus.failure,
            errorMessage: mapFailureToMessage(failure),
          ),
        );
      },
      (updatedSku) {
        emit(
          state.copyWith(status: BaseStatus.success, updatedSku: updatedSku),
        );
      },
    );
  }

  Future<String?> _resolveCreateSkuCode(Emitter<SkuFormState> emit) async {
    final currentSkuCode = state.form.skuCode.trim();
    if (currentSkuCode.isNotEmpty) {
      return currentSkuCode;
    }

    final result = await _getLatestGeneratedSkuCodeUseCase(NoParams());
    return result.fold((failure) {
      emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorMessage: mapFailureToMessage(failure),
        ),
      );
      return null;
    }, SkuCodeGenerator.nextFromLatest);
  }

  Future<void> _updateSku(
    List<String> attributeValueUids,
    Emitter<SkuFormState> emit,
  ) async {
    final shouldUpdateSku = state.hasFormChanges || state.hasAttributeChanges;
    var latestSku = state.sourceSku;

    if (shouldUpdateSku) {
      final result = await _updateSkuUseCase(
        state.toUpdateSkuParams(attributeValueUids: attributeValueUids),
      );

      final shouldStop = result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: BaseStatus.failure,
              errorMessage: mapFailureToMessage(failure),
            ),
          );
          return true;
        },
        (updatedSku) {
          latestSku = updatedSku;
          return false;
        },
      );

      if (shouldStop) {
        return;
      }
    }

    if (!state.hasImageChanges) {
      emit(state.copyWith(status: BaseStatus.success, updatedSku: latestSku));
      return;
    }

    final imageResult = await _updateSkuImagesUseCase(
      UpdateSkuImagesParams(
        skuUid: latestSku.uid,
        version: latestSku.version,
        imageKeys: state.imageKeys,
      ),
    );

    imageResult.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BaseStatus.failure,
            errorMessage: mapFailureToMessage(failure),
          ),
        );
      },
      (updatedSku) {
        emit(
          state.copyWith(status: BaseStatus.success, updatedSku: updatedSku),
        );
      },
    );
  }

  Future<Either<Failure, List<String>>> _resolveAttributeValueUids(
    List<SkuAttributeEntity> attributes,
  ) async {
    final sanitizedAttributes = attributes
        .where(
          (attribute) =>
              attribute.attributeName.trim().isNotEmpty &&
              attribute.value.trim().isNotEmpty,
        )
        .toList(growable: false);

    if (sanitizedAttributes.isEmpty) {
      return const Right(<String>[]);
    }

    final localAttributesResult = await _getLocalAttributesUseCase(NoParams());
    final localAttributes = localAttributesResult.fold<List<AttributeEntity>?>(
      (_) => null,
      (items) => items,
    );

    final resolvedUids = <String>[];

    for (final attribute in sanitizedAttributes) {
      final existingUid = _findSourceAttributeValueUid(attribute);
      if (existingUid != null) {
        _addUniqueUid(resolvedUids, existingUid);
        continue;
      }

      final attributeName = attribute.attributeName.trim();
      final value = attribute.value.trim();
      final matchingAttribute = _findAttributeByName(
        localAttributes,
        attributeName,
      );

      if (matchingAttribute == null) {
        return Left(
          ServerFailure(AppErrors.skuAttributeNotFound(attributeName)),
        );
      }

      final existingValueUid = _findAttributeValueUid(matchingAttribute, value);
      if (existingValueUid != null) {
        _addUniqueUid(resolvedUids, existingValueUid);
        continue;
      }

      final createResult = await _createAttributeValueUseCase(
        CreateAttributeValueParams(
          attributeUid: matchingAttribute.uid,
          value: value,
        ),
      );

      Failure? createFailure;
      String? createdValueUid;
      createResult.fold(
        (failure) => createFailure = failure,
        (createdValue) => createdValueUid = createdValue.uid,
      );

      if (createFailure != null) {
        return Left(createFailure!);
      }

      if (createdValueUid == null) {
        return const Left(ServerFailure(AppErrors.unexpected));
      }

      _addUniqueUid(resolvedUids, createdValueUid!);
    }

    return Right(resolvedUids);
  }

  String? _findSourceAttributeValueUid(SkuAttributeEntity attribute) {
    final normalizedName = _normalize(attribute.attributeName);
    final normalizedValue = _normalize(attribute.value);

    for (final sourceAttribute in state.sourceSku.attributes) {
      final sameName =
          _normalize(sourceAttribute.attributeName) == normalizedName;
      final sameValue = _normalize(sourceAttribute.value) == normalizedValue;

      if (sameName && sameValue) {
        return sourceAttribute.uid;
      }
    }

    return null;
  }

  AttributeEntity? _findAttributeByName(
    List<AttributeEntity>? attributes,
    String attributeName,
  ) {
    if (attributes == null) {
      return null;
    }

    final normalizedName = _normalize(attributeName);
    for (final attribute in attributes) {
      if (_normalize(attribute.name) == normalizedName) {
        return attribute;
      }
    }
    return null;
  }

  String? _findAttributeValueUid(AttributeEntity attribute, String value) {
    final normalizedValue = _normalize(value);

    for (final attributeValue in attribute.values) {
      if (_normalize(attributeValue.value) == normalizedValue) {
        return attributeValue.uid;
      }
    }

    return null;
  }

  void _addUniqueUid(List<String> resolvedUids, String uid) {
    if (!resolvedUids.contains(uid)) {
      resolvedUids.add(uid);
    }
  }

  String? _validateUnitDrafts(SkuFormState formState) {
    if (_baseUnitSku(formState) == null) {
      return AppStrings.productUnitBaseRequired;
    }

    final usedIds = <int>{};
    final usedNames = <String>{};
    final usedSkuCodes = <String>{};
    final sourceSku = formState.sourceSku;
    final currentUnit = _currentUnit(formState);
    final currentFactor = _currentConversionFactor(formState);
    final currentRemoved = formState.currentUnitEdit.isRemoved;
    final currentInfoChanged = _currentUnitInfoChanged(formState);
    final isBaseSku = sourceSku.uid == _baseUnitSku(formState)?.uid;
    final isBaseStructureChange =
        isBaseSku && currentInfoChanged && !currentRemoved;

    if (isBaseSku && currentRemoved) {
      return AppStrings.productUnitBaseEditUnsupported;
    }

    if (!currentRemoved) {
      if (currentUnit == null ||
          currentUnit.name.trim().isEmpty ||
          currentFactor <= 0) {
        return AppStrings.productUnitInvalidConversion;
      }
      if (_isBaseUnit(formState, currentUnit) && currentFactor != 1) {
        return AppStrings.productUnitInvalidConversion;
      }
    }

    void addExistingUnit(UnitEntity? unit) {
      if (unit == null) return;
      if (unit.id > 0) usedIds.add(unit.id);
      final name = _normalize(unit.name);
      if (name.isNotEmpty) usedNames.add(name);
    }

    for (final sku in _sameAttributeSkus(formState)) {
      if (!isBaseStructureChange) {
        addExistingUnit(sku.unit);
      }
      final skuCode = _normalize(sku.skuCode ?? '');
      if (skuCode.isNotEmpty) usedSkuCodes.add(skuCode);
    }
    final sourceSkuCode = _normalize(sourceSku.skuCode ?? '');
    if (sourceSkuCode.isNotEmpty) usedSkuCodes.add(sourceSkuCode);

    if (!currentRemoved) {
      final duplicateCurrentId =
          currentUnit!.id > 0 && !usedIds.add(currentUnit.id);
      final duplicateCurrentName = !usedNames.add(_normalize(currentUnit.name));
      if (duplicateCurrentId || duplicateCurrentName) {
        return AppStrings.productUnitDuplicate;
      }
    }

    for (final draft in formState.unitDrafts) {
      final name = draft.unit.name.trim();
      final normalizedName = _normalize(name);
      if (name.isEmpty || draft.conversionFactor <= 0) {
        return AppStrings.productUnitInvalidConversion;
      }
      if (draft.skuCode.trim().length > 100) {
        return AppStrings.productUnitSkuCodeTooLong;
      }
      final draftSkuCode = _normalize(draft.skuCode);
      if (draftSkuCode.isNotEmpty && !usedSkuCodes.add(draftSkuCode)) {
        return AppStrings.productUnitSkuCodeDuplicate;
      }
      if (_isBaseUnit(formState, draft.unit) && draft.conversionFactor != 1) {
        return AppStrings.productUnitInvalidConversion;
      }

      final duplicateId = draft.unit.id > 0 && !usedIds.add(draft.unit.id);
      final duplicateName =
          normalizedName.isNotEmpty && !usedNames.add(normalizedName);
      if (duplicateId || duplicateName) {
        return AppStrings.productUnitDuplicate;
      }
    }

    return null;
  }

  Future<int?> _resolveLatestSpuVersion(
    SkuFormState formState,
    Emitter<SkuFormState> emit,
  ) async {
    final result = await _getSpuByUidUseCase(formState.sourceSku.spuUid);
    return result.fold((failure) {
      emit(
        formState.copyWith(
          unitStatus: BaseStatus.failure,
          errorMessage: mapFailureToMessage(failure),
        ),
      );
      return null;
    }, (spu) => spu.version);
  }

  Future<SkuEntity?> _resolveLatestSourceSku(
    SkuFormState formState,
    Emitter<SkuFormState> emit,
  ) async {
    final result = await _getSkuByUidUseCase(formState.sourceSku.uid);
    return result.fold((failure) {
      emit(
        formState.copyWith(
          unitStatus: BaseStatus.failure,
          errorMessage: mapFailureToMessage(failure),
        ),
      );
      return null;
    }, (sku) => sku);
  }

  Future<void> _createBaseUnitProductStructure(
    SkuFormState formState,
    List<SkuFormUnitDraft> drafts,
    Emitter<SkuFormState> emit,
  ) async {
    final baseUnit = _currentUnit(formState);
    if (baseUnit == null || baseUnit.id <= 0) {
      emit(
        formState.copyWith(
          unitStatus: BaseStatus.failure,
          errorMessage: AppStrings.productUnitInvalidConversion,
        ),
      );
      return;
    }

    final pendingSkus = [
      _baseUnitStructureBaseSku(formState, baseUnit),
      ...drafts.map((draft) => _draftCreateSku(formState, draft)),
    ];
    final skus = await _resolveUnitCreateSkuCodes(pendingSkus, formState, emit);
    if (skus == null) return;

    final result = await _createProductUseCase(
      CreateProductParams(
        name: _baseUnitStructureName(formState, baseUnit),
        categoryUid: formState.form.categoryUid,
        description: formState.form.description.trim().isEmpty
            ? null
            : formState.form.description.trim(),
        currency: formState.form.currency.trim().isEmpty
            ? null
            : formState.form.currency.trim(),
        unitOfMeasure: baseUnit.name,
        baseUnitId: baseUnit.id,
        skus: skus,
      ),
    );

    result.fold(
      (failure) {
        emit(
          formState.copyWith(
            unitStatus: BaseStatus.failure,
            errorMessage: mapFailureToMessage(failure),
          ),
        );
      },
      (_) {
        emit(
          formState.copyWith(
            unitStatus: BaseStatus.success,
            unitDrafts: const [],
            currentUnitEdit: const SkuFormCurrentUnitEdit(),
            unitConfigurationSaved: true,
            unitSaveResult: SkuFormUnitSaveResult.updated,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  CreateSkuParams _baseUnitStructureBaseSku(
    SkuFormState formState,
    UnitEntity baseUnit,
  ) {
    return CreateSkuParams(
      sellingPrice: _currentSellingPrice(formState),
      costPrice: formState.sourceSku.costPrice,
      stockQuantity: 0,
      minStockQuantity: formState.sourceSku.minStockQuantity,
      unitId: baseUnit.id,
      conversionFactor: 1,
      imageKeys: formState.sourceSku.imageKeys,
      isSellable: formState.sourceSku.isSellable,
      attributeValueUids: formState.sourceAttributeValueUids,
    );
  }

  String _baseUnitStructureName(SkuFormState formState, UnitEntity baseUnit) {
    final productName = formState.form.skuName.trim().isEmpty
        ? formState.sourceSku.spuName
        : formState.form.skuName.trim();
    final unitName = baseUnit.name.trim();
    if (unitName.isEmpty || productName.contains(unitName)) return productName;
    return '$productName - $unitName';
  }

  SkuFormUnitSaveResult _unitSaveResult({
    required bool currentRemoved,
    required bool currentInfoChanged,
    required bool currentPriceChanged,
    required int addedDraftCount,
  }) {
    if (currentRemoved) return SkuFormUnitSaveResult.removed;
    if (currentInfoChanged || currentPriceChanged) {
      return SkuFormUnitSaveResult.updated;
    }
    if (addedDraftCount > 0) return SkuFormUnitSaveResult.added;
    return SkuFormUnitSaveResult.updated;
  }

  SkuEntity _postUnitSaveSourceSku(
    List<SkuEntity> skus,
    SkuFormState formState, {
    required CreateSkuParams? replacementCreateSku,
    required bool currentRemoved,
  }) {
    if (replacementCreateSku != null) {
      final replacement = skus
          .where((sku) => _matchesCreatedSku(sku, replacementCreateSku))
          .firstOrNull;
      if (replacement != null) return replacement;
    }

    final activeSameVariantSkus = skus
        .where((sku) => sku.status == 'ACTIVE')
        .where((sku) => _hasSameAttributeValues(sku, formState))
        .toList();
    final activeSourceSku = activeSameVariantSkus
        .where((sku) => sku.uid == formState.sourceSku.uid)
        .firstOrNull;
    if (activeSourceSku != null) return activeSourceSku;
    if (activeSameVariantSkus.isNotEmpty) return activeSameVariantSkus.first;
    if (!currentRemoved && formState.sourceSku.status == 'ACTIVE') {
      return formState.sourceSku;
    }
    return formState.sourceSku;
  }

  bool _matchesCreatedSku(SkuEntity sku, CreateSkuParams params) {
    if (sku.status != 'ACTIVE') return false;
    final skuCode = params.skuCode?.trim();
    if (skuCode != null && skuCode.isNotEmpty && sku.skuCode != skuCode) {
      return false;
    }
    if (params.unitId != null && sku.unit?.id != params.unitId) return false;
    if (params.conversionFactor != null &&
        sku.conversionFactor != params.conversionFactor) {
      return false;
    }
    return _sameAttributeValues(
      _attributeValueUids(sku),
      params.attributeValueUids,
    );
  }

  Future<List<CreateSkuParams>?> _resolveUnitCreateSkuCodes(
    List<CreateSkuParams> createSkus,
    SkuFormState formState,
    Emitter<SkuFormState> emit,
  ) async {
    if (!createSkus.any((sku) => (sku.skuCode ?? '').trim().isEmpty)) {
      return createSkus;
    }

    final result = await _getLatestGeneratedSkuCodeUseCase(NoParams());
    String? latestCode;
    final shouldStop = result.fold(
      (failure) {
        emit(
          formState.copyWith(
            unitStatus: BaseStatus.failure,
            errorMessage: mapFailureToMessage(failure),
          ),
        );
        return true;
      },
      (code) {
        latestCode = code;
        return false;
      },
    );

    if (shouldStop) {
      return null;
    }

    final usedCodes = createSkus
        .map((sku) => _normalize(sku.skuCode ?? ''))
        .where((code) => code.isNotEmpty)
        .toSet();

    return createSkus
        .map((sku) {
          final manualCode = sku.skuCode?.trim();
          if (manualCode != null && manualCode.isNotEmpty) {
            return _copyCreateSku(sku, skuCode: manualCode);
          }

          var generatedCode = SkuCodeGenerator.nextFromLatest(latestCode);
          while (usedCodes.contains(_normalize(generatedCode))) {
            latestCode = generatedCode;
            generatedCode = SkuCodeGenerator.nextFromLatest(latestCode);
          }
          latestCode = generatedCode;
          usedCodes.add(_normalize(generatedCode));
          return _copyCreateSku(sku, skuCode: generatedCode);
        })
        .toList(growable: false);
  }

  Future<UnitEntity?> _resolveCurrentEditedUnit(
    SkuFormState formState,
    Emitter<SkuFormState> emit,
  ) async {
    if (!_currentUnitInfoChanged(formState) ||
        formState.currentUnitEdit.isRemoved) {
      return null;
    }

    final unit = _currentUnit(formState);
    if (unit == null || unit.id > 0) {
      return unit;
    }

    final result = await _createUnitUseCase(unit.name.trim());
    return result.fold((failure) {
      emit(
        formState.copyWith(
          unitStatus: BaseStatus.failure,
          errorMessage: mapFailureToMessage(failure),
        ),
      );
      return null;
    }, (createdUnit) => createdUnit);
  }

  CreateSkuParams _replacementCreateSku(SkuFormState formState) {
    final factor = _currentConversionFactor(formState);
    return CreateSkuParams(
      sellingPrice: _currentSellingPrice(formState),
      costPrice: _scaledCostPrice(formState, factor),
      stockQuantity: 0,
      minStockQuantity: formState.sourceSku.minStockQuantity,
      unitId: _currentUnit(formState)?.id,
      conversionFactor: factor,
      replacementForSkuUid: formState.sourceSku.uid,
      imageKeys: formState.sourceSku.imageKeys,
      isSellable: formState.sourceSku.isSellable,
      attributeValueUids: formState.sourceAttributeValueUids,
    );
  }

  CreateSkuParams _draftCreateSku(
    SkuFormState formState,
    SkuFormUnitDraft draft,
  ) {
    return CreateSkuParams(
      skuCode: draft.skuCode.trim().isEmpty ? null : draft.skuCode.trim(),
      sellingPrice: draft.sellingPrice,
      costPrice: _scaledCostPrice(formState, draft.conversionFactor),
      stockQuantity: 0,
      minStockQuantity: formState.sourceSku.minStockQuantity,
      unitId: draft.unit.id,
      conversionFactor: draft.conversionFactor,
      imageKeys: formState.sourceSku.imageKeys,
      isSellable: formState.sourceSku.isSellable,
      attributeValueUids: formState.sourceAttributeValueUids,
    );
  }

  CreateSkuParams _copyCreateSku(
    CreateSkuParams sku, {
    required String skuCode,
  }) {
    return CreateSkuParams(
      skuCode: skuCode,
      barCode: sku.barCode,
      sellingPrice: sku.sellingPrice,
      costPrice: sku.costPrice,
      stockQuantity: sku.stockQuantity,
      minStockQuantity: sku.minStockQuantity,
      unitId: sku.unitId,
      conversionFactor: sku.conversionFactor,
      replacementForSkuUid: sku.replacementForSkuUid,
      imageKeys: sku.imageKeys,
      isSellable: sku.isSellable,
      attributeValueUids: sku.attributeValueUids,
    );
  }

  Iterable<SkuEntity> _sameAttributeSkus(SkuFormState formState) {
    return formState.siblingSkus.where((sku) {
      if (sku.uid == formState.sourceSku.uid || sku.status != 'ACTIVE') {
        return false;
      }
      return _hasSameAttributeValues(sku, formState);
    });
  }

  bool _hasSameAttributeValues(SkuEntity sku, SkuFormState formState) {
    return _sameAttributeValues(
      _attributeValueUids(sku),
      formState.sourceAttributeValueUids,
    );
  }

  bool _sameAttributeValues(List<String> left, List<String> right) {
    final leftUids = left.toSet();
    final rightUids = right.toSet();
    return leftUids.length == rightUids.length &&
        leftUids.every(rightUids.contains);
  }

  SkuEntity? _findSameVariantSku(SkuFormState formState, String skuUid) {
    if (formState.sourceSku.uid == skuUid) {
      return formState.sourceSku;
    }

    return _sameAttributeSkus(
      formState,
    ).where((sku) => sku.uid == skuUid).firstOrNull;
  }

  UnitEntity? _currentEditedUnit(SkuFormState formState) {
    return formState.currentUnitEdit.unit;
  }

  UnitEntity? _currentUnit(SkuFormState formState) {
    return formState.currentUnitEdit.unit ?? formState.sourceSku.unit;
  }

  double _currentConversionFactor(SkuFormState formState) {
    return formState.currentUnitEdit.conversionFactor ??
        formState.sourceSku.conversionFactor ??
        1;
  }

  double _currentSellingPrice(SkuFormState formState) {
    return formState.currentUnitEdit.sellingPrice ??
        formState.sourceSku.sellingPrice ??
        0;
  }

  bool _currentPriceChanged(SkuFormState formState) {
    return _currentSellingPrice(formState) !=
        (formState.sourceSku.sellingPrice ?? 0);
  }

  bool _currentUnitInfoChanged(SkuFormState formState) {
    final editedUnit = _currentUnit(formState);
    final sourceUnit = formState.sourceSku.unit;
    final unitChanged =
        editedUnit?.id != sourceUnit?.id ||
        _normalize(editedUnit?.name ?? '') !=
            _normalize(sourceUnit?.name ?? '');
    return unitChanged ||
        _currentConversionFactor(formState) !=
            (formState.sourceSku.conversionFactor ?? 1);
  }

  bool _isBaseUnit(SkuFormState formState, UnitEntity unit) {
    return unit.id > 0 && unit.id == formState.sourceSku.spuBaseUnit?.id;
  }

  bool _isSourceBaseSku(SkuFormState formState) {
    return formState.sourceSku.uid == _baseUnitSku(formState)?.uid;
  }

  List<SkuEntity> _replaceSku(List<SkuEntity> skus, SkuEntity replacement) {
    var didReplace = false;
    final nextSkus = skus
        .map((sku) {
          if (sku.uid != replacement.uid) return sku;
          didReplace = true;
          return replacement;
        })
        .toList(growable: true);
    if (!didReplace) {
      nextSkus.add(replacement);
    }
    return nextSkus;
  }

  List<String> _attributeValueUids(SkuEntity sku) {
    return sku.attributes
        .map((attribute) => attribute.uid)
        .where((uid) => uid.trim().isNotEmpty)
        .toList(growable: false);
  }

  SkuEntity? _baseUnitSku(SkuFormState formState) {
    final skus = [formState.sourceSku, ..._sameAttributeSkus(formState)];
    final baseUnitId =
        formState.sourceSku.spuBaseUnit?.id ??
        skus.map((sku) => sku.spuBaseUnit?.id).whereType<int>().firstOrNull;
    if (baseUnitId != null) {
      final baseSku = skus
          .where((sku) => sku.unit?.id == baseUnitId)
          .firstOrNull;
      if (baseSku != null) return baseSku;
    }
    return skus.where((sku) => (sku.conversionFactor ?? 1) == 1).firstOrNull;
  }

  double? _scaledCostPrice(SkuFormState formState, double conversionFactor) {
    final costPrice = _baseUnitSku(formState)?.costPrice;
    return costPrice == null ? null : costPrice * conversionFactor;
  }

  String _normalize(String value) => value.trim().toLowerCase();
}
