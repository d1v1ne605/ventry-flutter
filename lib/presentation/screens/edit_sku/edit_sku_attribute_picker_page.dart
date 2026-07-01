import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/theme/app_text_styles.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';
import 'package:ventry_flutter/domain/usecases/attribute/get_local_attributes_usecase.dart';
import 'package:ventry_flutter/domain/usecases/attribute/sync_attributes_usecase.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';
import 'package:ventry_flutter/injection.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_app_bar.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_attribute_selection_tile.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_attributes_bottom_bar.dart';

class EditSkuAttributePickerPage extends StatefulWidget {
  const EditSkuAttributePickerPage({
    super.key,
    required this.existingAttributeNames,
  });

  final List<String> existingAttributeNames;

  @override
  State<EditSkuAttributePickerPage> createState() =>
      _EditSkuAttributePickerPageState();
}

class _EditSkuAttributePickerPageState
    extends State<EditSkuAttributePickerPage> {
  final Set<String> _selectedAttributeUids = <String>{};

  late final Set<String> _existingAttributeNames;

  List<AttributeEntity> _attributes = const [];
  bool _isLoading = true;
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
        .where((attribute) => attribute.name.trim().isNotEmpty)
        .toList(growable: false);
  }

  String _normalizeAttributeName(String value) => value.trim().toLowerCase();

  bool _isAlreadyAdded(AttributeEntity attribute) {
    return _existingAttributeNames.contains(
      _normalizeAttributeName(attribute.name),
    );
  }

  void _toggleSelection(AttributeEntity attribute) {
    if (_isAlreadyAdded(attribute)) {
      return;
    }

    setState(() {
      if (!_selectedAttributeUids.add(attribute.uid)) {
        _selectedAttributeUids.remove(attribute.uid);
      }
    });
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
      backgroundColor: AppColors.editSkuSoftBackground,
      body: Stack(
        children: [
          Column(
            children: [
              EditSkuAppBar(
                title: AppStrings.editSkuSelectAttributesTitle,
                onBackTap: () => Navigator.of(context).maybePop(),
                showSaveAction: false,
              ),
              Expanded(child: _buildContent()),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: EditSkuAttributesBottomBar(
              onCancel: () => Navigator.of(context).maybePop(),
              onApply: _handleAddAttributes,
              primaryLabel: AppStrings.editSkuAddSelectedAttributes,
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
                AppStrings.editSkuAttributesLoadFailed,
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
                  style: AppTextStyles.editSkuButtonLabel.copyWith(
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
            AppStrings.editSkuAttributesEmptyState,
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
        120.h,
      ),
      itemCount: _attributes.length + 1,
      separatorBuilder: (_, __) => SizedBox(height: AppSize.size12.h),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Text(
            AppStrings.editSkuSelectAttributesHelper,
            style: AppTextStyles.editSkuFieldLabel,
          );
        }

        final attribute = _attributes[index - 1];
        final isDisabled = _isAlreadyAdded(attribute);

        return EditSkuAttributeSelectionTile(
          attribute: attribute,
          isSelected: _selectedAttributeUids.contains(attribute.uid),
          isDisabled: isDisabled,
          onTap: () => _toggleSelection(attribute),
        );
      },
    );
  }
}
