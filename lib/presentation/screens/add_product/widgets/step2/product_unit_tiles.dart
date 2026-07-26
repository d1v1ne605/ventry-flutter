import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_bloc.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_event.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/add_product_state.dart';

class ProductBaseUnitTile extends StatelessWidget {
  const ProductBaseUnitTile({
    super.key,
    required this.unit,
    required this.isLoading,
    required this.onTap,
  });

  final UnitEntity? unit;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ProductUnitTileFrame(
      title: unit?.name ?? AppStrings.productUnitChooseBase,
      subtitle: AppStrings.productUnitBaseSubtitle,
      trailing: isLoading
          ? SizedBox(
              width: AppSize.size20.r,
              height: AppSize.size20.r,
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(Icons.chevron_right_rounded, color: AppColors.subtitle),
      onTap: onTap,
    );
  }
}

class ProductConversionUnitTile extends StatelessWidget {
  const ProductConversionUnitTile({super.key, required this.draft});

  final ProductUnitDraft draft;

  @override
  Widget build(BuildContext context) {
    return ProductUnitTileFrame(
      title: draft.unit.name,
      subtitle: AppStrings.productUnitConversionSubtitle(
        draft.conversionFactor,
      ),
      trailing: IconButton(
        icon: Icon(Icons.close_rounded, color: AppColors.error, size: 18.r),
        onPressed: () => context.read<AddProductBloc>().add(
          RemoveProductUnitDraftEvent(draft.id),
        ),
      ),
    );
  }
}

class ProductUnitTileFrame extends StatelessWidget {
  const ProductUnitTileFrame({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.skuChipFill,
      borderRadius: BorderRadius.circular(AppSize.size10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSize.size10.r),
        child: Padding(
          padding: EdgeInsets.all(AppSize.size12.r),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.heading,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppSize.size2.h),
                    Text(subtitle, style: AppTextStyles.bodyManrope),
                  ],
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}
