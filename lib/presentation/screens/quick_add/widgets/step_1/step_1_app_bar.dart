import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/add_product_mode.dart';

class Step1AppBar extends StatelessWidget implements PreferredSizeWidget {
  const Step1AppBar({
    super.key,
    required this.mode,
    required this.onModeChanged,
    required this.onClose,
  });

  final AddProductMode mode;
  final void Function(AddProductMode) onModeChanged;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(
        top: topPadding + AppSize.size8.h,
        bottom: AppSize.size8.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: AppSize.size1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.size16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    padding: EdgeInsets.all(AppSize.size8.r),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 20.r,
                      color: AppColors.heading,
                    ),
                  ),
                ),
                Text(
                  'Add Product',
                  style: GoogleFonts.manrope(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.heading,
                  ),
                ),
                SizedBox(width: 36.r), // Balance spacing
              ],
            ),
          ),
          SizedBox(height: AppSize.size12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.size16.w),
            child: _SegmentedToggle(mode: mode, onModeChanged: onModeChanged),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100.h + 20); // Roughly
}

class _SegmentedToggle extends StatelessWidget {
  const _SegmentedToggle({required this.mode, required this.onModeChanged});

  final AddProductMode mode;
  final void Function(AddProductMode) onModeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.size4.r),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(AppSize.size24.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleTab(
              title: 'Simple',
              isSelected: mode == AddProductMode.simple,
              onTap: () => onModeChanged(AddProductMode.simple),
            ),
          ),
          Expanded(
            child: _ToggleTab(
              title: 'Professional',
              isSelected: mode == AddProductMode.professional,
              onTap: () => onModeChanged(AddProductMode.professional),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  const _ToggleTab({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: AppSize.size8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSize.size20.r),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, 1),
                    blurRadius: 2,
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.subtitle,
          ),
        ),
      ),
    );
  }
}
