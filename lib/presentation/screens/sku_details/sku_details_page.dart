import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/widgets/app_pull_to_refresh.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:ventry_flutter/core/widgets/app_top_bar.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/injection.dart';
import 'package:ventry_flutter/presentation/routes/router_constants.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/sku_form_page.dart';
import 'package:ventry_flutter/presentation/screens/sku_details/bloc/sku_details_bloc.dart';
import 'package:ventry_flutter/presentation/screens/sku_details/bloc/sku_details_event.dart';
import 'package:ventry_flutter/presentation/screens/sku_details/bloc/sku_details_state.dart';
import 'package:ventry_flutter/presentation/screens/sku_details/widgets/attributes_card.dart';
import 'package:ventry_flutter/presentation/screens/sku_details/widgets/description_card.dart';
import 'package:ventry_flutter/presentation/screens/sku_details/widgets/general_info_card.dart';
import 'package:ventry_flutter/presentation/screens/sku_details/widgets/inventory_stats_bar.dart';
import 'package:ventry_flutter/presentation/screens/sku_details/widgets/sku_hero_card.dart';

class SkuDetailsPage extends StatelessWidget {
  const SkuDetailsPage({super.key, required this.skuUid});

  final String skuUid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SkuDetailsBloc>()..add(LoadSkuDetails(skuUid)),
      child: _SkuDetailsView(skuUid: skuUid),
    );
  }
}

class _SkuDetailsView extends StatefulWidget {
  const _SkuDetailsView({required this.skuUid});

  final String skuUid;

  @override
  State<_SkuDetailsView> createState() => _SkuDetailsViewState();
}

class _SkuDetailsViewState extends State<_SkuDetailsView> {
  SkuEntity? _editedSku;

  void _refreshSkuDetails() {
    setState(() {
      _editedSku = null;
    });
    context.read<SkuDetailsBloc>().add(LoadSkuDetails(widget.skuUid));
  }

  Future<void> _openSkuForm(BuildContext context, SkuEntity sku) async {
    final updatedSku = await context.pushNamed<SkuEntity>(
      RouterName.skuForm,
      extra: SkuFormPageArgs.edit(_editedSku ?? sku),
    );

    if (updatedSku == null || !context.mounted) {
      return;
    }

    setState(() {
      _editedSku = updatedSku;
    });
    AppSnackBar.showSuccess(context, AppStrings.skuFormUpdatedSuccess);
  }

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
            return AppPullToRefresh(
              onRefresh: _refreshSkuDetails,
              child: const CustomScrollView(
                physics: AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state.status == BaseStatus.failure) {
            return AppPullToRefresh(
              onRefresh: _refreshSkuDetails,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        state.errorMessage ?? AppStrings.editSpuLoadFailed,
                        style: TextStyle(fontSize: 16.sp, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state.status == BaseStatus.success && state.sku != null) {
            final sku = _editedSku ?? state.sku!;
            return Stack(
              children: [
                AppPullToRefresh(
                  onRefresh: _refreshSkuDetails,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      top: 20.h,
                      bottom: 128.h,
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
                ),
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
                                onPressed: () => _openSkuForm(context, sku),
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
  const _OutlinedButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback onPressed;

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
          style: AppTextStyles.buttonText.copyWith(color: AppColors.primary),
        ),
      ),
    );
  }
}
