import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/supplier_option.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_3/quick_add_supplier_sheet.dart';

/// Dropdown trigger for selecting supplier in Quick Add Step 3.
class QuickAddSupplierDropdown extends StatelessWidget {
  const QuickAddSupplierDropdown({
    super.key,
    required this.label,
    required this.suppliers,
    required this.selectedSupplier,
    required this.onSelected,
  });

  final String label;
  final List<SupplierOption> suppliers;
  final SupplierOption? selectedSupplier;
  final void Function(SupplierOption) onSelected;

  void _openPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.size16.r),
        ),
      ),
      backgroundColor: AppColors.surface,
      builder: (_) => QuickAddSupplierSheet(
        suppliers: suppliers,
        selected: selectedSupplier,
        onSelected: (sup) {
          Navigator.of(context).pop();
          onSelected(sup);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedSupplier != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
        SizedBox(height: AppSize.size14.h),
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
                    hasSelection
                        ? selectedSupplier!.name
                        : 'Select a supplier...',
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
