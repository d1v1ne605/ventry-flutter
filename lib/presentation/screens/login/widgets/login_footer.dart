import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../routes/router_constants.dart';

/// Bottom footer of the login card with a "Create a new Shop" CTA.
class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.size16.w),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.inputBorder)),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSize.size12),
          bottomRight: Radius.circular(AppSize.size12),
        ),
      ),
      child: Center(
        child: GestureDetector(
          onTap: () {
            context.goNamed(RouterName.register);
          },
          child: RichText(
            text: TextSpan(
              text: AppStrings.login.footerPrefix,
              style: AppTextStyles.body,
              children: [
                TextSpan(
                  text: AppStrings.login.footerLink,
                  style: AppTextStyles.body.copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
