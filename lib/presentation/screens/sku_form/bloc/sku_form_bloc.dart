import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventry_flutter/core/base/base_view_model.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/constants/app_errors.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/core/utils/sku_code_generator.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/update_sku_images_params.dart';
import 'package:ventry_flutter/domain/usecases/attribute/create_attribute_value_usecase.dart';
import 'package:ventry_flutter/domain/usecases/attribute/get_local_attributes_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/create_sku_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/get_latest_generated_sku_code_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/update_sku_images_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/update_sku_usecase.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_event.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_state.dart';

class SkuFormBloc extends BaseViewModel<SkuFormEvent, SkuFormState> {
  final GetLocalAttributesUseCase _getLocalAttributesUseCase;
  final CreateAttributeValueUseCase _createAttributeValueUseCase;
  final CreateSkuUseCase _createSkuUseCase;
  final GetLatestGeneratedSkuCodeUseCase _getLatestGeneratedSkuCodeUseCase;
  final UpdateSkuUseCase _updateSkuUseCase;
  final UpdateSkuImagesUseCase _updateSkuImagesUseCase;

  SkuFormBloc(
    AppLogger logger,
    this._getLocalAttributesUseCase,
    this._createAttributeValueUseCase,
    this._createSkuUseCase,
    this._getLatestGeneratedSkuCodeUseCase,
    this._updateSkuUseCase, {
    required SkuFormMode mode,
    required SkuEntity initialSku,
    required UpdateSkuImagesUseCase updateSkuImagesUseCase,
  }) : _updateSkuImagesUseCase = updateSkuImagesUseCase,
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

  String _normalize(String value) => value.trim().toLowerCase();
}
