import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';
import 'package:ventry_flutter/presentation/screens/add_product/widgets/step2/product_unit_name_autocomplete_field.dart';

class ProductBaseUnitFormCard extends StatelessWidget {
  const ProductBaseUnitFormCard({
    super.key,
    required this.unit,
    required this.isLoading,
    required this.units,
    required this.onNameChanged,
    required this.onSelected,
  });

  final UnitEntity? unit;
  final bool isLoading;
  final List<UnitEntity> units;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<UnitEntity> onSelected;

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
          Text(
            AppStrings.productUnitBaseSection,
            style: AppTextStyles.body.copyWith(
              color: AppColors.subtitle,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppSize.size16.h),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              ProductUnitNameAutocompleteField(
                value: unit?.name ?? '',
                units: units,
                onChanged: isLoading ? (_) {} : onNameChanged,
                onSelected: isLoading ? (_) {} : onSelected,
              ),
              if (isLoading)
                Padding(
                  padding: EdgeInsets.only(right: AppSize.size16.r),
                  child: SizedBox(
                    width: AppSize.size20.r,
                    height: AppSize.size20.r,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
