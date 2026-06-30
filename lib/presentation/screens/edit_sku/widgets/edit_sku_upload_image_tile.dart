import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/widgets/dashed_border_painter.dart';

class EditSkuUploadImageTile extends StatelessWidget {
  const EditSkuUploadImageTile({super.key, this.height, this.onTap});

  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: AppColors.inputBorder,
          radius: AppSize.size12.r,
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSize.size12.r),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSize.size12.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                  size: AppSize.size24.r,
                  color: AppColors.textBody,
                ),
                SizedBox(height: AppSize.size8.h),
                Text(
                  AppStrings.editSkuUploadNew,
                  style: AppTextStyles.editSkuFieldLabel,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
