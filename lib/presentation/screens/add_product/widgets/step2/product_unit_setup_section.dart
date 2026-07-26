import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_bloc.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_event.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_state.dart';
import 'package:ventry_flutter/presentation/screens/add_product/widgets/step2/product_base_unit_form_card.dart';
import 'package:ventry_flutter/presentation/screens/add_product/widgets/step2/product_conversion_unit_form_card.dart';

class ProductUnitSetupSection extends StatelessWidget {
  const ProductUnitSetupSection({super.key});

  void _changeBaseUnitName(BuildContext context, String value) {
    final bloc = context.read<AddProductBloc>();
    final name = value.trim();
    if (name.isEmpty) {
      bloc.add(ClearBaseUnitEvent());
      return;
    }
    bloc.add(
      SelectBaseUnitEvent(
        _unitFromText(_availableBaseUnits(bloc.state), name, -1),
      ),
    );
  }

  void _addConversionUnit(BuildContext context) {
    final bloc = context.read<AddProductBloc>();
    if (bloc.state.selectedBaseUnit == null) {
      AppSnackBar.showError(context, AppStrings.productUnitBaseFirst);
      return;
    }
    bloc.add(
      AddProductUnitDraftEvent(
        ProductUnitDraft(
          id: const Uuid().v4(),
          unit: UnitEntity(
            id: -DateTime.now().microsecondsSinceEpoch,
            name: '',
          ),
          conversionFactor: 0,
          sellingPrice: 0,
        ),
      ),
    );
  }

  void _changeDraftUnitName(
    BuildContext context,
    ProductUnitDraft draft,
    String value,
  ) {
    final bloc = context.read<AddProductBloc>();
    final fallbackId = draft.unit.id < 0
        ? draft.unit.id
        : -DateTime.now().microsecondsSinceEpoch;
    bloc.add(
      UpdateProductUnitDraftEvent(
        id: draft.id,
        unit: _unitFromText(
          _availableUnits(bloc.state, draft),
          value.trim(),
          fallbackId,
        ),
      ),
    );
  }

  List<UnitEntity> _availableBaseUnits(AddProductState state) {
    final blockedIds = state.productUnitDrafts
        .where((draft) => draft.unit.id > 0)
        .map((draft) => draft.unit.id)
        .toSet();
    return state.units.where((unit) => !blockedIds.contains(unit.id)).toList();
  }

  List<UnitEntity> _availableUnits(
    AddProductState state,
    ProductUnitDraft draft,
  ) {
    final blockedIds = {
      if (state.selectedBaseUnit != null && state.selectedBaseUnit!.id > 0)
        state.selectedBaseUnit!.id,
      ...state.productUnitDrafts
          .where((item) => item.id != draft.id && item.unit.id > 0)
          .map((item) => item.unit.id),
    };
    return state.units.where((unit) => !blockedIds.contains(unit.id)).toList();
  }

  UnitEntity _unitFromText(
    List<UnitEntity> units,
    String name,
    int fallbackId,
  ) {
    final existing = units
        .where((unit) => unit.name.toLowerCase() == name.toLowerCase())
        .firstOrNull;
    return existing ?? UnitEntity(id: fallbackId, name: name);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddProductBloc, AddProductState, _UnitSectionData>(
      selector: _UnitSectionData.fromState,
      builder: (context, data) {
        final state = context.read<AddProductBloc>().state;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductBaseUnitFormCard(
              unit: data.baseUnit,
              isLoading: data.isLoading,
              units: _availableBaseUnits(state),
              onNameChanged: (value) => _changeBaseUnitName(context, value),
              onSelected: (unit) =>
                  context.read<AddProductBloc>().add(SelectBaseUnitEvent(unit)),
            ),
            SizedBox(height: AppSize.size16.h),
            ...data.drafts.map(
              (draft) => Padding(
                padding: EdgeInsets.only(bottom: AppSize.size16.h),
                child: ProductConversionUnitFormCard(
                  draft: draft,
                  baseUnitName: data.baseUnit?.name ?? '',
                  units: _availableUnits(state, draft),
                  onNameChanged: (value) =>
                      _changeDraftUnitName(context, draft, value),
                  onSelected: (unit) => context.read<AddProductBloc>().add(
                    UpdateProductUnitDraftEvent(id: draft.id, unit: unit),
                  ),
                  onRemove: () => context.read<AddProductBloc>().add(
                    RemoveProductUnitDraftEvent(draft.id),
                  ),
                  onFactorChanged: (factor) =>
                      context.read<AddProductBloc>().add(
                        UpdateProductUnitDraftEvent(
                          id: draft.id,
                          conversionFactor: factor,
                        ),
                      ),
                  onPriceChanged: (price) => context.read<AddProductBloc>().add(
                    UpdateProductUnitDraftEvent(
                      id: draft.id,
                      sellingPrice: price,
                    ),
                  ),
                ),
              ),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
              ),
              onPressed: data.isLoading
                  ? null
                  : () => _addConversionUnit(context),
              icon: Icon(Icons.add_rounded, size: AppSize.size20.r),
              label: const Text(AppStrings.productUnitAddConversion),
            ),
          ],
        );
      },
    );
  }
}

class _UnitSectionData extends Equatable {
  const _UnitSectionData({
    required this.baseUnit,
    required this.drafts,
    required this.isLoading,
  });

  final UnitEntity? baseUnit;
  final List<ProductUnitDraft> drafts;
  final bool isLoading;

  @override
  List<Object?> get props => [baseUnit, drafts, isLoading];

  static _UnitSectionData fromState(AddProductState state) {
    return _UnitSectionData(
      baseUnit: state.selectedBaseUnit,
      drafts: state.productUnitDrafts,
      isLoading: state.unitStatus == BaseStatus.loading,
    );
  }
}
