import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_size.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Generic labelled text field that follows the app design system.
///
/// When [obscureText] is true an eye-icon toggle is automatically added
/// as a suffixIcon so the user can reveal/hide the value.
/// All sizes come from [AppSize] — no magic numbers.
class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final Widget? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;

  /// Optional widget placed at the right side of the label row
  /// (e.g. "Forgot Password?" link).
  final Widget? topTrailing;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final int? maxLines;
  final int? minLines;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final bool isRequired;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.topTrailing,
    this.onChanged,
    this.controller,
    this.maxLines = 1,
    this.minLines,
    this.textInputAction,
    this.focusNode,
    this.isRequired = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  void _toggleVisibility() => setState(() => _obscured = !_obscured);

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
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.label, style: AppTextStyles.label),
            if (widget.isRequired) ...[
              SizedBox(width: AppSize.size4.w),
              Text(
                '*',
                style: AppTextStyles.label.copyWith(
                  color: const Color(0xFFEF4444), // Red-500
                ),
              ),
            ],
          ],
        ),
        if (widget.topTrailing != null) widget.topTrailing!,
      ],
    );
  }

  Widget _buildInput() {
    // If the caller passes an explicit suffixIcon, use it;
    // otherwise, for password fields, auto-generate the eye toggle.
    Widget? effectiveSuffix = widget.suffixIcon;
    if (effectiveSuffix == null && widget.obscureText) {
      effectiveSuffix = IconButton(
        onPressed: _toggleVisibility,
        icon: Icon(
          _obscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: AppColors.textBody,
          size: AppSize.size20,
        ),
        splashRadius: AppSize.size20,
      );
    }

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
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: _obscured,
        onChanged: widget.onChanged,
        style: AppTextStyles.input,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        textInputAction: widget.textInputAction,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: AppTextStyles.inputHint,
          border: InputBorder.none,
          prefixIcon: widget.prefixIcon,
          suffixIcon: effectiveSuffix,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppSize.size16.w,
            vertical: AppSize.size12.h,
          ),
        ),
      ),
    );
  }
}
