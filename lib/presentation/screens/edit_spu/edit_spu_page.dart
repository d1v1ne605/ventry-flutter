import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:ventry_flutter/core/widgets/app_top_bar.dart';
import 'package:ventry_flutter/core/widgets/custom_text_field.dart';
import 'package:ventry_flutter/core/widgets/primary_button.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';
import 'package:ventry_flutter/domain/entities/product/spu_entity.dart';
import 'package:ventry_flutter/injection.dart';
import 'package:ventry_flutter/presentation/screens/edit_spu/bloc/edit_spu_bloc.dart';
import 'package:ventry_flutter/presentation/screens/edit_spu/bloc/edit_spu_event.dart';
import 'package:ventry_flutter/presentation/screens/edit_spu/bloc/edit_spu_state.dart';

class EditSpuPage extends StatelessWidget {
  final String spuUid;

  const EditSpuPage({super.key, required this.spuUid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EditSpuBloc>()..add(LoadEditSpu(spuUid: spuUid)),
      child: const _EditSpuView(),
    );
  }
}

class _EditSpuView extends StatefulWidget {
  const _EditSpuView();

  @override
  State<_EditSpuView> createState() => _EditSpuViewState();
}

class _EditSpuViewState extends State<_EditSpuView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _seededSpuUid;
  int? _seededVersion;

  @override
  void dispose() {
    _nameController.dispose();
    _currencyController.dispose();
    _unitController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _seedForm(SpuEntity spu) {
    if (_seededSpuUid == spu.uid && _seededVersion == spu.version) {
      return;
    }

    _seededSpuUid = spu.uid;
    _seededVersion = spu.version;
    _nameController.text = spu.name;
    _currencyController.text = spu.currency ?? '';
    _unitController.text = spu.unitOfMeasure ?? '';
    _descriptionController.text = spu.description ?? '';
  }

  void _submit(BuildContext context) {
    context.read<EditSpuBloc>().add(
      SubmitEditSpu(
        name: _nameController.text,
        currency: _currencyController.text,
        unitOfMeasure: _unitController.text,
        description: _descriptionController.text,
      ),
    );
  }

  void _notifyFormChanged(BuildContext context) {
    context.read<EditSpuBloc>().add(
      EditSpuFormChanged(
        name: _nameController.text,
        currency: _currencyController.text,
        unitOfMeasure: _unitController.text,
        description: _descriptionController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditSpuBloc, EditSpuState>(
      listenWhen: (previous, current) =>
          previous.loadStatus != current.loadStatus ||
          previous.submitStatus != current.submitStatus ||
          previous.spu != current.spu ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        final spu = state.spu;
        if (spu != null) {
          _seedForm(spu);
        }

        if (state.submitStatus == BaseStatus.success &&
            state.updatedSpu != null) {
          AppSnackBar.showSuccess(context, AppStrings.editSpuUpdatedSuccess);
          context.pop(state.updatedSpu);
          return;
        }

        if ((state.loadStatus == BaseStatus.failure ||
                state.submitStatus == BaseStatus.failure) &&
            state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: AppTopBar(
          title: AppStrings.editSpuTitle,
          leadingWidget: IconButton(
            icon: Icon(
              Icons.chevron_left_rounded,
              color: AppColors.primary,
              size: AppSize.size28.r,
            ),
            onPressed: () => context.pop(),
          ),
          trailingWidget: SizedBox(width: AppSize.size40.w),
        ),
        body: _EditSpuBody(
          nameController: _nameController,
          currencyController: _currencyController,
          unitController: _unitController,
          descriptionController: _descriptionController,
          onChanged: () => _notifyFormChanged(context),
        ),
        bottomNavigationBar: _EditSpuBottomBar(
          onSubmit: () => _submit(context),
        ),
      ),
    );
  }
}

class _EditSpuBody extends StatelessWidget {
  const _EditSpuBody({
    required this.nameController,
    required this.currencyController,
    required this.unitController,
    required this.descriptionController,
    required this.onChanged,
  });

  final TextEditingController nameController;
  final TextEditingController currencyController;
  final TextEditingController unitController;
  final TextEditingController descriptionController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<EditSpuBloc, EditSpuState, BaseStatus>(
      selector: (state) => state.loadStatus,
      builder: (context, status) {
        if (status == BaseStatus.initial || status == BaseStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        if (status == BaseStatus.failure) {
          return const _EditSpuEmptyState();
        }

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSize.size16.w,
            AppSize.size20.h,
            AppSize.size16.w,
            AppSize.size96.h,
          ),
          child: _EditSpuFormCard(
            nameController: nameController,
            currencyController: currencyController,
            unitController: unitController,
            descriptionController: descriptionController,
            onChanged: onChanged,
          ),
        );
      },
    );
  }
}

