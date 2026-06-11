
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constants/app_size.dart';
import '../../../core/theme/app_colors.dart';
import 'widgets/register_card.dart';

/// Entry point for the Shop Owner Registration screen.
///
/// Renders a scrollable scaffold over [AppColors.background].
/// Padding values come from [AppSize] — no magic numbers.
class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.size16.w,
            vertical: AppSize.size20.h,
          ),
          child: const RegisterCard(),
        ),
      ),
    );
  }
}
