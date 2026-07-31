import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_bloc.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_event.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_state.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/utils/sku_form_unit_helpers.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/utils/sku_form_unit_setup_actions.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_current_unit_card.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_existing_unit_card.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_unit_draft_card.dart';

class SkuFormUnitSetupSection extends StatelessWidget {
  const SkuFormUnitSetupSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SkuFormBloc, SkuFormState>(
      buildWhen: (previous, current) =>
          previous.sourceSku != current.sourceSku ||
          previous.units != current.units ||
          previous.siblingSkus != current.siblingSkus ||
          previous.unitDrafts != current.unitDrafts ||
          previous.currentUnitEdit != current.currentUnitEdit ||
          previous.unitStatus != current.unitStatus,
      builder: (context, state) {
        final sourceSku = state.sourceSku;
        final unitSkus = sameVariantUnitSkus(state);
        final baseSku = baseUnitSkuForVariant(state);
        final baseUnitName =
            baseSku?.unitName ??
            sourceSku.baseUnitName ??
            sourceSku.unitName ??
            '';
        final isCurrentRemoved = state.currentUnitEdit.isRemoved;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...unitSkus.map(
              (sku) => Padding(
                padding: EdgeInsets.only(bottom: AppSize.size16.h),
                child: _UnitEditor(
                  sku: sku,
                  state: state,
                  baseSku: baseSku,
                  baseUnitName: baseUnitName,
                  isEditable: sku.uid == sourceSku.uid && !isCurrentRemoved,
                ),
              ),
            ),
            SizedBox(height: AppSize.size16.h),
            ...state.unitDrafts.map(
              (draft) => Padding(
                padding: EdgeInsets.only(bottom: AppSize.size16.h),
                child: SkuFormUnitDraftCard(
                  draft: draft,
                  baseUnitName: baseUnitName,
                  units: availableUnitsForDraft(state, draft),
                  onNameChanged: (value) =>
                      SkuFormUnitSetupActions.changeDraftUnitName(
                        context,
                        state,
                        draft,
                        value,
                      ),
                  onSelected: (unit) => context.read<SkuFormBloc>().add(
                    SkuFormUnitDraftChanged(id: draft.id, unit: unit),
                  ),
                  onRemove: () => context.read<SkuFormBloc>().add(
                    SkuFormUnitDraftRemoved(draft.id),
                  ),
                  onSkuCodeChanged: (value) => context.read<SkuFormBloc>().add(
                    SkuFormUnitDraftChanged(id: draft.id, skuCode: value),
                  ),
                  onFactorChanged: (factor) =>
                      SkuFormUnitSetupActions.changeDraftFactor(
                        context,
                        state,
                        draft,
                        factor,
                      ),
                  onPriceChanged: (price) => context.read<SkuFormBloc>().add(
                    SkuFormUnitDraftChanged(id: draft.id, sellingPrice: price),
                  ),
                ),
              ),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
              ),
              onPressed: state.unitStatus == BaseStatus.loading
                  ? null
                  : () => SkuFormUnitSetupActions.addDraft(context, state),
              icon: Icon(Icons.add_rounded, size: AppSize.size20.r),
              label: const Text(AppStrings.productUnitAddConversion),
            ),
          ],
        );
      },
    );
  }
}

class _UnitEditor extends StatelessWidget {
  const _UnitEditor({
    required this.sku,
    required this.state,
    required this.baseSku,
    required this.baseUnitName,
    required this.isEditable,
  });

  final SkuEntity sku;
  final SkuFormState state;
  final SkuEntity? baseSku;
  final String baseUnitName;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    final isBaseUnit = sku.uid == baseSku?.uid;
    if (isBaseUnit) {
      return SkuFormCurrentUnitCard(
        sku: sku,
        isEditable: isEditable,
        onNameChanged: isEditable
            ? (value) => SkuFormUnitSetupActions.changeCurrentUnitName(
                context,
                state,
                value,
              )
            : null,
      );
    }

    final sellingPrice = isEditable
        ? state.currentUnitEdit.sellingPrice ?? sku.sellingPrice ?? 0
        : sku.sellingPrice ?? 0;
    return SkuFormExistingUnitCard(
      sku: sku,
      baseUnitName: baseUnitName,
      sellingPrice: sellingPrice,
      isEditable: isEditable,
      onNameChanged: isEditable
          ? (value) => SkuFormUnitSetupActions.changeCurrentUnitName(
              context,
              state,
              value,
            )
          : null,
      onFactorChanged: isEditable
          ? (factor) => SkuFormUnitSetupActions.changeCurrentFactor(
              context,
              state,
              factor,
            )
          : null,
      onPriceChanged: isEditable
          ? (price) => SkuFormUnitSetupActions.changeCurrentPrice(
              context,
              state,
              price,
            )
          : null,
      onRemove: isEditable
          ? () => SkuFormUnitSetupActions.removeCurrentUnit(context, state)
          : null,
    );
  }
}
