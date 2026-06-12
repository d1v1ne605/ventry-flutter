import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

/// Monetary input field for Quick Add Step 2.
///
/// Features:
/// - Label row showing label text on the left and status (Required/Optional) on the right.
/// - Left-aligned currency prefix.
/// - Right-aligned input text (standard for financial figures).
/// - Smooth animated focus border.
class QuickAddPriceInput extends StatefulWidget {
  const QuickAddPriceInput({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.currencySymbol,
    this.statusText,
    this.focusNode,
    this.nextFocusNode,
  });

  final String label;
  final String hintText;
  final TextEditingController controller;
  final String currencySymbol;
  final String? statusText;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  @override
  State<QuickAddPriceInput> createState() => _QuickAddPriceInputState();
}

class _QuickAddPriceInputState extends State<QuickAddPriceInput> {
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
        // Label Row: [Label text] ... [Required/Optional]
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.label,
              style: GoogleFonts.manrope(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.subtitle,
              ),
            ),
            if (widget.statusText != null)
              Text(
                widget.statusText!,
                style: GoogleFonts.manrope(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subtitle.withValues(alpha: 0.8),
                ),
              ),
          ],
        ),
        SizedBox(height: AppSize.size4.h),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(AppSize.size8.r),
            border: Border.all(
              color: _hasFocus ? AppColors.primary : AppColors.inputBorder,
              width: _hasFocus ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: AppSize.size12.w),
                child: Text(
                  widget.currencySymbol,
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.heading.withValues(alpha: 0.7),
                  ),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  textAlign: TextAlign.end,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => widget.nextFocusNode?.requestFocus(),
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.heading,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: GoogleFonts.manrope(
                      fontSize: 14.sp,
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
            ],
          ),
        ),
      ],
    );
  }
}
