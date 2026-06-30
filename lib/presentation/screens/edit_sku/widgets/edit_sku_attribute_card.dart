import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/models/editable_sku_attribute.dart';

class EditSkuAttributeCard extends StatelessWidget {
  const EditSkuAttributeCard({
    super.key,
    required this.attribute,
    required this.controller,
    required this.onChanged,
    required this.onDelete,
  });

  final EditableSkuAttribute attribute;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.size16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  attribute.name,
                  style: AppTextStyles.editSkuSectionTitle.copyWith(
                    color: AppColors.textHeading,
                  ),
                ),
              ),
              IconButton(
                onPressed: onDelete,
                splashRadius: AppSize.size20.r,
                icon: Icon(
                  Icons.delete_outline,
                  size: AppSize.size20.r,
                  color: AppColors.subtitle,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.size8.h),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 200.w),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTextStyles.editSkuFieldValue,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: AppColors.inputFill,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppSize.size12.w,
                  vertical: AppSize.size12.h,
                ),
                enabledBorder: _border,
                focusedBorder: _border,
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder get _border => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSize.size8.r),
    borderSide: const BorderSide(color: AppColors.inputBorder),
  );
}
