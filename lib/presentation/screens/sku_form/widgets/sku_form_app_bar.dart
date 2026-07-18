import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';

class SkuFormAppBar extends StatelessWidget {
  const SkuFormAppBar({
    super.key,
    required this.title,
    required this.onBackTap,
    this.onSaveTap,
    this.showSaveAction = true,
    this.trailingWidget,
  });

  final String title;
  final VoidCallback onBackTap;
  final VoidCallback? onSaveTap;
  final bool showSaveAction;
  final Widget? trailingWidget;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: AppColors.surface,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Container(
        color: AppColors.surface,
        child: SafeArea(
          bottom: false,
          child: Container(
            height: AppSize.size64.h,
            color: AppColors.primary,
            padding: EdgeInsets.symmetric(horizontal: AppSize.size16.w),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: _SkuFormIconButton(
                    icon: Icons.arrow_back_ios_new,
                    onTap: onBackTap,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: (AppSize.size48 + AppSize.size8).w,
                  ),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.skuFormTitle,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child:
                      trailingWidget ??
                      (showSaveAction
                          ? _SkuFormIconButton(
                              icon: Icons.check,
                              onTap: onSaveTap,
                            )
                          : SizedBox(width: AppSize.size48.w)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SkuFormIconButton extends StatelessWidget {
  const _SkuFormIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      splashRadius: AppSize.size20.r,
      icon: Icon(icon, color: AppColors.onPrimary, size: AppSize.size20.r),
    );
  }
}
