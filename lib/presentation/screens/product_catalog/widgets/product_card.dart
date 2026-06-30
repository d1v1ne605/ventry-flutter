import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/utils/app_formatters.dart';
import 'package:ventry_flutter/core/utils/string_utils.dart';
import 'package:ventry_flutter/domain/entities/product/sku_spu_group_entity.dart';

/// SPU group card in the product catalog list.
///
/// Visual behaviour per [SkuSpuGroupStockStatus]:
/// - **inStock**    → no left border, green badge
/// - **lowStock**   → amber left border accent, orange badge
/// - **outOfStock** → red left border accent, muted text, pink badge
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.group, this.onTap});

  final SkuSpuGroupEntity group;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bool isOut = group.stockStatus.isOutOfStock;
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
              _ProductImage(imageUrl: group.primaryImageUrl, isOut: isOut),
              SizedBox(width: AppSize.size12.w),
              Expanded(child: _ProductInfo(group: group)),
            ],
          ),
        ),
      ),
    );
  }

  Color? _resolveLeftBorderColor() => switch (group.stockStatus) {
    SkuSpuGroupStockStatus.inStock => null,
    SkuSpuGroupStockStatus.lowStock => AppColors.lowStockBorder,
    SkuSpuGroupStockStatus.outOfStock => AppColors.outOfStockBorder,
  };
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({this.imageUrl, required this.isOut});

  final String? imageUrl;
  final bool isOut;

  @override
  Widget build(BuildContext context) {
    final safeImageUrl = StringUtils.isSafeNetworkUrl(imageUrl)
        ? imageUrl
        : null;

    return Container(
      width: 72.r,
      height: 72.r,
      decoration: BoxDecoration(
        color: isOut ? AppColors.searchBarFill : AppColors.screenBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: safeImageUrl != null
          ? Image.network(
              safeImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Image.asset(AppAssets.imgPlaceHolder, fit: BoxFit.cover),
            )
          : Image.asset(AppAssets.imgPlaceHolder, fit: BoxFit.cover),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.group});

  final SkuSpuGroupEntity group;

  @override
  Widget build(BuildContext context) {
    final representativeSku = group.summarySku;
    final bool isOut = group.stockStatus.isOutOfStock;
    final skuCode = representativeSku?.skuCode ?? representativeSku?.uid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                group.spuName,
                style: isOut
                    ? AppTextStyles.productNameMuted
                    : AppTextStyles.productName,
                softWrap: true,
              ),
            ),
            SizedBox(width: AppSize.size8.w),
            _StockBadge(group: group),
          ],
        ),
        if (group.attributeSummaries.isNotEmpty) ...[
          SizedBox(height: AppSize.size4.h),
          _AttributeChips(attributes: group.attributeSummaries),
        ],
        SizedBox(height: AppSize.size6.h),
        _SkuPriceRow(
          skuCode: skuCode,
          price: group.minSellingPrice,
          isOut: isOut,
        ),
        if (group.variantCount > 1) ...[
          SizedBox(height: AppSize.size10.h),
          _VariantCount(count: group.variantCount),
        ],
      ],
    );
  }
}

class _AttributeChips extends StatelessWidget {
  const _AttributeChips({required this.attributes});

  final List<SkuSpuGroupAttributeSummary> attributes;

  @override
  Widget build(BuildContext context) {
    if (attributes.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: AppSize.size4.w,
          runSpacing: AppSize.size4.h,
          children: attributes.map((attribute) {
            return _AttributeChip(
              label: attribute.value,
              maxWidth: constraints.maxWidth,
            );
          }).toList(),
        );
      },
    );
  }
}

class _AttributeChip extends StatelessWidget {
  const _AttributeChip({required this.label, required this.maxWidth});

  final String label;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: AppColors.skuChipFill,
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Text(
          label,
          style: AppTextStyles.productMeta,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ),
    );
  }
}

class _SkuPriceRow extends StatelessWidget {
  const _SkuPriceRow({
    required this.skuCode,
    required this.price,
    required this.isOut,
  });

  final String? skuCode;
  final double? price;
  final bool isOut;

  @override
  Widget build(BuildContext context) {
    if (skuCode == null && price == null) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (skuCode != null)
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: _SkuChip(skuCode: skuCode!),
            ),
          )
        else
          const Spacer(),
        if (skuCode != null && price != null) SizedBox(width: AppSize.size8.w),
        if (price != null) _PriceLabel(price: price!, isOut: isOut),
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
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: AppSize.size3.h),
      decoration: BoxDecoration(
        color: AppColors.skuChipFill,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        '${AppStrings.skuPrefix}$skuCode',
        style: AppTextStyles.skuChip,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        softWrap: false,
      ),
    );
  }
}

class _PriceLabel extends StatelessWidget {
  const _PriceLabel({required this.price, required this.isOut});

  final double price;
  final bool isOut;

  @override
  Widget build(BuildContext context) {
    return Text(
      AppFormatters.formatPrice(price),
      style: isOut
          ? AppTextStyles.productPrice.copyWith(color: AppColors.textMuted)
          : AppTextStyles.productPrice,
      maxLines: 1,
      overflow: TextOverflow.visible,
      softWrap: false,
    );
  }
}

class _StockBadge extends StatelessWidget {
  const _StockBadge({required this.group});

  final SkuSpuGroupEntity group;

  @override
  Widget build(BuildContext context) {
    final cfg = _BadgeConfig.fromGroup(group);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: AppSize.size3.h),
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

class _VariantCount extends StatelessWidget {
  const _VariantCount({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.variantCount(count),
          style: AppTextStyles.productMeta.copyWith(color: AppColors.subtitle),
        ),
        SizedBox(width: AppSize.size4.w),
        Icon(
          Icons.chevron_right_rounded,
          size: AppSize.size20.r,
          color: AppColors.subtitle,
        ),
      ],
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

  factory _BadgeConfig.fromGroup(SkuSpuGroupEntity group) {
    return switch (group.stockStatus) {
      SkuSpuGroupStockStatus.inStock => _BadgeConfig(
        fill: AppColors.inStockBadgeFill,
        dotColor: AppColors.inStockDot,
        textColor: AppColors.inStockBadgeText,
        label: '${AppStrings.inStock}: ${group.totalStock}',
      ),
      SkuSpuGroupStockStatus.lowStock => _BadgeConfig(
        fill: AppColors.lowStockBadgeFill,
        dotColor: AppColors.lowStockDot,
        textColor: AppColors.lowStockBadgeText,
        label: '${AppStrings.lowStock}: ${group.lowStockCount}',
      ),
      SkuSpuGroupStockStatus.outOfStock => _BadgeConfig(
        fill: AppColors.outOfStockBadgeFill,
        dotColor: AppColors.outOfStockDot,
        textColor: AppColors.outOfStockBadgeText,
        label: AppStrings.outOfStock,
      ),
    };
  }
}
