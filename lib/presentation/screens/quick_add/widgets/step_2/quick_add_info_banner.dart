import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

/// Informational banner shown below the Step 2 form.
class QuickAddInfoBanner extends StatelessWidget {
  const QuickAddInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.size12.w,
        vertical: AppSize.size12.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.inStockBadgeFill, // soft light teal
        borderRadius: BorderRadius.circular(AppSize.size8.r),
        border: Border.all(
          color: AppColors.inStockBadgeText.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info,
            size: 18.r,
            color: AppColors.inStockBadgeText, // teal icon
          ),
          SizedBox(width: AppSize.size8.w),
          Expanded(
            child: Text(
              AppStrings.quickAddStep2InfoText,
              style: GoogleFonts.manrope(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.inStockBadgeText, // teal text
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
