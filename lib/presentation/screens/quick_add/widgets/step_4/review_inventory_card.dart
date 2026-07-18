import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

/// Card summarizing inventory details (Initial Stock, Low Stock Alert, and Location).
class ReviewInventoryCard extends StatelessWidget {
  const ReviewInventoryCard({
    super.key,
    required this.initialStockText,
    required this.lowStockAlertText,
    required this.locationText,
    required this.onEdit,
  });

  final String initialStockText;
  final String lowStockAlertText;
  final String locationText;
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
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 18.r,
                    color: AppColors.subtitle,
                  ),
                  SizedBox(width: AppSize.size8.w),
                  Text(
                    'INVENTORY',
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

          // Initial Stock row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Initial Stock',
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subtitle,
                ),
              ),
              Text(
                initialStockText,
                style: GoogleFonts.manrope(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.size8.h),

          // Low Stock Alert row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Low Stock Alert',
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subtitle,
                ),
              ),
              Text(
                lowStockAlertText,
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.subtitle,
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

          // Location row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Location',
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subtitle,
                ),
              ),
              Text(
                locationText,
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.heading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
