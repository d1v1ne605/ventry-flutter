import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/utils/app_formatters.dart';
import 'package:ventry_flutter/core/widgets/barcode_scanner_bottom_sheet.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/bloc/edit_sku_bloc.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/bloc/edit_sku_state.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_input_field.dart';

class EditSkuFormCard extends StatelessWidget {
  const EditSkuFormCard({
    super.key,
    required this.skuNameController,
    required this.categoryController,
    required this.barcodeController,
    required this.skuCodeController,
    required this.costPriceController,
    required this.sellingPriceController,
    required this.currencyController,
    required this.unitController,
    required this.onSkuNameChanged,
    required this.onCategoryTap,
    required this.onBarcodeChanged,
    required this.onBarcodeScanned,
    required this.onSkuCodeChanged,
    required this.onCostPriceChanged,
    required this.onSellingPriceChanged,
    required this.onCurrencyChanged,
    required this.onUnitChanged,
    required this.onSellableChanged,
  });

  final TextEditingController skuNameController;
  final TextEditingController categoryController;
  final TextEditingController barcodeController;
  final TextEditingController skuCodeController;
  final TextEditingController costPriceController;
  final TextEditingController sellingPriceController;
  final TextEditingController currencyController;
  final TextEditingController unitController;
  final ValueChanged<String> onSkuNameChanged;
  final VoidCallback onCategoryTap;
  final ValueChanged<String> onBarcodeChanged;
  final ValueChanged<String> onBarcodeScanned;
  final ValueChanged<String> onSkuCodeChanged;
  final ValueChanged<String> onCostPriceChanged;
  final ValueChanged<String> onSellingPriceChanged;
  final ValueChanged<String> onCurrencyChanged;
  final ValueChanged<String> onUnitChanged;
  final ValueChanged<bool> onSellableChanged;

  Future<void> _scanBarcode(BuildContext context) async {
    final result = await showBarcodeScanner(context);
    if (result == null || result.isEmpty) {
      return;
    }
    onBarcodeScanned(result);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.size16.w),
      decoration: BoxDecoration(
        color: AppColors.editSkuCardBackground,
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.editSkuGeneralInformation,
            style: AppTextStyles.editSkuSectionTitle,
          ),
          SizedBox(height: AppSize.size16.h),
          EditSkuInputField(
            label: AppStrings.editSkuCategory,
            controller: categoryController,
            readOnly: true,
            onTap: onCategoryTap,
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.subtitle,
              size: AppSize.size20.r,
            ),
          ),
          SizedBox(height: AppSize.size16.h),
          Row(
            children: [
              Expanded(
                child: EditSkuInputField(
                  label: AppStrings.editSkuBarcode,
                  controller: barcodeController,
                  onChanged: onBarcodeChanged,
                  suffixIcon: IconButton(
                    onPressed: () => _scanBarcode(context),
                    icon: SvgPicture.asset(
                      AppAssets.icScanner,
                      width: AppSize.size20.w,
                      height: AppSize.size20.w,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppSize.size16.w),
              Expanded(
                child: EditSkuInputField(
                  label: AppStrings.editSkuSkuCode,
                  controller: skuCodeController,
                  onChanged: onSkuCodeChanged,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.size16.h),
          Row(
            children: [
              Expanded(
                child: EditSkuInputField(
                  label: AppStrings.editSkuCostPrice,
                  controller: costPriceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [CurrencyTextInputFormatter()],
                  onChanged: onCostPriceChanged,
                ),
              ),
              SizedBox(width: AppSize.size16.w),
              Expanded(
                child: EditSkuInputField(
                  label: AppStrings.editSkuSellingPrice,
                  controller: sellingPriceController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [CurrencyTextInputFormatter()],
                  onChanged: onSellingPriceChanged,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.size16.h),
          Row(
            children: [
              Expanded(
                child: EditSkuInputField(
                  label: AppStrings.editSkuCurrency,
                  controller: currencyController,
                  onChanged: onCurrencyChanged,
                ),
              ),
              SizedBox(width: AppSize.size16.w),
              Expanded(
                child: EditSkuInputField(
                  label: AppStrings.editSkuUnitOfMeasure,
                  controller: unitController,
                  onChanged: onUnitChanged,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.size16.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.editSkuIsSellable,
                      style: AppTextStyles.editSkuButtonLabel.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppSize.size4.h),
                    Text(
                      AppStrings.editSkuSellableHelper,
                      style: AppTextStyles.editSkuFieldLabel,
                    ),
                  ],
                ),
              ),
              BlocSelector<EditSkuBloc, EditSkuState, bool>(
                selector: (state) => state.form.isSellable,
                builder: (context, isSellable) {
                  return Switch(
                    value: isSellable,
                    onChanged: onSellableChanged,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.editSkuSuccess,
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: AppColors.inputBorder,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
