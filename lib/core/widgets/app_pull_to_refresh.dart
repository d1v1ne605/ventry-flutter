import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

typedef AppRefreshCallback = FutureOr<void> Function();

class AppPullToRefresh extends StatefulWidget {
  static const Duration defaultMinimumLoaderDuration = Duration(
    milliseconds: 700,
  );
  static const Duration defaultCooldown = Duration(seconds: 2);

  const AppPullToRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
    this.minimumLoaderDuration = defaultMinimumLoaderDuration,
    this.cooldown = defaultCooldown,
    this.displacement,
  });

  final AppRefreshCallback onRefresh;
  final Widget child;
  final Duration minimumLoaderDuration;
  final Duration cooldown;
  final double? displacement;

  @override
  State<AppPullToRefresh> createState() => _AppPullToRefreshState();
}

class _AppPullToRefreshState extends State<AppPullToRefresh> {
  DateTime? _lastRefreshStartedAt;
  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    if (_shouldSkipRefresh()) {
      await Future<void>.delayed(widget.minimumLoaderDuration);
      return;
    }

    _isRefreshing = true;
    _lastRefreshStartedAt = DateTime.now();
    final startedAt = DateTime.now();

    try {
      await widget.onRefresh();
    } finally {
      await _completeMinimumLoaderDuration(startedAt);
      _isRefreshing = false;
    }
  }

  bool _shouldSkipRefresh() {
    if (_isRefreshing) {
      return true;
    }

    final lastRefreshStartedAt = _lastRefreshStartedAt;
    if (lastRefreshStartedAt == null) {
      return false;
    }

    return DateTime.now().difference(lastRefreshStartedAt) < widget.cooldown;
  }

  Future<void> _completeMinimumLoaderDuration(DateTime startedAt) async {
    final elapsed = DateTime.now().difference(startedAt);
    final remaining = widget.minimumLoaderDuration - elapsed;
    if (remaining.isNegative || remaining == Duration.zero) {
      return;
    }

    await Future<void>.delayed(remaining);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppColors.primary,
      backgroundColor: AppColors.surface,
      strokeWidth: AppSize.size3.r,
      displacement: widget.displacement ?? AppSize.size40.h,
      semanticsLabel: AppStrings.pullToRefreshLoading,
      child: widget.child,
    );
  }
}
