import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';

/// Filter tab option for the product catalog.
enum ProductFilter {
  totalStock,
  lowStock,
  outOfStock;
}

/// Horizontally scrollable filter chip row.
///
/// Shows Total Stock / Low Stock / Out of Stock tabs.
/// The active chip has a teal border; inactive chips have a grey border.
class ProductFilterChips extends StatelessWidget {
  const ProductFilterChips({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    this.totalCount = 0,
    this.lowStockCount = 0,
    this.outOfStockCount = 0,
  });

  final ProductFilter selectedFilter;
  final void Function(ProductFilter) onFilterChanged;
  final int totalCount;
  final int lowStockCount;
  final int outOfStockCount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _FilterChip(
            label: AppStrings.filterTotalStock,
            count: totalCount,
            isActive: selectedFilter == ProductFilter.totalStock,
            badgeColor: AppColors.filterChipBadgeTeal,
            onTap: () => onFilterChanged(ProductFilter.totalStock),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: AppStrings.filterLowStock,
            count: lowStockCount,
            isActive: selectedFilter == ProductFilter.lowStock,
            badgeColor: AppColors.filterChipBadgeOrange,
            onTap: () => onFilterChanged(ProductFilter.lowStock),
          ),
          SizedBox(width: 8.w),
          _FilterChip(
            label: AppStrings.filterOutOfStock,
            count: outOfStockCount,
            isActive: selectedFilter == ProductFilter.outOfStock,
            badgeColor: AppColors.outOfStockDot,
            onTap: () => onFilterChanged(ProductFilter.outOfStock),
          ),
        ],
      ),
    );
  }
}

/// Individual filter chip with optional count badge.
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.count,
    required this.isActive,
    required this.badgeColor,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool isActive;
  final Color badgeColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color borderColor = isActive
        ? AppColors.filterChipActiveBorder
        : AppColors.filterChipInactiveBorder;
    final Color textColor = isActive
        ? AppColors.filterChipActiveText
        : AppColors.filterChipInactiveText;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.filterChipActiveFill,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTextStyles.filterChipLabel.copyWith(color: textColor),
            ),
            SizedBox(width: 6.w),
            _CountBadge(count: count, color: badgeColor),
          ],
        ),
      ),
    );
  }
}

/// Small pill badge with count number inside a [_FilterChip].
class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.count, required this.color});

  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        '$count',
        style: AppTextStyles.stockBadge.copyWith(
          color: Colors.white,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}
