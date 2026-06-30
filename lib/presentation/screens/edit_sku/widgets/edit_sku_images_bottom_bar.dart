import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';

class EditSkuImagesBottomBar extends StatelessWidget {
  const EditSkuImagesBottomBar({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSize.size16.w,
        AppSize.size8.h,
        AppSize.size16.w,
        AppSize.size8.h + bottomPadding,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.inputBorder)),
        boxShadow: [
          BoxShadow(
            color: Color(0x140F172A),
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
              AppStrings.editSkuCancel,
              style: AppTextStyles.editSkuButtonLabel.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: AppSize.size16.w),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppSize.size8.r),
                boxShadow: const [AppColors.buttonShadow],
              ),
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.symmetric(vertical: AppSize.size12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.size8.r),
                  ),
                ),
                child: Text(
                  AppStrings.editSkuSaveGallery,
                  style: AppTextStyles.buttonText,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
