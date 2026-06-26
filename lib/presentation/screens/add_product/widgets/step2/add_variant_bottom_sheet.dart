import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/custom_text_field.dart';

class AddVariantBottomSheet extends StatelessWidget {
  const AddVariantBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSize.size24.r),
          topRight: Radius.circular(AppSize.size24.r),
        ),
      ),
      padding: EdgeInsets.only(
        left: AppSize.size24.w,
        right: AppSize.size24.w,
        top: AppSize.size16.h,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppSize.size32.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: AppSize.size48.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
          ),
          SizedBox(height: AppSize.size24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.addCustomVariant,
                style: GoogleFonts.manrope(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.heading,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: AppColors.heading, size: 24.r),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SizedBox(height: AppSize.size24.h),
          
          Flexible(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppStrings.variantAttributes,
                    style: GoogleFonts.manrope(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: AppSize.size12.h),
                  const CustomTextField(
                    label: AppStrings.colorLabel,
                    hintText: AppStrings.colorHint,
                  ),
                  SizedBox(height: AppSize.size12.h),
                  const CustomTextField(
                    label: AppStrings.storageLabel,
                    hintText: AppStrings.storageHint,
                  ),
                  SizedBox(height: AppSize.size24.h),
                  const Divider(color: AppColors.divider),
                  SizedBox(height: AppSize.size24.h),
                  
                  Text(
                    AppStrings.logisticsAndPricing,
                    style: GoogleFonts.manrope(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: AppSize.size12.h),
                  const CustomTextField(
                    label: AppStrings.skuCodeLabel,
                    hintText: AppStrings.skuCodeExampleHint,
                  ),
                  SizedBox(height: AppSize.size12.h),
                  const CustomTextField(
                    label: AppStrings.barcodeLabel,
                    hintText: AppStrings.barcodeScanHint2,
                  ),
                  SizedBox(height: AppSize.size12.h),
                  Row(
                    children: [
                      const Expanded(
                        child: CustomTextField(
                          label: AppStrings.quickAddStep2CostPriceLabel,
                          hintText: AppStrings.priceZeroHint,
                        ),
                      ),
                      SizedBox(width: AppSize.size12.w),
                      const Expanded(
                        child: CustomTextField(
                          label: AppStrings.quickAddStep2SellingPriceLabel,
                          hintText: AppStrings.priceZeroHint,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.size12.h),
                  Row(
                    children: [
                      const Expanded(
                        child: CustomTextField(
                          label: AppStrings.initialStock,
                          hintText: AppStrings.stockQuantityHint,
                        ),
                      ),
                      SizedBox(width: AppSize.size12.w),
                      const Expanded(
                        child: CustomTextField(
                          label: AppStrings.quickAddStep2UnitLabel,
                          hintText: AppStrings.unitPcsHint,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.size24.h),
                ],
              ),
            ),
          ),
          
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.size8.r),
              ),
            ),
            child: Ink(
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(AppSize.size8.r),
              ),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: AppSize.size14.h),
                child: Text(
                  AppStrings.saveVariant,
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
