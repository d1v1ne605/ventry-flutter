import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';

class ProductUnitNameAutocompleteField extends StatelessWidget {
  const ProductUnitNameAutocompleteField({
    super.key,
    required this.value,
    required this.units,
    required this.onChanged,
    required this.onSelected,
  });

  final String value;
  final List<UnitEntity> units;
  final ValueChanged<String> onChanged;
  final ValueChanged<UnitEntity> onSelected;

  @override
  Widget build(BuildContext context) {
    return Autocomplete<UnitEntity>(
      initialValue: TextEditingValue(text: value),
      displayStringForOption: (unit) => unit.name,
      optionsBuilder: (textEditingValue) {
        final query = textEditingValue.text.trim().toLowerCase();
        if (query.isEmpty) return const Iterable<UnitEntity>.empty();
        return units.where((unit) => unit.name.toLowerCase().contains(query));
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.productUnitNameLabel,
                  style: AppTextStyles.label,
                ),
                SizedBox(width: AppSize.size4.w),
                Text(
                  '*',
                  style: AppTextStyles.label.copyWith(color: AppColors.error),
                ),
              ],
            ),
            SizedBox(height: AppSize.size4.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSize.size8.r),
                border: Border.all(color: AppColors.inputBorder),
              ),
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onChanged: onChanged,
                textInputAction: TextInputAction.done,
                style: AppTextStyles.input.copyWith(
                  color: AppColors.heading,
                  fontWeight: FontWeight.w700,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.productUnitNameHint,
                  hintStyle: AppTextStyles.inputHint,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSize.size16.w,
                    vertical: AppSize.size12.h,
                  ),
                ),
              ),
            ),
          ],
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            color: AppColors.surface,
            elevation: 4,
            borderRadius: BorderRadius.circular(AppSize.size8.r),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 180.h, maxWidth: 280.w),
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: AppSize.size4.h),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final unit = options.elementAt(index);
                  return ListTile(
                    dense: true,
                    title: Text(unit.name, style: AppTextStyles.body),
                    onTap: () => onSelected(unit),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
