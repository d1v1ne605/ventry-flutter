import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/widgets/app_pull_to_refresh.dart';
import 'package:ventry_flutter/core/widgets/barcode_scanner_bottom_sheet.dart';
import 'package:ventry_flutter/domain/entities/product/sku_spu_group_entity.dart';
import 'package:ventry_flutter/injection.dart';
import 'package:ventry_flutter/presentation/routes/router_constants.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/bloc/product_catalog_bloc.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/bloc/product_catalog_event.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/bloc/product_catalog_state.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/widgets/product_card.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/widgets/product_catalog_top_bar.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/widgets/product_filter_chips.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/widgets/product_search_bar.dart';

/// Product Catalog screen wrapped in [BlocProvider].
/// Removed AppBottomNavBar — handled by MainLayout (ShellRoute).
class ProductCatalogPage extends StatelessWidget {
  const ProductCatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductCatalogBloc>()..add(const LoadSkus()),
      child: const _ProductCatalogView(),
    );
  }
}

class _ProductCatalogView extends StatefulWidget {
  const _ProductCatalogView();

  @override
  State<_ProductCatalogView> createState() => _ProductCatalogViewState();
}

class _ProductCatalogViewState extends State<_ProductCatalogView> {
  static const double _loadMoreScrollThreshold = 240;

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    _requestLoadMoreIfNeeded();
  }

  void _requestLoadMoreIfNeeded() {
    if (!_scrollController.hasClients) {
      return;
    }

    final state = context.read<ProductCatalogBloc>().state;
    if (state.isLoading || state.isLoadingMore || !state.hasNextPage) {
      return;
    }

    final extentAfter = _scrollController.position.extentAfter;
    final shouldLoadMore = extentAfter <= _loadMoreScrollThreshold.h;

    if (shouldLoadMore) {
      context.read<ProductCatalogBloc>().add(const LoadMoreSkus());
    }
  }

  Future<void> _handleBarcodeScan() async {
    final result = await showBarcodeScanner(context);
    if (result != null && result.isNotEmpty) {
      _searchController.text = result;
      if (mounted) {
        context.read<ProductCatalogBloc>().add(SearchSkus(result));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: ProductCatalogTopBar(
        title: AppStrings.productCatalogTitle,
        onBarcodeTap: _handleBarcodeScan,
      ),
      body: _ProductCatalogBody(
        searchController: _searchController,
        onQrTap: _handleBarcodeScan,
        scrollController: _scrollController,
      ),
      floatingActionButton: const _AddProductFab(),
    );
  }
}

class _ProductCatalogBody extends StatelessWidget {
  const _ProductCatalogBody({
    required this.searchController,
    required this.onQrTap,
    required this.scrollController,
  });

  final TextEditingController searchController;
  final VoidCallback onQrTap;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return AppPullToRefresh(
      onRefresh: () => context.read<ProductCatalogBloc>().add(const LoadSkus()),
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: _StickyHeader(
              controller: searchController,
              onQrTap: onQrTap,
            ),
          ),
          BlocBuilder<ProductCatalogBloc, ProductCatalogState>(
            buildWhen: (prev, curr) =>
                prev.isLoading != curr.isLoading ||
                prev.isLoadingMore != curr.isLoadingMore ||
                prev.displayMode != curr.displayMode ||
                prev.spuGroups != curr.spuGroups,
            builder: (context, state) {
              if (state.isLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }

              final isFlatMode =
                  state.displayMode == ProductCatalogDisplayMode.flat;
              final flatSkus = state.flattenedSkus;
              final itemCount = isFlatMode
                  ? flatSkus.length
                  : state.spuGroups.length;

              if (itemCount == 0) {
                return const SliverFillRemaining(child: _EmptyState());
              }

              return SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppSize.size16.w,
                  AppSize.size8.h,
                  AppSize.size16.w,
                  96.h,
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((ctx, i) {
                    if (i >= itemCount) {
                      return const _LoadMoreIndicator();
                    }

                    final isLastDataItem = i == itemCount - 1;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: isLastDataItem && !state.isLoadingMore
                            ? 0
                            : 12.h,
                      ),
                      child: isFlatMode
                          ? ProductSkuCard(
                              sku: flatSkus[i],
                              onTap: () =>
                                  _openSkuDetails(ctx, flatSkus[i].uid),
                            )
                          : _GroupedProductCard(group: state.spuGroups[i]),
                    );
                  }, childCount: itemCount + (state.isLoadingMore ? 1 : 0)),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openSkuDetails(BuildContext context, String skuUid) async {
    final deletedSkuUid = await context.pushNamed<String>(
      RouterName.skuDetail,
      pathParameters: {'skuUid': skuUid},
    );

    if (deletedSkuUid != null && context.mounted) {
      context.read<ProductCatalogBloc>().add(const LoadSkus());
    }
  }
}

