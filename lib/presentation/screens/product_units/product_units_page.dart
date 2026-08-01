import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:ventry_flutter/core/widgets/app_top_bar.dart';
import 'package:ventry_flutter/core/widgets/primary_button.dart';
import 'package:ventry_flutter/injection.dart';
import 'package:ventry_flutter/presentation/screens/add_product/models/add_product_draft_models.dart';
import 'package:ventry_flutter/presentation/screens/add_product/widgets/step2/product_conversion_unit_sheet.dart';
import 'package:ventry_flutter/presentation/screens/product_units/bloc/product_units_bloc.dart';
import 'package:ventry_flutter/presentation/screens/product_units/bloc/product_units_event.dart';
import 'package:ventry_flutter/presentation/screens/product_units/bloc/product_units_state.dart';
import 'package:ventry_flutter/presentation/screens/product_units/widgets/product_unit_list_item.dart';
import 'package:ventry_flutter/presentation/screens/product_units/widgets/product_units_header_card.dart';

class ProductUnitsPage extends StatelessWidget {
  const ProductUnitsPage({super.key, required this.spuUid});

  final String spuUid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductUnitsBloc>()..add(LoadProductUnits(spuUid)),
      child: const _ProductUnitsView(),
    );
  }
}

class _ProductUnitsView extends StatelessWidget {
  const _ProductUnitsView();

  Future<void> _addUnit(BuildContext context) async {
    final bloc = context.read<ProductUnitsBloc>();
    final state = bloc.state;
    final activeUnitIds =
        state.group?.activeUnits.map((unit) => unit.id).toSet() ?? {};
    final pendingUnitIds = state.pendingCreateSkus
        .map((sku) => sku.unitId)
        .whereType<int>()
        .toSet();

    final draft = await ProductConversionUnitSheet.show(
      context,
      units: state.units,
      excludedUnitIds: {...activeUnitIds, ...pendingUnitIds},
      onCreateUnit: (_) {},
    );
    if (draft != null && context.mounted) {
      bloc.add(
        QueueProductUnitCreation(
          ProductUnitDraft(
            id: draft.unit.id.toString(),
            unit: draft.unit,
            conversionFactor: draft.conversionFactor,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductUnitsBloc, ProductUnitsState>(
      listenWhen: (previous, current) =>
          previous.saveStatus != current.saveStatus,
      listener: (context, state) {
        if (state.saveStatus == BaseStatus.success) {
          AppSnackBar.showSuccess(context, AppStrings.productUnitsSaved);
          context.pop(true);
        }
        if (state.saveStatus == BaseStatus.failure) {
          AppSnackBar.showError(
            context,
            state.errorMessage ?? AppStrings.editSpuLoadFailed,
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: AppTopBar(
          title: AppStrings.productUnitsTitle,
          leadingWidget: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.primary,
              size: AppSize.size16.r,
            ),
            onPressed: () => context.pop(),
          ),
          trailingWidget: TextButton(
            onPressed: () => _addUnit(context),
            child: const Text(AppStrings.productUnitsAdd),
          ),
        ),
        body: BlocBuilder<ProductUnitsBloc, ProductUnitsState>(
          builder: (context, state) {
            if (state.status == BaseStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == BaseStatus.failure || state.group == null) {
              return Center(
                child: Text(state.errorMessage ?? AppStrings.noVariantsFound),
              );
            }

            final removedIds = state.pendingRemovedUnitIds;
            final units = state.group!.activeUnits
                .where((unit) => !removedIds.contains(unit.id))
                .toList();

            return ListView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 120.h),
              children: [
                ProductUnitsHeaderCard(group: state.group!),
                SizedBox(height: AppSize.size12.h),
                ...units.map(
                  (unit) => Padding(
                    padding: EdgeInsets.only(bottom: AppSize.size8.h),
                    child: ProductUnitListItem(
                      unit: unit,
                      isBaseUnit: state.group!.baseUnit?.id == unit.id,
                      skuCount: state.group!.skus
                          .where((sku) => sku.unit?.id == unit.id)
                          .length,
                      onRemove: () => context.read<ProductUnitsBloc>().add(
                        QueueProductUnitRemoval(unit.id),
                      ),
                    ),
                  ),
                ),
                if (state.pendingCreateSkus.isNotEmpty)
                  Text(
                    AppStrings.productUnitsPendingCreate(
                      state.pendingCreateSkus.length,
                    ),
                  ),
              ],
            );
          },
        ),
        bottomNavigationBar:
            BlocSelector<ProductUnitsBloc, ProductUnitsState, _SaveBarData>(
              selector: _SaveBarData.fromState,
              builder: (context, data) {
                return SafeArea(
                  minimum: EdgeInsets.all(AppSize.size16.r),
                  child: PrimaryButton(
                    text: AppStrings.editSpuSaveChanges,
                    isEnabled: data.hasChanges,
                    isLoading: data.isSaving,
                    onPressed: () => context.read<ProductUnitsBloc>().add(
                      const SaveProductUnitConfiguration(),
                    ),
                  ),
                );
              },
            ),
      ),
    );
  }
}

class _SaveBarData extends Equatable {
  const _SaveBarData({required this.hasChanges, required this.isSaving});

  final bool hasChanges;
  final bool isSaving;

  @override
  List<Object?> get props => [hasChanges, isSaving];

  static _SaveBarData fromState(ProductUnitsState state) {
    return _SaveBarData(
      hasChanges: state.hasPendingChanges,
      isSaving: state.saveStatus == BaseStatus.loading,
    );
  }
}
