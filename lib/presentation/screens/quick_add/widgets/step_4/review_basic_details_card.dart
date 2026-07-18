import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

/// Card summarizing the basic details of the product (Name, Category, SKU, and image).
class ReviewBasicDetailsCard extends StatelessWidget {
  const ReviewBasicDetailsCard({
    super.key,
    required this.name,
    required this.sku,
    required this.category,
    required this.onEdit,
  });

  final String name;
  final String sku;
  final String category;
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mock Image Container
          Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(AppSize.size8.r),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Icon(
              Icons.chair_rounded, // Premium placeholder icon
              size: 32.r,
              color: AppColors.primary.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(width: AppSize.size12.w),

          // Details column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label & Edit button row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'BASIC DETAILS',
                      style: GoogleFonts.manrope(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.subtitle,
                        letterSpacing: 0.5,
                      ),
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
                SizedBox(height: AppSize.size2.h),

                // Product Name
                Text(
                  name,
                  style: GoogleFonts.manrope(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                  ),
                ),
                SizedBox(height: AppSize.size8.h),

                // SKU & Category Pills Row
                Row(
                  children: [
                    // SKU Pill
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.size8.w,
                        vertical: AppSize.size4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(AppSize.size4.r),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.manrope(
                            fontSize: 10.sp,
                            color: AppColors.subtitle,
                          ),
                          children: [
                            const TextSpan(text: 'SKU '),
                            TextSpan(
                              text: sku,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.size8.w),

                    // Category Pill
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.size8.w,
                        vertical: AppSize.size4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(AppSize.size4.r),
                      ),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.manrope(
                            fontSize: 10.sp,
                            color: AppColors.subtitle,
                          ),
                          children: [
                            const TextSpan(text: 'CATEGORY '),
                            TextSpan(
                              text: category,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
