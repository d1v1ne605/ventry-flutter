import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/utils/string_utils.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/models/editable_sku_form_image.dart';

class SkuFormMediaCard extends StatelessWidget {
  const SkuFormMediaCard({
    super.key,
    required this.attributeItems,
    required this.imageItems,
    required this.onEditAttributesTap,
    required this.onEditMediaTap,
  });

  final List<SkuAttributeEntity> attributeItems;
  final List<EditableSkuFormImage> imageItems;
  final VoidCallback onEditAttributesTap;
  final VoidCallback onEditMediaTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SkuFormSectionCard(
          title: AppStrings.skuFormAttributes,
          actionLabel: AppStrings.skuFormEdit,
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
                        child: _SkuFormAttributeTile(item: item),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ),
        SizedBox(height: AppSize.size20.h),
        _SkuFormSectionCard(
          title: AppStrings.skuFormMedia,
          actionLabel: AppStrings.skuFormManage,
          actionIcon: Icons.photo_library_outlined,
          onActionTap: onEditMediaTap,
          child: Row(
            children: [
              _SkuFormImageTile(
                image: imageItems.isNotEmpty ? imageItems.first : null,
                showBadge: true,
              ),
              SizedBox(width: AppSize.size8.w),
              _SkuFormImageTile(
                image: imageItems.length > 1 ? imageItems[1] : null,
              ),
              SizedBox(width: AppSize.size8.w),
              const _SkuFormAddImageTile(),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkuFormSectionCard extends StatelessWidget {
  const _SkuFormSectionCard({
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
        color: AppColors.skuFormCardBackground,
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppTextStyles.skuFormSectionTitle),
              OutlinedButton.icon(
                onPressed: onActionTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textHeading,
                  side: const BorderSide(color: AppColors.skuFormActionBorder),
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
                  style: AppTextStyles.skuFormButtonLabel,
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

class _SkuFormAttributeTile extends StatelessWidget {
  const _SkuFormAttributeTile({required this.item});

  final SkuAttributeEntity item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.size8.w),
      decoration: BoxDecoration(
        color: AppColors.skuFormSoftBackground,
        borderRadius: BorderRadius.circular(AppSize.size8.r),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.attributeName, style: AppTextStyles.skuFormFieldLabel),
          SizedBox(height: AppSize.size4.h),
          Text(
            item.value,
            style: AppTextStyles.skuFormButtonLabel.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkuFormImageTile extends StatelessWidget {
  const _SkuFormImageTile({this.image, this.showBadge = false});

  final EditableSkuFormImage? image;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final image = this.image;
    final safeImageUrl =
        image != null &&
            !image.isLocalFile &&
            StringUtils.isSafeNetworkUrl(image.previewPath)
        ? image.previewPath
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
                    color: AppColors.skuFormImageShadow,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.size8.r),
                child: _buildImage(image, safeImageUrl),
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
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSize.size4.r),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: Text(
                    AppStrings.skuFormMainImageBadge,
                    style: AppTextStyles.skuFormFieldLabel.copyWith(
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

  Widget _buildImage(EditableSkuFormImage? image, String? safeImageUrl) {
    if (image == null) {
      return Image.asset(AppAssets.imgPlaceHolder, fit: BoxFit.cover);
    }

    if (image.isLocalFile) {
      return Image.file(File(image.previewPath), fit: BoxFit.cover);
    }

    if (safeImageUrl == null) {
      return Image.asset(AppAssets.imgPlaceHolder, fit: BoxFit.cover);
    }

    return Image.network(
      safeImageUrl,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Image.asset(AppAssets.imgPlaceHolder, fit: BoxFit.cover);
      },
    );
  }
}

class _SkuFormAddImageTile extends StatelessWidget {
  const _SkuFormAddImageTile();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.skuFormSoftBackground,
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
                AppStrings.skuFormAddImage,
                style: AppTextStyles.skuFormFieldLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
