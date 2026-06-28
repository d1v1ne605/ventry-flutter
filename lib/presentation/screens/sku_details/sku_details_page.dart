import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/widgets/app_top_bar.dart';
import 'package:ventry_flutter/injection.dart';
import 'bloc/sku_details_bloc.dart';
import 'bloc/sku_details_event.dart';
import 'bloc/sku_details_state.dart';
import 'widgets/attributes_card.dart';
import 'widgets/description_card.dart';
import 'widgets/general_info_card.dart';
import 'widgets/inventory_stats_bar.dart';
import 'widgets/sku_hero_card.dart';

class SkuDetailsPage extends StatelessWidget {
  final String skuUid;

  const SkuDetailsPage({super.key, required this.skuUid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SkuDetailsBloc>()..add(LoadSkuDetails(skuUid)),
      child: const _SkuDetailsView(),
    );
  }
}

class _SkuDetailsView extends StatelessWidget {
  const _SkuDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppTopBar(
        title: AppStrings.skuDetailsTitle,
        leadingWidget: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.primary,
            size: AppSize.size16.r,
          ),
          onPressed: () => context.pop(),
        ),
        trailingWidget: SizedBox(width: 48.w),
      ),
      body: BlocBuilder<SkuDetailsBloc, SkuDetailsState>(
        builder: (context, state) {
          if (state.status == BaseStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state.status == BaseStatus.failure) {
            return Center(
              child: Text(
                state.errorMessage ?? 'Error loading SKU details',
                style: TextStyle(fontSize: 16.sp, color: Colors.red),
              ),
            );
          } else if (state.status == BaseStatus.success && state.sku != null) {
            final sku = state.sku!;
            return Stack(
              children: [
                // Main Content
                SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 16.w,
                    right: 16.w,
                    top: 20.h,
                    bottom: 128.h, // Space for fixed bottom actions
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SkuHeroCard(sku: sku),
                      SizedBox(height: 20.h),
                      InventoryStatsBar(sku: sku),
                      SizedBox(height: 20.h),
                      GeneralInfoCard(sku: sku),
                      SizedBox(height: 20.h),
                      AttributesCard(sku: sku),
                      SizedBox(height: 20.h),
                      DescriptionCard(sku: sku),
                    ],
                  ),
                ),
                // Fixed Bottom Actions
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                      child: Container(
                        padding: EdgeInsets.all(AppSize.size16.w),
                        decoration: const BoxDecoration(
                          color: Color(0xE6F5FAF8),
                          border: Border(
                            top: BorderSide(color: AppColors.inputBorder),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _OutlinedButton(
                                text: AppStrings.editVariantButton,
                                onPressed: () {
                                  // TODO: Navigate to Edit Variant
                                },
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: _FilledButton(
                                text: AppStrings.quickAdjustButton,
                                onPressed: () {
                                  // TODO: Open Quick Adjust Modal
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _OutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _OutlinedButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSize.size8.r),
                          border: Border.all(color: AppColors.primary),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          text,
                          style: AppTextStyles.buttonText.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
      ),
    );
  }
}

class _FilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _FilledButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppSize.size8.r),
          boxShadow: const [AppColors.buttonShadow],
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppTextStyles.buttonText,
        ),
      ),
    );
  }
}
