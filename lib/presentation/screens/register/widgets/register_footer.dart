import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../routes/router_constants.dart';

/// "Already have a shop? Login" link row below the submit button.
class RegisterFooter extends StatelessWidget {
  const RegisterFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: AppSize.size8.h),
      child: Center(
        child: GestureDetector(
          onTap: () {
            context.goNamed(RouterName.login);
          },
          child: RichText(
            text: TextSpan(
              text: AppStrings.register.footerPrefix,
              style: AppTextStyles.bodySubtle,
              children: [
                TextSpan(
                  text: AppStrings.register.footerLink,
                  style: AppTextStyles.bodySubtle.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
