import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_bloc.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_event.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_state.dart';
import 'package:ventry_flutter/presentation/screens/category_management/widgets/add_category_bottom_sheet.dart';

class SkuFormCategoryBottomSheet extends StatefulWidget {
  const SkuFormCategoryBottomSheet({super.key, this.selectedCategory});

  final CategoryEntity? selectedCategory;

  @override
  State<SkuFormCategoryBottomSheet> createState() =>
      _SkuFormCategoryBottomSheetState();
}

class _SkuFormCategoryBottomSheetState
    extends State<SkuFormCategoryBottomSheet> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCreateCategorySheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<CategoryBloc>(),
        child: const AddCategoryBottomSheet(),
      ),
    );
  }

  bool _isSelected(CategoryEntity category) {
    final selected = widget.selectedCategory;
    if (selected == null) {
      return false;
    }
    return category.uid == selected.uid || category.name == selected.name;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<CategoryBloc, CategoryState>(
      listenWhen: (previous, current) =>
          previous.categories.length != current.categories.length &&
          current.actionStatus == CategoryActionStatus.success &&
          current.categories.isNotEmpty,
      listener: (context, state) {
        Navigator.of(context).pop(state.categories.first);
      },
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SafeArea(
          top: false,
          child: Container(
            constraints: BoxConstraints(maxHeight: 0.82.sh),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSize.size24.r),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: AppSize.size12.h),
                Container(
                  width: AppSize.size48.w,
                  height: AppSize.size4.h,
                  decoration: BoxDecoration(
                    color: AppColors.divider,
                    borderRadius: BorderRadius.circular(AppSize.size4.r),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSize.size16.w,
                    AppSize.size16.h,
                    AppSize.size16.w,
                    AppSize.size12.h,
                  ),
                  child: Column(
                    children: [
                      Text(
                        AppStrings.skuFormCategory,
                        style: AppTextStyles.sectionHeading,
                      ),
                      SizedBox(height: AppSize.size16.h),
                      TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          context.read<CategoryBloc>().add(
                            SearchCategories(value),
                          );
                        },
                        style: AppTextStyles.input,
                        decoration: InputDecoration(
                          hintText: AppStrings.categorySearchHint,
                          hintStyle: AppTextStyles.inputHint,
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.subtitle,
                            size: AppSize.size20.r,
                          ),
                          filled: true,
                          fillColor: AppColors.inputFill,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppSize.size12.r,
                            ),
                            borderSide: const BorderSide(
                              color: AppColors.inputBorder,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppSize.size12.r,
                            ),
                            borderSide: const BorderSide(
                              color: AppColors.inputBorder,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppSize.size12.r,
                            ),
                            borderSide: const BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    buildWhen: (previous, current) =>
                        previous.isLoading != current.isLoading ||
                        previous.categories != current.categories,
                    builder: (context, state) {
                      if (state.isLoading && state.categories.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }

                      if (state.categories.isEmpty) {
                        return Center(
                          child: Text(
                            AppStrings.categoryNoResults,
                            style: AppTextStyles.body,
                          ),
                        );
                      }

                      return ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.fromLTRB(
                          AppSize.size16.w,
                          0,
                          AppSize.size16.w,
                          AppSize.size16.h,
                        ),
                        itemCount: state.categories.length,
                        separatorBuilder: (_, __) =>
                            SizedBox(height: AppSize.size8.h),
                        itemBuilder: (context, index) {
                          final category = state.categories[index];
                          final isSelected = _isSelected(category);
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(
                                AppSize.size12.r,
                              ),
                              onTap: () => Navigator.of(context).pop(category),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSize.size16.w,
                                  vertical: AppSize.size14.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.skuFormSoftBackground
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    AppSize.size12.r,
                                  ),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.inputBorder,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        category.name,
                                        style: AppTextStyles.input.copyWith(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.heading,
                                        ),
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.check_rounded,
                                        color: AppColors.primary,
                                        size: AppSize.size20.r,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSize.size16.w,
                    AppSize.size8.h,
                    AppSize.size16.w,
                    AppSize.size16.h,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _openCreateCategorySheet,
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: AppSize.size14.h,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.size12.r),
                        ),
                        side: const BorderSide(color: AppColors.primary),
                      ),
                      icon: Icon(
                        Icons.add_rounded,
                        color: AppColors.primary,
                        size: AppSize.size20.r,
                      ),
                      label: Text(
                        AppStrings.createNewCategory,
                        style: AppTextStyles.buttonText.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
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
