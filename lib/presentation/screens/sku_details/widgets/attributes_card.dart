import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';

class AttributesCard extends StatelessWidget {
  final SkuEntity sku;

  const AttributesCard({super.key, required this.sku});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(AppSize.size16.w),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.inputBorder)),
            ),
            child: Text(
              AppStrings.attributesTitle,
              style: AppTextStyles.cardTitle,
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(AppSize.size16.w),
            child: sku.attributes.isEmpty
                ? Center(
                    child: Text(
                      AppStrings.notAvailable,
                      style: AppTextStyles.body,
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: sku.attributes.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(height: AppSize.size16.h),
                    itemBuilder: (context, index) {
                      final attr = sku.attributes[index];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            attr.attributeName,
                            style: AppTextStyles.body.copyWith(
                              fontSize: 12.sp,
                            ),
                          ),
                          Text(
                            attr.value,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.textHeading,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
