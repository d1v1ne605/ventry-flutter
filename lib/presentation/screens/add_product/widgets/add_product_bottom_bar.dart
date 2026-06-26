import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

class AddProductBottomBar extends StatelessWidget {
  const AddProductBottomBar({
    super.key,
    required this.onCancel,
    required this.onNext,
    this.leftButtonText,
    this.rightButtonText,
    this.showRightIcon = true,
  });

  final VoidCallback onCancel;
  final VoidCallback onNext;
  final String? leftButtonText;
  final String? rightButtonText;
  final bool showRightIcon;

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
          _CancelButton(onTap: onCancel, text: leftButtonText),
          SizedBox(width: AppSize.size12.w),
          Expanded(child: _NextButton(
            onTap: onNext, 
            text: rightButtonText,
            showIcon: showRightIcon,
          )),
        ],
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.onTap, this.text});

  final VoidCallback onTap;
  final String? text;

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
            Text(
              text ?? AppStrings.addProductCancel,
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
  const _NextButton({
    required this.onTap,
    this.text,
    this.showIcon = true,
  });

  final VoidCallback onTap;
  final String? text;
  final bool showIcon;

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
              text ?? AppStrings.addProductNext,
              style: GoogleFonts.manrope(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            if (showIcon) ...[
              SizedBox(width: AppSize.size8.w),
              Icon(Icons.chevron_right_rounded, size: 20.r, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}
