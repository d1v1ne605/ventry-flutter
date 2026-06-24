import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
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
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: ProductCatalogTopBar(
        title: AppStrings.productCatalogPageTitle,
        onBarcodeTap: () {},
      ),
      body: _ProductCatalogBody(searchController: _searchController),
      floatingActionButton: const _AddProductFab(),
    );
  }
}

class _ProductCatalogBody extends StatelessWidget {
  const _ProductCatalogBody({required this.searchController});

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _StickyHeader(controller: searchController)),
        BlocBuilder<ProductCatalogBloc, ProductCatalogState>(
          buildWhen: (prev, curr) =>
              prev.isLoading != curr.isLoading || prev.skus != curr.skus,
          builder: (context, state) {
            if (state.isLoading) {
              return const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              );
            }

            if (state.skus.isEmpty) {
              return const SliverFillRemaining(child: _EmptyState());
            }

            return SliverPadding(
              padding: EdgeInsets.fromLTRB(
                AppSize.size16.w,
                AppSize.size8.h,
                AppSize.size16.w,
                96.h,
              ),
              sliver: SliverList.separated(
                itemCount: state.skus.length,
                separatorBuilder: (_, __) => SizedBox(height: 12.h),
                itemBuilder: (_, i) =>
                    ProductCard(sku: state.skus[i], onTap: () {}),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _StickyHeader extends StatelessWidget {
  const _StickyHeader({required this.controller});

  final TextEditingController controller;

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
            onQrTap: () {},
            onFilterTap: () {},
          ),
          SizedBox(height: AppSize.size16.h),
          BlocSelector<ProductCatalogBloc, ProductCatalogState, _FilterCounts>(
            selector: (state) => _FilterCounts(
              total: state.total,
              lowStock: state.skus
                  .where((s) => s.stockStatus == SkuStockStatus.lowStock)
                  .length,
              outOfStock: state.skus
                  .where((s) => s.stockStatus == SkuStockStatus.outOfStock)
                  .length,
              filterStatus: state.filterStatus,
              isStockAlert: state.isStockAlert,
            ),
            builder: (context, counts) => ProductFilterChips(
              selectedFilter: _resolveFilter(counts),
              onFilterChanged: (filter) => _onFilterChanged(context, filter),
              totalCount: counts.total,
              lowStockCount: counts.lowStock,
              outOfStockCount: counts.outOfStock,
            ),
          ),
        ],
      ),
    );
  }

  ProductFilter _resolveFilter(_FilterCounts counts) {
    if (counts.isStockAlert == true) return ProductFilter.lowStock;
    if (counts.filterStatus == 'OUT_OF_STOCK') return ProductFilter.outOfStock;
    return ProductFilter.totalStock;
  }

  void _onFilterChanged(BuildContext context, ProductFilter filter) {
    context.read<ProductCatalogBloc>().add(
      FilterSkus(
        status: filter == ProductFilter.outOfStock ? 'OUT_OF_STOCK' : null,
        isStockAlert: filter == ProductFilter.lowStock ? true : null,
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

class _AddProductFab extends StatelessWidget {
  const _AddProductFab();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(RouterPath.addProduct),
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
    this.filterStatus,
    this.isStockAlert,
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
