import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';

/// Search bar with inline QR scanner icon and a separate filter button.
///
/// Matches the Figma search row in the Product Catalog screen.
/// All interactions are surfaced via callbacks for future Bloc wiring.
class ProductSearchBar extends StatelessWidget {
  const ProductSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onQrTap,
    this.onFilterTap,
  });

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final VoidCallback? onQrTap;
  final VoidCallback? onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SearchField(
            controller: controller,
            onChanged: onChanged,
            onQrTap: onQrTap,
          ),
        ),
        SizedBox(width: AppSize.size8.w),
        _FilterButton(onTap: onFilterTap),
      ],
    );
  }
}

/// The text input portion of [ProductSearchBar].
class _SearchField extends StatelessWidget {
  const _SearchField({this.controller, this.onChanged, this.onQrTap});

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final VoidCallback? onQrTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.searchBarFill,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.searchBarBorder),
      ),
      child: Row(
        children: [
          SizedBox(width: 12.w),
          Icon(Icons.search_rounded, color: AppColors.navInactive, size: 20.r),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTextStyles.bodyManrope.copyWith(
                color: AppColors.heading,
              ),
              decoration: InputDecoration(
                hintText: AppStrings.searchHint,
                hintStyle: AppTextStyles.searchHint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          // QR scan icon inside field
          GestureDetector(
            onTap: onQrTap,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Icon(
                Icons.qr_code_scanner_rounded,
                color: AppColors.primary,
                size: 22.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Square filter button to the right of the search field.
class _FilterButton extends StatelessWidget {
  const _FilterButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.r,
        height: 48.r,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.searchBarBorder),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.tune_rounded,
          color: AppColors.navInactive,
          size: 20.r,
        ),
      ),
    );
  }
}
