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

  // ── Manrope styles (Inventory Dashboard / Figma) ──────────────────────────

  /// "Inventory Dashboard" heading — Manrope SemiBold 24 (style_A80L26)
  static TextStyle get dashboardHeading => GoogleFonts.manrope(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    color: AppColors.heading,
  );

  /// Card title — Manrope SemiBold 18 (style_6QKXRQ)
  static TextStyle get cardTitle => GoogleFonts.manrope(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    color: AppColors.heading,
  );

  /// "STORAGE MANAGER" app bar title — Manrope Bold 16 uppercase (style_SF3FVA)
  static TextStyle get topBarTitle => GoogleFonts.manrope(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    height: 24 / 16,
    letterSpacing: 16 * 0.05,
    color: AppColors.primary,
  );

  /// Nav label — Manrope SemiBold 14 (style_1CFXP6)
  static TextStyle get navLabel => GoogleFonts.manrope(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 16 / 14,
    letterSpacing: 14 * 0.0357,
    color: AppColors.navInactive,
  );

  /// Nav label active
  static TextStyle get navLabelActive => GoogleFonts.manrope(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 16 / 14,
    letterSpacing: 14 * 0.0357,
    color: AppColors.primary,
  );

  /// Body regular 14 — Manrope Regular (style_FJFLON)
  static TextStyle get bodyManrope => GoogleFonts.manrope(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.subtitle,
  );

  // ── Product Catalog styles ───────────────────────────────────────────────────

  /// Top bar brand name — Manrope Bold 20
  static TextStyle get topBarBrand => GoogleFonts.manrope(
    fontSize: 20.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  /// Product name — Manrope SemiBold 16
  static TextStyle get productName => GoogleFonts.manrope(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 22 / 16,
    color: AppColors.productName,
  );

  /// Product name muted (out of stock)
  static TextStyle get productNameMuted => GoogleFonts.manrope(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 22 / 16,
    color: AppColors.textMuted,
  );

  /// Product meta (size, color) — Manrope Regular 13
  static TextStyle get productMeta => GoogleFonts.manrope(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.productMeta,
  );

  /// SKU chip text — Manrope Medium 12
  static TextStyle get skuChip => GoogleFonts.manrope(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.skuChipText,
  );

  /// Product price — Manrope SemiBold 15
  static TextStyle get productPrice => GoogleFonts.manrope(
    fontSize: 15.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.productPrice,
  );

  /// Stock badge text — Manrope SemiBold 12
  static TextStyle get stockBadge =>
      GoogleFonts.manrope(fontSize: 12.sp, fontWeight: FontWeight.w600);

  /// Filter chip label — Manrope SemiBold 13
  static TextStyle get filterChipLabel =>
      GoogleFonts.manrope(fontSize: 13.sp, fontWeight: FontWeight.w600);

  /// Search hint / input — Manrope Regular 14
  static TextStyle get searchHint => GoogleFonts.manrope(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
  );

  static TextStyle get skuFormTitle => GoogleFonts.inter(
    fontSize: 24.sp,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: -0.6,
    color: Colors.white,
  );

  static TextStyle get skuFormSectionTitle => GoogleFonts.inter(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    color: const Color(0xFF3D4947),
  );

  static TextStyle get skuFormFieldLabel => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.textBody,
  );

  static TextStyle get skuFormFieldValue => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.textHeading,
  );

  static TextStyle get skuFormButtonLabel => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    height: 21 / 14,
    letterSpacing: 0.35,
    color: AppColors.textHeading,
  );

  static TextStyle get skuFormTag => GoogleFonts.inter(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.skuFormTagText,
  );
}
