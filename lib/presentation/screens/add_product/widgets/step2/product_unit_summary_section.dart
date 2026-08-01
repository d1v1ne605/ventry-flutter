import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';
import 'package:ventry_flutter/presentation/screens/add_product/add_product_unit_setup_page.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_bloc.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_state.dart';

class ProductUnitSummarySection extends StatelessWidget {
  const ProductUnitSummarySection({super.key});

  void _openUnitSetup(BuildContext context) {
    final bloc = context.read<AddProductBloc>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddProductUnitSetupPage(bloc: bloc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AddProductBloc, AddProductState, _UnitSummaryData>(
      selector: _UnitSummaryData.fromState,
      builder: (context, data) {
        return Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSize.size12.r),
          child: InkWell(
            onTap: () => _openUnitSetup(context),
            borderRadius: BorderRadius.circular(AppSize.size12.r),
            child: Padding(
              padding: EdgeInsets.all(AppSize.size12.r),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppStrings.productUnitSetupTitle.toUpperCase(),
                          style: AppTextStyles.bodyManrope.copyWith(
                            color: AppColors.subtitle,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: AppColors.subtitle,
                      ),
                    ],
                  ),
                  if (data.baseUnit == null)
                    _emptyRow()
                  else ...[
                    SizedBox(height: AppSize.size12.h),
                    _unitRow(
                      title: data.baseUnit!.name,
                      subtitle: AppStrings.productUnitsBaseMarker,
                      price: data.globalPrice,
                    ),
                    ...data.validDrafts.map(
                      (draft) => _unitRow(
                        title: draft.unit.name,
                        subtitle: AppStrings.productUnitConversionWithBase(
                          draft.conversionFactor,
                          data.baseUnit!.name,
                        ),
                        price: draft.sellingPrice,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _emptyRow() {
    return Padding(
      padding: EdgeInsets.only(top: AppSize.size8.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          AppStrings.productUnitDisabledSummary,
          style: AppTextStyles.bodyManrope,
        ),
      ),
    );
  }

  Widget _unitRow({
    required String title,
    required String subtitle,
    required double price,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.size10.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.heading,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Text(
                _formatPrice(price),
                style: AppTextStyles.body.copyWith(
                  color: AppColors.heading,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.size2.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(subtitle, style: AppTextStyles.bodyManrope),
          ),
        ],
      ),
    );
  }

  String _formatPrice(double value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }
}

class _UnitSummaryData extends Equatable {
  const _UnitSummaryData({
    required this.baseUnit,
    required this.drafts,
    required this.globalPrice,
  });

  final UnitEntity? baseUnit;
  final List<ProductUnitDraft> drafts;
  final double globalPrice;

  List<ProductUnitDraft> get validDrafts => drafts
      .where(
        (draft) =>
            draft.unit.id > 0 &&
            draft.unit.name.trim().isNotEmpty &&
            draft.conversionFactor > 0,
      )
      .toList();

  static _UnitSummaryData fromState(AddProductState state) {
    return _UnitSummaryData(
      baseUnit: state.selectedBaseUnit,
      drafts: state.productUnitDrafts,
      globalPrice: state.globalPrice,
    );
  }

  @override
  List<Object?> get props => [baseUnit, drafts, globalPrice];
}
