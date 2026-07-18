import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized SnackBar factory matching the Ventry app theme.
///
/// Usage:
/// ```dart
/// AppSnackBar.showSuccess(context, 'Account created!');
/// AppSnackBar.showError(context, 'Something went wrong.');
/// ```
abstract class AppSnackBar {
  static void showSuccess(BuildContext context, String message) {
    _show(context, _AppSnackBarType.success, message);
  }

  static void showError(BuildContext context, String message) {
    _show(context, _AppSnackBarType.error, message);
  }

  static void _show(
    BuildContext context,
    _AppSnackBarType type,
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          duration: const Duration(seconds: 3),
          content: _AppSnackBarContent(type: type, message: message),
        ),
      );
  }
}

enum _AppSnackBarType { success, error }

class _AppSnackBarContent extends StatelessWidget {
  const _AppSnackBarContent({required this.type, required this.message});

  final _AppSnackBarType type;
  final String message;

  @override
  Widget build(BuildContext context) {
    final isSuccess = type == _AppSnackBarType.success;

    final backgroundColor = isSuccess
        ? const Color(0xFF022C22)
        : const Color(0xFF2D0A0A);
    final borderColor = isSuccess
        ? const Color(0xFF059669)
        : const Color(0xFFDC2626);
    final iconColor = isSuccess
        ? const Color(0xFF34D399)
        : const Color(0xFFF87171);
    final iconData = isSuccess
        ? Icons.check_circle_rounded
        : Icons.error_rounded;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderColor.withValues(alpha: 0.5), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon with glowing background
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 20.sp),
          ),
          SizedBox(width: 12.w),
          // Message
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