class _GroupedProductCard extends StatelessWidget {
  const _GroupedProductCard({required this.group});

  final SkuSpuGroupEntity group;

  @override
  Widget build(BuildContext context) {
    return ProductCard(
      group: group,
      onTap: () async {
        final sku = group.representativeSku;
        if (sku == null) {
          return;
        }

        if (group.variantCount > 1) {
          context.pushNamed(
            RouterName.spuVariants,
            pathParameters: {'spuUid': group.spuUid},
          );
          return;
        }

        final deletedSkuUid = await context.pushNamed<String>(
          RouterName.skuDetail,
          pathParameters: {'skuUid': sku.uid},
        );

        if (deletedSkuUid != null && context.mounted) {
          context.read<ProductCatalogBloc>().add(const LoadSkus());
        }
      },
    );
  }
}

class _StickyHeader extends StatelessWidget {
  const _StickyHeader({required this.controller, required this.onQrTap});

  final TextEditingController controller;
  final VoidCallback onQrTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(
        AppSize.size16.w,
        AppSize.size16.h,
        AppSize.size16.w,
        AppSize.size12.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductSearchBar(
            controller: controller,
            onChanged: (query) =>
                context.read<ProductCatalogBloc>().add(SearchSkus(query)),
            onQrTap: onQrTap,
            onFilterTap: () {},
          ),
          SizedBox(height: AppSize.size12.h),
          BlocSelector<
            ProductCatalogBloc,
            ProductCatalogState,
            ProductCatalogDisplayMode
          >(
            selector: (state) => state.displayMode,
            builder: (context, displayMode) => _DisplayModeToggle(
              displayMode: displayMode,
              onChanged: (mode) => context.read<ProductCatalogBloc>().add(
                ChangeProductCatalogDisplayMode(mode),
              ),
            ),
          ),
          SizedBox(height: AppSize.size16.h),
          // Just comment out for now, will re-enable when we have the filter counts ready
          // Don't delete the code, as we will re-enable it in the future
          // BlocSelector<ProductCatalogBloc, ProductCatalogState, _FilterCounts>(
          //   selector: (state) => _FilterCounts(
          //     total: state.total,
          //     lowStock: state.spuGroups
          //         .where((group) => group.lowStockCount > 0)
          //         .length,
          //     outOfStock: state.spuGroups
          //         .where((group) => group.stockStatus.isOutOfStock)
          //         .length,
          //     filterStatus: state.filterStatus,
          //     isStockAlert: state.isStockAlert,
          //   ),
          //   builder: (context, counts) => ProductFilterChips(
          //     selectedFilter: _resolveFilter(counts),
          //     onFilterChanged: (filter) => _onFilterChanged(context, filter),
          //     totalCount: counts.total,
          //     lowStockCount: counts.lowStock,
          //     outOfStockCount: counts.outOfStock,
          //   ),
          // ),
        ],
      ),
    );
  }

  // ignore: unused_element
  ProductFilter _resolveFilter(_FilterCounts counts) {
    if (counts.isStockAlert == true) return ProductFilter.lowStock;
    if (counts.filterStatus == 'OUT_OF_STOCK') return ProductFilter.outOfStock;
    return ProductFilter.totalStock;
  }

  // ignore: unused_element
  void _onFilterChanged(BuildContext context, ProductFilter filter) {
    context.read<ProductCatalogBloc>().add(
      FilterSkus(
        status: filter == ProductFilter.outOfStock ? 'OUT_OF_STOCK' : null,
        isStockAlert: filter == ProductFilter.lowStock ? true : null,
      ),
    );
  }
}

