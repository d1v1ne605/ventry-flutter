import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';

/// Reusable top app bar matching the Figma "Header - TopAppBar" design.
///
/// Displays a menu button on the left, a centered title, and an
/// action button (default: search) on the right. All parameters are
/// configurable so any screen can reuse this widget.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.onMenuTap,
    this.onActionTap,
    this.actionIcon = AppAssets.icSearch,
    this.leadingWidget,
    this.trailingWidget,
  });

  /// Title displayed in the center of the bar (usually in UPPERCASE).
  final String title;

  /// Callback when the leading menu icon is pressed.
  final VoidCallback? onMenuTap;

  /// Callback when the trailing action icon is pressed.
  final VoidCallback? onActionTap;

  /// Asset path for the trailing action icon. Defaults to search icon.
  final String? actionIcon;

  /// Custom widget to replace the default leading menu button
  final Widget? leadingWidget;

  /// Custom widget to replace the default trailing action button
  final Widget? trailingWidget;

  @override
  Size get preferredSize => Size.fromHeight(64.h);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.barBackground,
          border: Border(
            bottom: BorderSide(color: AppColors.divider, width: 1),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x080F172A), // rgba(15, 23, 42, 0.03)
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Container(
            height: 64.h,
            padding: EdgeInsets.symmetric(horizontal: AppSize.size24.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading menu button
            leadingWidget ?? _BarIconButton(
              iconPath: AppAssets.icMenu,
              iconWidth: 18.w,
              iconHeight: 12.h,
              onTap: onMenuTap,
            ),

            // Title
            Text(
              title.toUpperCase(),
              style: AppTextStyles.topBarTitle,
            ),

            // Trailing action button
            trailingWidget ??
                (actionIcon != null && actionIcon!.isNotEmpty
                    ? _BarIconButton(
                        iconPath: actionIcon!,
                        iconWidth: 18.w,
                        iconHeight: 18.h,
                        onTap: onActionTap,
                      )
                    : SizedBox(width: 40.w, height: 40.h)),
          ],
        ),
          ),
        ),
      ),
    );
  }
}

/// Circular icon button used inside [AppTopBar].
class _BarIconButton extends StatelessWidget {
  const _BarIconButton({
    required this.iconPath,
    required this.iconWidth,
    required this.iconHeight,
    this.onTap,
  });

  final String iconPath;
  final double iconWidth;
  final double iconHeight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(9999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9999),
        child: Opacity(
          opacity: 0.8,
          child: Padding(
            padding: EdgeInsets.all(AppSize.size8.r),
            child: SvgPicture.asset(
              iconPath,
              width: iconWidth,
              height: iconHeight,
              colorFilter: const ColorFilter.mode(
                AppColors.subtitle,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
