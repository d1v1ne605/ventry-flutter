import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';

class EditSkuInputField extends StatelessWidget {
  const EditSkuInputField({
    super.key,
    required this.label,
    required this.controller,
    this.suffixIcon,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
    this.inputFormatters,
  });

  final String label;
  final TextEditingController controller;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.editSkuFieldLabel),
        SizedBox(height: AppSize.size4.h),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChanged,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: AppTextStyles.editSkuFieldValue,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSize.size12.w,
              vertical: AppSize.size12.h,
            ),
            enabledBorder: _border,
            focusedBorder: _border,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  OutlineInputBorder get _border => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSize.size8.r),
    borderSide: const BorderSide(color: AppColors.editSkuFieldBorder),
  );
}
