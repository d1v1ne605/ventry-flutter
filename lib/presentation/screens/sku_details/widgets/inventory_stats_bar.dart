import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';

class InventoryStatsBar extends StatelessWidget {
  final SkuEntity sku;

  const InventoryStatsBar({super.key, required this.sku});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: AppStrings.currentStockLabel,
            value: sku.stockQuantity.toString(),
            valueColor: AppColors.primary,
          ),
        ),
        SizedBox(width: AppSize.size8.w),
        Expanded(
          child: _StatCard(
            label: AppStrings.inTransitLabel,
            value: '0', // Hardcoded as per plan
            valueColor: const Color(0xFF0284C7),
          ),
        ),
        SizedBox(width: AppSize.size8.w),
        Expanded(
          child: _StatCard(
            label: AppStrings.reservedLabel,
            value: '0', // Hardcoded as per plan
            valueColor: AppColors.filterChipBadgeOrange,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: AppSize.size8.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSize.size4.h),
          Text(
            value,
            style: AppTextStyles.sectionHeading.copyWith(
              color: valueColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
