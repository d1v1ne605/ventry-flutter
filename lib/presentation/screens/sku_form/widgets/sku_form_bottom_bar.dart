import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/primary_button.dart';

class SkuFormBottomBar extends StatelessWidget {
  const SkuFormBottomBar({
    super.key,
    required this.isEnabled,
    required this.onPressed,
    this.label = AppStrings.skuFormSaveChanges,
    this.isLoading = false,
  });

  final bool isEnabled;
  final VoidCallback onPressed;
  final String label;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSize.size16.w,
        AppSize.size16.h,
        AppSize.size16.w,
        (AppSize.size16 + bottomPadding).h,
      ),
      decoration: const BoxDecoration(
        color: AppColors.skuFormBottomBarBackground,
        border: Border(top: BorderSide(color: AppColors.inputBorder)),
        boxShadow: [
          BoxShadow(
            color: AppColors.skuFormOverlayShadow,
            offset: Offset(0, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Opacity(
        opacity: isEnabled ? 1 : 0.5,
        child: IgnorePointer(
          ignoring: !isEnabled || isLoading,
          child: PrimaryButton(
            text: label,
            onPressed: onPressed,
            isLoading: isLoading,
            icon: Icon(
              Icons.save_outlined,
              color: AppColors.onPrimary,
              size: AppSize.size16.r,
            ),
          ),
        ),
      ),
    );
  }
}
