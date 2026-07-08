import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/constants/app_assets.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/utils/app_formatters.dart';
import 'package:ventry_flutter/core/utils/string_utils.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:ventry_flutter/core/widgets/app_top_bar.dart';
import 'package:ventry_flutter/core/widgets/app_pull_to_refresh.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/entities/product/sku_spu_group_entity.dart';
import 'package:ventry_flutter/domain/entities/product/spu_entity.dart';
import 'package:ventry_flutter/injection.dart';
import 'package:ventry_flutter/presentation/routes/router_constants.dart';
import 'package:ventry_flutter/presentation/screens/spu_variants/bloc/spu_variants_bloc.dart';
import 'package:ventry_flutter/presentation/screens/spu_variants/bloc/spu_variants_event.dart';
import 'package:ventry_flutter/presentation/screens/spu_variants/bloc/spu_variants_state.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/sku_form_page.dart';

class SpuVariantsPage extends StatelessWidget {
  final String spuUid;

  const SpuVariantsPage({super.key, required this.spuUid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<SpuVariantsBloc>()..add(LoadSpuVariants(spuUid)),
      child: _SpuVariantsView(spuUid: spuUid),
    );
  }
}

class _SpuVariantsView extends StatelessWidget {
  const _SpuVariantsView({required this.spuUid});

  final String spuUid;

  void _refreshVariants(BuildContext context) {
    context.read<SpuVariantsBloc>().add(LoadSpuVariants(spuUid));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppTopBar(
        title: AppStrings.spuVariantsTitle,
        leadingWidget: IconButton(
          padding: EdgeInsets.zero,
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(3.14159),
            child: SvgPicture.asset(
              AppAssets.icChevronRight,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
              width: AppSize.size16.r,
              height: AppSize.size16.r,
            ),
          ),
          onPressed: () => context.pop(),
        ),
        trailingWidget: const _AddVariantAction(),
      ),
      body: BlocBuilder<SpuVariantsBloc, SpuVariantsState>(
        builder: (context, state) {
          if (state.status == BaseStatus.loading) {
            return AppPullToRefresh(
              onRefresh: () => _refreshVariants(context),
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
              onRefresh: () => _refreshVariants(context),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _VariantsErrorState(message: state.errorMessage),
                  ),
                ],
              ),
            );
          }

          final group = state.group;
          if (state.status != BaseStatus.success || group == null) {
            return const SizedBox.shrink();
          }

          return AppPullToRefresh(
            onRefresh: () => _refreshVariants(context),
            child: _VariantsContent(group: group),
          );
        },
      ),
    );
  }
}

class _AddVariantAction extends StatelessWidget {
  const _AddVariantAction();

