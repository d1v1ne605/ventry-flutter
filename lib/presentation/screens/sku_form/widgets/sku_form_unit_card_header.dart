import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';

class SkuFormUnitCardHeader extends StatelessWidget {
  const SkuFormUnitCardHeader({
    super.key,
    required this.title,
    required this.isEditable,
    this.onRemove,
  });

  final String title;
  final bool isEditable;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.body.copyWith(
              color: AppColors.subtitle,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        _UnitStatusBadge(isEditable: isEditable),
        if (onRemove != null)
          IconButton(
            onPressed: onRemove,
            icon: Icon(
              Icons.remove_circle_outline_rounded,
              color: AppColors.subtitle,
              size: AppSize.size24.r,
            ),
          ),
      ],
    );
  }
}

class _UnitStatusBadge extends StatelessWidget {
  const _UnitStatusBadge({required this.isEditable});

  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    final color = isEditable ? AppColors.primary : AppColors.subtitle;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.size8.w,
        vertical: AppSize.size4.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.skuChipFill,
        borderRadius: BorderRadius.circular(AppSize.size8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isEditable ? Icons.edit_rounded : Icons.lock_outline_rounded,
            size: AppSize.size14.r,
            color: color,
          ),
          SizedBox(width: AppSize.size4.w),
          Text(
            isEditable
                ? AppStrings.productUnitEditableBadge
                : AppStrings.productUnitLockedBadge,
            style: AppTextStyles.bodyManrope.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
