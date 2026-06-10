import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_email_changed.dart';
import '../bloc/login_password_changed.dart';
import 'login_button.dart';

/// Displays the login form: email field, password field, and submit button.
///
/// Each field is built via private methods to keep a single widget class
/// while still separating visual concerns logically.
class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildEmailField(context),
        SizedBox(height: 24.h),
        _buildPasswordField(context),
        SizedBox(height: 32.h),
        const LoginButton(),
      ],
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return CustomTextField(
      label: 'Email Address',
      hintText: 'admin@storagepro.com',
      prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF64748B)),
      onChanged: (val) =>
          context.read<LoginBloc>().add(LoginEmailChanged(val)),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return CustomTextField(
      label: 'Password',
      hintText: '••••••••',
      obscureText: true,
      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF64748B)),
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
      child: Text('Forgot Password?', style: AppTextStyles.linkSmall),
    );
  }
}