class _EditSpuFormCard extends StatelessWidget {
  const _EditSpuFormCard({
    required this.nameController,
    required this.currencyController,
    required this.unitController,
    required this.descriptionController,
    required this.onChanged,
  });

  final TextEditingController nameController;
  final TextEditingController currencyController;
  final TextEditingController unitController;
  final TextEditingController descriptionController;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSize.size16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size16.r),
        boxShadow: const [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.editSpuBasicInformation,
            style: AppTextStyles.cardTitle,
          ),
          SizedBox(height: AppSize.size16.h),
          const _EditSpuCategoryField(),
          SizedBox(height: AppSize.size16.h),
          CustomTextField(
            label: AppStrings.addProductNameLabel,
            hintText: AppStrings.addProductNameHint,
            controller: nameController,
            onChanged: (_) => onChanged(),
            isRequired: true,
            textInputAction: TextInputAction.next,
            inputFormatters: [LengthLimitingTextInputFormatter(255)],
          ),
          SizedBox(height: AppSize.size16.h),
          CustomTextField(
            label: AppStrings.addProductCurrencyLabel,
            hintText: AppStrings.currencyHint,
            controller: currencyController,
            onChanged: (_) => onChanged(),
            textInputAction: TextInputAction.next,
            inputFormatters: [LengthLimitingTextInputFormatter(10)],
          ),
          SizedBox(height: AppSize.size16.h),
          CustomTextField(
            label: AppStrings.addProductUnitLabel,
            hintText: AppStrings.unitHint,
            controller: unitController,
            onChanged: (_) => onChanged(),
            textInputAction: TextInputAction.next,
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
          ),
          SizedBox(height: AppSize.size16.h),
          CustomTextField(
            label: AppStrings.addProductDescriptionLabel,
            hintText: AppStrings.addProductDescriptionHint,
            controller: descriptionController,
            onChanged: (_) => onChanged(),
            minLines: 4,
            maxLines: 6,
            textInputAction: TextInputAction.newline,
          ),
        ],
      ),
    );
  }
}

class _EditSpuCategoryField extends StatelessWidget {
  const _EditSpuCategoryField();

  static const String _noCategoryValue = '';

