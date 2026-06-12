import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/product_attribute.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_3/quick_add_attribute_row.dart';

/// Container widget showing the Attributes heading, the list of rows, and the "+ Add Attribute" button.
class QuickAddAttributesList extends StatelessWidget {
  const QuickAddAttributesList({
    super.key,
    required this.attributes,
    required this.keyControllers,
    required this.valueControllers,
    required this.onAddAttribute,
    required this.onDeleteAttribute,
  });

  final List<ProductAttribute> attributes;
  final Map<String, TextEditingController> keyControllers;
  final Map<String, TextEditingController> valueControllers;
  final VoidCallback onAddAttribute;
  final void Function(String) onDeleteAttribute;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title: Attributes
        Text(
          AppStrings.quickAddStep3AttributesTitle,
          style: GoogleFonts.manrope(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
        SizedBox(height: AppSize.size14.h),

        // List of Attribute Rows
        ...attributes.map((attr) {
          final kCtrl = keyControllers[attr.id] ?? TextEditingController(text: attr.key);
          final vCtrl = valueControllers[attr.id] ?? TextEditingController(text: attr.value);
          return QuickAddAttributeRow(
            keyController: kCtrl,
            valueController: vCtrl,
            onDelete: () => onDeleteAttribute(attr.id),
          );
        }),

        SizedBox(height: AppSize.size4.h),

        // "+ Add Attribute" Button
        GestureDetector(
          onTap: onAddAttribute,
          child: Container(
            height: 44.h,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppSize.size8.r),
              border: Border.all(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_rounded,
                  size: 20.r,
                  color: AppColors.primary,
                ),
                SizedBox(width: AppSize.size4.w),
                Text(
                  AppStrings.quickAddStep3AddAttributeButton,
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
