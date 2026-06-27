import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_bloc.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_event.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_state.dart';

class AddCategoryBottomSheet extends StatefulWidget {
  const AddCategoryBottomSheet({super.key, this.initialCategory});

  final CategoryEntity? initialCategory;

  @override
  State<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends State<AddCategoryBottomSheet> {
  late final TextEditingController _controller;

  bool get _isEdit => widget.initialCategory != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialCategory?.name ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CategoryBloc, CategoryState>(
      listenWhen: (previous, current) =>
          previous.actionStatus != current.actionStatus,
      listener: (context, state) {
        if (state.actionStatus == CategoryActionStatus.success) {
          if (mounted && GoRouter.of(context).canPop()) {
            context.pop();
          }
        } else if (state.actionStatus == CategoryActionStatus.failure &&
            state.failure != null) {
          AppSnackBar.showError(context, state.failure!.message);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSize.size24.r),
            topRight: Radius.circular(AppSize.size24.r),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A0F172A),
              offset: Offset(0, -8),
              blurRadius: 24,
            ),
          ],
        ),
        padding: EdgeInsets.only(
          left: AppSize.size24.w,
          right: AppSize.size24.w,
          top: AppSize.size16.h,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSize.size32.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: AppSize.size48.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: AppColors.cardChevron,
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),
            SizedBox(height: AppSize.size24.h),
            Text(
              _isEdit
                  ? AppStrings.categoryEditTitle
                  : AppStrings.categoryNewTitle,
              style: AppTextStyles.sectionHeading,
            ),
            SizedBox(height: AppSize.size24.h),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.size16.w,
                vertical: AppSize.size14.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(AppSize.size8.r),
                border: Border.all(color: AppColors.primary, width: 1.5),
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
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: AppStrings.categoryNameHint,
                  hintStyle: AppTextStyles.inputHint,
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: AppTextStyles.input,
              ),
            ),
            SizedBox(height: AppSize.size32.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: AppSize.size14.h),
                      side: const BorderSide(color: AppColors.cardChevron),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSize.size8.r),
                      ),
                    ),
                    child: Text(
                      AppStrings.categoryCancelButton,
                      style: AppTextStyles.buttonText.copyWith(
                        color: AppColors.heading,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSize.size16.w),
                Expanded(
                  child: BlocSelector<CategoryBloc, CategoryState, bool>(
                    selector: (state) => state.isSubmitting,
                    builder: (context, isSubmitting) {
                      return ElevatedButton(
                        onPressed: isSubmitting
                            ? null
                            : () {
                                final name = _controller.text.trim();
                                if (name.isEmpty) return;

                                if (_isEdit) {
                                  context.read<CategoryBloc>().add(
                                    UpdateCategory(
                                      categoryUid: widget.initialCategory!.uid,
                                      name: name,
                                    ),
                                  );
                                } else {
                                  context.read<CategoryBloc>().add(
                                    CreateCategory(name: name),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSize.size8.r,
                            ),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: isSubmitting
                                ? null
                                : AppColors.primaryGradient,
                            color: isSubmitting ? AppColors.inputFill : null,
                            borderRadius: BorderRadius.circular(
                              AppSize.size8.r,
                            ),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                              vertical: AppSize.size14.h,
                            ),
                            child: isSubmitting
                                ? SizedBox(
                                    width: AppSize.size20.w,
                                    height: AppSize.size20.w,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.primary,
                                    ),
                                  )
                                : Text(
                                    _isEdit
                                        ? AppStrings.categoryUpdateTitle
                                        : AppStrings.categorySaveTitle,
                                    style: AppTextStyles.buttonText.copyWith(
                                      color: isSubmitting
                                          ? AppColors.subtitle
                                          : Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
