import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

/// Labelled text input field matching the Figma Quick Add form style.
///
/// Shows a small gray label above a rounded input box.
/// Supports optional [suffixWidget] (e.g. generate-SKU icon).
class QuickAddInputField extends StatelessWidget {
  const QuickAddInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    this.suffixWidget,
    this.maxLines = 1,
    this.minLines = 1,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.nextFocusNode,
    this.statusText,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final Widget? suffixWidget;
  final int maxLines;
  final int minLines;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final String? statusText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: AppSize.size14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textHeading,
              ),
            ),
            if (statusText != null)
              Text(
                statusText!,
                style: GoogleFonts.manrope(
                  fontSize: AppSize.size12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.subtitle.withValues(alpha: 0.8),
                ),
              ),
          ],
        ),
        SizedBox(height: AppSize.size4.h),
        _InputBox(
          controller: controller,
          hintText: hintText,
          suffixWidget: suffixWidget,
          maxLines: maxLines,
          minLines: minLines,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          focusNode: focusNode,
          nextFocusNode: nextFocusNode,
        ),
      ],
    );
  }
}

class _InputBox extends StatefulWidget {
  const _InputBox({
    required this.controller,
    required this.hintText,
    this.suffixWidget,
    required this.maxLines,
    required this.minLines,
    this.keyboardType,
    required this.textInputAction,
    this.focusNode,
    this.nextFocusNode,
  });

  final TextEditingController controller;
  final String hintText;
  final Widget? suffixWidget;
  final int maxLines;
  final int minLines;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  @override
  State<_InputBox> createState() => _InputBoxState();
}

class _InputBoxState extends State<_InputBox> {
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
    return AnimatedContainer(
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
        crossAxisAlignment: widget.maxLines > 1
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _focus,
              maxLines: widget.maxLines,
              minLines: widget.minLines,
              keyboardType:
                  widget.keyboardType ??
                  (widget.maxLines > 1
                      ? TextInputType.multiline
                      : TextInputType.text),
              textInputAction: widget.textInputAction,
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
          if (widget.suffixWidget != null) widget.suffixWidget!,
        ],
      ),
    );
  }
}
