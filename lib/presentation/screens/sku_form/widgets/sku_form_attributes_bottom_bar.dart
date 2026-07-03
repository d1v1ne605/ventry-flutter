import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';

class SkuFormAttributesBottomBar extends StatelessWidget {
  const SkuFormAttributesBottomBar({
    super.key,
    required this.onCancel,
    required this.onApply,
    this.primaryLabel = AppStrings.skuFormApplyAttributes,
    this.isPrimaryEnabled = true,
  });

  final VoidCallback onCancel;
  final VoidCallback onApply;
  final String primaryLabel;
  final bool isPrimaryEnabled;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSize.size16.w,
        AppSize.size16.h,
        AppSize.size16.w,
        AppSize.size16.h + bottomPadding,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.inputBorder)),
        boxShadow: [
          BoxShadow(
            color: AppColors.skuFormOverlayShadow,
            offset: Offset(0, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.primary),
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.size24.w,
                vertical: AppSize.size10.h,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.size8.r),
              ),
            ),
            child: Text(
              AppStrings.skuFormCancel,
              style: AppTextStyles.skuFormButtonLabel.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: AppSize.size16.w),
          Expanded(
            child: Opacity(
              opacity: isPrimaryEnabled ? 1 : 0.5,
              child: IgnorePointer(
                ignoring: !isPrimaryEnabled,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(AppSize.size8.r),
                    boxShadow: const [AppColors.buttonShadow],
                  ),
                  child: ElevatedButton(
                    onPressed: onApply,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.transparent,
                      shadowColor: AppColors.transparent,
                      padding: EdgeInsets.symmetric(vertical: AppSize.size12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.size8.r),
                      ),
                    ),
                    child: Text(primaryLabel, style: AppTextStyles.buttonText),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
