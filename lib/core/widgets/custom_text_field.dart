import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_size.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Generic labelled text field that follows the app design system.
///
/// Renders a label row (with optional trailing widget) above a styled
/// [TextField]. All sizes come from [AppSize] — no magic numbers.
class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final Widget? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;

  /// Optional widget placed at the right side of the label row
  /// (e.g. "Forgot Password?" link).
  final Widget? topTrailing;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.topTrailing,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelRow(),
        SizedBox(height: AppSize.size4.h),
        _buildInput(),
      ],
    );
  }

  Widget _buildLabelRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.label),
        if (topTrailing != null) topTrailing!,
      ],
    );
  }

  Widget _buildInput() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(AppSize.size8.r),
        border: Border.all(
          color: AppColors.inputBorder,
          width: AppSize.size1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F1722),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: TextField(
        obscureText: obscureText,
        onChanged: onChanged,
        style: AppTextStyles.input,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.inputHint,
          border: InputBorder.none,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSize.size16.w,
            vertical: AppSize.size12.h,
          ),
        ),
      ),
    );
  }
}
