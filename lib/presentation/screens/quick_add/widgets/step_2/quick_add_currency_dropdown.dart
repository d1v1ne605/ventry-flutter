import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/currency_option.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_2/quick_add_currency_sheet.dart';

/// Labelled dropdown for selecting currency in Quick Add Step 2.
class QuickAddCurrencyDropdown extends StatelessWidget {
  const QuickAddCurrencyDropdown({
    super.key,
    required this.label,
    required this.currencies,
    required this.selectedCurrency,
    required this.onSelected,
  });

  final String label;
  final List<CurrencyOption> currencies;
  final CurrencyOption? selectedCurrency;
  final void Function(CurrencyOption) onSelected;

  void _openPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.size16.r),
        ),
      ),
      backgroundColor: AppColors.surface,
      builder: (_) => QuickAddCurrencySheet(
        currencies: currencies,
        selected: selectedCurrency,
        onSelected: (curr) {
          Navigator.of(context).pop();
          onSelected(curr);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedCurrency != null;
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
                    hasSelection
                        ? selectedCurrency!.displayName
                        : 'Select Currency',
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
