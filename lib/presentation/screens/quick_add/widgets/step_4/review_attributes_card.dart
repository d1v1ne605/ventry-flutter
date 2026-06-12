import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

/// Card summarizing the attributes and variants (Color, Material, Generated SKUs, and sync Status).
class ReviewAttributesCard extends StatelessWidget {
  const ReviewAttributesCard({
    super.key,
    required this.colorText,
    required this.materialText,
    required this.variantsCount,
    required this.statusText,
    required this.onEdit,
  });

  final String colorText;
  final String materialText;
  final int variantsCount;
  final String statusText;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.size16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        boxShadow: AppColors.cardShadows,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Icon + Title ... Edit Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 18.r,
                    color: AppColors.subtitle,
                  ),
                  SizedBox(width: AppSize.size8.w),
                  Text(
                    'ATTRIBUTES & VARIANTS',
                    style: GoogleFonts.manrope(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.subtitle,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: onEdit,
                child: Icon(
                  Icons.edit_outlined,
                  size: 18.r,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.size12.h),

          // Color row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Color',
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subtitle,
                ),
              ),
              Text(
                colorText,
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.heading,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.size8.h),

          // Material row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Material',
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subtitle,
                ),
              ),
              Text(
                materialText,
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.heading,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.size10.h),

          // Divider
          Divider(
            color: AppColors.divider,
            thickness: 1.0,
            height: AppSize.size1.h,
          ),
          SizedBox(height: AppSize.size10.h),

          // Generated Variants row (teal/green)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Generated Variants',
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subtitle,
                ),
              ),
              Text(
                '$variantsCount SKUs',
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.size8.h),

          // Status row (teal/green)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status',
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subtitle,
                ),
              ),
              Text(
                statusText,
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
