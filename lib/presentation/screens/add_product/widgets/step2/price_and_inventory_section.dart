import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/custom_text_field.dart';

class PriceAndInventorySection extends StatelessWidget {
  const PriceAndInventorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: AppColors.heading,
              size: 20.r,
            ),
            SizedBox(width: AppSize.size8.w),
            Text(
              'Price & Inventory',
              style: GoogleFonts.manrope(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSize.size16.h),
        const CustomTextField(label: 'Selling Price', hintText: 'e.g. 10.00'),
        SizedBox(height: AppSize.size16.h),
        const CustomTextField(label: 'Cost Price', hintText: 'e.g. 5.00'),
        SizedBox(height: AppSize.size16.h),
        const CustomTextField(label: 'Stock Quantity', hintText: '0'),
      ],
    );
  }
}
