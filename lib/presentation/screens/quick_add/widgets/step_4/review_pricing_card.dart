import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

/// Card summarizing pricing details (Selling Price, Cost Price, and calculated margin percentage).
class ReviewPricingCard extends StatelessWidget {
  const ReviewPricingCard({
    super.key,
    required this.sellingPriceText,
    required this.costPriceText,
    required this.marginText,
    required this.onEdit,
  });

  final String sellingPriceText;
  final String costPriceText;
  final String marginText;
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
                    Icons.payments_outlined,
                    size: 18.r,
                    color: AppColors.subtitle,
                  ),
                  SizedBox(width: AppSize.size8.w),
                  Text(
                    'PRICING',
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

          // Selling Price row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selling Price',
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subtitle,
                ),
              ),
              Text(
                sellingPriceText,
                style: GoogleFonts.manrope(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.size8.h),

          // Cost Price row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cost Price',
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subtitle,
                ),
              ),
              Text(
                costPriceText,
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

          // Margin row (green/teal)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Margin',
                style: GoogleFonts.manrope(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                marginText,
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
