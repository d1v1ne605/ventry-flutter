import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/product_category.dart';

/// Labelled category dropdown matching the Figma "Category" field.
///
/// Shows "Select Category" hint when nothing is selected.
/// Opens a [showModalBottomSheet] picker on tap.
class QuickAddCategoryDropdown extends StatelessWidget {
  const QuickAddCategoryDropdown({
    super.key,
    required this.label,
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final String label;
  final List<ProductCategory> categories;
  final ProductCategory? selectedCategory;
  final void Function(ProductCategory) onSelected;

  void _openPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.size16.r),
        ),
      ),
      backgroundColor: AppColors.surface,
      builder: (_) => _CategorySheet(
        categories: categories,
        selected: selectedCategory,
        onSelected: (cat) {
          Navigator.of(context).pop();
          onSelected(cat);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedCategory != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: AppSize.size14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textHeading,
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
                    hasSelection ? selectedCategory!.name : 'Select Category',
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

/// Bottom sheet listing all categories.
class _CategorySheet extends StatelessWidget {
  const _CategorySheet({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<ProductCategory> categories;
  final ProductCategory? selected;
  final void Function(ProductCategory) onSelected;

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
                'Select Category',
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
                itemCount: categories.length,
                itemBuilder: (_, i) {
                  final cat = categories[i];
                  final isSelected = selected?.id == cat.id;
                  return ListTile(
                    onTap: () => onSelected(cat),
                    title: Text(
                      cat.name,
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
