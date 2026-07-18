import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/utils/string_utils.dart';
import 'package:ventry_flutter/core/widgets/app_zoomable_image.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';

class SkuHeroCard extends StatefulWidget {
  final SkuEntity sku;

  const SkuHeroCard({super.key, required this.sku});

  @override
  State<SkuHeroCard> createState() => _SkuHeroCardState();
}

class _SkuHeroCardState extends State<SkuHeroCard> {
  String? _selectedImageUrl;

  @override
  void didUpdateWidget(covariant SkuHeroCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sku.uid != widget.sku.uid ||
        oldWidget.sku.imageUrls != widget.sku.imageUrls) {
      _selectedImageUrl = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sku = widget.sku;
    final attributesText = sku.attributes.isNotEmpty
        ? sku.attributes.map((e) => e.value).join(' / ')
        : '';
    final safePrimaryImageUrl =
        StringUtils.isSafeNetworkUrl(sku.primaryImageUrl)
        ? sku.primaryImageUrl
        : null;
    final galleryImageUrls = {
      if (safePrimaryImageUrl != null) safePrimaryImageUrl,
      ...sku.imageUrls.where(StringUtils.isSafeNetworkUrl),
    }.toList(growable: false);
    final selectedImageUrl = galleryImageUrls.contains(_selectedImageUrl)
        ? _selectedImageUrl
        : null;
    final mainImageUrl =
        selectedImageUrl ??
        (galleryImageUrls.isNotEmpty ? galleryImageUrls.first : null);

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
                child: AppZoomableImage(
                  imageUrl: mainImageUrl,
                  width: 134.w,
                  height: 126.h,
                  backgroundColor: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSize.size8.r),
                  placeholder: Image.asset(
                    AppAssets.imgPlaceHolder,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: AppSize.size8.w),
              // Thumbnails
              if (galleryImageUrls.isNotEmpty)
                Expanded(
                  child: Wrap(
                    spacing: AppSize.size8.w,
                    runSpacing: AppSize.size8.h,
                    children: List.generate(galleryImageUrls.length, (index) {
                      final imageUrl = galleryImageUrls[index];
                      final isSelected = imageUrl == mainImageUrl;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedImageUrl = imageUrl;
                          });
                        },
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(
                              AppSize.size8.r,
                            ),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.inputBorder,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppSize.size6.r,
                            ),
                            child: Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  Image.asset(AppAssets.imgPlaceHolder),
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
