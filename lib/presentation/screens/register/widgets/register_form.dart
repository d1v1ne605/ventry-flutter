import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/presentation/screens/register/bloc/register_name_changed.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/register_bloc.dart';
import '../bloc/register_confirm_password_changed.dart';
import '../bloc/register_password_changed.dart';
import '../bloc/register_shop_name_changed.dart';
import '../bloc/register_username_changed.dart';

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
        border: Border.all(color: AppColors.inputBorder, width: AppSize.size1),
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
        _buildPersonalInfoSection(context),
        SizedBox(height: AppSize.size20.h),
        _buildShopDetailsSection(context),
      ],
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context) {
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
          onChanged: (value) =>
              context.read<RegisterBloc>().add(RegisterNameChanged(value)),
        ),
        CustomTextField(
          label: AppStrings.register.usernameLabel,
          hintText: AppStrings.register.usernameHint,
          prefixIcon: Icon(
            Icons.account_circle_outlined,
            color: AppColors.textBody,
            size: AppSize.size20,
          ),
          onChanged: (value) =>
              context.read<RegisterBloc>().add(RegisterUsernameChanged(value)),
        ),
        CustomTextField(
          label: AppStrings.register.passwordLabel,
          hintText: AppStrings.register.passwordHint,
          obscureText: true,
          prefixIcon: Icon(
            Icons.lock_outline,
            color: AppColors.textBody,
            size: AppSize.size20,
          ),
          onChanged: (value) =>
              context.read<RegisterBloc>().add(RegisterPasswordChanged(value)),
        ),
        CustomTextField(
          label: AppStrings.register.confirmPasswordLabel,
          hintText: AppStrings.register.confirmPasswordHint,
          obscureText: true,
          prefixIcon: Icon(
            Icons.lock_reset_outlined,
            color: AppColors.textBody,
            size: AppSize.size20,
          ),
          onChanged: (value) => context.read<RegisterBloc>().add(
            RegisterConfirmPasswordChanged(value),
          ),
        ),
      ],
    );
  }

  Widget _buildShopDetailsSection(BuildContext context) {
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
          onChanged: (value) =>
              context.read<RegisterBloc>().add(RegisterShopNameChanged(value)),
        ),
      ],
    );
  }
}
