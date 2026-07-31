import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/widgets/custom_text_field.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';
import 'package:ventry_flutter/presentation/screens/add_product/widgets/step2/product_unit_name_autocomplete_field.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/models/sku_form_unit_draft.dart';

class SkuFormUnitDraftCard extends StatefulWidget {
  const SkuFormUnitDraftCard({
    super.key,
    required this.draft,
    required this.baseUnitName,
    required this.units,
    required this.onNameChanged,
    required this.onSelected,
    required this.onRemove,
    required this.onSkuCodeChanged,
    required this.onFactorChanged,
    required this.onPriceChanged,
  });

  final SkuFormUnitDraft draft;
  final String baseUnitName;
  final List<UnitEntity> units;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<UnitEntity> onSelected;
  final VoidCallback onRemove;
  final ValueChanged<String> onSkuCodeChanged;
  final ValueChanged<double> onFactorChanged;
  final ValueChanged<double> onPriceChanged;

  @override
  State<SkuFormUnitDraftCard> createState() => _SkuFormUnitDraftCardState();
}

class _SkuFormUnitDraftCardState extends State<SkuFormUnitDraftCard> {
  late final TextEditingController _skuCodeController;
  late final TextEditingController _factorController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _skuCodeController = TextEditingController(text: widget.draft.skuCode);
    _factorController = TextEditingController(text: _formatFactor());
    _priceController = TextEditingController(text: _formatPrice());
  }

  @override
  void didUpdateWidget(SkuFormUnitDraftCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.draft.conversionFactor != widget.draft.conversionFactor) {
      _factorController.text = _formatFactor();
    }
    if (oldWidget.draft.skuCode != widget.draft.skuCode) {
      _skuCodeController.text = widget.draft.skuCode;
    }
    if (oldWidget.draft.sellingPrice != widget.draft.sellingPrice) {
      _priceController.text = _formatPrice();
    }
  }

  @override
  void dispose() {
    _skuCodeController.dispose();
    _factorController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.size16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.productUnitConversionSection,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.subtitle,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: widget.onRemove,
                icon: Icon(
                  Icons.remove_circle_outline_rounded,
                  color: AppColors.subtitle,
                  size: AppSize.size24.r,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.size12.h),
          ProductUnitNameAutocompleteField(
            value: widget.draft.unit.name,
            units: widget.units,
            onChanged: widget.onNameChanged,
            onSelected: widget.onSelected,
          ),
          SizedBox(height: AppSize.size12.h),
          CustomTextField(
            label: AppStrings.skuCodeLabel,
            hintText: AppStrings.skuCodeHint,
            controller: _skuCodeController,
            textInputAction: TextInputAction.next,
            onChanged: widget.onSkuCodeChanged,
          ),
          SizedBox(height: AppSize.size12.h),
          CustomTextField(
            label: AppStrings.productUnitConversionFactor,
            hintText: AppStrings.productUnitConversionHint,
            controller: _factorController,
            isRequired: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            textInputAction: TextInputAction.done,
            onChanged: (value) =>
                widget.onFactorChanged(double.tryParse(value.trim()) ?? 0),
          ),
          SizedBox(height: AppSize.size8.h),
          Text(
            AppStrings.productUnitConversionWithBase(
              widget.draft.conversionFactor,
              widget.baseUnitName,
            ),
            style: AppTextStyles.bodyManrope,
          ),
          SizedBox(height: AppSize.size12.h),
          CustomTextField(
            label: AppStrings.sellingPriceLabel,
            hintText: '0',
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            textInputAction: TextInputAction.done,
            onChanged: (value) =>
                widget.onPriceChanged(double.tryParse(value.trim()) ?? 0),
          ),
        ],
      ),
    );
  }

  String _formatFactor() {
    final value = widget.draft.conversionFactor;
    if (value == 0) return '';
    if (value % 1 == 0) return value.toInt().toString();
    return value.toString();
  }

  String _formatPrice() {
    final value = widget.draft.sellingPrice;
    if (value == 0) return '';
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }
}
