import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';

class GeneralInfoCard extends StatelessWidget {
  final SkuEntity sku;

  const GeneralInfoCard({super.key, required this.sku});

  String _calculateMargin() {
    if (sku.sellingPrice != null &&
        sku.costPrice != null &&
        sku.sellingPrice! > 0) {
      final margin =
          ((sku.sellingPrice! - sku.costPrice!) / sku.sellingPrice!) * 100;
      return '${margin.toStringAsFixed(0)}%';
    }
    return AppStrings.notAvailable;
  }

  void _copyToClipboard(BuildContext context, String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label copied to clipboard')));
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = sku.spuCategoryName ?? AppStrings.notAvailable;
    final unitOfMeasure = sku.spuUnitOfMeasure ?? AppStrings.notAvailable;
    final currency = sku.spuCurrency ?? AppStrings.notAvailable;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(AppSize.size16.w),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.inputBorder)),
            ),
            child: Text(
              AppStrings.generalInfoTitle,
              style: AppTextStyles.cardTitle,
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(AppSize.size16.w),
            child: Column(
              children: [
                _InfoRow(label: AppStrings.categoryLabel, value: categoryName),
                SizedBox(height: AppSize.size16.h),
                _InfoRow(
                  label: AppStrings.unitOfMeasureLabel,
                  value: unitOfMeasure,
                ),
                SizedBox(height: AppSize.size16.h),
                _InfoRow(label: AppStrings.currencyLabel, value: currency),
                SizedBox(height: AppSize.size16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.isSellableLabel,
                      style: AppTextStyles.body.copyWith(fontSize: 12.sp),
                    ),
                    Switch(
                      value: sku.isSellable,
                      onChanged: null,
                      activeTrackColor: AppColors.primary,
                    ),
                  ],
                ),
                SizedBox(height: AppSize.size16.h),
                const Divider(color: AppColors.inputBorder, height: 1),
                SizedBox(height: AppSize.size16.h),
                _CopyRow(
                  label: AppStrings.barcodeLabel,
                  value: sku.barCode ?? AppStrings.notAvailable,
                  onCopy: () => _copyToClipboard(
                    context,
                    sku.barCode ?? '',
                    AppStrings.barcodeLabel,
                  ),
                ),
                SizedBox(height: AppSize.size16.h),
                _CopyRow(
                  label: AppStrings.skuCodeLabel,
                  value: sku.skuCode ?? AppStrings.notAvailable,
                  onCopy: () => _copyToClipboard(
                    context,
                    sku.skuCode ?? '',
                    AppStrings.skuCodeLabel,
                  ),
                ),
                SizedBox(height: AppSize.size16.h),
                const Divider(color: AppColors.inputBorder, height: 1),
                SizedBox(height: AppSize.size16.h),
                _InfoRow(
                  label: AppStrings.costPriceLabel,
                  value: '${sku.costPrice ?? 0.0}',
                ),
                SizedBox(height: AppSize.size16.h),
                _InfoRow(
                  label: AppStrings.sellingPriceLabel,
                  value: '${sku.sellingPrice ?? 0.0}',
                ),
                SizedBox(height: AppSize.size16.h),
                _InfoRow(
                  label: AppStrings.marginLabel,
                  value: _calculateMargin(),
                  valueColor: const Color(0xFF10B981),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body.copyWith(fontSize: 12.sp)),
        Text(
          value,
          style: AppTextStyles.body.copyWith(
            color: valueColor ?? AppColors.textHeading,
          ),
        ),
      ],
    );
  }
}

class _CopyRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback onCopy;

  const _CopyRow({
    required this.label,
    required this.value,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.body.copyWith(fontSize: 12.sp)),
              SizedBox(height: AppSize.size2.h),
              Text(
                value,
                style: AppTextStyles.body.copyWith(
                  fontFamily: 'Liberation Mono',
                  color: AppColors.textHeading,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: value == AppStrings.notAvailable ? null : onCopy,
          icon: Icon(Icons.copy, color: AppColors.navInactive, size: 18.r),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}
