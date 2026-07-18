import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ventry_flutter/presentation/routes/router_constants.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/widgets/app_pull_to_refresh.dart';
import 'package:ventry_flutter/presentation/screens/inventory_dashboard/widgets/inventory_dashboard_card.dart';
import 'package:ventry_flutter/presentation/screens/inventory_dashboard/widgets/inventory_header_section.dart';

/// Inventory Dashboard screen — "Inventory Dashboard Hub" frame from Figma.
///
/// This is a pure UI page (no Bloc yet). It composes:
/// - [AppTopBar] (shared, reusable)
/// - [InventoryHeaderSection] with title and scanner button
/// - A list of [InventoryDashboardCard] items
/// - [AppBottomNavBar] (shared, reusable)
class InventoryDashboardPage extends StatelessWidget {
  const InventoryDashboardPage({super.key});

  List<InventoryCardData> _buildCards(BuildContext context) {
    return [
      InventoryCardData(
        title: AppStrings.productCatalogTitle,
        subtitle: AppStrings.productCatalogSubtitle,
        iconPath: AppAssets.icInventory,
        onTap: () => context.push(RouterPath.productCatalog),
      ),
      InventoryCardData(
        title: AppStrings.categoryManagementTitle,
        subtitle: AppStrings.categoryManagementSubtitle,
        iconPath: AppAssets.icPartners,
        onTap: () => context.push(RouterPath.categoryManagement),
      ),
      const InventoryCardData(
        title: AppStrings.stockMovementLogsTitle,
        subtitle: AppStrings.stockMovementLogsSubtitle,
        iconPath: AppAssets.icSales,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return _InventoryDashboardBody(cards: _buildCards(context));
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
    return AppPullToRefresh(
      onRefresh: () {},
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.fromLTRB(
          AppSize.size16.w,
          AppSize.size24.h,
          AppSize.size16.w,
          AppSize.size24.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InventoryHeaderSection(
              onScannerTap: () {
                // context.push(RouterPath.testScanner);
              },
            ),
            SizedBox(height: AppSize.size24.h),
            _CardList(cards: cards),
          ],
        ),
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
