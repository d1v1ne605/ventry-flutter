import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/custom_text_field.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_state.dart';

class EditVariantBottomSheet extends StatefulWidget {
  final GeneratedSku sku;
  final void Function(
    String skuCode,
    String barcode,
    double costPrice,
    double price,
    int stock,
  )
  onSave;

  const EditVariantBottomSheet({
    super.key,
    required this.sku,
    required this.onSave,
  });

  @override
  State<EditVariantBottomSheet> createState() => _EditVariantBottomSheetState();
}

class _EditVariantBottomSheetState extends State<EditVariantBottomSheet> {
  late final TextEditingController _skuCodeController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _costPriceController;
  late final TextEditingController _sellingPriceController;
  late final TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    _skuCodeController = TextEditingController(text: widget.sku.skuCode);
    _barcodeController = TextEditingController(text: widget.sku.barcode);
    _costPriceController = TextEditingController(
      text: widget.sku.costPrice > 0
          ? widget.sku.costPrice.toStringAsFixed(2)
          : '',
    );
    _sellingPriceController = TextEditingController(
      text: widget.sku.price > 0 ? widget.sku.price.toStringAsFixed(2) : '',
    );
    _stockController = TextEditingController(
      text: widget.sku.stock > 0 ? widget.sku.stock.toString() : '',
    );
  }

  @override
  void dispose() {
    _skuCodeController.dispose();
    _barcodeController.dispose();
    _costPriceController.dispose();
    _sellingPriceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _handleSave() {
    final skuCode = _skuCodeController.text.trim();
    final barcode = _barcodeController.text.trim();
    final costPrice = double.tryParse(_costPriceController.text.trim()) ?? 0.0;
    final sellingPrice =
        double.tryParse(_sellingPriceController.text.trim()) ?? 0.0;
    final stock = int.tryParse(_stockController.text.trim()) ?? 0;

    widget.onSave(skuCode, barcode, costPrice, sellingPrice, stock);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.screenBackground,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.size16.r),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: AppSize.size16.w,
            right: AppSize.size16.w,
            top: AppSize.size16.h,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSize.size16.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDragHandle(),
                _buildHeader(),
                const Divider(height: 1, color: AppColors.divider),
                SizedBox(height: AppSize.size16.h),
                _buildSectionTitle(
                  AppStrings.skuInfo,
                  Icons.inventory_2_outlined,
                  suffixText: widget.sku.name,
                ),
                SizedBox(height: AppSize.size16.h),
                CustomTextField(
                  label: AppStrings.skuCodeLabel,
                  hintText: AppStrings.skuCodeHint,
                  controller: _skuCodeController,
                  // If we want a dotted border, CustomTextField might not support it directly without a custom decoration,
                  // but we stick to the standard CustomTextField for consistency as requested by no-hardcode rule.
                ),
                SizedBox(height: AppSize.size16.h),
                CustomTextField(
                  label: AppStrings.barcodeLabel,
                  hintText: AppStrings.barcodeHint,
                  controller: _barcodeController,
                  suffixIcon: Padding(
                    padding: EdgeInsets.all(AppSize.size12.r),
                    child: SvgPicture.asset(
                      AppAssets.icScanner,
                      colorFilter: const ColorFilter.mode(
                        AppColors.primary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSize.size24.h),
                _buildSectionTitle(
                  AppStrings.pricingAndStock,
                  Icons.payments_outlined,
                ),
                SizedBox(height: AppSize.size16.h),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        label: AppStrings.quickAddStep2CostPriceLabel,
                        hintText: AppStrings.editVariantPriceHint,
                        controller: _costPriceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                    SizedBox(width: AppSize.size16.w),
                    Expanded(
                      child: CustomTextField(
                        label: AppStrings.quickAddStep2SellingPriceLabel,
                        hintText: AppStrings.editVariantPriceHint,
                        controller: _sellingPriceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.size16.h),
                CustomTextField(
                  label: AppStrings.initialStock,
                  hintText: AppStrings.stockQuantityHint,
                  controller: _stockController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: AppSize.size24.h),
                const Divider(height: 1, color: AppColors.divider),
                SizedBox(height: AppSize.size16.h),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40.w,
        height: 4.h,
        margin: EdgeInsets.only(bottom: AppSize.size8.h),
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(AppSize.size2.r),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.size8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppStrings.editVariant,
            style: GoogleFonts.manrope(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: AppColors.subtitle),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, {String? suffixText}) {
    return Row(
      children: [
        Icon(icon, size: 20.r, color: AppColors.subtitle),
        SizedBox(width: AppSize.size8.w),
        RichText(
          text: TextSpan(
            text: title,
            style: GoogleFonts.manrope(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.subtitle,
            ),
            children: suffixText != null
                ? [
                    TextSpan(
                      text: suffixText,
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                      ),
                    ),
                  ]
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: AppSize.size16.h),
              side: BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.size8.r),
              ),
            ),
            child: Text(
              AppStrings.addProductCancel,
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        SizedBox(width: AppSize.size16.w),
        Expanded(
          child: ElevatedButton(
            onPressed: _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(vertical: AppSize.size16.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.size8.r),
              ),
              elevation: 0,
            ),
            child: Text(
              AppStrings.saveButton,
              style: GoogleFonts.manrope(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
