import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/widgets/custom_text_field.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';

class ProductUnitPickerSheet extends StatefulWidget {
  const ProductUnitPickerSheet({
    super.key,
    required this.units,
    required this.title,
    required this.selectedUnit,
    required this.onCreateUnit,
  });

  final List<UnitEntity> units;
  final String title;
  final UnitEntity? selectedUnit;
  final void Function(String) onCreateUnit;

  static Future<UnitEntity?> show(
    BuildContext context, {
    required List<UnitEntity> units,
    required String title,
    UnitEntity? selectedUnit,
    required void Function(String) onCreateUnit,
  }) {
    return showModalBottomSheet<UnitEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (_) => ProductUnitPickerSheet(
        units: units,
        title: title,
        selectedUnit: selectedUnit,
        onCreateUnit: onCreateUnit,
      ),
    );
  }

  @override
  State<ProductUnitPickerSheet> createState() => _ProductUnitPickerSheetState();
}

class _ProductUnitPickerSheetState extends State<ProductUnitPickerSheet> {
  final TextEditingController _unitController = TextEditingController();

  @override
  void dispose() {
    _unitController.dispose();
    super.dispose();
  }

  void _createUnit() {
    final name = _unitController.text.trim();
    if (name.isEmpty) return;
    widget.onCreateUnit(name);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h + bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.title, style: AppTextStyles.cardTitle),
            SizedBox(height: AppSize.size12.h),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.units.length,
                itemBuilder: (context, index) {
                  final unit = widget.units[index];
                  final isSelected = widget.selectedUnit?.id == unit.id;
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      unit.name,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.heading,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_rounded, color: AppColors.primary)
                        : null,
                    onTap: () => Navigator.of(context).pop(unit),
                  );
                },
              ),
            ),
            SizedBox(height: AppSize.size12.h),
            CustomTextField(
              label: AppStrings.productUnitCreateNew,
              hintText: AppStrings.productUnitNameHint,
              controller: _unitController,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _createUnit(),
            ),
            SizedBox(height: AppSize.size8.h),
            OutlinedButton.icon(
              onPressed: _createUnit,
              icon: const Icon(Icons.add_rounded),
              label: const Text(AppStrings.productUnitCreateButton),
            ),
          ],
        ),
      ),
    );
  }
}
