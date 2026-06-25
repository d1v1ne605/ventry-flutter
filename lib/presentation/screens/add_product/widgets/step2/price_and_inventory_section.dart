import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/custom_text_field.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_bloc.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_event.dart';

class PriceAndInventorySection extends StatefulWidget {
  const PriceAndInventorySection({super.key});

  @override
  State<PriceAndInventorySection> createState() => _PriceAndInventorySectionState();
}

class _PriceAndInventorySectionState extends State<PriceAndInventorySection> {
  final TextEditingController _sellingPriceController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  void dispose() {
    _sellingPriceController.dispose();
    _costPriceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

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
              AppStrings.quickAddStep2Title,
              style: GoogleFonts.manrope(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
              ),
            ),
          ],
        ),
        SizedBox(height: AppSize.size16.h),
        CustomTextField(
          label: AppStrings.quickAddStep2SellingPriceLabel,
          hintText: AppStrings.sellingPriceHint,
          controller: _sellingPriceController,
          textInputAction: TextInputAction.next,
          onChanged: (val) {
            final price = double.tryParse(val) ?? 0.0;
            context.read<AttributeBloc>().add(UpdateGlobalPriceEvent(price));
          },
        ),
        SizedBox(height: AppSize.size16.h),
        CustomTextField(
          label: AppStrings.quickAddStep2CostPriceLabel,
          hintText: AppStrings.costPriceHint,
          controller: _costPriceController,
          textInputAction: TextInputAction.next,
          onChanged: (val) {
            final costPrice = double.tryParse(val) ?? 0.0;
            context.read<AttributeBloc>().add(UpdateGlobalCostPriceEvent(costPrice));
          },
        ),
        SizedBox(height: AppSize.size16.h),
        CustomTextField(
          label: AppStrings.quickAddStep2QuantityLabel,
          hintText: AppStrings.stockQuantityHint,
          controller: _stockController,
          textInputAction: TextInputAction.done,
          onChanged: (val) {
            final stock = int.tryParse(val) ?? 0;
            context.read<AttributeBloc>().add(UpdateGlobalStockEvent(stock));
          },
        ),
      ],
    );
  }
}
