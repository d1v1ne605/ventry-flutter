import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

/// Product image upload area with dashed border.
///
/// Shows a cloud upload icon + caption when no image is selected.
/// Tapping triggers [onTap] (e.g., image picker integration).
class QuickAddImageUpload extends StatelessWidget {
  const QuickAddImageUpload({
    super.key,
    required this.label,
    required this.onTap,
    this.imagePath,
  });

  final String label;
  final VoidCallback onTap;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.subtitle,
          ),
        ),
        SizedBox(height: AppSize.size4.h),
        GestureDetector(
          onTap: onTap,
          child: _UploadBox(imagePath: imagePath),
        ),
      ],
    );
  }
}

class _UploadBox extends StatelessWidget {
  const _UploadBox({this.imagePath});

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120.h,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size8.r),
      ),
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: AppColors.inputBorder,
          radius: AppSize.size8.r,
          dashWidth: 6,
          dashGap: 4,
        ),
        child: imagePath != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.size8.r),
                child: Image.asset(
                  imagePath!,
                  fit: BoxFit.cover,
                ),
              )
            : const _UploadPlaceholder(),
      ),
    );
  }
}

class _UploadPlaceholder extends StatelessWidget {
  const _UploadPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: AppColors.cardIconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.cloud_upload_outlined,
            size: 22.r,
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: AppSize.size8.h),
        Text(
          'Tap to upload image',
          style: GoogleFonts.manrope(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

/// Custom painter that draws a dashed rectangle border.
class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({
    required this.color,
    required this.radius,
    this.dashWidth = 6,
    this.dashGap = 4,
  });

  final Color color;
  final double radius;
  final double dashWidth;
  final double dashGap;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    final dashPath = _createDashedPath(path, dashWidth, dashGap);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source, double dashWidth, double dashGap) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final len = draw ? dashWidth : dashGap;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color ||
      old.radius != radius ||
      old.dashWidth != dashWidth ||
      old.dashGap != dashGap;
}
