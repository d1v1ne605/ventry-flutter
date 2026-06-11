import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/app_bottom_nav_bar.dart';
import 'package:ventry_flutter/core/widgets/app_top_bar.dart';
import 'package:ventry_flutter/presentation/screens/inventory_dashboard/widgets/inventory_dashboard_card.dart';
import 'package:ventry_flutter/presentation/screens/inventory_dashboard/widgets/inventory_header_section.dart';

/// Inventory Dashboard screen — "Inventory Dashboard Hub" frame from Figma.
///
/// This is a pure UI page (no Bloc yet). It composes:
/// - [AppTopBar] (shared, reusable)
/// - [InventoryHeaderSection] with title and scanner button
/// - A list of [InventoryDashboardCard] items
/// - [AppBottomNavBar] (shared, reusable)
class InventoryDashboardPage extends StatefulWidget {
  const InventoryDashboardPage({super.key});

  @override
  State<InventoryDashboardPage> createState() => _InventoryDashboardPageState();
}

class _InventoryDashboardPageState extends State<InventoryDashboardPage> {
  AppNavItem _currentNavItem = AppNavItem.inventory;

  /// Static card data — will be replaced by Bloc state in the future.
  static const List<InventoryCardData> _cards = [
    InventoryCardData(
      title: AppStrings.productCatalogTitle,
      subtitle: AppStrings.productCatalogSubtitle,
      iconPath: AppAssets.icInventory,
    ),
    InventoryCardData(
      title: AppStrings.categoryManagementTitle,
      subtitle: AppStrings.categoryManagementSubtitle,
      iconPath: AppAssets.icPartners,
    ),
    InventoryCardData(
      title: AppStrings.stockMovementLogsTitle,
      subtitle: AppStrings.stockMovementLogsSubtitle,
      iconPath: AppAssets.icSales,
    ),
  ];

  void _onNavItemTapped(AppNavItem item) {
    setState(() => _currentNavItem = item);
    // Navigation between tabs will be handled by GoRouter in a future iteration.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppTopBar(
        title: AppStrings.storageManagerTitle,
        onMenuTap: () {},
        onActionTap: () {},
      ),
      body: _InventoryDashboardBody(cards: _cards),
      bottomNavigationBar: AppBottomNavBar(
        currentItem: _currentNavItem,
        onItemTapped: _onNavItemTapped,
      ),
    );
  }
}

/// The scrollable body of [InventoryDashboardPage].
///
/// Extracted to keep [_InventoryDashboardPageState.build] concise
/// and below the 20-line limit per function guideline.
class _InventoryDashboardBody extends StatelessWidget {
  const _InventoryDashboardBody({required this.cards});

  final List<InventoryCardData> cards;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSize.size16.w,
        AppSize.size24.h,
        AppSize.size16.w,
        AppSize.size24.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InventoryHeaderSection(onScannerTap: () {}),
          SizedBox(height: AppSize.size24.h),
          _CardList(cards: cards),
        ],
      ),
    );
  }
}

/// Vertical list of [InventoryDashboardCard] items with consistent spacing.
class _CardList extends StatelessWidget {
  const _CardList({required this.cards});

  final List<InventoryCardData> cards;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cards.length,
      separatorBuilder: (_, __) => SizedBox(height: AppSize.size16.h),
      itemBuilder: (_, index) => InventoryDashboardCard(data: cards[index]),
    );
  }
}
