import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppZoomableImage extends StatelessWidget {
  const AppZoomableImage({
    super.key,
    required this.placeholder,
    this.imageUrl,
    this.imageFilePath,
    this.width,
    this.height,
    this.borderRadius,
    this.backgroundColor,
    this.fit = BoxFit.cover,
    this.enabled = true,
  });

  final String? imageUrl;
  final String? imageFilePath;
  final Widget placeholder;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final BoxFit fit;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final image = _ZoomableImageContent(
      imageUrl: imageUrl,
      imageFilePath: imageFilePath,
      placeholder: placeholder,
      fit: fit,
    );
    final hasImageSource =
        (imageUrl != null && imageUrl!.isNotEmpty) ||
        (imageFilePath != null && imageFilePath!.isNotEmpty);

    return GestureDetector(
      onTap: enabled && hasImageSource
          ? () => _showZoomableViewer(context)
          : null,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        clipBehavior: Clip.antiAlias,
        child: image,
      ),
    );
  }

  Future<void> _showZoomableViewer(BuildContext context) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Image Viewer',
      barrierColor: Colors.black87,
      pageBuilder: (dialogContext, _, __) {
        return _ZoomableImageViewer(
          imageUrl: imageUrl,
          imageFilePath: imageFilePath,
          placeholder: placeholder,
        );
      },
    );
  }
}

class _ZoomableImageContent extends StatelessWidget {
  const _ZoomableImageContent({
    required this.placeholder,
    required this.fit,
    this.imageUrl,
    this.imageFilePath,
  });

  final String? imageUrl;
  final String? imageFilePath;
  final Widget placeholder;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (imageFilePath != null && imageFilePath!.isNotEmpty) {
      return Image.file(
        File(imageFilePath!),
        fit: fit,
        errorBuilder: (_, __, ___) => placeholder,
      );
    }

    if (imageUrl == null || imageUrl!.isEmpty) {
      return placeholder;
    }

    return Image.network(
      imageUrl!,
      fit: fit,
      errorBuilder: (_, __, ___) => placeholder,
    );
  }
}

class _ZoomableImageViewer extends StatelessWidget {
  const _ZoomableImageViewer({
    required this.placeholder,
    this.imageUrl,
    this.imageFilePath,
  });

  final String? imageUrl;
  final String? imageFilePath;
  final Widget placeholder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: ColoredBox(
                  color: Colors.transparent,
                  child: Center(
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 4,
                      child: _ZoomableImageContent(
                        imageUrl: imageUrl,
                        imageFilePath: imageFilePath,
                        placeholder: placeholder,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 12.h,
              right: 12.w,
              child: Material(
                color: Colors.white.withValues(alpha: 0.92),
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => Navigator.of(context).pop(),
                  child: Padding(
                    padding: EdgeInsets.all(8.r),
                    child: Icon(Icons.close, color: Colors.black87, size: 20.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
