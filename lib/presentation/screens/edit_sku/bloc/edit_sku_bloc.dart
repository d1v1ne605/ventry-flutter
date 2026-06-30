import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventry_flutter/core/base/base_view_model.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/bloc/edit_sku_event.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/bloc/edit_sku_state.dart';

class EditSkuBloc extends BaseViewModel<EditSkuEvent, EditSkuState> {
  EditSkuBloc(AppLogger logger, {required SkuEntity initialSku})
    : super(EditSkuState.fromSku(initialSku), logger) {
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
  }

  void _onNameChanged(EditSkuNameChanged event, Emitter<EditSkuState> emit) {
    emit(state.copyWith(form: state.form.copyWith(skuName: event.value)));
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
      ),
    );
  }

  void _onBarcodeChanged(
    EditSkuBarcodeChanged event,
    Emitter<EditSkuState> emit,
  ) {
    emit(state.copyWith(form: state.form.copyWith(barcode: event.value)));
  }

  void _onSkuCodeChanged(EditSkuCodeChanged event, Emitter<EditSkuState> emit) {
    emit(state.copyWith(form: state.form.copyWith(skuCode: event.value)));
  }

  void _onCostPriceChanged(
    EditSkuCostPriceChanged event,
    Emitter<EditSkuState> emit,
  ) {
    emit(state.copyWith(form: state.form.copyWith(costPrice: event.value)));
  }

  void _onSellingPriceChanged(
    EditSkuSellingPriceChanged event,
    Emitter<EditSkuState> emit,
  ) {
    emit(state.copyWith(form: state.form.copyWith(sellingPrice: event.value)));
  }

  void _onCurrencyChanged(
    EditSkuCurrencyChanged event,
    Emitter<EditSkuState> emit,
  ) {
    emit(state.copyWith(form: state.form.copyWith(currency: event.value)));
  }

  void _onUnitChanged(
    EditSkuUnitOfMeasureChanged event,
    Emitter<EditSkuState> emit,
  ) {
    emit(state.copyWith(form: state.form.copyWith(unitOfMeasure: event.value)));
  }

  void _onSellableChanged(
    EditSkuSellableChanged event,
    Emitter<EditSkuState> emit,
  ) {
    emit(state.copyWith(form: state.form.copyWith(isSellable: event.value)));
  }

  void _onDescriptionChanged(
    EditSkuDescriptionChanged event,
    Emitter<EditSkuState> emit,
  ) {
    emit(state.copyWith(form: state.form.copyWith(description: event.value)));
  }
}
