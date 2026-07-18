import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/utils/app_formatters.dart';

/// Quick suggestion price chips shown below the Selling Price field.
class QuickAddPriceChips extends StatelessWidget {
  const QuickAddPriceChips({
    super.key,
    required this.suggestions,
    required this.onTap,
  });

  final List<int> suggestions;
  final void Function(int) onTap;

  /// Helper to format number with comma separator (e.g. 100000 -> 100,000)
  String _formatNumber(int val) {
    return AppFormatters.formatPrice(val);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSize.size8.w,
      children: suggestions.map((val) {
        final formattedText = _formatNumber(val);
        return GestureDetector(
          onTap: () => onTap(val),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.size12.w,
              vertical: AppSize.size4.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(color: AppColors.inputBorder),
            ),
            child: Text(
              formattedText,
              style: GoogleFonts.manrope(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.subtitle,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
