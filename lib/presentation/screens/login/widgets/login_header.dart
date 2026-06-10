import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

/// Displays the login screen header: circular logo, welcome title, and subtitle.
///
/// The logo icon is built via a private method to avoid introducing
/// an additional widget class in this file (Single Responsibility).
class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLogo(),
        Text('Welcome Back', style: AppTextStyles.heading1),
        SizedBox(height: 4.h),
        Text('Sign in to your workspace', style: AppTextStyles.body),
      ],
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 64.w,
      height: 64.w,
      margin: EdgeInsets.only(bottom: 8.h),
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
          Icons.storefront_outlined,
          color: AppColors.primary,
          size: 24.w,
        ),
      ),
    );
  }
}
