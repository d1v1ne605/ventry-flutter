import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

/// A single side-by-side key/value input row with a delete icon.
class QuickAddAttributeRow extends StatelessWidget {
  const QuickAddAttributeRow({
    super.key,
    required this.keyController,
    required this.valueController,
    required this.onDelete,
    this.keyHint = AppStrings.quickAddStep3KeyHint,
    this.valueHint = AppStrings.quickAddStep3ValueHint,
  });

  final TextEditingController keyController;
  final TextEditingController valueController;
  final VoidCallback onDelete;
  final String keyHint;
  final String valueHint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.size12.h),
      child: Row(
        children: [
          // Key text field
          Expanded(
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(AppSize.size8.r),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: TextField(
                controller: keyController,
                style: GoogleFonts.manrope(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.heading,
                ),
                decoration: InputDecoration(
                  hintText: keyHint,
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textHint,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSize.size12.w,
                    vertical: AppSize.size10.h,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSize.size12.w),
          // Value text field
          Expanded(
            child: Container(
              height: 44.h,
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(AppSize.size8.r),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: TextField(
                controller: valueController,
                style: GoogleFonts.manrope(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.heading,
                ),
                decoration: InputDecoration(
                  hintText: valueHint,
                  hintStyle: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textHint,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSize.size12.w,
                    vertical: AppSize.size10.h,
                  ),
                ),
              ),
            ),
          ),
          // Delete/Trash button
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline_rounded,
              size: 22.r,
              color: AppColors.subtitle.withValues(alpha: 0.8),
            ),
            padding: EdgeInsets.symmetric(horizontal: AppSize.size8.w),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
