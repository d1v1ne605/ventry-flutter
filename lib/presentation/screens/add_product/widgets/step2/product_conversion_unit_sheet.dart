import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:ventry_flutter/core/widgets/custom_text_field.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';

class ProductConversionUnitDraft {
  const ProductConversionUnitDraft({
    required this.unit,
    required this.conversionFactor,
  });

  final UnitEntity unit;
  final double conversionFactor;
}

class ProductConversionUnitSheet extends StatefulWidget {
  const ProductConversionUnitSheet({
    super.key,
    required this.units,
    required this.excludedUnitIds,
    required this.onCreateUnit,
  });

  final List<UnitEntity> units;
  final Set<int> excludedUnitIds;
  final void Function(String) onCreateUnit;

  static Future<ProductConversionUnitDraft?> show(
    BuildContext context, {
    required List<UnitEntity> units,
    required Set<int> excludedUnitIds,
    required void Function(String) onCreateUnit,
  }) {
    return showModalBottomSheet<ProductConversionUnitDraft>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (_) => ProductConversionUnitSheet(
        units: units,
        excludedUnitIds: excludedUnitIds,
        onCreateUnit: onCreateUnit,
      ),
    );
  }

  @override
  State<ProductConversionUnitSheet> createState() =>
      _ProductConversionUnitSheetState();
}

class _ProductConversionUnitSheetState
    extends State<ProductConversionUnitSheet> {
  final TextEditingController _factorController = TextEditingController();
  UnitEntity? _unit;

  List<UnitEntity> get _availableUnits {
    return widget.units
        .where((unit) => !widget.excludedUnitIds.contains(unit.id))
        .toList(growable: false);
  }

  @override
  void dispose() {
    _factorController.dispose();
    super.dispose();
  }

  void _submit() {
    final unit = _unit;
    final factor = double.tryParse(_factorController.text.trim());
    if (unit == null || factor == null || factor <= 0) {
      AppSnackBar.showError(context, AppStrings.productUnitInvalidConversion);
      return;
    }

    Navigator.of(
      context,
    ).pop(ProductConversionUnitDraft(unit: unit, conversionFactor: factor));
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final units = _availableUnits;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h + bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.productUnitAddConversion,
              style: AppTextStyles.cardTitle,
            ),
            SizedBox(height: AppSize.size12.h),
            DropdownButtonFormField<UnitEntity>(
              initialValue: _unit,
              items: units.map((unit) {
                return DropdownMenuItem(value: unit, child: Text(unit.name));
              }).toList(),
              decoration: InputDecoration(
                labelText: AppStrings.unitOfMeasureLabel,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.size8.r),
                ),
              ),
              onChanged: (unit) => setState(() => _unit = unit),
            ),
            SizedBox(height: AppSize.size12.h),
            CustomTextField(
              label: AppStrings.productUnitConversionFactor,
              hintText: AppStrings.productUnitConversionHint,
              controller: _factorController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
            ),
            SizedBox(height: AppSize.size12.h),
            ElevatedButton(
              onPressed: _submit,
              child: const Text(AppStrings.addNew),
            ),
          ],
        ),
      ),
    );
  }
}