class _DisplayModeToggle extends StatelessWidget {
  const _DisplayModeToggle({
    required this.displayMode,
    required this.onChanged,
  });

  final ProductCatalogDisplayMode displayMode;
  final ValueChanged<ProductCatalogDisplayMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      padding: EdgeInsets.all(AppSize.size4.r),
      decoration: BoxDecoration(
        color: AppColors.searchBarFill,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _DisplayModeButton(
              icon: Icons.view_agenda_outlined,
              label: AppStrings.productCatalogGroupedMode,
              tooltip: AppStrings.productCatalogGroupedModeTooltip,
              isSelected: displayMode == ProductCatalogDisplayMode.grouped,
              onTap: () => onChanged(ProductCatalogDisplayMode.grouped),
            ),
          ),
          SizedBox(width: AppSize.size4.w),
          Expanded(
            child: _DisplayModeButton(
              icon: Icons.view_list_rounded,
              label: AppStrings.productCatalogFlatMode,
              tooltip: AppStrings.productCatalogFlatModeTooltip,
              isSelected: displayMode == ProductCatalogDisplayMode.flat,
              onTap: () => onChanged(ProductCatalogDisplayMode.flat),
            ),
          ),
        ],
      ),
    );
  }
}

class _DisplayModeButton extends StatelessWidget {
  const _DisplayModeButton({
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String tooltip;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = isSelected ? AppColors.primary : AppColors.subtitle;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: isSelected ? AppColors.surface : Colors.transparent,
        borderRadius: BorderRadius.circular(9.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9.r),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: AppSize.size20.r, color: foregroundColor),
                SizedBox(width: AppSize.size6.w),
                Flexible(
                  child: Text(
                    label,
                    style: AppTextStyles.skuChip.copyWith(
                      color: foregroundColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 60.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64.r,
            color: AppColors.navInactive.withValues(alpha: 0.4),
          ),
          SizedBox(height: 16.h),
          Text(AppStrings.productCatalogEmpty, style: AppTextStyles.searchHint),
        ],
      ),
    );
  }
}

class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSize.size16.h),
      child: Center(
        child: SizedBox(
          width: AppSize.size20.r,
          height: AppSize.size20.r,
          child: const CircularProgressIndicator(
            strokeWidth: 2.4,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _AddProductFab extends StatelessWidget {
  const _AddProductFab();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final created = await context.push<bool>(RouterPath.addProduct);
        if (context.mounted && created == true) {
          context.read<ProductCatalogBloc>().add(const LoadSkus());
        }
      },
      child: Container(
        width: 56.r,
        height: 56.r,
        decoration: BoxDecoration(
          color: AppColors.fabBackground,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x3300685F),
              offset: Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Icon(Icons.add_rounded, color: Colors.white, size: 28.r),
      ),
    );
  }
}

/// Internal DTO for BlocSelector to avoid rebuilding when unrelated state changes.
class _FilterCounts {
  final int total;
  final int lowStock;
  final int outOfStock;
  final String? filterStatus;
  final bool? isStockAlert;

  const _FilterCounts({
    required this.total,
    required this.lowStock,
    required this.outOfStock,
    required this.filterStatus,
    required this.isStockAlert,
  });

  @override
  bool operator ==(Object other) =>
      other is _FilterCounts &&
      other.total == total &&
      other.lowStock == lowStock &&
      other.outOfStock == outOfStock &&
      other.filterStatus == filterStatus &&
      other.isStockAlert == isStockAlert;

  @override
  int get hashCode =>
      Object.hash(total, lowStock, outOfStock, filterStatus, isStockAlert);
}
