import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.screenBackground,
      body: Center(child: _SplashContent()),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AppAssets.ventrySplashIcon,
          width: AppSize.size152.w,
          height: AppSize.size152.w,
          fit: BoxFit.contain,
        ),
        SizedBox(height: AppSize.size16.h),
        Text(
          AppStrings.appName,
          style: AppTextStyles.cardTitle.copyWith(
            color: AppColors.primary,
            fontSize: AppSize.size28.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