  Future<void> _openCategorySheet(BuildContext context) async {
    final state = context.read<EditSpuBloc>().state;
    final selectedUid = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.size20.r),
        ),
      ),
      builder: (_) => _EditSpuCategorySheet(
        categories: state.categories,
        selectedCategoryUid: state.selectedCategoryUid,
      ),
    );

    if (!context.mounted) {
      return;
    }

    if (selectedUid == null) {
      return;
    }

    context.read<EditSpuBloc>().add(
      EditSpuCategoryChanged(
        selectedUid == _noCategoryValue ? null : selectedUid,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<EditSpuBloc, EditSpuState, _CategoryFieldData>(
      selector: (state) => _CategoryFieldData(
        label:
            state.selectedCategory?.name ??
            state.selectedCategoryName ??
            AppStrings.editSpuNoCategory,
        hasCategories: state.categories.isNotEmpty,
      ),
      builder: (context, data) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.addProductCategoryLabel,
              style: AppTextStyles.label,
            ),
            SizedBox(height: AppSize.size4.h),
            Material(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(AppSize.size8.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppSize.size8.r),
                onTap: data.hasCategories
                    ? () => _openCategorySheet(context)
                    : null,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size16.w,
                    vertical: AppSize.size12.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSize.size8.r),
                    border: Border.all(
                      color: AppColors.inputBorder,
                      width: AppSize.size1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          data.label,
                          style: AppTextStyles.input,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.subtitle,
                        size: AppSize.size24.r,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _EditSpuCategorySheet extends StatelessWidget {
  const _EditSpuCategorySheet({
    required this.categories,
    required this.selectedCategoryUid,
  });

  final List<CategoryEntity> categories;
  final String? selectedCategoryUid;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSize.size16.w,
          AppSize.size16.h,
          AppSize.size16.w,
          AppSize.size8.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.editSpuSelectCategory,
              style: AppTextStyles.cardTitle,
            ),
            SizedBox(height: AppSize.size12.h),
            _CategoryOptionTile(
              title: AppStrings.editSpuNoCategory,
              selected: selectedCategoryUid == null,
              onTap: () => Navigator.of(
                context,
              ).pop(_EditSpuCategoryField._noCategoryValue),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _CategoryOptionTile(
                    title: category.name,
                    selected: category.uid == selectedCategoryUid,
                    onTap: () => Navigator.of(context).pop(category.uid),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryOptionTile extends StatelessWidget {
  const _CategoryOptionTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: AppTextStyles.bodySubtle),
      trailing: selected
          ? Icon(
              Icons.check_circle_rounded,
              color: AppColors.primary,
              size: AppSize.size20.r,
            )
          : null,
      onTap: onTap,
    );
  }
}

class _EditSpuBottomBar extends StatelessWidget {
  const _EditSpuBottomBar({required this.onSubmit});

  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSize.size16.w,
        AppSize.size12.h,
        AppSize.size16.w,
        AppSize.size24.h,
      ),
      decoration: const BoxDecoration(
        color: AppColors.skuFormBottomBarBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.skuFormOverlayShadow,
            offset: Offset(0, -4),
            blurRadius: 16,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BlocSelector<EditSpuBloc, EditSpuState, _SubmitButtonState>(
          selector: (state) => _SubmitButtonState(
            isLoading: state.submitStatus == BaseStatus.loading,
            canSubmit: state.canSubmit,
          ),
          builder: (context, buttonState) => PrimaryButton(
            text: AppStrings.editSpuSaveChanges,
            isLoading: buttonState.isLoading,
            isEnabled: buttonState.canSubmit,
            onPressed: onSubmit,
          ),
        ),
      ),
    );
  }
}

class _EditSpuEmptyState extends StatelessWidget {
  const _EditSpuEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSize.size24.r),
        child: Text(
          AppStrings.editSpuLoadFailed,
          style: AppTextStyles.bodySubtle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _CategoryFieldData {
  final String label;
  final bool hasCategories;

  const _CategoryFieldData({required this.label, required this.hasCategories});

  @override
  bool operator ==(Object other) {
    return other is _CategoryFieldData &&
        other.label == label &&
        other.hasCategories == hasCategories;
  }

  @override
  int get hashCode => Object.hash(label, hasCategories);
}

class _SubmitButtonState {
  final bool isLoading;
  final bool canSubmit;

  const _SubmitButtonState({required this.isLoading, required this.canSubmit});

  @override
  bool operator ==(Object other) {
    return other is _SubmitButtonState &&
        other.isLoading == isLoading &&
        other.canSubmit == canSubmit;
  }

  @override
  int get hashCode => Object.hash(isLoading, canSubmit);
}
