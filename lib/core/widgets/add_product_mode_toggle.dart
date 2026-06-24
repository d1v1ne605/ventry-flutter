import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/add_product_mode.dart';

/// Segmented tab switcher: Simple | Professional.
///
/// Displays a pill-shaped container with two selectable tabs.
/// The active tab slides to a white elevated pill.
class AddProductModeToggle extends StatelessWidget {
  const AddProductModeToggle({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  final AddProductMode selectedMode;
  final void Function(AddProductMode) onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.all(AppSize.size4.r),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(AppSize.size8.r),
      ),
      child: Row(
        children: [
          _ModeTab(
            label: 'Simple',
            isSelected: selectedMode == AddProductMode.simple,
            onTap: () => onModeChanged(AddProductMode.simple),
          ),
          _ModeTab(
            label: 'Professional',
            isSelected: selectedMode == AddProductMode.professional,
            onTap: () => onModeChanged(AddProductMode.professional),
          ),
        ],
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  const _ModeTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSize.size4.r + 2),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: const Color(0x1A000000),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.heading : AppColors.navInactive,
            ),
          ),
        ),
      ),
    );
  }
}
