import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';

/// The "Header Section" inside the Main Content Canvas.
///
/// Shows the dashboard title, subtitle, and the floating scanner button.
/// Matches the Figma "Header Section" frame layout.
class InventoryHeaderSection extends StatelessWidget {
  const InventoryHeaderSection({
    super.key,
    this.onScannerTap,
  });

  final VoidCallback? onScannerTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSize.size8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Title + subtitle column
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.inventoryDashboard,
                style: AppTextStyles.dashboardHeading,
              ),
              SizedBox(height: AppSize.size4.h),
              Text(
                AppStrings.inventorySubtitle,
                style: AppTextStyles.bodyManrope,
              ),
            ],
          ),
          // Global Scanner button
          _ScannerButton(onTap: onScannerTap),
        ],
      ),
    );
  }
}

/// Circular gradient scanner button with shadow overlay.
/// Matches the Figma "Button - Global Scanner" design.
class _ScannerButton extends StatelessWidget {
  const _ScannerButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.r,
        height: 48.r,
        decoration: BoxDecoration(
          gradient: AppColors.scannerGradient,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A00685F), // rgba(0, 104, 95, 0.1)
              offset: Offset(0, 2),
              blurRadius: 4,
              spreadRadius: -1,
            ),
            BoxShadow(
              color: Color(0x3300685F), // rgba(0, 104, 95, 0.2)
              offset: Offset(0, 4),
              blurRadius: 6,
              spreadRadius: -1,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: SvgPicture.asset(
          AppAssets.icScanner,
          width: 22.w,
          height: 18.h,
          colorFilter: const ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
