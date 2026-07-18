import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Displays the registration screen header: logo, title, and subtitle.
class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLogo(),
        SizedBox(height: AppSize.size8.h),
        Text(AppStrings.register.title, style: AppTextStyles.heading1),
        SizedBox(height: AppSize.size4.h),
        Text(
          AppStrings.register.subtitle,
          style: AppTextStyles.bodySubtle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: AppSize.size64.w,
      height: AppSize.size64.w,
      margin: EdgeInsets.only(bottom: AppSize.size8.h),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFEAEFED),
        border: Border.all(color: const Color(0xFFDEE4E1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F1722),
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.store_outlined,
          color: AppColors.primary,
          size: AppSize.size28,
        ),
      ),
    );
  }
}
