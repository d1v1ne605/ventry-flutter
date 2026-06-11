import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/app_bottom_nav_bar.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/models/product_item.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/widgets/product_card.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/widgets/product_catalog_top_bar.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/widgets/product_filter_chips.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/widgets/product_search_bar.dart';

/// Product Catalog screen — Figma node 44:118 "Product Catalog".
///
/// Pure UI page (no Bloc yet). State held locally in [_ProductCatalogPageState]:
/// - [_query]          — current search text
/// - [_selectedFilter] — active filter tab
/// - [_currentNavItem] — active bottom nav tab
///
/// Static mock data will be replaced by Bloc-emitted state in the next phase.
class ProductCatalogPage extends StatefulWidget {
  const ProductCatalogPage({super.key});

  @override
  State<ProductCatalogPage> createState() => _ProductCatalogPageState();
}

class _ProductCatalogPageState extends State<ProductCatalogPage> {
  final TextEditingController _searchController = TextEditingController();
  ProductFilter _selectedFilter = ProductFilter.totalStock;
  AppNavItem _currentNavItem = AppNavItem.inventory;
  String _query = '';

  /// Mock product data — will come from Bloc in the future.
  static final List<ProductItem> _mockProducts = [
    const ProductItem(
      id: '1',
      name: 'iPhone 15 Pro',
      meta: 'Size: 128GB • Color: Titanium',
      sku: 'IP15P-128-TI',
      price: 999.00,
      stockStatus: StockStatus.inStock,
      stockCount: 45,
    ),
    const ProductItem(
      id: '2',
      name: 'Nike Pegasus 40',
      meta: 'Color: Black • Size: 42',
      sku: 'NK-PEG40-BK-42',
      price: 130.00,
      stockStatus: StockStatus.lowStock,
      stockCount: 3,
    ),
    const ProductItem(
      id: '3',
      name: 'Samsung S24 Ultra',
      meta: 'Color: Gray • Size: 256GB',
      sku: 'SS-S24U-256-GR',
      price: 1199.00,
      stockStatus: StockStatus.outOfStock,
      stockCount: null,
    ),
    const ProductItem(
      id: '4',
      name: 'MacBook Air M3',
      meta: 'Color: Silver • RAM: 16GB',
      sku: 'MB-AIR-M3-16',
      price: 1299.00,
      stockStatus: StockStatus.inStock,
      stockCount: 12,
    ),
    const ProductItem(
      id: '5',
      name: 'AirPods Pro 2',
      meta: 'Color: White',
      sku: 'APP-PRO2-WH',
      price: 249.00,
      stockStatus: StockStatus.lowStock,
      stockCount: 2,
    ),
  ];

  List<ProductItem> get _filteredProducts {
    final byQuery = _query.isEmpty
        ? _mockProducts
        : _mockProducts
            .where((p) =>
                p.name.toLowerCase().contains(_query.toLowerCase()) ||
                p.sku.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return switch (_selectedFilter) {
      ProductFilter.totalStock => byQuery,
      ProductFilter.lowStock =>
        byQuery.where((p) => p.stockStatus == StockStatus.lowStock).toList(),
      ProductFilter.outOfStock =>
        byQuery.where((p) => p.stockStatus == StockStatus.outOfStock).toList(),
    };
  }

  int get _lowStockCount =>
      _mockProducts.where((p) => p.stockStatus == StockStatus.lowStock).length;

  int get _outOfStockCount =>
      _mockProducts.where((p) => p.stockStatus == StockStatus.outOfStock).length;

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
      body: _ProductCatalogBody(
        searchController: _searchController,
        selectedFilter: _selectedFilter,
        products: _filteredProducts,
        totalCount: _mockProducts.length,
        lowStockCount: _lowStockCount,
        outOfStockCount: _outOfStockCount,
        onQueryChanged: (q) => setState(() => _query = q),
        onFilterChanged: (f) => setState(() => _selectedFilter = f),
        onProductTap: (_) {},
        onQrTap: () {},
        onFilterBarTap: () {},
      ),
      floatingActionButton: _AddProductFab(onTap: () {}),
      bottomNavigationBar: AppBottomNavBar(
        currentItem: _currentNavItem,
        onItemTapped: (item) => setState(() => _currentNavItem = item),
      ),
    );
  }
}

/// Scrollable body of [ProductCatalogPage].
/// Extracted to keep [_ProductCatalogPageState.build] concise.
class _ProductCatalogBody extends StatelessWidget {
  const _ProductCatalogBody({
    required this.searchController,
    required this.selectedFilter,
    required this.products,
    required this.totalCount,
    required this.lowStockCount,
    required this.outOfStockCount,
    required this.onQueryChanged,
    required this.onFilterChanged,
    required this.onProductTap,
    required this.onQrTap,
    required this.onFilterBarTap,
  });

  final TextEditingController searchController;
  final ProductFilter selectedFilter;
  final List<ProductItem> products;
  final int totalCount;
  final int lowStockCount;
  final int outOfStockCount;
  final void Function(String) onQueryChanged;
  final void Function(ProductFilter) onFilterChanged;
  final void Function(ProductItem) onProductTap;
  final VoidCallback onQrTap;
  final VoidCallback onFilterBarTap;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Sticky search + filter header
        SliverToBoxAdapter(
          child: _StickyHeader(
            controller: searchController,
            selectedFilter: selectedFilter,
            totalCount: totalCount,
            lowStockCount: lowStockCount,
            outOfStockCount: outOfStockCount,
            onQueryChanged: onQueryChanged,
            onFilterChanged: onFilterChanged,
            onQrTap: onQrTap,
            onFilterBarTap: onFilterBarTap,
          ),
        ),
        // Product list
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            AppSize.size16.w,
            AppSize.size8.h,
            AppSize.size16.w,
            100.h, // space for FAB + bottom nav
          ),
          sliver: products.isEmpty
              ? const SliverToBoxAdapter(child: _EmptyState())
              : SliverList.separated(
                  itemCount: products.length,
                  separatorBuilder: (_, __) => SizedBox(height: 12.h),
                  itemBuilder: (_, i) => ProductCard(
                    product: products[i],
                    onTap: () => onProductTap(products[i]),
                  ),
                ),
        ),
      ],
    );
  }
}

/// White-background card containing search bar + filter chips.
class _StickyHeader extends StatelessWidget {
  const _StickyHeader({
    required this.controller,
    required this.selectedFilter,
    required this.totalCount,
    required this.lowStockCount,
    required this.outOfStockCount,
    required this.onQueryChanged,
    required this.onFilterChanged,
    required this.onQrTap,
    required this.onFilterBarTap,
  });

  final TextEditingController controller;
  final ProductFilter selectedFilter;
  final int totalCount;
  final int lowStockCount;
  final int outOfStockCount;
  final void Function(String) onQueryChanged;
  final void Function(ProductFilter) onFilterChanged;
  final VoidCallback onQrTap;
  final VoidCallback onFilterBarTap;

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
            onChanged: onQueryChanged,
            onQrTap: onQrTap,
            onFilterTap: onFilterBarTap,
          ),
          SizedBox(height: AppSize.size16.h),
          ProductFilterChips(
            selectedFilter: selectedFilter,
            onFilterChanged: onFilterChanged,
            totalCount: totalCount,
            lowStockCount: lowStockCount,
            outOfStockCount: outOfStockCount,
          ),
        ],
      ),
    );
  }
}

/// Shown when the product list is empty (e.g. no search results).
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
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.navInactive,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Teal circular FAB that triggers the add-product flow.
class _AddProductFab extends StatelessWidget {
  const _AddProductFab({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
