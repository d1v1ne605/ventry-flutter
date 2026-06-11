import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_size.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Full-width gradient primary button following the app design system.
///
/// Shows a [CircularProgressIndicator] when [isLoading] is true.
/// All sizes come from [AppSize] — no magic numbers.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Widget? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(AppSize.size8.r),
        border: Border.all(
          color: const Color(0x80115E59),
          width: AppSize.size1,
        ),
        boxShadow: const [AppColors.buttonShadow],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(AppSize.size8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.size12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: AppSize.size20.w,
                    height: AppSize.size20.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: AppSize.size2,
                    ),
                  )
                else ...[
                  Text(text, style: AppTextStyles.buttonText),
                  if (icon != null) ...[
                    SizedBox(width: AppSize.size4.w),
                    icon!,
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
