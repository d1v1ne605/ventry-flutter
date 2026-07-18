import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/base/base_view_model.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/domain/entities/product/spu_entity.dart';
import 'package:ventry_flutter/domain/entities/product/update_spu_params.dart';
import 'package:ventry_flutter/domain/usecases/category/get_categories_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/get_spu_by_uid_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/update_spu_usecase.dart';
import 'package:ventry_flutter/presentation/screens/edit_spu/bloc/edit_spu_event.dart';
import 'package:ventry_flutter/presentation/screens/edit_spu/bloc/edit_spu_state.dart';

@injectable
class EditSpuBloc extends BaseViewModel<EditSpuEvent, EditSpuState> {
  final GetSpuByUidUseCase _getSpuByUidUseCase;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final UpdateSpuUseCase _updateSpuUseCase;

  EditSpuBloc(
    AppLogger logger,
    this._getSpuByUidUseCase,
    this._getCategoriesUseCase,
    this._updateSpuUseCase,
  ) : super(const EditSpuState(), logger) {
    on<LoadEditSpu>(_onLoadEditSpu);
    on<EditSpuCategoryChanged>(_onCategoryChanged);
    on<EditSpuFormChanged>(_onFormChanged);
    on<SubmitEditSpu>(_onSubmitEditSpu);
  }

  Future<void> _onLoadEditSpu(
    LoadEditSpu event,
    Emitter<EditSpuState> emit,
  ) async {
    emit(
      state.copyWith(
        loadStatus: BaseStatus.loading,
        clearErrorMessage: true,
        clearUpdatedSpu: true,
      ),
    );

    await _loadCategories(emit);
    await _loadSpu(event.spuUid, emit);
  }

  Future<void> _loadCategories(Emitter<EditSpuState> emit) async {
    final result = await _getCategoriesUseCase(null);
    result.fold(
      (failure) => emit(
        state.copyWith(
          errorMessage:
              '${AppStrings.editSpuCategoryLoadFailed}: ${mapFailureToMessage(failure)}',
        ),
      ),
      (categories) => emit(state.copyWith(categories: categories)),
    );
  }

  Future<void> _loadSpu(String spuUid, Emitter<EditSpuState> emit) async {
    final result = await _getSpuByUidUseCase(spuUid);

    result.fold(
      (failure) => emit(
        state.copyWith(
          loadStatus: BaseStatus.failure,
          errorMessage: mapFailureToMessage(failure),
        ),
      ),
      (spu) {
        emit(
          state.copyWith(
            loadStatus: BaseStatus.success,
            spu: spu,
            selectedCategoryUid: spu.categoryUid,
            clearSelectedCategoryUid: spu.categoryUid == null,
            selectedCategoryName: spu.categoryName,
            clearSelectedCategoryName: spu.categoryName == null,
            name: spu.name,
            currency: spu.currency ?? '',
            unitOfMeasure: spu.unitOfMeasure ?? '',
            description: spu.description ?? '',
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  void _onCategoryChanged(
    EditSpuCategoryChanged event,
    Emitter<EditSpuState> emit,
  ) {
    String? selectedCategoryName;
    for (final category in state.categories) {
      if (category.uid == event.categoryUid) {
        selectedCategoryName = category.name;
        break;
      }
    }

    emit(
      state.copyWith(
        selectedCategoryUid: event.categoryUid,
        clearSelectedCategoryUid: event.categoryUid == null,
        selectedCategoryName: selectedCategoryName,
        clearSelectedCategoryName: event.categoryUid == null,
        submitStatus: BaseStatus.initial,
      ),
    );
  }

  void _onFormChanged(EditSpuFormChanged event, Emitter<EditSpuState> emit) {
    emit(
      state.copyWith(
        name: event.name,
        currency: event.currency,
        unitOfMeasure: event.unitOfMeasure,
        description: event.description,
        submitStatus: BaseStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitEditSpu(
    SubmitEditSpu event,
    Emitter<EditSpuState> emit,
  ) async {
    final spu = state.spu;
    final name = event.name.trim();
    if (spu == null) {
      emit(
        state.copyWith(
          submitStatus: BaseStatus.failure,
          errorMessage: AppStrings.editSpuLoadFailed,
        ),
      );
      return;
    }

    if (name.isEmpty) {
      emit(
        state.copyWith(
          submitStatus: BaseStatus.failure,
          errorMessage: AppStrings.editSpuNameRequired,
        ),
      );
      return;
    }

    if (!_hasChanges(
      spu: spu,
      name: name,
      categoryUid: state.selectedCategoryUid,
      description: event.description,
      currency: event.currency,
      unitOfMeasure: event.unitOfMeasure,
    )) {
      return;
    }

    emit(
      state.copyWith(
        submitStatus: BaseStatus.loading,
        clearErrorMessage: true,
        clearUpdatedSpu: true,
      ),
    );

    final result = await _updateSpuUseCase(
      UpdateSpuParams(
        spuUid: spu.uid,
        version: spu.version,
        name: name,
        categoryUid: state.selectedCategoryUid,
        description: _nullableTrim(event.description),
        currency: _nullableTrim(event.currency),
        unitOfMeasure: _nullableTrim(event.unitOfMeasure),
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          submitStatus: BaseStatus.failure,
          errorMessage: mapFailureToMessage(failure),
        ),
      ),
      (spu) => emit(
        state.copyWith(
          submitStatus: BaseStatus.success,
          updatedSpu: spu,
          clearErrorMessage: true,
        ),
      ),
    );
  }

  String? _nullableTrim(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  bool _hasChanges({
    required SpuEntity spu,
    required String name,
    required String? categoryUid,
    required String description,
    required String currency,
    required String unitOfMeasure,
  }) {
    return name.trim() != spu.name.trim() ||
        categoryUid != spu.categoryUid ||
        _nullableTrim(description) != _nullableTrim(spu.description ?? '') ||
        _nullableTrim(currency) != _nullableTrim(spu.currency ?? '') ||
        _nullableTrim(unitOfMeasure) != _nullableTrim(spu.unitOfMeasure ?? '');
  }
}
