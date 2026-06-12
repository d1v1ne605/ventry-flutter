import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/storage_unit.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_2/quick_add_unit_sheet.dart';

/// Labelled unit of measure dropdown for Step 2 of Quick Add flow.
class QuickAddUnitDropdown extends StatelessWidget {
  const QuickAddUnitDropdown({
    super.key,
    required this.label,
    required this.units,
    required this.selectedUnit,
    required this.onSelected,
  });

  final String label;
  final List<StorageUnit> units;
  final StorageUnit? selectedUnit;
  final void Function(StorageUnit) onSelected;

  void _openPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.size16.r),
        ),
      ),
      backgroundColor: AppColors.surface,
      builder: (_) => QuickAddUnitSheet(
        units: units,
        selected: selectedUnit,
        onSelected: (unit) {
          Navigator.of(context).pop();
          onSelected(unit);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedUnit != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.subtitle,
          ),
        ),
        SizedBox(height: AppSize.size4.h),
        GestureDetector(
          onTap: () => _openPicker(context),
          child: Container(
            height: 44.h,
            padding: EdgeInsets.symmetric(horizontal: AppSize.size12.w),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(AppSize.size8.r),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasSelection ? selectedUnit!.name : 'Select Unit of Measure',
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: hasSelection
                          ? AppColors.heading
                          : AppColors.textHint,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20.r,
                  color: AppColors.subtitle,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
