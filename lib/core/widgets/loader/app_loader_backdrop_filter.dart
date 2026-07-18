import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

class AppLoaderBackdropFilter extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final double blur;
  final Color? backgroundColor;

  const AppLoaderBackdropFilter({
    super.key,
    required this.child,
    required this.isLoading,
    this.blur = 4.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) ...[
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Container(
                color: backgroundColor ?? Colors.black.withValues(alpha: 0.4),
              ),
            ),
          ),
          const ModalBarrier(dismissible: false, color: Colors.transparent),
          const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ],
      ],
    );
  }
}
