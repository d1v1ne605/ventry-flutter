import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/primary_button.dart';
import 'register_footer.dart';
import 'register_form.dart';
import 'register_header.dart';

/// Main content card for the Shop Owner Registration screen.
///
/// Composes [RegisterHeader], [RegisterForm], the CTA button, and
/// [RegisterFooter]. All spacing comes from [AppSize] — no magic numbers.
class RegisterCard extends StatelessWidget {
  const RegisterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const RegisterHeader(),
        SizedBox(height: AppSize.size20.h),
        const RegisterForm(),
        SizedBox(height: AppSize.size20.h),
        PrimaryButton(
          text: AppStrings.register.createButton,
          onPressed: () {
            // TODO: Dispatch register event via Bloc
          },
        ),
        const RegisterFooter(),
      ],
    );
  }
}
