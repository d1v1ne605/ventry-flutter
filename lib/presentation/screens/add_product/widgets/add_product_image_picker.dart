import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/dashed_border_painter.dart';
import 'dart:io';

class AddProductImagePicker extends StatelessWidget {
  const AddProductImagePicker({
    super.key,
    required this.label,
    required this.imagePaths,
    required this.onTap,
    this.isUploading = false,
    this.onRemoveImage,
  });

  final String label;
  final List<String> imagePaths;
  final VoidCallback onTap;
  final bool isUploading;
  final void Function(int index)? onRemoveImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: AppSize.size14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textHeading,
          ),
        ),
        SizedBox(height: AppSize.size8.h),
        _buildPrimaryImage(),
        SizedBox(height: AppSize.size12.h),
        _buildSecondaryRow(),
        if (isUploading) ...[
          SizedBox(height: AppSize.size12.h),
          LinearProgressIndicator(
            minHeight: 4.h,
            backgroundColor: AppColors.divider,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ],
      ],
    );
  }

  Widget _buildPrimaryImage() {
    if (imagePaths.isEmpty) {
      return _buildDashedBox(
        width: double.infinity,
        height: 160.h,
        iconSize: 32.r,
        text: AppStrings.addProductImageHint,
        onTap: onTap,
      );
    } else {
      return _buildImageCard(0, width: double.infinity, height: 160.h);
    }
  }

  Widget _buildSecondaryRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = AppSize.size12.w;
        // Calculate width for 4 items per row
        final itemWidth = (constraints.maxWidth - (spacing * 3)) / 4;

        final secondaryCount = imagePaths.length > 1
            ? imagePaths.length - 1
            : 0;
        // Always show at least 4 boxes total
        final totalBoxes = secondaryCount >= 4 ? secondaryCount + 1 : 4;

        return Wrap(
          spacing: spacing,
          runSpacing: AppSize.size12.h,
          children: List.generate(totalBoxes, (index) {
            final imageIndex = index + 1;
            if (imageIndex < imagePaths.length) {
              return _buildImageCard(
                imageIndex,
                width: itemWidth,
                height: itemWidth,
              );
            } else {
              return _buildDashedBox(
                width: itemWidth,
                height: itemWidth,
                iconSize: 24.r,
                onTap: onTap,
              );
            }
          }),
        );
      },
    );
  }

  Widget _buildDashedBox({
    required double width,
    required double height,
    required double iconSize,
    String? text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: AppColors.inputBorder,
          radius: AppSize.size8.r,
          dashWidth: 4,
          dashGap: 4,
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: iconSize,
                color: AppColors.subtitle,
              ),
              if (text != null) ...[
                SizedBox(height: AppSize.size4.h),
                Text(
                  text,
                  style: GoogleFonts.manrope(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.subtitle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(
    int index, {
    required double width,
    required double height,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSize.size8.r),
            border: Border.all(color: AppColors.divider),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.size8.r),
            child: Image.file(
              File(imagePaths[index]),
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          ),
        ),
        if (onRemoveImage != null)
          Positioned(
            top: -6.h,
            right: -6.w,
            child: GestureDetector(
              onTap: () => onRemoveImage!(index),
              child: Container(
                padding: EdgeInsets.all(AppSize.size2.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 16.r,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
