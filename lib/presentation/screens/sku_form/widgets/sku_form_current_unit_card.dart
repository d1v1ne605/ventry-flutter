import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/utils/app_formatters.dart';
import 'package:ventry_flutter/core/widgets/custom_text_field.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_unit_card_header.dart';

class SkuFormCurrentUnitCard extends StatefulWidget {
  const SkuFormCurrentUnitCard({
    super.key,
    required this.sku,
    this.isEditable = true,
    this.onNameChanged,
  });

  final SkuEntity sku;
  final bool isEditable;
  final ValueChanged<String>? onNameChanged;

  @override
  State<SkuFormCurrentUnitCard> createState() => _SkuFormCurrentUnitCardState();
}

class _SkuFormCurrentUnitCardState extends State<SkuFormCurrentUnitCard> {
  late final TextEditingController _unitController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _unitController = TextEditingController(text: _unitName);
    _priceController = TextEditingController(text: _price);
  }

  @override
  void didUpdateWidget(SkuFormCurrentUnitCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sku.unitName != widget.sku.unitName) {
      _unitController.text = _unitName;
    }
    if (oldWidget.sku.sellingPrice != widget.sku.sellingPrice) {
      _priceController.text = _price;
    }
  }

  @override
  void dispose() {
    _unitController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  String get _unitName => widget.sku.unitName ?? '';

  String get _price {
    final sellingPrice = widget.sku.sellingPrice;
    return sellingPrice == null ? '' : AppFormatters.formatPrice(sellingPrice);
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
            title: AppStrings.productUnitBaseSection,
            isEditable: widget.isEditable,
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
            label: AppStrings.sellingPriceLabel,
            hintText: '0',
            controller: _priceController,
            enabled: false,
          ),
        ],
      ),
    );
  }
}
