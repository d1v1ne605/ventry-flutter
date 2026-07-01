import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/utils/string_utils.dart';

class EditSkuImageGalleryTile extends StatelessWidget {
  const EditSkuImageGalleryTile({
    super.key,
    required this.previewPath,
    required this.onRemove,
    this.isCover = false,
    this.height,
    this.isLocalFile = false,
  });

  final String previewPath;
  final VoidCallback onRemove;
  final bool isCover;
  final double? height;
  final bool isLocalFile;

  @override
  Widget build(BuildContext context) {
    final safeImageUrl = StringUtils.isSafeNetworkUrl(previewPath)
        ? previewPath
        : null;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        border: Border.all(color: AppColors.inputBorder),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (isLocalFile)
              Image.file(
                File(previewPath),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Image.asset(
                    AppAssets.imgPlaceHolder,
                    fit: BoxFit.cover,
                  );
                },
              )
            else if (safeImageUrl != null)
              Image.network(
                safeImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return Image.asset(
                    AppAssets.imgPlaceHolder,
                    fit: BoxFit.cover,
                  );
                },
              )
            else
              Image.asset(AppAssets.imgPlaceHolder, fit: BoxFit.cover),
            if (isCover)
              Positioned(
                left: AppSize.size8.w,
                bottom: AppSize.size8.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size8.w,
                    vertical: AppSize.size4.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(AppSize.size4.r),
                  ),
                  child: Text(
                    AppStrings.editSkuCover,
                    style: AppTextStyles.editSkuFieldLabel.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            Positioned(
              top: AppSize.size8.h,
              right: AppSize.size8.w,
              child: Material(
                color: Colors.white.withValues(alpha: 0.92),
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onRemove,
                  customBorder: const CircleBorder(),
                  child: Padding(
                    padding: EdgeInsets.all(AppSize.size6.r),
                    child: Icon(
                      Icons.close,
                      size: AppSize.size14.r,
                      color: AppColors.textHeading,
                    ),
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
