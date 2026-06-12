import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

/// Progress header showing "Review & Confirm" and "Step 4 of 4" with a fully filled progress bar.
class QuickAddStep4Header extends StatelessWidget {
  const QuickAddStep4Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.quickAddStep4Title,
              style: GoogleFonts.manrope(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
            Text(
              AppStrings.quickAddStep4ProgressText,
              style: GoogleFonts.manrope(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.subtitle,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSize.size8.h),
        // Custom horizontal progress bar (100% progress)
        Container(
          height: 6.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(100.r),
          ),
        ),
      ],
    );
  }
}
