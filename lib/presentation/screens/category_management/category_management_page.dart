import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/widgets/app_top_bar.dart';
import 'package:ventry_flutter/presentation/screens/category_management/widgets/category_list_item.dart';
import 'package:ventry_flutter/presentation/screens/category_management/widgets/add_category_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventry_flutter/injection.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_bloc.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_event.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_state.dart';

class CategoryManagementPage extends StatelessWidget {
  const CategoryManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CategoryBloc>()..add(LoadCategories()),
      child: const _CategoryManagementView(),
    );
  }
}

class _CategoryManagementView extends StatefulWidget {
  const _CategoryManagementView();

  @override
  State<_CategoryManagementView> createState() =>
      _CategoryManagementViewState();
}

class _CategoryManagementViewState extends State<_CategoryManagementView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppTopBar(
        title: AppStrings.categoryManagementTitle.toUpperCase(),
        leadingWidget: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.heading,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
        trailingWidget: SizedBox(width: AppSize.size48.w),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search Bar
              Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSize.size24.w,
                  AppSize.size24.h,
                  AppSize.size24.w,
                  AppSize.size16.h,
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size16.w,
                    vertical: AppSize.size14.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.searchBarFill,
                    borderRadius: BorderRadius.circular(AppSize.size8.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(
                          0x0F000000,
                        ), // inset 0px 2px 4px 0px rgba(0, 0, 0, 0.06)
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        blurStyle: BlurStyle.inner,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: AppColors.subtitle,
                        size: AppSize.size20.w,
                      ),
                      SizedBox(width: AppSize.size8.w),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (query) {
                            context.read<CategoryBloc>().add(
                              SearchCategories(query),
                            );
                          },
                          decoration: InputDecoration(
                            hintText: AppStrings.categorySearchHint,
                            hintStyle: AppTextStyles.searchHint,
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: AppTextStyles.input,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Divider
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSize.size24.w),
                child: const Divider(color: Color(0xCCFFFFFF), height: 1),
              ),
              // List
              Expanded(
                child: BlocBuilder<CategoryBloc, CategoryState>(
                  buildWhen: (previous, current) =>
                      previous.isLoading != current.isLoading ||
                      previous.categories != current.categories,
                  builder: (context, state) {
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    if (state.categories.isEmpty) {
                      return Center(
                        child: Text(
                          state.searchKeyword.isEmpty
                              ? AppStrings.categoryEmpty
                              : AppStrings.categoryNoResults,
                          style: AppTextStyles.searchHint,
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        AppSize.size24.w,
                        AppSize.size8.h,
                        AppSize.size24.w,
                        96.h,
                      ),
                      itemCount: state.categories.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        return CategoryListItem(
                          category: state.categories[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          // Floating Action Button
          Positioned(
            right: 24.w,
            bottom: 24.h,
            child: Builder(
              builder: (fabContext) => GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: fabContext,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => BlocProvider.value(
                      value: fabContext.read<CategoryBloc>(),
                      child: const AddCategoryBottomSheet(),
                    ),
                  );
                },
                child: Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppColors.primaryGradient,
                    boxShadow: AppColors.cardShadows,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: AppSize.size24.w,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
