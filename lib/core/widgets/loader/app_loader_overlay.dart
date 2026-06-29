import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

class AppLoaderOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final double blur;
  final Color? backgroundColor;

  const AppLoaderOverlay({
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
            child: Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
