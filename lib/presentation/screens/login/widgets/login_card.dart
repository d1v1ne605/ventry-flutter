import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/theme/app_colors.dart';
import 'login_footer.dart';
import 'login_header.dart';
import 'login_form.dart';

/// Card container that holds all login UI sections.
class LoginCard extends StatelessWidget {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        border: Border.all(
          color: AppColors.inputBorder,
          width: AppSize.size1,
        ),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(AppSize.size32.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LoginHeader(),
                SizedBox(height: AppSize.size32.h),
                const LoginForm(),
              ],
            ),
          ),
          const LoginFooter(),
        ],
      ),
    );
  }
}
