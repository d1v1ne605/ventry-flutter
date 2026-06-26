import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_1/quick_add_image_upload_items.dart';

/// Product image upload area.
/// Matches Figma label style and provides a large main image
/// plus a row of smaller thumbnail boxes below for multiple images.
class QuickAddImageUpload extends StatelessWidget {
  const QuickAddImageUpload({
    super.key,
    required this.label,
    required this.onTap,
    this.imagePaths = const [],
    this.onRemoveImage,
  });

  final String label;
  final VoidCallback onTap;
  final List<String> imagePaths;
  final void Function(int index)? onRemoveImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textBody,
          ),
        ),
        SizedBox(height: AppSize.size4.h),
        // Main Image / Large Placeholder
        GestureDetector(
          onTap: imagePaths.isEmpty ? onTap : () {},
          child: UploadBox(
            imagePath: imagePaths.isNotEmpty ? imagePaths.first : null,
            onRemove: imagePaths.isNotEmpty && onRemoveImage != null
                ? () => onRemoveImage!(0)
                : null,
          ),
        ),
        SizedBox(height: AppSize.size12.h),
        // Small thumbnails row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (int i = 1; i < imagePaths.length; i++) ...[
                ImagePreviewItem(
                  imagePath: imagePaths[i],
                  onRemove: onRemoveImage != null ? () => onRemoveImage!(i) : null,
                ),
                SizedBox(width: 12.w),
              ],
              GestureDetector(
                onTap: onTap,
                child: const AddMoreBox(),
              ),
              // Show a couple of empty boxes if there are very few images
              if (imagePaths.length <= 1) ...[
                SizedBox(width: 12.w),
                const EmptySmallBox(),
                SizedBox(width: 12.w),
                const EmptySmallBox(),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
