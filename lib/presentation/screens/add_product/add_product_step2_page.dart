import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:ventry_flutter/core/widgets/app_top_bar.dart';
import 'package:ventry_flutter/presentation/screens/add_product/widgets/add_product_bottom_bar.dart';
import 'package:ventry_flutter/presentation/screens/add_product/widgets/step2/price_and_inventory_section.dart';
import 'package:ventry_flutter/presentation/screens/add_product/widgets/step2/sku_preview_section.dart';
import 'package:ventry_flutter/presentation/screens/add_product/widgets/step2/variant_options_section.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_bloc.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_state.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/bloc/product_catalog_bloc.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/bloc/product_catalog_event.dart';
import 'package:ventry_flutter/presentation/screens/product_catalog/bloc/product_catalog_state.dart';
import 'package:ventry_flutter/injection.dart';

class AddProductStep2Page extends StatelessWidget {
  const AddProductStep2Page({super.key, required this.params});

  final CreateProductParams params;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductCatalogBloc>(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: AppTopBar(
          title: AppStrings.addProductTitle,
          leadingWidget: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.transparent,
              padding: EdgeInsets.all(AppSize.size8.r),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20.r,
                color: AppColors.heading,
              ),
            ),
          ),
          trailingWidget: SizedBox(width: 40.w, height: 40.h),
        ),
        body: const _AddProductStep2Body(),
        bottomNavigationBar: Builder(
          builder: (context) {
            return AddProductBottomBar(
              leftButtonText: AppStrings.quickAddBack,
              onCancel: () => Navigator.of(context).pop(),
              rightButtonText: AppStrings.saveAndComplete,
              showRightIcon: false,
              onNext: () {
                final attrState = context.read<AttributeBloc>().state;
                final skus = attrState.generatedSkus.map((e) {
                  final uids = e.options
                      .map((opt) => opt.uid)
                      .whereType<String>()
                      .toList();

                  return CreateSkuParams(
                    skuCode: e.skuCode.trim().isEmpty ? null : e.skuCode.trim(),
                    barCode: e.barcode.trim().isEmpty ? null : e.barcode.trim(),
                    sellingPrice: e.price,
                    costPrice: e.costPrice,
                    stockQuantity: e.stock,
                    minStockQuantity: 0,
                    isSellable: attrState.globalIsSellable,
                    attributeValueUids: uids,
                  );
                }).toList();

                if (skus.isEmpty) {
                  skus.add(CreateSkuParams(
                    skuCode: null, // Auto-generated in Bloc
                    barCode: null,
                    sellingPrice: attrState.globalPrice,
                    costPrice: attrState.globalCostPrice,
                    stockQuantity: attrState.globalStock,
                    minStockQuantity: 0,
                    isSellable: attrState.globalIsSellable,
                    attributeValueUids: const [],
                  ));
                }
                
                final finalParams = CreateProductParams(
                  name: params.name,
                  categoryUid: params.categoryUid,
                  description: params.description,
                  brand: params.brand,
                  imageUrl: params.imageUrl,
                  currency: params.currency,
                  unitOfMeasure: params.unitOfMeasure,
                  globalAttributeValueUids: params.globalAttributeValueUids,
                  skus: skus,
                );

                context.read<ProductCatalogBloc>().add(CreateProduct(finalParams));
              },
            );
          }
        ),
      ),
    ));
  }
}

class _AddProductStep2Body extends StatelessWidget {
  const _AddProductStep2Body();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AttributeBloc, AttributeState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              current.status == BaseStatus.failure,
          listener: (context, state) {
            if (state.errorMessage != null) {
              AppSnackBar.showError(context, state.errorMessage!);
            }
          },
        ),
        BlocListener<ProductCatalogBloc, ProductCatalogState>(
          listenWhen: (prev, curr) => prev.actionStatus != curr.actionStatus,
          listener: (context, state) {
            if (state.actionStatus == ProductCatalogActionStatus.success) {
              AppSnackBar.showSuccess(context, 'Product created successfully!');
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else if (state.actionStatus == ProductCatalogActionStatus.failure) {
              AppSnackBar.showError(context, state.failure?.message ?? 'Failed to create product');
            }
          },
        ),
      ],
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Progress Bar Area
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSize.size16.w,
                AppSize.size16.h,
                AppSize.size16.w,
                AppSize.size8.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.size4.r),
                      child: LinearProgressIndicator(
                        value: 0.66,
                        backgroundColor: AppColors.divider,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        minHeight: 8.h,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSize.size12.w),
                  Text(
                    AppStrings.addProductProgress2,
                    style: GoogleFonts.manrope(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.subtitle,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.size16.w),
              child: Text(
                AppStrings.priceAndSkuVariants,
                style: GoogleFonts.manrope(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(height: AppSize.size16.h),

            // Main Card
            Container(
              padding: EdgeInsets.all(AppSize.size16.r),
              margin: EdgeInsets.symmetric(horizontal: AppSize.size16.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSize.size12.r),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x080F1722),
                    offset: Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PriceAndInventorySection(),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSize.size16.h),
                    child: const Divider(color: AppColors.divider),
                  ),
                  const VariantOptionsSection(),
                ],
              ),
            ),
            SizedBox(height: AppSize.size24.h),

            // SKU Preview
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.size16.w),
              child: const SkuPreviewSection(),
            ),
            SizedBox(height: AppSize.size24.h),
          ],
        ),
      ),
    );
  }
}
