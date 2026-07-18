import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventry_flutter/presentation/screens/login/bloc/login_event.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/login_bloc.dart';
import 'login_button.dart';

/// Displays the login form: email field, password field, and submit button.
///
/// All labels, hints, and spacing come from [AppStrings] / [AppSize].
class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildEmailField(context),
        SizedBox(height: AppSize.size24.h),
        _buildPasswordField(context),
        SizedBox(height: AppSize.size32.h),
        const LoginButton(),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return CustomTextField(
      label: AppStrings.login.emailLabel,
      hintText: AppStrings.login.emailHint,
      prefixIcon: Icon(
        Icons.email_outlined,
        color: AppColors.textBody,
        size: AppSize.size20,
      ),
      onChanged: (val) => context.read<LoginBloc>().add(LoginEmailChanged(val)),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return CustomTextField(
      label: AppStrings.login.passwordLabel,
      hintText: AppStrings.login.passwordHint,
      obscureText: true,
      prefixIcon: Icon(
        Icons.lock_outline,
        color: AppColors.textBody,
        size: AppSize.size20,
      ),
      topTrailing: _buildForgotPasswordLink(),
      onChanged: (val) =>
          context.read<LoginBloc>().add(LoginPasswordChanged(val)),
    );
  }

  Widget _buildForgotPasswordLink() {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to Forgot Password screen
      },
      child: Text(
        AppStrings.login.forgotPassword,
        style: AppTextStyles.linkSmall,
      ),
    );
  }
}
