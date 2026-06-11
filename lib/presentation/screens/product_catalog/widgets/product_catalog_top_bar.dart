import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';

/// Top bar for the Product Catalog screen.
///
/// Layout: [back button] | [logo icon + brand name] | [barcode scan button]
///
/// This is a screen-specific top bar. The brand icon uses a Material
/// inventory icon to represent the "StockMaster" logo.
class ProductCatalogTopBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ProductCatalogTopBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.onBarcodeTap,
  });

  final String title;
  final VoidCallback? onBackTap;
  final VoidCallback? onBarcodeTap;

  @override
  Size get preferredSize => Size.fromHeight(64.h);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        height: 64.h,
        padding: EdgeInsets.symmetric(horizontal: AppSize.size16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(
            bottom: BorderSide(color: AppColors.divider, width: 1),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x080F172A),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Back button
            _TopBarIconButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: onBackTap ?? () => Navigator.of(context).maybePop(),
            ),
            const Spacer(),
            // Logo + brand name
            _BrandTitle(title: title),
            const Spacer(),
            // Barcode scanner
            _TopBarIconButton(
              icon: Icons.barcode_reader,
              onTap: onBarcodeTap,
            ),
          ],
        ),
      ),
    );
  }
}

/// Brand logo + name widget in [ProductCatalogTopBar].
class _BrandTitle extends StatelessWidget {
  const _BrandTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28.r,
          height: 28.r,
          decoration: BoxDecoration(
            color: AppColors.cardIconBackground,
            borderRadius: BorderRadius.circular(6.r),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.inventory_2_outlined,
            size: 16.r,
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: 8.w),
        Text(title, style: AppTextStyles.topBarBrand),
      ],
    );
  }
}

/// Circular icon button used in [ProductCatalogTopBar].
class _TopBarIconButton extends StatelessWidget {
  const _TopBarIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(9999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9999),
        child: Padding(
          padding: EdgeInsets.all(AppSize.size8.r),
          child: Icon(icon, size: 22.r, color: AppColors.heading),
        ),
      ),
    );
  }
}
