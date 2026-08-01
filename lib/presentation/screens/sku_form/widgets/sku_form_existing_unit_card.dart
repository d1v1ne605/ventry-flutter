import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/widgets/custom_text_field.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_unit_card_header.dart';

class SkuFormExistingUnitCard extends StatefulWidget {
  const SkuFormExistingUnitCard({
    super.key,
    required this.sku,
    required this.baseUnitName,
    required this.sellingPrice,
    this.isEditable = true,
    this.onNameChanged,
    this.onFactorChanged,
    this.onPriceChanged,
    this.onRemove,
  });

  final SkuEntity sku;
  final String baseUnitName;
  final double sellingPrice;
  final bool isEditable;
  final ValueChanged<String>? onNameChanged;
  final ValueChanged<double>? onFactorChanged;
  final ValueChanged<double>? onPriceChanged;
  final VoidCallback? onRemove;

  @override
  State<SkuFormExistingUnitCard> createState() =>
      _SkuFormExistingUnitCardState();
}

class _SkuFormExistingUnitCardState extends State<SkuFormExistingUnitCard> {
  late final TextEditingController _unitController;
  late final TextEditingController _factorController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _unitController = TextEditingController(text: widget.sku.unitName ?? '');
    _factorController = TextEditingController(text: _formatFactor());
    _priceController = TextEditingController(text: _formatPrice());
  }

  @override
  void didUpdateWidget(SkuFormExistingUnitCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sku.unitName != widget.sku.unitName) {
      _unitController.text = widget.sku.unitName ?? '';
    }
    if (oldWidget.sku.conversionFactor != widget.sku.conversionFactor) {
      _factorController.text = _formatFactor();
    }
    if (oldWidget.sellingPrice != widget.sellingPrice) {
      _priceController.text = _formatPrice();
    }
  }

  @override
  void dispose() {
    _unitController.dispose();
    _factorController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.size16.r),
      decoration: BoxDecoration(
        color: widget.isEditable ? AppColors.surface : AppColors.inputFill,
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        border: Border.all(
          color: widget.isEditable ? AppColors.primary : AppColors.inputBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkuFormUnitCardHeader(
            title: AppStrings.productUnitConversionSection,
            isEditable: widget.isEditable,
            onRemove: widget.isEditable ? widget.onRemove : null,
          ),
          SizedBox(height: AppSize.size12.h),
          CustomTextField(
            label: AppStrings.productUnitNameLabel,
            hintText: AppStrings.productUnitNameHint,
            controller: _unitController,
            enabled: widget.isEditable,
            isRequired: true,
            onChanged: widget.onNameChanged,
          ),
          SizedBox(height: AppSize.size12.h),
          CustomTextField(
            label: AppStrings.productUnitConversionFactor,
            hintText: AppStrings.productUnitConversionHint,
            controller: _factorController,
            enabled: widget.isEditable,
            isRequired: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            textInputAction: TextInputAction.done,
            onChanged: widget.isEditable
                ? (value) => widget.onFactorChanged?.call(
                    double.tryParse(value.trim()) ?? 0,
                  )
                : null,
          ),
          SizedBox(height: AppSize.size8.h),
          Text(
            AppStrings.productUnitConversionWithBase(
              widget.sku.conversionFactor ?? 1,
              widget.baseUnitName,
            ),
            style: AppTextStyles.bodyManrope,
          ),
          SizedBox(height: AppSize.size12.h),
          CustomTextField(
            label: AppStrings.sellingPriceLabel,
            hintText: '0',
            controller: _priceController,
            enabled: widget.isEditable,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            textInputAction: TextInputAction.done,
            onChanged: widget.isEditable
                ? (value) => widget.onPriceChanged?.call(
                    double.tryParse(value.trim()) ?? 0,
                  )
                : null,
          ),
        ],
      ),
    );
  }

  String _formatFactor() {
    final value = widget.sku.conversionFactor ?? 1;
    if (value % 1 == 0) return value.toInt().toString();
    return value.toString();
  }

  String _formatPrice() {
    final value = widget.sellingPrice;
    if (value == 0) return '';
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }
}
