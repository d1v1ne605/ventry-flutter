import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';
import 'package:ventry_flutter/domain/usecases/attribute/create_attribute_usecase.dart';
import 'package:ventry_flutter/domain/usecases/attribute/get_local_attributes_usecase.dart';
import 'package:ventry_flutter/domain/usecases/attribute/sync_attributes_usecase.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';
import 'package:ventry_flutter/injection.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_app_bar.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_attribute_selection_tile.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_attributes_bottom_bar.dart';

class SkuFormAttributePickerPage extends StatefulWidget {
  const SkuFormAttributePickerPage({
    super.key,
    required this.existingAttributeNames,
  });

  final List<String> existingAttributeNames;

  @override
  State<SkuFormAttributePickerPage> createState() =>
      _SkuFormAttributePickerPageState();
}

class _SkuFormAttributePickerPageState
    extends State<SkuFormAttributePickerPage> {
  final Set<String> _selectedAttributeUids = <String>{};

  late final Set<String> _existingAttributeNames;

  List<AttributeEntity> _attributes = const [];
  bool _isLoading = true;
  bool _isCreatingAttribute = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _existingAttributeNames = widget.existingAttributeNames
        .map(_normalizeAttributeName)
        .toSet();
    _loadAttributes();
  }

  Future<void> _loadAttributes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final localResult = await getIt<GetLocalAttributesUseCase>()(NoParams());
    if (!mounted) {
      return;
    }

    localResult.fold(
      (failure) {
        _attributes = const [];
        _errorMessage = failure.message;
      },
      (attributes) {
        _attributes = _sanitizeAttributes(attributes);
      },
    );

    setState(() {
      _isLoading = false;
    });

    final syncResult = await getIt<SyncAttributesUseCase>()(NoParams());
    if (!mounted || syncResult.isLeft()) {
      return;
    }

    final refreshedResult = await getIt<GetLocalAttributesUseCase>()(
      NoParams(),
    );
    if (!mounted) {
      return;
    }

    refreshedResult.fold((_) {}, (attributes) {
      setState(() {
        _attributes = _sanitizeAttributes(attributes);
        _errorMessage = null;
      });
    });
  }

  List<AttributeEntity> _sanitizeAttributes(List<AttributeEntity> attributes) {
    return attributes
        .where(
          (attribute) =>
              attribute.name.trim().isNotEmpty && !_isAlreadyAdded(attribute),
        )
        .toList(growable: false);
  }

  String _normalizeAttributeName(String value) => value.trim().toLowerCase();

  bool _isAlreadyAdded(AttributeEntity attribute) {
    return _existingAttributeNames.contains(
      _normalizeAttributeName(attribute.name),
    );
  }

  void _toggleSelection(AttributeEntity attribute) {
    setState(() {
      if (!_selectedAttributeUids.add(attribute.uid)) {
        _selectedAttributeUids.remove(attribute.uid);
      }
    });
  }

  Future<void> _handleCreateAttribute() async {
    if (_isCreatingAttribute) {
      return;
    }

    String draftAttributeName = '';
    final createdName = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final trimmedName = draftAttributeName.trim();
            final canCreate = trimmedName.isNotEmpty;

            return Dialog(
              backgroundColor: AppColors.transparent,
              insetPadding: EdgeInsets.symmetric(horizontal: AppSize.size24.w),
              child: Container(
                padding: EdgeInsets.all(AppSize.size20.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSize.size16.r),
                  boxShadow: const [AppColors.cardShadow],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: AppSize.size32.w,
                          height: AppSize.size32.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.10),
                            borderRadius: BorderRadius.circular(
                              AppSize.size8.r,
                            ),
                          ),
                          child: Icon(
                            Icons.add_rounded,
                            size: AppSize.size20.r,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(width: AppSize.size12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.skuFormCreateAttributeTitle,
                                style: AppTextStyles.skuFormSectionTitle
                                    .copyWith(color: AppColors.textHeading),
                              ),
                              SizedBox(height: AppSize.size4.h),
                              Text(
                                AppStrings.skuFormCreateAttributeHelper,
                                style: AppTextStyles.skuFormFieldLabel,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.size20.h),
                    Text(
                      AppStrings.skuFormCreateAttributeNameLabel,
                      style: AppTextStyles.skuFormFieldLabel.copyWith(
                        color: AppColors.textHeading,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: AppSize.size8.h),
                    TextField(
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      cursorColor: AppColors.primary,
                      style: AppTextStyles.input,
                      decoration: InputDecoration(
                        hintText: AppStrings.skuFormCreateAttributeHint,
                        hintStyle: AppTextStyles.inputHint,
                        filled: true,
                        fillColor: AppColors.inputFill,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSize.size16.w,
                          vertical: AppSize.size14.h,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSize.size12.r),
                          borderSide: const BorderSide(
                            color: AppColors.inputBorder,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSize.size12.r),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: AppSize.size2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        setDialogState(() {
                          draftAttributeName = value;
                        });
                      },
                      onSubmitted: (value) {
                        if (!canCreate) {
                          return;
                        }
                        Navigator.of(dialogContext).pop(value.trim());
                      },
                    ),
                    SizedBox(height: AppSize.size20.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              padding: EdgeInsets.symmetric(
                                vertical: AppSize.size12.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppSize.size12.r,
                                ),
                              ),
                            ),
                            child: Text(
                              AppStrings.skuFormCancel,
                              style: AppTextStyles.skuFormButtonLabel.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSize.size12.w),
                        Expanded(
                          child: Opacity(
                            opacity: canCreate ? 1 : 0.5,
                            child: IgnorePointer(
                              ignoring: !canCreate,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(
                                    AppSize.size12.r,
                                  ),
                                  boxShadow: const [AppColors.buttonShadow],
                                ),
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(
                                      dialogContext,
                                    ).pop(trimmedName);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.transparent,
                                    shadowColor: AppColors.transparent,
                                    padding: EdgeInsets.symmetric(
                                      vertical: AppSize.size12.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppSize.size12.r,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    AppStrings.skuFormCreateAttributeConfirm,
                                    style: AppTextStyles.buttonText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    final attributeName = createdName?.trim() ?? '';
    if (!mounted) {
      return;
    }

    if (attributeName.isEmpty) {
      if (createdName != null) {
        AppSnackBar.showError(
          context,
          AppStrings.skuFormCreateAttributeNameRequired,
        );
      }
      return;
    }

    setState(() {
      _isCreatingAttribute = true;
    });

    final result = await getIt<CreateAttributeUseCase>()(
      CreateAttributeParams(name: attributeName),
    );

    if (!mounted) {
      return;
    }

    result.fold(
      (failure) {
        AppSnackBar.showError(context, failure.message);
      },
      (_) {
        AppSnackBar.showSuccess(
          context,
          AppStrings.skuFormAttributeCreatedSuccess,
        );
      },
    );

    setState(() {
      _isCreatingAttribute = false;
    });

    if (result.isRight()) {
      await _loadAttributes();
    }
  }

  void _handleAddAttributes() {
    if (_selectedAttributeUids.isEmpty) {
      return;
    }

    final selectedAttributes = _attributes
        .where((attribute) => _selectedAttributeUids.contains(attribute.uid))
        .toList(growable: false);

    Navigator.of(context).pop(selectedAttributes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.skuFormSoftBackground,
      body: Stack(
        children: [
          Column(
            children: [
              SkuFormAppBar(
                title: AppStrings.skuFormSelectAttributesTitle,
                onBackTap: () => Navigator.of(context).maybePop(),
                showSaveAction: false,
                trailingWidget: TextButton.icon(
                  onPressed: _isCreatingAttribute
                      ? null
                      : _handleCreateAttribute,
                  icon: Icon(
                    Icons.add,
                    size: AppSize.size16.r,
                    color: AppColors.onPrimary,
                  ),
                  label: Text(
                    AppStrings.skuFormCreateAttributeHeaderAction,
                    style: AppTextStyles.skuFormFieldLabel.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.onPrimary,
                    padding: EdgeInsets.symmetric(horizontal: AppSize.size8.w),
                  ),
                ),
              ),
              Expanded(child: _buildContent()),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SkuFormAttributesBottomBar(
              onCancel: () => Navigator.of(context).maybePop(),
              onApply: _handleAddAttributes,
              primaryLabel: AppStrings.skuFormAddSelectedAttributes,
              isPrimaryEnabled: _selectedAttributeUids.isNotEmpty,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading && _attributes.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (_errorMessage != null && _attributes.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.size24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.skuFormAttributesLoadFailed,
                textAlign: TextAlign.center,
                style: AppTextStyles.body,
              ),
              SizedBox(height: AppSize.size12.h),
              OutlinedButton(
                onPressed: _loadAttributes,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSize.size24.w,
                    vertical: AppSize.size10.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.size8.r),
                  ),
                ),
                child: Text(
                  AppStrings.retry,
                  style: AppTextStyles.skuFormButtonLabel.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_attributes.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.size24.w),
          child: Text(
            _existingAttributeNames.isEmpty
                ? AppStrings.skuFormAttributesEmptyState
                : AppStrings.skuFormAttributesAllAdded,
            textAlign: TextAlign.center,
            style: AppTextStyles.body,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        AppSize.size16.w,
        AppSize.size24.h,
        AppSize.size16.w,
        AppSize.size120.h,
      ),
      itemCount: _attributes.length + 1,
      separatorBuilder: (_, __) => SizedBox(height: AppSize.size12.h),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Text(
            AppStrings.skuFormSelectAttributesHelper,
            style: AppTextStyles.skuFormFieldLabel,
          );
        }

        final attribute = _attributes[index - 1];

        return SkuFormAttributeSelectionTile(
          attribute: attribute,
          isSelected: _selectedAttributeUids.contains(attribute.uid),
          isDisabled: false,
          onTap: () => _toggleSelection(attribute),
        );
      },
    );
  }
}
