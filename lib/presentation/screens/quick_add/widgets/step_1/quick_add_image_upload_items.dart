import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/dashed_border_painter.dart';

class UploadBox extends StatelessWidget {
  const UploadBox({super.key, this.imagePath, this.onRemove});

  final String? imagePath;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 120.h,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSize.size8.r),
          ),
          child: CustomPaint(
            painter: DashedBorderPainter(
              color: AppColors.inputBorder,
              radius: AppSize.size8.r,
              dashWidth: 6,
              dashGap: 4,
            ),
            child: imagePath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.size8.r),
                    child: Image.asset(
                      imagePath!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  )
                : const UploadPlaceholder(),
          ),
        ),
        if (onRemove != null)
          Positioned(
            top: 4.h,
            right: 4.w,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.outOfStockDot,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 16.r,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class ImagePreviewItem extends StatelessWidget {
  const ImagePreviewItem({super.key, required this.imagePath, this.onRemove});

  final String imagePath;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 64.r,
          height: 64.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.size8.r),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.size8.r),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
        if (onRemove != null)
          Positioned(
            top: -4,
            right: -4,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(2.r),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.outOfStockDot,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 12.r,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class AddMoreBox extends StatelessWidget {
  const AddMoreBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64.r,
      height: 64.r,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size8.r),
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: AppColors.primary,
          radius: AppSize.size8.r,
          dashWidth: 4,
          dashGap: 3,
        ),
        child: Center(
          child: Icon(Icons.add_rounded, size: 24.r, color: AppColors.primary),
        ),
      ),
    );
  }
}

class EmptySmallBox extends StatelessWidget {
  const EmptySmallBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64.r,
      height: 64.r,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size8.r),
      ),
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: AppColors.inputBorder,
          radius: AppSize.size8.r,
          dashWidth: 4,
          dashGap: 3,
        ),
      ),
    );
  }
}

class UploadPlaceholder extends StatelessWidget {
  const UploadPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: AppColors.cardIconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.cloud_upload_outlined,
            size: 22.r,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: AppSize.size8.h),
        Text(
          AppStrings.quickAddTapToUploadImages,
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.subtitle,
          ),
        ),
      ],
    );
  }
}
