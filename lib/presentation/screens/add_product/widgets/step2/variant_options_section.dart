import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/custom_text_field.dart';

class VariantOptionsSection extends StatelessWidget {
  const VariantOptionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Variant Options Definition',
          style: GoogleFonts.manrope(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
        SizedBox(height: AppSize.size16.h),

        // Option Group 1
        Container(
          padding: EdgeInsets.all(AppSize.size12.r),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(AppSize.size8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: 'Option Name',
                hintText: 'e.g. Color',
                topTrailing: Padding(
                  padding: const EdgeInsets.only(bottom: AppSize.size4),
                  child: GestureDetector(
                    child: SvgPicture.asset(
                      AppAssets.icTrash,
                      height: AppSize.size16.h,
                      width: AppSize.size16.w,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSize.size12.h),
              const CustomTextField(
                label: 'Option Values',
                hintText: 'Type and press enter...',
              ),
              SizedBox(height: AppSize.size8.h),
              Wrap(
                spacing: AppSize.size8.w,
                runSpacing: AppSize.size8.h,
                children: [_buildChip('Red'), _buildChip('Blue')],
              ),
            ],
          ),
        ),
        SizedBox(height: AppSize.size16.h),

        // Option Group 2
        Container(
          padding: EdgeInsets.all(AppSize.size12.r),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.divider),
            borderRadius: BorderRadius.circular(AppSize.size8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                topTrailing: Padding(
                  padding: const EdgeInsets.only(bottom: AppSize.size4),
                  child: GestureDetector(
                    child: SvgPicture.asset(
                      AppAssets.icTrash,
                      height: AppSize.size16.h,
                      width: AppSize.size16.w,
                    ),
                  ),
                ),
                label: 'Option Name',
                hintText: 'e.g. Size',
              ),
              SizedBox(height: AppSize.size12.h),
              const CustomTextField(
                label: 'Option Values',
                hintText: 'Type and press enter...',
              ),
              SizedBox(height: AppSize.size8.h),
              Wrap(
                spacing: AppSize.size8.w,
                runSpacing: AppSize.size8.h,
                children: [
                  _buildChip('Small'),
                  _buildChip('Medium'),
                  _buildChip('Large'),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: AppSize.size16.h),

        // Add Option Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add, size: 20.r, color: AppColors.primary),
            label: Text(
              'Add Another Option',
              style: GoogleFonts.manrope(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: AppSize.size12.h),
              side: BorderSide(color: AppColors.primary.withOpacity(0.5)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.size8.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.size12.w,
        vertical: AppSize.size6.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: AppSize.size4.w),
          Icon(Icons.close, size: 14.r, color: AppColors.primary),
        ],
      ),
    );
  }
}
