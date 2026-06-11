import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/models/product_item.dart';

/// Single product row card in the catalog list.
///
/// Visual behaviour per [StockStatus]:
/// - **inStock**  → no left border, green badge
/// - **lowStock** → amber left border accent, orange badge
/// - **outOfStock** → red left border accent, muted text, pink "Out" badge
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  final ProductItem product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isOut = product.stockStatus.isOutOfStock;
    final Color? leftBorderColor = _resolveLeftBorderColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: leftBorderColor != null
              ? Border(
                  left: BorderSide(color: leftBorderColor, width: 4.w),
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: const Color(0x0A1E293B),
              offset: const Offset(0, 2),
              blurRadius: 8,
            ),
            BoxShadow(
              color: const Color(0xA0FFFFFF),
              offset: const Offset(-1, -1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSize.size16.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ProductImage(imageUrl: product.imageUrl, isOut: isOut),
              SizedBox(width: AppSize.size12.w),
              Expanded(
                child: _ProductInfo(product: product),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color? _resolveLeftBorderColor() => switch (product.stockStatus) {
        StockStatus.inStock => null,
        StockStatus.lowStock => AppColors.lowStockBorder,
        StockStatus.outOfStock => AppColors.outOfStockBorder,
      };
}

/// Product thumbnail image with rounded corners.
/// Falls back to a grey placeholder when [imageUrl] is null.
class _ProductImage extends StatelessWidget {
  const _ProductImage({this.imageUrl, required this.isOut});

  final String? imageUrl;
  final bool isOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72.r,
      height: 72.r,
      decoration: BoxDecoration(
        color: isOut ? AppColors.searchBarFill : AppColors.screenBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: imageUrl != null
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _PlaceholderIcon(isOut: isOut),
            )
          : _PlaceholderIcon(isOut: isOut),
    );
  }
}

/// Fallback icon shown when no product image is available.
class _PlaceholderIcon extends StatelessWidget {
  const _PlaceholderIcon({required this.isOut});

  final bool isOut;

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.inventory_2_outlined,
      size: 28.r,
      color: isOut ? AppColors.textMuted : AppColors.navInactive,
    );
  }
}

/// Title, meta, SKU chip and price column for [ProductCard].
class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.product});

  final ProductItem product;

  @override
  Widget build(BuildContext context) {
    final bool isOut = product.stockStatus.isOutOfStock;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Stock badge + name row
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: isOut
                    ? AppTextStyles.productNameMuted
                    : AppTextStyles.productName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: AppSize.size8.w),
            _StockBadge(status: product.stockStatus, count: product.stockCount),
          ],
        ),
        SizedBox(height: 4.h),
        // Meta line
        Text(
          product.meta,
          style: AppTextStyles.productMeta,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 6.h),
        // SKU chip + price row
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _SkuChip(sku: product.sku),
            const Spacer(),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: isOut
                  ? AppTextStyles.productPrice.copyWith(
                      color: AppColors.textMuted,
                    )
                  : AppTextStyles.productPrice,
            ),
          ],
        ),
      ],
    );
  }
}

/// Pill-shaped SKU chip (grey background).
class _SkuChip extends StatelessWidget {
  const _SkuChip({required this.sku});

  final String sku;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.skuChipFill,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        '${AppStrings.skuPrefix}$sku',
        style: AppTextStyles.skuChip,
      ),
    );
  }
}

/// Colored status badge (green / orange / red-pink).
class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.status, required this.count});

  final StockStatus status;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final _BadgeConfig cfg = _BadgeConfig.fromStatus(status, count);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: cfg.fill,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: cfg.dotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            cfg.label,
            style: AppTextStyles.stockBadge.copyWith(color: cfg.textColor),
          ),
        ],
      ),
    );
  }
}

/// Configuration helper for [_StockBadge] colours and label.
class _BadgeConfig {
  const _BadgeConfig({
    required this.fill,
    required this.dotColor,
    required this.textColor,
    required this.label,
  });

  final Color fill;
  final Color dotColor;
  final Color textColor;
  final String label;

  factory _BadgeConfig.fromStatus(StockStatus status, int? count) {
    return switch (status) {
      StockStatus.inStock => _BadgeConfig(
          fill: AppColors.inStockBadgeFill,
          dotColor: AppColors.inStockDot,
          textColor: AppColors.inStockBadgeText,
          label: '${AppStrings.inStock}: ${count ?? 0}',
        ),
      StockStatus.lowStock => _BadgeConfig(
          fill: AppColors.lowStockBadgeFill,
          dotColor: AppColors.lowStockDot,
          textColor: AppColors.lowStockBadgeText,
          label: '${AppStrings.lowStock}: ${count ?? 0}',
        ),
      StockStatus.outOfStock => _BadgeConfig(
          fill: AppColors.outOfStockBadgeFill,
          dotColor: AppColors.outOfStockDot,
          textColor: AppColors.outOfStockBadgeText,
          label: AppStrings.outOfStock,
        ),
    };
  }
}
