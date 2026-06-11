import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';

/// A card section with a heading and a list of form fields.
///
/// Used by [RegisterForm] to render "Personal Information" and "Shop Details"
/// sections with consistent styling. All sizes and colors come from
/// [AppSize] / [AppColors] — no magic numbers.
class RegisterFormSection extends StatelessWidget {
  final String sectionTitle;
  final List<Widget> fields;

  const RegisterFormSection({
    super.key,
    required this.sectionTitle,
    required this.fields,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.size16.w),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sectionTitle, style: AppTextStyles.sectionHeading),
          SizedBox(height: AppSize.size16.h),
          _buildFields(),
        ],
      ),
    );
  }

  Widget _buildFields() {
    return Column(
      children: List.generate(fields.length, (index) {
        return Column(
          children: [
            fields[index],
            if (index < fields.length - 1) SizedBox(height: AppSize.size12.h),
          ],
        );
      }),
    );
  }
}

/// Renders the full registration form:
/// "Personal Information" section + "Shop Details" section.
class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildPersonalInfoSection(),
        SizedBox(height: AppSize.size20.h),
        _buildShopDetailsSection(),
      ],
    );
  }

  Widget _buildPersonalInfoSection() {
    return RegisterFormSection(
      sectionTitle: AppStrings.register.personalInfoSection,
      fields: [
        CustomTextField(
          label: AppStrings.register.fullNameLabel,
          hintText: AppStrings.register.fullNameHint,
          prefixIcon: Icon(
            Icons.person_outline,
            color: AppColors.textBody,
            size: AppSize.size20,
          ),
        ),
        CustomTextField(
          label: AppStrings.register.emailLabel,
          hintText: AppStrings.register.emailHint,
          prefixIcon: Icon(
            Icons.email_outlined,
            color: AppColors.textBody,
            size: AppSize.size20,
          ),
        ),
        CustomTextField(
          label: AppStrings.register.phoneLabel,
          hintText: AppStrings.register.phoneHint,
          prefixIcon: Icon(
            Icons.phone_outlined,
            color: AppColors.textBody,
            size: AppSize.size20,
          ),
        ),
      ],
    );
  }

  Widget _buildShopDetailsSection() {
    return RegisterFormSection(
      sectionTitle: AppStrings.register.shopDetailsSection,
      fields: [
        CustomTextField(
          label: AppStrings.register.shopNameLabel,
          hintText: AppStrings.register.shopNameHint,
          prefixIcon: Icon(
            Icons.storefront_outlined,
            color: AppColors.textBody,
            size: AppSize.size20,
          ),
        ),
      ],
    );
  }
}
