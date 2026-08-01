import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/domain/entities/product/sku_spu_group_entity.dart';

class ProductUnitsHeaderCard extends StatelessWidget {
  const ProductUnitsHeaderCard({super.key, required this.group});

  final SkuSpuGroupEntity group;

  @override
  Widget build(BuildContext context) {
    final baseUnit = group.baseUnit?.name ?? AppStrings.notAvailable;
    return Container(
      padding: EdgeInsets.all(AppSize.size16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(group.spuName, style: AppTextStyles.cardTitle),
          SizedBox(height: AppSize.size8.h),
          Text(
            AppStrings.productUnitsSummary(
              group.variantCount,
              group.activeUnits.length,
            ),
            style: AppTextStyles.bodyManrope,
          ),
          SizedBox(height: AppSize.size8.h),
          Text(
            AppStrings.productUnitsBaseUnit(baseUnit),
            style: AppTextStyles.body.copyWith(color: AppColors.heading),
          ),
        ],
      ),
    );
  }
}
