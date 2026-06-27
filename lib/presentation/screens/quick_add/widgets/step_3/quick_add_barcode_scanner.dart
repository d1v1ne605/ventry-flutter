import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

/// Barcode / QR input section with manual input text box and scan button.
class QuickAddBarcodeScanner extends StatefulWidget {
  const QuickAddBarcodeScanner({
    super.key,
    required this.controller,
    required this.onScanTap,
    this.focusNode,
  });

  final TextEditingController controller;
  final VoidCallback onScanTap;
  final FocusNode? focusNode;

  @override
  State<QuickAddBarcodeScanner> createState() => _QuickAddBarcodeScannerState();
}

class _QuickAddBarcodeScannerState extends State<QuickAddBarcodeScanner> {
  late final FocusNode _focus;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focus = widget.focusNode ?? FocusNode();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() => _hasFocus = _focus.hasFocus);

  @override
  void dispose() {
    if (widget.focusNode == null) _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Heading
        Text(
          AppStrings.quickAddStep3BarcodeTitle,
          style: GoogleFonts.manrope(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.heading,
          ),
        ),
        SizedBox(height: AppSize.size14.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expanded input field
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 44.h,
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(AppSize.size8.r),
                  border: Border.all(
                    color: _hasFocus
                        ? AppColors.primary
                        : AppColors.inputBorder,
                    width: _hasFocus ? 1.5 : 1.0,
                  ),
                ),
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.heading,
                  ),
                  decoration: InputDecoration(
                    hintText: AppStrings.quickAddStep3BarcodeHint,
                    hintStyle: GoogleFonts.manrope(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textHint,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSize.size12.w,
                      vertical: AppSize.size10.h,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: AppSize.size12.w),

            // Scan Button
            GestureDetector(
              onTap: widget.onScanTap,
              child: Container(
                height: 44.h,
                padding: EdgeInsets.symmetric(horizontal: AppSize.size16.w),
                decoration: BoxDecoration(
                  color: AppColors.inStockBadgeFill, // soft light teal
                  borderRadius: BorderRadius.circular(AppSize.size8.r),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 20.r,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: AppSize.size8.w),
                    Text(
                      AppStrings.quickAddStep3Scan,
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
        ),
      ],
    );
  }
}
