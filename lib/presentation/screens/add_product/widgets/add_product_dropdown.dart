import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

class AddProductDropdown<T> extends StatelessWidget {
  const AddProductDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
    required this.itemAsString,
    this.bottomAction,
    this.hintText = 'Select option',
  });

  final String label;
  final List<T> items;
  final T? selectedValue;
  final void Function(T) onSelected;
  final String Function(T) itemAsString;
  final Widget? bottomAction;
  final String hintText;

  void _openPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.size16.r),
        ),
      ),
      backgroundColor: AppColors.surface,
      builder: (_) => _DropdownSheet<T>(
        items: items,
        selected: selectedValue,
        itemAsString: itemAsString,
        bottomAction: bottomAction,
        onSelected: (val) {
          Navigator.of(context).pop();
          onSelected(val);
        },
        title: hintText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedValue != null;
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
                    hasSelection ? itemAsString(selectedValue as T) : hintText,
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

class _DropdownSheet<T> extends StatelessWidget {
  const _DropdownSheet({
    required this.items,
    required this.selected,
    required this.onSelected,
    required this.title,
    required this.itemAsString,
    this.bottomAction,
  });

  final List<T> items;
  final T? selected;
  final void Function(T) onSelected;
  final String title;
  final String Function(T) itemAsString;
  final Widget? bottomAction;

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
                title,
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
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final item = items[i];
                  final isSelected = selected == item;
                  return ListTile(
                    onTap: () => onSelected(item),
                    title: Text(
                      itemAsString(item),
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
            if (bottomAction != null) bottomAction!,
          ],
        ),
      ),
    );
  }
}
