import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';

class ProductUnitListItem extends StatelessWidget {
  const ProductUnitListItem({
    super.key,
    required this.unit,
    required this.isBaseUnit,
    required this.skuCount,
    required this.onRemove,
  });

  final UnitEntity unit;
  final bool isBaseUnit;
  final int skuCount;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.size14.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unit.name,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.heading,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSize.size4.h),
                Text(
                  isBaseUnit
                      ? AppStrings.productUnitsBaseMarker
                      : AppStrings.productUnitsSkuCount(skuCount),
                  style: AppTextStyles.bodyManrope,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: isBaseUnit ? null : onRemove,
            icon: Icon(
              Icons.delete_outline_rounded,
              color: isBaseUnit ? AppColors.textMuted : AppColors.error,
              size: 22.r,
            ),
          ),
        ],
      ),
    );
  }
}
