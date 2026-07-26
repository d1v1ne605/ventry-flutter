import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/domain/entities/product/sku_spu_group_entity.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/widgets/product_unit_group_card_parts.dart';

class ProductUnitGroupCard extends StatelessWidget {
  const ProductUnitGroupCard({super.key, required this.group, this.onTap});

  final SkuSpuUnitGroupEntity group;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isOut = group.stockStatus.isOutOfStock;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: _leftBorder(),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductUnitGroupImage(
                imageUrl: group.primaryImageUrl,
                isOut: isOut,
              ),
              SizedBox(width: AppSize.size12.w),
              Expanded(child: ProductUnitGroupInfo(group: group)),
              SizedBox(width: AppSize.size8.w),
              ProductUnitGroupMetrics(group: group, isOut: isOut),
            ],
          ),
        ),
      ),
    );
  }

  Border? _leftBorder() {
    final color = switch (group.stockStatus) {
      SkuSpuGroupStockStatus.inStock => null,
      SkuSpuGroupStockStatus.lowStock => AppColors.lowStockBorder,
      SkuSpuGroupStockStatus.outOfStock => AppColors.outOfStockBorder,
    };
    return color == null
        ? null
        : Border(
            left: BorderSide(color: color, width: 4.w),
          );
  }
}
