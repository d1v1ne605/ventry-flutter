import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/utils/string_utils.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';

class SkuHeroCard extends StatelessWidget {
  final SkuEntity sku;

  const SkuHeroCard({super.key, required this.sku});

  @override
  Widget build(BuildContext context) {
    final attributesText = sku.attributes.isNotEmpty
        ? sku.attributes.map((e) => e.value).join(' / ')
        : '';
    final primaryImageUrl = StringUtils.isSafeNetworkUrl(sku.primaryImageUrl)
        ? sku.primaryImageUrl
        : null;
    final validImageUrls = sku.imageUrls
        .where(StringUtils.isSafeNetworkUrl)
        .toList(growable: false);

    return Container(
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Image
              Container(
                width: 134.w,
                height: 126.h,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSize.size8.r),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: primaryImageUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.size8.r),
                        child: Image.network(
                          primaryImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.image_not_supported,
                            color: AppColors.navInactive,
                          ),
                        ),
                      )
                    : Image.asset(AppAssets.imgPlaceHolder, fit: BoxFit.cover),
              ),
              SizedBox(width: AppSize.size8.w),
              // Thumbnails
              if (validImageUrls.isNotEmpty)
                Expanded(
                  child: Wrap(
                    spacing: AppSize.size8.w,
                    runSpacing: AppSize.size8.h,
                    children: List.generate(validImageUrls.length, (index) {
                      final isSelected = index == 0;
                      return Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSize.size8.r),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.inputBorder,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppSize.size6.r),
                          child: Image.network(
                            validImageUrls[index],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.image_not_supported,
                              size: AppSize.size16,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
          SizedBox(height: AppSize.size16.h),
          Text(sku.spuName, style: AppTextStyles.heading1),
          if (attributesText.isNotEmpty) ...[
            SizedBox(height: AppSize.size4.h),
            Text(
              attributesText,
              style: AppTextStyles.label.copyWith(
                color: const Color(
                  0xFF0088FF,
                ), // Specific color for attributes like design
              ),
            ),
          ] else if (sku.skuCode != null) ...[
            SizedBox(height: AppSize.size4.h),
            Text(
              sku.skuCode!,
              style: AppTextStyles.label.copyWith(
                color: const Color(0xFF0088FF),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
