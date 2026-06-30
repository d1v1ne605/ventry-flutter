import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/utils/string_utils.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';

class EditSkuMediaCard extends StatelessWidget {
  const EditSkuMediaCard({
    super.key,
    required this.attributeItems,
    required this.imageUrls,
    required this.onEditAttributesTap,
    required this.onEditMediaTap,
  });

  final List<SkuAttributeEntity> attributeItems;
  final List<String> imageUrls;
  final VoidCallback onEditAttributesTap;
  final VoidCallback onEditMediaTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _EditSkuSectionCard(
          title: AppStrings.editSkuAttributes,
          actionLabel: AppStrings.editSkuEdit,
          actionIcon: Icons.edit_outlined,
          onActionTap: onEditAttributesTap,
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (attributeItems.isEmpty) {
                return Text(AppStrings.notAvailable, style: AppTextStyles.body);
              }

              final itemWidth = (constraints.maxWidth - AppSize.size8.w) / 2;
              return Wrap(
                spacing: AppSize.size8.w,
                runSpacing: AppSize.size8.h,
                children: attributeItems
                    .map(
                      (item) => SizedBox(
                        width: itemWidth,
                        child: _EditSkuAttributeTile(item: item),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
        SizedBox(height: 20.h),
        _EditSkuSectionCard(
          title: AppStrings.editSkuMedia,
          actionLabel: AppStrings.editSkuManage,
          actionIcon: Icons.photo_library_outlined,
          onActionTap: onEditMediaTap,
          child: Row(
            children: [
              _EditSkuImageTile(
                imageUrl: imageUrls.isNotEmpty ? imageUrls.first : null,
                showBadge: true,
              ),
              SizedBox(width: AppSize.size8.w),
              _EditSkuImageTile(
                imageUrl: imageUrls.length > 1 ? imageUrls[1] : null,
              ),
              SizedBox(width: AppSize.size8.w),
              const _EditSkuAddImageTile(),
            ],
          ),
        ),
      ],
    );
  }
}

class _EditSkuSectionCard extends StatelessWidget {
  const _EditSkuSectionCard({
    required this.title,
    required this.actionLabel,
    required this.actionIcon,
    required this.onActionTap,
    required this.child,
  });

  final String title;
  final String actionLabel;
  final IconData actionIcon;
  final VoidCallback onActionTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.size16.w),
      decoration: BoxDecoration(
        color: AppColors.editSkuCardBackground,
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.editSkuSectionTitle),
              OutlinedButton.icon(
                onPressed: onActionTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textHeading,
                  side: const BorderSide(color: Color(0xFF6B7280)),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size12.w,
                    vertical: AppSize.size8.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.size8.r),
                  ),
                ),
                icon: Icon(actionIcon, size: AppSize.size16.r),
                label: Text(
                  actionLabel,
                  style: AppTextStyles.editSkuButtonLabel,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.size16.h),
          child,
        ],
      ),
    );
  }
}

class _EditSkuAttributeTile extends StatelessWidget {
  const _EditSkuAttributeTile({required this.item});

  final SkuAttributeEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.size8.w),
      decoration: BoxDecoration(
        color: AppColors.editSkuSoftBackground,
        borderRadius: BorderRadius.circular(AppSize.size8.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.attributeName, style: AppTextStyles.editSkuFieldLabel),
          SizedBox(height: AppSize.size4.h),
          Text(
            item.value,
            style: AppTextStyles.editSkuButtonLabel.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditSkuImageTile extends StatelessWidget {
  const _EditSkuImageTile({this.imageUrl, this.showBadge = false});

  final String? imageUrl;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final safeImageUrl = StringUtils.isSafeNetworkUrl(imageUrl)
        ? imageUrl
        : null;

    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.size8.r),
                border: Border.all(color: AppColors.inputBorder),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000),
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.size8.r),
                child: safeImageUrl == null
                    ? Image.asset(AppAssets.imgPlaceHolder, fit: BoxFit.cover)
                    : Image.network(
                        safeImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) {
                          return Image.asset(
                            AppAssets.imgPlaceHolder,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
              ),
            ),
            if (showBadge)
              Positioned(
                left: AppSize.size8.w,
                top: AppSize.size8.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size8.w,
                    vertical: AppSize.size4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppSize.size4.r),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Text(
                    'Main',
                    style: AppTextStyles.editSkuFieldLabel.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EditSkuAddImageTile extends StatelessWidget {
  const _EditSkuAddImageTile();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.editSkuSoftBackground,
            borderRadius: BorderRadius.circular(AppSize.size8.r),
            border: Border.all(
              color: AppColors.inputBorder,
              width: AppSize.size2,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: AppColors.textBody,
                size: AppSize.size24.r,
              ),
              SizedBox(height: AppSize.size8.h),
              Text(
                AppStrings.editSkuAddImage,
                style: AppTextStyles.editSkuFieldLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
