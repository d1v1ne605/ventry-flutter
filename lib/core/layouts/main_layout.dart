import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/app_bottom_nav_bar.dart';
import 'package:ventry_flutter/core/widgets/app_top_bar.dart';
import 'package:ventry_flutter/presentation/routes/router_constants.dart';

class MainLayout extends StatelessWidget {
  final Widget body;
  final bool? isPaddingTop;

  const MainLayout({super.key, required this.body, this.isPaddingTop = false});

  String _getTitle(String location) {
    if (location.startsWith(RouterPath.inventory)) {
      return AppStrings.storageManagerTitle;
    }
    return AppStrings.appName;
  }

  AppNavItem _getNavItem(String location) {
    if (location.startsWith(RouterPath.inventory)) {
      return AppNavItem.inventory;
    }
    return AppNavItem.inventory;
  }

  void _onNavItemTapped(BuildContext context, AppNavItem item) {
    switch (item) {
      case AppNavItem.inventory:
        context.go(RouterPath.inventory);
        break;
      case AppNavItem.sales:
      case AppNavItem.partners:
      case AppNavItem.account:
        // TODO: Handle navigation when these screens are available
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final title = _getTitle(location);
    final currentItem = _getNavItem(location);

    return _buildSafeArea(
      context,
      Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: AppTopBar(title: title, onMenuTap: () {}, onActionTap: () {}),
        body: body,
        bottomNavigationBar: AppBottomNavBar(
          currentItem: currentItem,
          onItemTapped: (item) => _onNavItemTapped(context, item),
        ),
      ),
    );
  }

  _buildSafeArea(BuildContext context, Widget buildBody) {
    if (Platform.isIOS) {
      return SafeArea(child: buildBody);
    }
    return SafeArea(
      top: false,
      child: Padding(
        padding: isPaddingTop == true
            ? EdgeInsets.only(top: MediaQuery.of(context).padding.top)
            : EdgeInsets.zero,
        child: buildBody,
      ),
    );
  }
}
