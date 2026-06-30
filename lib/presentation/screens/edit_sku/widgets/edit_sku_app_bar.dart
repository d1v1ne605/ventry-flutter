import 'package:flutter/material.dart';
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
  });

  final String title;
  final VoidCallback onBackTap;
  final VoidCallback? onSaveTap;
  final bool showSaveAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: AppSize.size64.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.size16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _EditSkuIconButton(
                  icon: Icons.arrow_back_ios_new,
                  onTap: onBackTap,
                ),
                Text(title, style: AppTextStyles.editSkuTitle),
                showSaveAction
                    ? _EditSkuIconButton(icon: Icons.check, onTap: onSaveTap)
                    : SizedBox(width: AppSize.size48.w),
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
