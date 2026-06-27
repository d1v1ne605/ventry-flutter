import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';

/// Defines each tab in the bottom navigation bar.
enum AppNavItem {
  sales,
  inventory,
  partners,
  account;

  String get label => switch (this) {
    AppNavItem.sales => AppStrings.navSales,
    AppNavItem.inventory => AppStrings.navInventory,
    AppNavItem.partners => AppStrings.navPartners,
    AppNavItem.account => AppStrings.navAccount,
  };

  String get iconPath => switch (this) {
    AppNavItem.sales => AppAssets.icSales,
    AppNavItem.inventory => AppAssets.icInventory,
    AppNavItem.partners => AppAssets.icPartners,
    AppNavItem.account => AppAssets.icAccount,
  };
}

/// Reusable bottom navigation bar matching the Figma "BottomNavBar" design.
///
/// Renders four nav items (Sales, Inventory, Partners, Account).
/// The active item is highlighted with a teal-tinted pill background.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentItem,
    required this.onItemTapped,
  });

  final AppNavItem currentItem;
  final void Function(AppNavItem item) onItemTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 81.h,
      decoration: BoxDecoration(
        color: AppColors.barBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSize.size12.r),
          topRight: Radius.circular(AppSize.size12.r),
        ),
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A), // rgba(15, 23, 42, 0.05)
            offset: Offset(0, -4),
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: AppSize.size24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: AppNavItem.values
            .map(
              (item) => _NavItemWidget(
                item: item,
                isActive: item == currentItem,
                onTap: () => onItemTapped(item),
              ),
            )
            .toList(),
      ),
    );
  }
}

/// Single nav item tile rendered inside [AppBottomNavBar].
class _NavItemWidget extends StatelessWidget {
  const _NavItemWidget({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  final AppNavItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isActive
        ? AppColors.primary
        : AppColors.navInactive;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.size16.w,
          vertical: AppSize.size8.h,
        ),
        decoration: isActive
            ? BoxDecoration(
                color: AppColors.navActiveBackground,
                borderRadius: BorderRadius.circular(AppSize.size8.r),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon
            SvgPicture.asset(
              item.iconPath,
              width: 20.w,
              height: 20.h,
              colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
            ),
            SizedBox(height: AppSize.size4.h),
            // Label
            Text(
              item.label,
              style: isActive
                  ? AppTextStyles.navLabelActive
                  : AppTextStyles.navLabel,
            ),
          ],
        ),
      ),
    );
  }
}
