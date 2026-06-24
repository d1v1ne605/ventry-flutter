import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';

/// Single SKU row card in the product catalog list.
///
/// Visual behaviour per [SkuStockStatus]:
/// - **inStock**    → no left border, green badge
/// - **lowStock**   → amber left border accent, orange badge
/// - **outOfStock** → red left border accent, muted text, pink badge
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.sku,
    this.onTap,
  });

  final SkuEntity sku;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isOut = sku.stockStatus.isOutOfStock;
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
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A1E293B),
              offset: Offset(0, 2),
              blurRadius: 8,
            ),
            BoxShadow(
              color: Color(0xA0FFFFFF),
              offset: Offset(-1, -1),
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSize.size16.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ProductImage(imageUrl: sku.primaryImageUrl, isOut: isOut),
              SizedBox(width: AppSize.size12.w),
              Expanded(child: _ProductInfo(sku: sku)),
            ],
          ),
        ),
      ),
    );
  }

  Color? _resolveLeftBorderColor() => switch (sku.stockStatus) {
        SkuStockStatus.inStock => null,
        SkuStockStatus.lowStock => AppColors.lowStockBorder,
        SkuStockStatus.outOfStock => AppColors.outOfStockBorder,
      };
}

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

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.sku});

  final SkuEntity sku;

  @override
  Widget build(BuildContext context) {
    final bool isOut = sku.stockStatus.isOutOfStock;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                sku.spuName,
                style: isOut
                    ? AppTextStyles.productNameMuted
                    : AppTextStyles.productName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: AppSize.size8.w),
            _StockBadge(status: sku.stockStatus, count: sku.stockQuantity),
          ],
        ),
        if (sku.skuCode != null) ...[
          SizedBox(height: 4.h),
          Text(
            sku.skuCode!,
            style: AppTextStyles.productMeta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        SizedBox(height: 6.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (sku.skuCode != null)
              _SkuChip(skuCode: sku.skuCode!)
            else
              _SkuChip(skuCode: sku.uid.substring(0, 8)),
            const Spacer(),
            if (sku.sellingPrice != null)
              Text(
                '\$${sku.sellingPrice!.toStringAsFixed(2)}',
                style: isOut
                    ? AppTextStyles.productPrice
                        .copyWith(color: AppColors.textMuted)
                    : AppTextStyles.productPrice,
              ),
          ],
        ),
      ],
    );
  }
}

class _SkuChip extends StatelessWidget {
  const _SkuChip({required this.skuCode});

  final String skuCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: AppColors.skuChipFill,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        '${AppStrings.skuPrefix}$skuCode',
        style: AppTextStyles.skuChip,
      ),
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.status, required this.count});

  final SkuStockStatus status;
  final int count;

  @override
  Widget build(BuildContext context) {
    final cfg = _BadgeConfig.fromStatus(status, count);

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

  factory _BadgeConfig.fromStatus(SkuStockStatus status, int count) {
    return switch (status) {
      SkuStockStatus.inStock => _BadgeConfig(
          fill: AppColors.inStockBadgeFill,
          dotColor: AppColors.inStockDot,
          textColor: AppColors.inStockBadgeText,
          label: '${AppStrings.inStock}: $count',
        ),
      SkuStockStatus.lowStock => _BadgeConfig(
          fill: AppColors.lowStockBadgeFill,
          dotColor: AppColors.lowStockDot,
          textColor: AppColors.lowStockBadgeText,
          label: '${AppStrings.lowStock}: $count',
        ),
      SkuStockStatus.outOfStock => _BadgeConfig(
          fill: AppColors.outOfStockBadgeFill,
          dotColor: AppColors.outOfStockDot,
          textColor: AppColors.outOfStockBadgeText,
          label: AppStrings.outOfStock,
        ),
    };
  }
}
