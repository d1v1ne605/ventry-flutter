import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';

class SkuFormAttributeSelectionTile extends StatelessWidget {
  const SkuFormAttributeSelectionTile({
    super.key,
    required this.attribute,
    required this.isSelected,
    required this.isDisabled,
    required this.onTap,
  });

  final AttributeEntity attribute;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isDisabled || isSelected
        ? AppColors.primary
        : AppColors.inputBorder;
    final backgroundColor = isDisabled || isSelected
        ? AppColors.skuFormSoftBackground
        : AppColors.surface;
    final textColor = isDisabled || isSelected
        ? AppColors.primary
        : AppColors.textHeading;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.size16.w,
            vertical: AppSize.size14.h,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppSize.size12.r),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  attribute.name,
                  style: AppTextStyles.input.copyWith(color: textColor),
                ),
              ),
              if (isDisabled)
                Text(
                  AppStrings.skuFormAttributeAlreadyAdded,
                  style: AppTextStyles.skuFormFieldLabel.copyWith(
                    color: AppColors.primary,
                  ),
                )
              else
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: isSelected ? AppColors.primary : AppColors.inputBorder,
                  size: AppSize.size20.r,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
