import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/utils/app_formatters.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_bloc.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_event.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_state.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/sku_form_unit_setup_page.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/utils/sku_form_unit_helpers.dart';

class SkuFormUnitSummaryCard extends StatelessWidget {
  const SkuFormUnitSummaryCard({super.key});

  Future<void> _openUnitSetup(BuildContext context) async {
    final bloc = context.read<SkuFormBloc>();
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => SkuFormUnitSetupPage(bloc: bloc)),
    );

    if (updated == true && context.mounted) {
      if (bloc.state.unitSaveResult == SkuFormUnitSaveResult.removed) {
        Navigator.of(context).pop(SkuFormUnitSaveResult.removed);
        return;
      }

      AppSnackBar.showSuccess(context, _successMessage(bloc.state));
      bloc.add(const SkuFormUnitDataRequested());
    }
  }

  String _successMessage(SkuFormState state) {
    return switch (state.unitSaveResult) {
      SkuFormUnitSaveResult.removed => AppStrings.productUnitRemovedSuccess,
      SkuFormUnitSaveResult.updated => AppStrings.productUnitUpdatedSuccess,
      _ => AppStrings.productUnitAddedSuccess,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SkuFormBloc, SkuFormState>(
      buildWhen: (previous, current) =>
          previous.sourceSku != current.sourceSku ||
          previous.siblingSkus != current.siblingSkus ||
          previous.unitDrafts != current.unitDrafts,
      builder: (context, state) {
        final skus = sameVariantUnitSkus(state);
        final baseSku = baseUnitSkuForVariant(state);
        final baseUnitId = baseSku?.unit?.id;
        final baseUnitName =
            baseSku?.unitName ??
            state.sourceSku.baseUnitName ??
            state.sourceSku.unitName ??
            '';
        return Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSize.size12.r),
          child: InkWell(
            onTap: () => _openUnitSetup(context),
            borderRadius: BorderRadius.circular(AppSize.size12.r),
            child: Padding(
              padding: EdgeInsets.all(AppSize.size16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppStrings.productUnitBaseSection,
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.subtitle,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.subtitle,
                        size: AppSize.size24.r,
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.size12.h),
                  if (skus.isEmpty)
                    Text(
                      AppStrings.productUnitDisabledSummary,
                      style: AppTextStyles.bodyManrope,
                    )
                  else
                    ...skus.map(
                      (sku) => _UnitRow(
                        sku: sku,
                        baseUnitId: baseUnitId,
                        baseUnitName: baseUnitName,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _UnitRow extends StatelessWidget {
  const _UnitRow({
    required this.sku,
    required this.baseUnitId,
    required this.baseUnitName,
  });

  final SkuEntity sku;
  final int? baseUnitId;
  final String baseUnitName;

  @override
  Widget build(BuildContext context) {
    final price = sku.sellingPrice == null
        ? '0'
        : AppFormatters.formatPrice(sku.sellingPrice!);
    final factor = sku.conversionFactor ?? 1;
    final isBaseUnit = sku.unit?.id == baseUnitId;

    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.size10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sku.unitName ?? AppStrings.notAvailable,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: AppSize.size4.h),
                Text(
                  isBaseUnit
                      ? AppStrings.productUnitsBaseMarker
                      : AppStrings.productUnitConversionWithBase(
                          factor,
                          baseUnitName,
                        ),
                  style: AppTextStyles.bodyManrope,
                ),
              ],
            ),
          ),
          Text(
            price,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
