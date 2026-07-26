import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/base/base_view_model.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';
import 'package:ventry_flutter/domain/entities/product/product_unit_configuration_params.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/usecases/product/configure_product_units_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/get_skus_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/get_units_usecase.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';
import 'package:ventry_flutter/presentation/screens/product_units/bloc/product_units_event.dart';
import 'package:ventry_flutter/presentation/screens/product_units/bloc/product_units_state.dart';

@injectable
class ProductUnitsBloc
    extends BaseViewModel<ProductUnitsEvent, ProductUnitsState> {
  ProductUnitsBloc(
    AppLogger logger,
    this._getSkus,
    this._getUnits,
    this._configureUnits,
  ) : super(const ProductUnitsState(), logger) {
    on<LoadProductUnits>(_onLoad);
    on<QueueProductUnitCreation>(_onQueueCreate);
    on<QueueProductUnitRemoval>(_onQueueRemove);
    on<SaveProductUnitConfiguration>(_onSave);
  }

  final GetSkusUseCase _getSkus;
  final GetUnitsUseCase _getUnits;
  final ConfigureProductUnitsUseCase _configureUnits;

  Future<void> _onLoad(
    LoadProductUnits event,
    Emitter<ProductUnitsState> emit,
  ) async {
    emit(
      state.copyWith(
        status: BaseStatus.loading,
        saveStatus: BaseStatus.initial,
      ),
    );

    final unitsResult = await _getUnits(NoParams());
    final groupResult = await _getSkus(
      SkuQueryParams(spuUid: event.spuUid, page: 1, limit: 1),
    );

    unitsResult.fold(
      (failure) => emit(
        state.copyWith(
          status: BaseStatus.failure,
          errorMessage: mapFailureToMessage(failure),
        ),
      ),
      (units) => groupResult.fold(
        (failure) => emit(
          state.copyWith(
            status: BaseStatus.failure,
            errorMessage: mapFailureToMessage(failure),
          ),
        ),
        (list) {
          final group = list.items.firstOrNull;
          emit(
            state.copyWith(
              status: group == null ? BaseStatus.failure : BaseStatus.success,
              group: group,
              units: units,
              pendingCreateSkus: const [],
              pendingDiscontinueSkus: const [],
              errorMessage: group == null ? AppStrings.noVariantsFound : null,
            ),
          );
        },
      ),
    );
  }

  void _onQueueCreate(
    QueueProductUnitCreation event,
    Emitter<ProductUnitsState> emit,
  ) {
    final group = state.group;
    if (group == null) return;

    final activeTemplates = _distinctAttributeTemplates(group.sortedSkus);
    final createSkus = activeTemplates.map((sku) {
      return CreateSkuParams(
        skuCode: _buildSkuCode(sku, event.draft.unit.name),
        sellingPrice: (sku.sellingPrice ?? 0) * event.draft.conversionFactor,
        costPrice: sku.costPrice == null
            ? null
            : sku.costPrice! * event.draft.conversionFactor,
        stockQuantity: 0,
        minStockQuantity: 0,
        unitId: event.draft.unit.id,
        conversionFactor: event.draft.conversionFactor,
        imageKeys: sku.imageKeys,
        isSellable: true,
        attributeValueUids: sku.attributes.map((attr) => attr.uid).toList(),
      );
    }).toList();

    emit(
      state.copyWith(
        pendingCreateSkus: [...state.pendingCreateSkus, ...createSkus],
      ),
    );
  }

  void _onQueueRemove(
    QueueProductUnitRemoval event,
    Emitter<ProductUnitsState> emit,
  ) {
    final group = state.group;
    if (group == null || group.baseUnit?.id == event.unitId) {
      return;
    }

    final removals = group.skus
        .where((sku) => sku.unit?.id == event.unitId && sku.status == 'ACTIVE')
        .map(
          (sku) => ProductUnitSkuDiscontinueParams(
            skuUid: sku.uid,
            version: sku.version,
          ),
        )
        .toList();

    emit(
      state.copyWith(
        pendingDiscontinueSkus: [...state.pendingDiscontinueSkus, ...removals],
      ),
    );
  }

  Future<void> _onSave(
    SaveProductUnitConfiguration event,
    Emitter<ProductUnitsState> emit,
  ) async {
    final group = state.group;
    if (group == null || !state.hasPendingChanges) return;

    emit(state.copyWith(saveStatus: BaseStatus.loading));
    final result = await _configureUnits(
      ProductUnitConfigurationParams(
        spuUid: group.spuUid,
        version: group.spuVersion,
        createSkus: state.pendingCreateSkus,
        discontinueSkus: state.pendingDiscontinueSkus,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          saveStatus: BaseStatus.failure,
          errorMessage: mapFailureToMessage(failure),
        ),
      ),
      (_) => emit(state.copyWith(saveStatus: BaseStatus.success)),
    );
  }

  List<SkuEntity> _distinctAttributeTemplates(List<SkuEntity> skus) {
    final templates = <String, SkuEntity>{};
    for (final sku in skus.where((sku) => sku.status == 'ACTIVE')) {
      final key = sku.attributes.map((attr) => attr.uid).toList()..sort();
      templates.putIfAbsent(key.join('|'), () => sku);
    }
    return templates.values.toList(growable: false);
  }

  String _buildSkuCode(SkuEntity sku, String unitName) {
    final source = sku.skuCode ?? sku.uid;
    final normalizedUnit = unitName.toUpperCase().replaceAll(' ', '-');
    final code = '$source-$normalizedUnit';
    return code.length > 100 ? code.substring(0, 100) : code;
  }
}
