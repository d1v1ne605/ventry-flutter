import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';

class SkuFormDescriptionCard extends StatelessWidget {
  const SkuFormDescriptionCard({
    super.key,
    required this.controller,
    required this.tags,
    required this.isExpanded,
    required this.onDescriptionChanged,
    required this.onToggleExpanded,
  });

  final TextEditingController controller;
  final List<String> tags;
  final bool isExpanded;
  final ValueChanged<String> onDescriptionChanged;
  final VoidCallback onToggleExpanded;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.size16.w),
      decoration: BoxDecoration(
        color: AppColors.skuFormCardBackground,
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onToggleExpanded,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.skuFormDescription,
                  style: AppTextStyles.skuFormSectionTitle,
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.subtitle,
                  size: AppSize.size20.r,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSize.size16.h),
          Container(height: 1.h, color: AppColors.inputBorder),
          if (isExpanded) ...[
            SizedBox(height: AppSize.size16.h),
            TextField(
              controller: controller,
              maxLines: 4,
              onChanged: onDescriptionChanged,
              style: AppTextStyles.skuFormFieldValue,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(AppSize.size12.w),
                enabledBorder: _border,
                focusedBorder: _border,
              ),
            ),
            if (tags.isNotEmpty) ...[
              SizedBox(height: AppSize.size16.h),
              Wrap(
                spacing: AppSize.size8.w,
                runSpacing: AppSize.size8.h,
                children: tags
                    .map(
                      (tag) => Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSize.size12.w,
                          vertical: AppSize.size6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppSize.size16.r),
                          border: Border.all(color: AppColors.skuFormTagBorder),
                        ),
                        child: Text(tag, style: AppTextStyles.skuFormTag),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ],
      ),
    );
  }

  OutlineInputBorder get _border => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSize.size12.r),
    borderSide: const BorderSide(color: AppColors.skuFormFieldBorder),
  );
}
