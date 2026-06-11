import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';

/// Data model for a single dashboard card entry.
class InventoryCardData {
  const InventoryCardData({
    required this.title,
    required this.subtitle,
    required this.iconPath,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String iconPath;
  final VoidCallback? onTap;
}

/// Renders a single dashboard card matching the Figma
/// "Button - Card" design (Product Catalog / Category Management / Stock Movement Logs).
///
/// Each card has:
/// - A teal circular icon container on the left
/// - Title + subtitle text in the center (fills available width)
/// - A muted chevron on the right
class InventoryDashboardCard extends StatelessWidget {
  const InventoryDashboardCard({
    super.key,
    required this.data,
  });

  final InventoryCardData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSize.size12.r),
      child: InkWell(
        onTap: data.onTap,
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        splashColor: AppColors.cardIconBackground,
        highlightColor: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSize.size12.r),
            boxShadow: AppColors.cardShadows,
          ),
          padding: EdgeInsets.all(AppSize.size16.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon container
              _CardIconContainer(iconPath: data.iconPath),
              SizedBox(width: AppSize.size16.w),
              // Title + subtitle
              Expanded(child: _CardTextBlock(data: data)),
              SizedBox(width: AppSize.size16.w),
              // Chevron
              SvgPicture.asset(
                AppAssets.icChevronRight,
                width: 7.4.w,
                height: 12.h,
                colorFilter: const ColorFilter.mode(
                  Color(0xFFBCC9C6),
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Circular teal-tinted icon container for [InventoryDashboardCard].
class _CardIconContainer extends StatelessWidget {
  const _CardIconContainer({required this.iconPath});

  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.r,
      height: 48.r,
      decoration: const BoxDecoration(
        color: AppColors.cardIconBackground,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        iconPath,
        width: 20.r,
        height: 20.r,
        colorFilter: const ColorFilter.mode(
          Color(0xFF00685F),
          BlendMode.srcIn,
        ),
      ),
    );
  }
}

/// Title + subtitle text column for [InventoryDashboardCard].
class _CardTextBlock extends StatelessWidget {
  const _CardTextBlock({required this.data});

  final InventoryCardData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(data.title, style: AppTextStyles.cardTitle),
        SizedBox(height: AppSize.size4.h),
        Text(
          data.subtitle,
          style: AppTextStyles.bodyManrope,
        ),
      ],
    );
  }
}
