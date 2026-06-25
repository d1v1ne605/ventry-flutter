import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

class SkuPreviewSection extends StatelessWidget {
  const SkuPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.size16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F1722),
            offset: Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SKU Preview',
                style: GoogleFonts.manrope(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size8.w,
                  vertical: AppSize.size4.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSize.size4.r),
                ),
                child: Text(
                  '4 Variants',
                  style: GoogleFonts.manrope(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.size16.h),
          _buildPreviewItem('Black - 128GB', '1000.00', '10'),
          _buildPreviewItem('Black - 256GB', '1100.00', '10'),
          _buildPreviewItem('White - 128GB', '1000.00', '5'),
          _buildPreviewItem('White - 256GB', '1100.00', '5'),
        ],
      ),
    );
  }

  Widget _buildPreviewItem(String name, String price, String stock) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.size8.h),
      padding: EdgeInsets.all(AppSize.size12.r),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(AppSize.size8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                  ),
                ),
                SizedBox(height: AppSize.size4.h),
                Row(
                  children: [
                    Text(
                      'Price: \$$price',
                      style: GoogleFonts.manrope(
                        fontSize: 12.sp,
                        color: AppColors.subtitle,
                      ),
                    ),
                    SizedBox(width: AppSize.size12.w),
                    Text(
                      'Stock: $stock',
                      style: GoogleFonts.manrope(
                        fontSize: 12.sp,
                        color: AppColors.subtitle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.edit_outlined,
              color: AppColors.primary,
              size: 20.r,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              AppAssets.icTrash,
              width: AppSize.size20.w,
              height: AppSize.size20.h,
              colorFilter: ColorFilter.mode(AppColors.error, BlendMode.srcIn),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
