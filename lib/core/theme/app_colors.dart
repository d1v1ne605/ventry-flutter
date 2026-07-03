import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);

  // Inputs
  static const Color inputFill = Color(0xFFF1F5F9);
  static const Color inputBorder = Color(0xFFE2E8F0);

  // Texts
  static const Color textHeading = Color(0xFF171D1C);
  static const Color textBody = Color(0xFF64748B);
  static const Color textHint = Color(0xB364748B); // rgba(100, 116, 139, 0.7)

  // Primary
  static const Color primary = Color(0xFF00685F);
  static const Color primaryDark = Color(0xFF115E59);
  static const Color error = Color(0xFFEF4444);

  // Gradient for button
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF00685F), Color(0xFF115E59)],
  );

  // Shadows
  static const BoxShadow cardShadow = BoxShadow(
    color: Color(0x0D0F1722), // rgba(15, 23, 42, 0.05)
    offset: Offset(0, 4),
    blurRadius: 12,
  );

  static const BoxShadow buttonShadow = BoxShadow(
    color: Color(0x4000685F), // rgba(0, 104, 95, 0.25)
    offset: Offset(0, 2),
    blurRadius: 5,
  );

  // Screen background (from Figma fill_9CAKHN / #F7F9FB)
  static const Color screenBackground = Color(0xFFF7F9FB);

  // Top app bar / bottom nav background (fill_JPG6LT)
  static const Color barBackground = Color(0xFFF7F9FB);

  // Bottom nav divider (fill_EEBU81)
  static const Color divider = Color(0xFFE5E7EB);

  // Bottom nav active item background (fill_NG2OSG: #D5E0F8)
  static const Color navActiveBackground = Color(0xFFD5E0F8);

  // Nav inactive icon/text (fill_EF2MI6: #6D7A77)
  static const Color navInactive = Color(0xFF6D7A77);

  // Heading text color (fill_52K9LO: #191C1E)
  static const Color heading = Color(0xFF191C1E);

  // Subtitle / icon color (fill_03ZF2A / fill_S3GGS7: #545F73)
  static const Color subtitle = Color(0xFF545F73);

  // Card icon container background (fill_C2FU93: rgba(13, 148, 136, 0.1))
  static const Color cardIconBackground = Color(0x190D9488);

  // Card icon teal color (fill_9MB8CD: #00685F)
  static const Color cardIconColor = Color(0xFF00685F);

  // Card chevron color (fill_A75VHH: #BCC9C6)
  static const Color cardChevron = Color(0xFFBCC9C6);

  // Scanner button gradient
  static const Gradient scannerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF008378), // rgba(0, 131, 120, 1)
      Color(0xFF00685F), // rgba(0, 104, 95, 1)
    ],
  );

  // Card shadow (effect_STCC4P)
  static const List<BoxShadow> cardShadows = [
    BoxShadow(
      color: Color(0x141E293B), // rgba(30, 41, 59, 0.08)
      offset: Offset(4, 4),
      blurRadius: 12,
    ),
    BoxShadow(
      color: Color(0xCCFFFFFF), // rgba(255, 255, 255, 0.8)
      offset: Offset(-2, -2),
      blurRadius: 6,
    ),
  ];

  // ── Product Catalog ─────────────────────────────────────────────────────────

  // Search bar
  static const Color searchBarFill = Color(0xFFF1F5F9);
  static const Color searchBarBorder = Color(0xFFE2E8F0);

  // Filter chip — active (teal outlined)
  static const Color filterChipActiveBorder = Color(0xFF00685F);
  static const Color filterChipActiveFill = Color(0xFFFFFFFF);
  static const Color filterChipActiveText = Color(0xFF00685F);
  // Filter chip — inactive
  static const Color filterChipInactiveBorder = Color(0xFFE2E8F0);
  static const Color filterChipInactiveFill = Color(0xFFFFFFFF);
  static const Color filterChipInactiveText = Color(0xFF6D7A77);
  // Filter chip count badge
  static const Color filterChipBadgeTeal = Color(0xFF00685F);
  static const Color filterChipBadgeOrange = Color(0xFFFFA500);
  static const Color filterChipBadgeText = Color(0xFFFFFFFF);

  // SKU chip background
  static const Color skuChipFill = Color(0xFFF1F5F9);
  static const Color skuChipText = Color(0xFF6D7A77);

  // Stock status badge — In Stock
  static const Color inStockBadgeFill = Color(0xFFE6F4F1);
  static const Color inStockBadgeText = Color(0xFF00685F);
  static const Color inStockDot = Color(0xFF22C55E);

  // Stock status badge — Low Stock
  static const Color lowStockBadgeFill = Color(0xFFFFF7E6);
  static const Color lowStockBadgeText = Color(0xFFF59E0B);
  static const Color lowStockDot = Color(0xFFF59E0B);
  // Low stock left border
  static const Color lowStockBorder = Color(0xFFF59E0B);

  // Stock status badge — Out of Stock
  static const Color outOfStockBadgeFill = Color(0xFFFFECEC);
  static const Color outOfStockBadgeText = Color(0xFFEF4444);
  static const Color outOfStockDot = Color(0xFFEF4444);
  // Out of stock left border
  static const Color outOfStockBorder = Color(0xFFEF4444);
  // Muted text for out-of-stock products
  static const Color textMuted = Color(0xFFADB5BD);

  // Edit SKU
  static const Color skuFormFieldBorder = Color(0xFF94A3B8);
  static const Color skuFormCardBackground = Color(0xFFFFFFFF);
  static const Color skuFormSoftBackground = Color(0xFFF5FAF8);
  static const Color skuFormTagBorder = Color(0xFFD7E2EC);
  static const Color skuFormTagText = Color(0xFF64748B);
  static const Color skuFormSuccess = Color(0xFF10B981);

  // Product name text
  static const Color productName = Color(0xFF1C2B2A);
  static const Color productMeta = Color(0xFF6D7A77);
  static const Color productPrice = Color(0xFF191C1E);

  // FAB
  static const Color fabBackground = Color(0xFF00685F);
}
