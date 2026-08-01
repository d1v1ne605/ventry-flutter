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

class ProductUnitGroupImage extends StatelessWidget {
  const ProductUnitGroupImage({super.key, this.imageUrl, required this.isOut});

  final String? imageUrl;
  final bool isOut;

  @override
  Widget build(BuildContext context) {
    final safeImageUrl = StringUtils.isSafeNetworkUrl(imageUrl)
        ? imageUrl
        : null;
    return Container(
      width: 64.r,
      height: 64.r,
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

class ProductUnitGroupInfo extends StatelessWidget {
  const ProductUnitGroupInfo({super.key, required this.group});

  final SkuSpuUnitGroupEntity group;

  @override
  Widget build(BuildContext context) {
    final isOut = group.stockStatus.isOutOfStock;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          group.parent.spuName,
          style: isOut
              ? AppTextStyles.productNameMuted
              : AppTextStyles.productName,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: AppSize.size4.h),
        ProductUnitGroupAttributeChips(attributes: group.attributeSummaries),
        SizedBox(height: AppSize.size6.h),
        if (group.summarySku?.skuCode != null)
          ProductUnitGroupSkuCode(skuCode: group.summarySku!.skuCode!),
        if (group.variantCount > 1) ...[
          SizedBox(height: AppSize.size8.h),
          ProductUnitGroupVariantLink(count: group.variantCount),
        ],
      ],
    );
  }
}

class ProductUnitGroupMetrics extends StatelessWidget {
  const ProductUnitGroupMetrics({
    super.key,
    required this.group,
    required this.isOut,
  });

  final SkuSpuUnitGroupEntity group;
  final bool isOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (group.minSellingPrice != null)
          Text(
            AppFormatters.formatPrice(group.minSellingPrice!),
            style: isOut
                ? AppTextStyles.productPrice.copyWith(
                    color: AppColors.textMuted,
                  )
                : AppTextStyles.productPrice,
          ),
        SizedBox(height: AppSize.size16.h),
        Text(
          '${AppStrings.inStock}: ${group.totalStock} ${group.unitName}',
          style: AppTextStyles.productMeta.copyWith(color: AppColors.subtitle),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}

class ProductUnitGroupAttributeChips extends StatelessWidget {
  const ProductUnitGroupAttributeChips({super.key, required this.attributes});

  final List<SkuSpuGroupAttributeSummary> attributes;

  @override
  Widget build(BuildContext context) {
    if (attributes.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: AppSize.size4.w,
      runSpacing: AppSize.size4.h,
      children: attributes
          .map(
            (attribute) =>
                ProductUnitGroupAttributeChip(label: attribute.value),
          )
          .toList(),
    );
  }
}

class ProductUnitGroupAttributeChip extends StatelessWidget {
  const ProductUnitGroupAttributeChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppColors.skuChipFill,
        borderRadius: BorderRadius.circular(5.r),
      ),
      child: Text(label, style: AppTextStyles.productMeta),
    );
  }
}

class ProductUnitGroupSkuCode extends StatelessWidget {
  const ProductUnitGroupSkuCode({super.key, required this.skuCode});

  final String skuCode;

  @override
  Widget build(BuildContext context) {
    return Text(
      skuCode,
      style: AppTextStyles.productMeta.copyWith(color: AppColors.subtitle),
    );
  }
}

class ProductUnitGroupVariantLink extends StatelessWidget {
  const ProductUnitGroupVariantLink({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.variantCount(count),
          style: AppTextStyles.productMeta.copyWith(color: AppColors.primary),
        ),
        Icon(
          Icons.chevron_right_rounded,
          size: AppSize.size20.r,
          color: AppColors.primary,
        ),
      ],
    );
  }
}
