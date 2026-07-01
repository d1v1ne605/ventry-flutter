import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventry_flutter/core/base/base_view_model.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/constants/app_errors.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/usecases/attribute/create_attribute_value_usecase.dart';
import 'package:ventry_flutter/domain/usecases/attribute/get_local_attributes_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/update_sku_usecase.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/bloc/edit_sku_event.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/bloc/edit_sku_state.dart';

class EditSkuBloc extends BaseViewModel<EditSkuEvent, EditSkuState> {
  final GetLocalAttributesUseCase _getLocalAttributesUseCase;
  final CreateAttributeValueUseCase _createAttributeValueUseCase;
  final UpdateSkuUseCase _updateSkuUseCase;

  EditSkuBloc(
    AppLogger logger,
    this._getLocalAttributesUseCase,
    this._createAttributeValueUseCase,
    this._updateSkuUseCase, {
    required SkuEntity initialSku,
  }) : super(EditSkuState.fromSku(initialSku), logger) {
    on<EditSkuNameChanged>(_onNameChanged);
    on<EditSkuCategoryChanged>(_onCategoryChanged);
    on<EditSkuBarcodeChanged>(_onBarcodeChanged);
    on<EditSkuCodeChanged>(_onSkuCodeChanged);
    on<EditSkuCostPriceChanged>(_onCostPriceChanged);
    on<EditSkuSellingPriceChanged>(_onSellingPriceChanged);
    on<EditSkuCurrencyChanged>(_onCurrencyChanged);
    on<EditSkuUnitOfMeasureChanged>(_onUnitChanged);
    on<EditSkuSellableChanged>(_onSellableChanged);
    on<EditSkuDescriptionChanged>(_onDescriptionChanged);
    on<EditSkuSubmitted>(_onSubmitted);
    on<EditSkuSourceSynced>(_onSourceSynced);
  }

  void _onNameChanged(EditSkuNameChanged event, Emitter<EditSkuState> emit) {
    emit(
      state.copyWith(
        form: state.form.copyWith(skuName: event.value),
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  void _onCategoryChanged(
    EditSkuCategoryChanged event,
    Emitter<EditSkuState> emit,
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
    EditSkuBarcodeChanged event,
    Emitter<EditSkuState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(barcode: event.value),
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  void _onSkuCodeChanged(EditSkuCodeChanged event, Emitter<EditSkuState> emit) {
    emit(
      state.copyWith(
        form: state.form.copyWith(skuCode: event.value),
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  void _onCostPriceChanged(
    EditSkuCostPriceChanged event,
    Emitter<EditSkuState> emit,
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
    EditSkuSellingPriceChanged event,
    Emitter<EditSkuState> emit,
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
    EditSkuCurrencyChanged event,
    Emitter<EditSkuState> emit,
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
    EditSkuUnitOfMeasureChanged event,
    Emitter<EditSkuState> emit,
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
    EditSkuSellableChanged event,
    Emitter<EditSkuState> emit,
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
    EditSkuDescriptionChanged event,
    Emitter<EditSkuState> emit,
  ) {
    emit(
      state.copyWith(
        form: state.form.copyWith(description: event.value),
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  void _onSourceSynced(EditSkuSourceSynced event, Emitter<EditSkuState> emit) {
    emit(
      state.copyWith(
        sourceSku: event.sku,
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );
  }

  Future<void> _onSubmitted(
    EditSkuSubmitted event,
    Emitter<EditSkuState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BaseStatus.loading,
        clearErrorMessage: true,
        clearUpdatedSku: true,
      ),
    );

    final attributeValueUidsResult = await _resolveAttributeValueUids(
      event.attributes,
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

    final result = await _updateSkuUseCase(
      state.toUpdateSkuParams(
        attributeValueUids: attributeValueUids,
        baseSku: event.baseSku,
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
    final submittedUid = attribute.uid.trim();

    for (final sourceAttribute in state.sourceSku.attributes) {
      final sameUid =
          submittedUid.isNotEmpty && sourceAttribute.uid == submittedUid;
      final sameName =
          _normalize(sourceAttribute.attributeName) == normalizedName;
      final sameValue = _normalize(sourceAttribute.value) == normalizedValue;

      if ((sameUid && sameName) || (sameName && sameValue)) {
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
