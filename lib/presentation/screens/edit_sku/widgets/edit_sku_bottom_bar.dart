import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/primary_button.dart';

class EditSkuBottomBar extends StatelessWidget {
  const EditSkuBottomBar({
    super.key,
    required this.isEnabled,
    required this.onPressed,
  });

  final bool isEnabled;
  final VoidCallback onPressed;

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
        color: Color(0xF2FFFFFF),
        border: Border(top: BorderSide(color: AppColors.inputBorder)),
        boxShadow: [
          BoxShadow(
            color: Color(0x140F172A),
            offset: Offset(0, -4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Opacity(
        opacity: isEnabled ? 1 : 0.5,
        child: IgnorePointer(
          ignoring: !isEnabled,
          child: PrimaryButton(
            text: AppStrings.editSkuSaveChanges,
            onPressed: onPressed,
            icon: Icon(
              Icons.save_outlined,
              color: Colors.white,
              size: AppSize.size16.r,
            ),
          ),
        ),
      ),
    );
  }
}
