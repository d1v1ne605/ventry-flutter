import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/storage_unit.dart';

/// Bottom sheet content for selecting a unit of measure.
/// Single responsibility: Displaying list of units and handling selection.
class QuickAddUnitSheet extends StatelessWidget {
  const QuickAddUnitSheet({
    super.key,
    required this.units,
    required this.selected,
    required this.onSelected,
  });

  final List<StorageUnit> units;
  final StorageUnit? selected;
  final void Function(StorageUnit) onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppSize.size8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: AppSize.size12.h),
              decoration: BoxDecoration(
                color: AppColors.inputBorder,
                borderRadius: BorderRadius.circular(AppSize.size4.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSize.size16.w,
                0,
                AppSize.size16.w,
                AppSize.size8.h,
              ),
              child: Text(
                'Select Unit of Measure',
                style: GoogleFonts.manrope(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.heading,
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: units.length,
                itemBuilder: (_, i) {
                  final unit = units[i];
                  final isSelected = selected?.id == unit.id;
                  return ListTile(
                    onTap: () => onSelected(unit),
                    title: Text(
                      unit.name,
                      style: GoogleFonts.manrope(
                        fontSize: 14.sp,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.heading,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            color: AppColors.primary,
                            size: 20.r,
                          )
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