  Future<void> _openCreateSkuForm(BuildContext context) async {
    final bloc = context.read<SpuVariantsBloc>();
    final group = bloc.state.group;
    final templateSku = group?.representativeSku;
    if (group == null || templateSku == null) {
      return;
    }

    final createdSku = await context.pushNamed<SkuEntity>(
      RouterName.skuForm,
      extra: SkuFormPageArgs.create(templateSku),
    );

    if (createdSku == null || !context.mounted) {
      return;
    }

    AppSnackBar.showSuccess(context, AppStrings.skuFormCreatedSuccess);
    bloc.add(LoadSpuVariants(group.spuUid));
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SpuVariantsBloc, SpuVariantsState, bool>(
      selector: (state) => state.group?.representativeSku != null,
      builder: (context, canCreate) {
        return GestureDetector(
          onTap: canCreate ? () => _openCreateSkuForm(context) : null,
          child: Opacity(
            opacity: canCreate ? 1 : 0.5,
            child: Text(
              AppStrings.addNew,
              style: AppTextStyles.linkSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: AppSize.size14.sp,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _VariantsContent extends StatelessWidget {
  const _VariantsContent({required this.group});

  final SkuSpuGroupEntity group;

  @override
  Widget build(BuildContext context) {
    final variants = group.sortedSkus;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _VariantsHero(group: group),
          SizedBox(height: 16.h),
          _VariantsSectionHeader(count: variants.length),
          SizedBox(height: 12.h),
          ...variants.map(
            (sku) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _VariantListItem(sku: sku),
            ),
          ),
        ],
      ),
    );
  }
}

class _VariantsHero extends StatelessWidget {
  const _VariantsHero({required this.group});

  final SkuSpuGroupEntity group;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeroImage(imageUrl: group.primaryImageUrl),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        group.spuName,
                        style: AppTextStyles.cardTitle,
                      ),
                    ),
                    SizedBox(width: AppSize.size8.w),
                    _HeroEditSpuButton(group: group),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  AppStrings.variantCount(group.variantCount),
                  style: AppTextStyles.bodyManrope,
                ),
                if (group.attributeSummaries.isNotEmpty) ...[
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: group.attributeSummaries.map((attribute) {
                      return _SummaryChip(label: attribute.value);
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroEditSpuButton extends StatelessWidget {
  const _HeroEditSpuButton({required this.group});

  final SkuSpuGroupEntity group;

  Future<void> _openEditSpuForm(BuildContext context) async {
    final bloc = context.read<SpuVariantsBloc>();
    final updatedSpu = await context.pushNamed<SpuEntity>(
      RouterName.editSpu,
      pathParameters: {'spuUid': group.spuUid},
    );

    if (updatedSpu == null || !context.mounted) {
      return;
    }

    bloc.add(LoadSpuVariants(group.spuUid));
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppStrings.editSpuButton,
      child: Material(
        color: AppColors.skuChipFill,
        borderRadius: BorderRadius.circular(AppSize.size8.r),
        child: InkWell(
          onTap: () => _openEditSpuForm(context),
          borderRadius: BorderRadius.circular(AppSize.size8.r),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.size8.w,
              vertical: AppSize.size6.h,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.edit_rounded,
                  color: AppColors.primary,
                  size: AppSize.size16.r,
                ),
                SizedBox(width: AppSize.size4.w),
                Text(
                  AppStrings.editSpuButton,
                  style: AppTextStyles.skuChip.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final safeImageUrl = StringUtils.isSafeNetworkUrl(imageUrl)
        ? imageUrl
        : null;

    return Container(
      width: 72.r,
      height: 72.r,
      decoration: BoxDecoration(
        color: AppColors.searchBarFill,
        borderRadius: BorderRadius.circular(14.r),
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

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.skuChipFill,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: AppTextStyles.skuChip,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _VariantsSectionHeader extends StatelessWidget {
  const _VariantsSectionHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            AppStrings.variantsListTitle.toUpperCase(),
            style: AppTextStyles.label.copyWith(
              color: AppColors.subtitle,
              letterSpacing: 0,
            ),
          ),
        ),
        Text(
          AppStrings.variantCount(count),
          style: AppTextStyles.linkSmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _VariantListItem extends StatelessWidget {
  const _VariantListItem({required this.sku});

  final SkuEntity sku;

  @override
  Widget build(BuildContext context) {
    final attributes = sku.attributes
        .map((attribute) => attribute.value)
        .where((value) => value.isNotEmpty)
        .join(' - ');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final deletedSkuUid = await context.pushNamed<String>(
            RouterName.skuDetail,
            pathParameters: {'skuUid': sku.uid},
          );

          if (deletedSkuUid != null && context.mounted) {
            context.read<SpuVariantsBloc>().add(LoadSpuVariants(sku.spuUid));
          }
        },
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (attributes.isNotEmpty)
                      Text(attributes, style: AppTextStyles.productName),
                    if (attributes.isNotEmpty) SizedBox(height: 6.h),
                    Text(
                      sku.skuCode ?? sku.uid,
                      style: AppTextStyles.productMeta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    sku.sellingPrice == null
                        ? AppStrings.notAvailable
                        : AppFormatters.formatPrice(sku.sellingPrice!),
                    style: AppTextStyles.productPrice,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '${AppStrings.stockShortLabel}: ${sku.stockQuantity}',
                    style: AppTextStyles.bodyManrope,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VariantsErrorState extends StatelessWidget {
  const _VariantsErrorState({required this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Text(
          message ?? AppStrings.noVariantsFound,
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
