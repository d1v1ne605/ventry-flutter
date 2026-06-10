import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle get heading1 => GoogleFonts.inter(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        height: 32 / 24,
        color: AppColors.textHeading,
      );

  static TextStyle get body => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: AppColors.textBody,
      );

  static TextStyle get label => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 14 * 0.025,
        color: AppColors.textHeading,
      );

  static TextStyle get input => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textHeading,
      );

  static TextStyle get inputHint => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppColors.textHint,
      );

  static TextStyle get linkSmall => GoogleFonts.inter(
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
        color: AppColors.primary,
      );

  static TextStyle get buttonText => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 14 * 0.025,
        color: Colors.white,
      );

  /// Section heading for registration form cards (style_OTCDPP in Figma).
  static TextStyle get sectionHeading => GoogleFonts.inter(
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        height: 24 / 18,
        color: AppColors.textHeading,
      );

  /// Subtle body text used in subtitles (fill_9TBVDU: #475569).
  static TextStyle get bodySubtle => GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        color: const Color(0xFF475569),
      );
}
