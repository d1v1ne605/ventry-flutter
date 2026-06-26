import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_bloc.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_event.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_state.dart';
import 'package:ventry_flutter/presentation/screens/add_product/widgets/step2/edit_variant_bottom_sheet.dart';

class SkuPreviewSection extends StatelessWidget {
  const SkuPreviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AttributeBloc, AttributeState, List<GeneratedSku>>(
      selector: (state) => state.generatedSkus,
      builder: (context, skus) {
        if (skus.isEmpty) return const SizedBox();
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
                    AppStrings.skuPreview,
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
                      AppStrings.skuVariantsCount(skus.length),
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
              ...skus.map(
                (sku) => _buildPreviewItem(context, sku),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPreviewItem(
    BuildContext context,
    GeneratedSku sku,
  ) {
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
                  sku.name,
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
                      AppStrings.priceLabel(sku.price.toStringAsFixed(2)),
                      style: GoogleFonts.manrope(
                        fontSize: 12.sp,
                        color: AppColors.subtitle,
                      ),
                    ),
                    SizedBox(width: AppSize.size12.w),
                    Text(
                      AppStrings.stockLabel(sku.stock),
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
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (ctx) => EditVariantBottomSheet(
                  sku: sku,
                  onSave: (skuCode, barcode, costPrice, price, stock) {
                    context.read<AttributeBloc>().add(
                          UpdateGeneratedSkuEvent(
                            skuName: sku.name,
                            skuCode: skuCode,
                            barcode: barcode,
                            costPrice: costPrice,
                            price: price,
                            stock: stock,
                          ),
                        );
                  },
                ),
              );
            },
            icon: Icon(
              Icons.edit_outlined,
              color: AppColors.primary,
              size: 20.r,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          IconButton(
            onPressed: () {
              context.read<AttributeBloc>().add(RemoveGeneratedSkuEvent(sku.name));
            },
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
