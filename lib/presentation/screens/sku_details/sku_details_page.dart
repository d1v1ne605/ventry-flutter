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

  Future<void> _openCreateSkuForm(BuildContext context, SkuEntity sku) async {
    final createdSku = await context.pushNamed<SkuEntity>(
      RouterName.skuForm,
      extra: SkuFormPageArgs.create(sku),
    );

    if (createdSku == null || !context.mounted) {
      return;
    }

    AppSnackBar.showSuccess(context, AppStrings.skuFormCreatedSuccess);
  }

  Future<void> _confirmDeleteSku(BuildContext context, SkuEntity sku) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          AppStrings.skuDetailsDeleteTitle,
          style: AppTextStyles.sectionHeading,
        ),
        content: Text(
          AppStrings.skuDetailsDeleteConfirmation,
          style: AppTextStyles.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              AppStrings.categoryCancelButton,
              style: AppTextStyles.buttonText.copyWith(
                color: AppColors.heading,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              AppStrings.skuDetailsDeleteButton,
              style: AppTextStyles.buttonText.copyWith(
                color: const Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm != true || !context.mounted) {
      return;
    }

    context.read<SkuDetailsBloc>().add(
      DeleteSkuDetails(skuUid: sku.uid, version: sku.version),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SkuDetailsBloc, SkuDetailsState>(
      listenWhen: (previous, current) =>
          previous.deleteStatus != current.deleteStatus,
      listener: (context, state) {
        if (state.deleteStatus == SkuDetailsDeleteStatus.failure) {
          AppSnackBar.showError(
            context,
            state.deleteMessage ?? AppStrings.editSpuLoadFailed,
          );
        }

        if (state.deleteStatus == SkuDetailsDeleteStatus.success &&
            state.deletedSkuUid != null) {
          AppSnackBar.showSuccess(context, AppStrings.skuDetailsDeletedSuccess);
          context.pop(state.deletedSkuUid);
        }
      },
      child: Scaffold(
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
          trailingWidget: _SkuDetailsMoreActions(
            editedSku: _editedSku,
            onCreateSelected: _openCreateSkuForm,
            onDeleteSelected: _confirmDeleteSku,
          ),
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
              final isDeleting =
                  state.deleteStatus == SkuDetailsDeleteStatus.loading;

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
                                  onPressed: isDeleting
                                      ? null
                                      : () => _openSkuForm(context, sku),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isDeleting)
                    const Positioned.fill(
                      child: ColoredBox(
                        color: Colors.white54,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
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
      ),
    );
  }
}

class _OutlinedButton extends StatelessWidget {
  const _OutlinedButton({required this.text, required this.onPressed});

  final String text;
  final VoidCallback? onPressed;

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
          border: Border.all(
            color: onPressed == null
                ? AppColors.inputBorder
                : AppColors.primary,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: AppTextStyles.buttonText.copyWith(
            color: onPressed == null ? AppColors.subtitle : AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _SkuDetailsMoreActions extends StatelessWidget {
  const _SkuDetailsMoreActions({
    required this.editedSku,
    required this.onCreateSelected,
    required this.onDeleteSelected,
  });

  final SkuEntity? editedSku;
  final Future<void> Function(BuildContext context, SkuEntity sku)
  onCreateSelected;
  final Future<void> Function(BuildContext context, SkuEntity sku)
  onDeleteSelected;

  Future<void> _showActionsSheet(BuildContext context, SkuEntity sku) async {
    final canCreateSameType = sku.attributes.isNotEmpty;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: const [AppColors.cardShadow],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 8.h),
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.inputBorder,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                ),
                if (canCreateSameType)
                  ListTile(
                    leading: const Icon(
                      Icons.add_box_outlined,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      AppStrings.skuDetailsAddSameTypeButton,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    onTap: () async {
                      Navigator.of(sheetContext).pop();
                      await onCreateSelected(context, sku);
                    },
                  ),
                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFEF4444),
                  ),
                  title: Text(
                    AppStrings.skuDetailsDeleteButton,
                    style: AppTextStyles.body.copyWith(
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    await onDeleteSelected(context, sku);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SkuDetailsBloc, SkuDetailsState>(
      buildWhen: (previous, current) =>
          previous.sku != current.sku ||
          previous.deleteStatus != current.deleteStatus,
      builder: (context, state) {
        final sku = editedSku ?? state.sku;
        final isDeleting = state.deleteStatus == SkuDetailsDeleteStatus.loading;

        if (sku == null) {
          return SizedBox(width: 48.w);
        }

        if (isDeleting) {
          return SizedBox(
            width: 48.w,
            child: const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
            ),
          );
        }

        return IconButton(
          tooltip: AppStrings.skuDetailsMoreOptions,
          onPressed: () => _showActionsSheet(context, sku),
          icon: Icon(
            Icons.more_vert,
            color: AppColors.primary,
            size: AppSize.size20.r,
          ),
        );
      },
    );
  }
}
