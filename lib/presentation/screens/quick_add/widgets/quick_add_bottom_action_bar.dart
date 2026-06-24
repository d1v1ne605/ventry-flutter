import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

class QuickAddBottomActionBar extends StatelessWidget {
  const QuickAddBottomActionBar({
    super.key,
    required this.onBack,
    required this.onNext,
  });

  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSize.size16.w,
        AppSize.size12.h,
        AppSize.size16.w,
        AppSize.size12.h + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: AppSize.size1),
        ),
      ),
      child: Row(
        children: [
          _BackButton(onTap: onBack),
          SizedBox(width: AppSize.size12.w),
          Expanded(child: _NextButton(onTap: onNext)),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: AppSize.size20.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSize.size8.r),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chevron_left_rounded,
              size: 20.r,
              color: AppColors.subtitle,
            ),
            SizedBox(width: AppSize.size4.w),
            Text(
              AppStrings.quickAddBack,
              style: GoogleFonts.manrope(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.subtitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSize.size8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.quickAddNext,
              style: GoogleFonts.manrope(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: AppSize.size8.w),
            Icon(Icons.check_circle_rounded, size: 20.r, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
