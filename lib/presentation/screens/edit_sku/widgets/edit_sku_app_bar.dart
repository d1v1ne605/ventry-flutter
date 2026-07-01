import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';

class EditSkuAppBar extends StatelessWidget {
  const EditSkuAppBar({
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
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Container(
        color: Colors.white,
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
                  child: _EditSkuIconButton(
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
                    style: AppTextStyles.editSkuTitle,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child:
                      trailingWidget ??
                      (showSaveAction
                          ? _EditSkuIconButton(
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

class _EditSkuIconButton extends StatelessWidget {
  const _EditSkuIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      splashRadius: 20.r,
      icon: Icon(icon, color: Colors.white, size: AppSize.size20.r),
    );
  }
}
