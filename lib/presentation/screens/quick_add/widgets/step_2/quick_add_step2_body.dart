import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/currency_option.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/storage_unit.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_1/quick_add_input_field.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_2/quick_add_currency_dropdown.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_2/quick_add_info_banner.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_2/quick_add_price_chips.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_2/quick_add_price_input.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_2/quick_add_unit_dropdown.dart';

/// Body content of Quick Add Step 2 (Price & Inventory form).
class QuickAddStep2Body extends StatelessWidget {
  const QuickAddStep2Body({
    super.key,
    required this.priceController,
    required this.costController,
    required this.quantityController,
    required this.priceFocus,
    required this.costFocus,
    required this.quantityFocus,
    required this.selectedCurrency,
    required this.onCurrencySelected,
    required this.selectedUnit,
    required this.onUnitSelected,
  });

  final TextEditingController priceController;
  final TextEditingController costController;
  final TextEditingController quantityController;
  final FocusNode priceFocus;
  final FocusNode costFocus;
  final FocusNode quantityFocus;
  final CurrencyOption? selectedCurrency;
  final void Function(CurrencyOption) onCurrencySelected;
  final StorageUnit? selectedUnit;
  final void Function(StorageUnit) onUnitSelected;

  @override
  Widget build(BuildContext context) {
    final activeCurrencySymbol = selectedCurrency?.symbol ?? '₫';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Subheader block on screen background
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSize.size16.w,
              AppSize.size16.h,
              AppSize.size16.w,
              AppSize.size16.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.quickAddStep2Title,
                  style: GoogleFonts.manrope(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                  ),
                ),
                SizedBox(height: AppSize.size4.h),
                Text(
                  AppStrings.quickAddStep2Subtitle,
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.subtitle,
                  ),
                ),
              ],
            ),
          ),

          // Main White Form Card
          Container(
            margin: EdgeInsets.symmetric(horizontal: AppSize.size16.w),
            padding: EdgeInsets.all(AppSize.size16.r),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSize.size12.r),
              boxShadow: AppColors.cardShadows,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Currency Dropdown
                QuickAddCurrencyDropdown(
                  label: AppStrings.quickAddStep2CurrencyLabel,
                  currencies: CurrencyOption.defaults,
                  selectedCurrency: selectedCurrency,
                  onSelected: onCurrencySelected,
                ),
                SizedBox(height: AppSize.size14.h),

                // Selling Price
                QuickAddPriceInput(
                  label: AppStrings.quickAddStep2SellingPriceLabel,
                  hintText: '0',
                  controller: priceController,
                  currencySymbol: activeCurrencySymbol,
                  statusText: AppStrings.quickAddStep2Required,
                  focusNode: priceFocus,
                  nextFocusNode: costFocus,
                ),
                SizedBox(height: AppSize.size8.h),

                // Quick Suggestion Price Chips
                QuickAddPriceChips(
                  suggestions: const [100000, 250000, 500000],
                  onTap: (val) {
                    priceController.text = val.toString();
                    priceFocus.unfocus();
                  },
                ),
                SizedBox(height: AppSize.size14.h),

                // Cost Price
                QuickAddPriceInput(
                  label: AppStrings.quickAddStep2CostPriceLabel,
                  hintText: '0',
                  controller: costController,
                  currencySymbol: activeCurrencySymbol,
                  statusText: AppStrings.quickAddStep2Optional,
                  focusNode: costFocus,
                  nextFocusNode: quantityFocus,
                ),
                SizedBox(height: AppSize.size4.h),
                Text(
                  AppStrings.quickAddStep2CostPriceHelper,
                  style: GoogleFonts.manrope(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.subtitle.withValues(alpha: 0.8),
                  ),
                ),
                SizedBox(height: AppSize.size16.h),

                // Divider line separating Pricing and Inventory
                Divider(
                  color: AppColors.divider,
                  thickness: 1.0,
                  height: AppSize.size1.h,
                ),
                SizedBox(height: AppSize.size16.h),

                // Inventory Section Header
                Text(
                  AppStrings.quickAddStep2InventoryTitle,
                  style: GoogleFonts.manrope(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                  ),
                ),
                SizedBox(height: AppSize.size14.h),

                // Stock Quantity
                QuickAddInputField(
                  label: AppStrings.quickAddStep2QuantityLabel,
                  controller: quantityController,
                  hintText: '0',
                  focusNode: quantityFocus,
                  statusText: AppStrings.quickAddStep2Required,
                  keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                  textInputAction: TextInputAction.done,
                ),
                SizedBox(height: AppSize.size14.h),

                // Unit of Measure Dropdown
                QuickAddUnitDropdown(
                  label: AppStrings.quickAddStep2UnitLabel,
                  units: StorageUnit.defaults,
                  selectedUnit: selectedUnit,
                  onSelected: onUnitSelected,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSize.size16.h),

          // Bottom Info Banner alert
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.size16.w),
            child: const QuickAddInfoBanner(),
          ),
          SizedBox(height: AppSize.size24.h),
        ],
      ),
    );
  }
}
