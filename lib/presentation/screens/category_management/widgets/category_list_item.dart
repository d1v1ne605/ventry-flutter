import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';
import 'package:ventry_flutter/presentation/screens/category_management/widgets/add_category_bottom_sheet.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_bloc.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_event.dart';

class CategoryListItem extends StatelessWidget {
  final CategoryEntity category;

  const CategoryListItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.size16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size8.r),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: const BoxDecoration(
              color: AppColors.cardIconBackground,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.category,
                color: AppColors.primary,
                size: AppSize.size20.w,
              ), // Placeholder for category icon
            ),
          ),
          SizedBox(width: AppSize.size16.w),
          Expanded(child: Text(category.name, style: AppTextStyles.label)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => BlocProvider.value(
                      value: context.read<CategoryBloc>(),
                      child: AddCategoryBottomSheet(initialCategory: category),
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit,
                  color: const Color(0xFF0284C7),
                  size: AppSize.size20.w,
                ),
                splashRadius: AppSize.size20.r,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              SizedBox(width: AppSize.size16.w),
              IconButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      backgroundColor: AppColors.surface,
                      title: Text(
                        AppStrings.categoryDeleteTitle,
                        style: AppTextStyles.sectionHeading,
                      ),
                      content: Text(
                        AppStrings.categoryDeleteConfirm(category.name),
                        style: AppTextStyles.body,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
                          child: Text(
                            AppStrings.categoryCancelButton,
                            style: AppTextStyles.buttonText.copyWith(
                              color: AppColors.heading,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          child: Text(
                            AppStrings.categoryDeleteButton,
                            style: AppTextStyles.buttonText.copyWith(
                              color: const Color(0xFFEF4444),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true && context.mounted) {
                    context.read<CategoryBloc>().add(
                      DeleteCategory(category.uid),
                    );
                  }
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: const Color(0xFFEF4444),
                  size: AppSize.size20.w,
                ),
                splashRadius: AppSize.size20.r,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
