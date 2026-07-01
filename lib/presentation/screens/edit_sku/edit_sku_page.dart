import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/usecases/attribute/create_attribute_value_usecase.dart';
import 'package:ventry_flutter/domain/usecases/attribute/get_local_attributes_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/update_sku_usecase.dart';
import 'package:ventry_flutter/injection.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_bloc.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_event.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/bloc/edit_sku_bloc.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/bloc/edit_sku_event.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/bloc/edit_sku_state.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/edit_sku_attributes_page.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/edit_sku_images_page.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_app_bar.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_bottom_bar.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_category_bottom_sheet.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_description_card.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_form_card.dart';
import 'package:ventry_flutter/presentation/screens/edit_sku/widgets/edit_sku_media_card.dart';

class EditSkuPage extends StatelessWidget {
  const EditSkuPage({super.key, required this.sku});

  final SkuEntity sku;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => EditSkuBloc(
            getIt<AppLogger>(),
            getIt<GetLocalAttributesUseCase>(),
            getIt<CreateAttributeValueUseCase>(),
            getIt<UpdateSkuUseCase>(),
            initialSku: sku,
          ),
        ),
        BlocProvider(
          create: (_) => getIt<CategoryBloc>()..add(LoadCategories()),
        ),
      ],
      child: _EditSkuView(sku: sku),
    );
  }
}

class _EditSkuView extends StatefulWidget {
  const _EditSkuView({required this.sku});

  final SkuEntity sku;

  @override
  State<_EditSkuView> createState() => _EditSkuViewState();
}

class _EditSkuViewState extends State<_EditSkuView> {
  late final TextEditingController _skuNameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _skuCodeController;
  late final TextEditingController _costPriceController;
  late final TextEditingController _sellingPriceController;
  late final TextEditingController _currencyController;
  late final TextEditingController _unitController;
  late final TextEditingController _descriptionController;
  late SkuEntity _currentSku;
  late List<SkuAttributeEntity> _attributeItems;
  late List<String> _imageUrls;

  bool _isDescriptionExpanded = true;

  @override
  void initState() {
    super.initState();
    final form = context.read<EditSkuBloc>().state.form;
    _skuNameController = TextEditingController(text: form.skuName);
    _categoryController = TextEditingController(text: form.categoryName);
    _barcodeController = TextEditingController(text: form.barcode);
    _skuCodeController = TextEditingController(text: form.skuCode);
    _costPriceController = TextEditingController(text: form.costPrice);
    _sellingPriceController = TextEditingController(text: form.sellingPrice);
    _currencyController = TextEditingController(text: form.currency);
    _unitController = TextEditingController(text: form.unitOfMeasure);
    _descriptionController = TextEditingController(text: form.description);
    _currentSku = widget.sku;
    _attributeItems = List<SkuAttributeEntity>.from(_currentSku.attributes);
    _imageUrls = List<String>.from(_currentSku.imageUrls);
  }

  @override
  void dispose() {
    _skuNameController.dispose();
    _categoryController.dispose();
    _barcodeController.dispose();
    _skuCodeController.dispose();
    _costPriceController.dispose();
    _sellingPriceController.dispose();
    _currencyController.dispose();
    _unitController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _openCategorySheet() async {
    final editState = context.read<EditSkuBloc>().state;
    final selectedCategory = editState.selectedCategoryName.isEmpty
        ? null
        : CategoryEntity(
            uid: editState.selectedCategoryUid ?? _currentSku.uid,
            name: editState.selectedCategoryName,
          );

    final category = await showModalBottomSheet<CategoryEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<CategoryBloc>(),
        child: EditSkuCategoryBottomSheet(selectedCategory: selectedCategory),
      ),
    );

    if (category == null || !mounted) {
      return;
    }

    _categoryController.text = category.name;
    context.read<EditSkuBloc>().add(EditSkuCategoryChanged(category));
  }

  void _handleBarcodeScanned(String barcode) {
    _barcodeController.text = barcode;
    context.read<EditSkuBloc>().add(EditSkuBarcodeChanged(barcode));
  }

  bool get _hasAttributeChanges =>
      !listEquals(_currentSku.attributes, _attributeItems);

  void _saveChanges() {
    context.read<EditSkuBloc>().add(
      EditSkuSubmitted(
        attributes: List<SkuAttributeEntity>.from(_attributeItems),
        baseSku: _currentSku,
      ),
    );
  }

  Future<void> _openEditAttributesPage() async {
    final result = await Navigator.of(context).push<List<SkuAttributeEntity>>(
      MaterialPageRoute(
        builder: (_) => EditSkuAttributesPage(attributes: _attributeItems),
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _attributeItems = result;
    });
  }

  Future<void> _openEditImagesPage() async {
    final result = await Navigator.of(context).push<SkuEntity>(
      MaterialPageRoute(builder: (_) => EditSkuImagesPage(sku: _currentSku)),
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _currentSku = result;
      _imageUrls = List<String>.from(result.imageUrls);
    });
    context.read<EditSkuBloc>().add(EditSkuSourceSynced(result));
    AppSnackBar.showSuccess(context, AppStrings.editSkuGalleryUpdatedSuccess);
  }

  @override
  Widget build(BuildContext context) {
    final attributes = _attributeItems;
    final tags = attributes
        .map((attribute) => attribute.value.trim())
        .where((value) => value.isNotEmpty)
        .take(3)
        .toList(growable: false);

    return BlocListener<EditSkuBloc, EditSkuState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == BaseStatus.failure && state.errorMessage != null) {
          AppSnackBar.showError(context, state.errorMessage!);
          return;
        }

        if (state.status == BaseStatus.success && state.updatedSku != null) {
          Navigator.of(context).pop(state.updatedSku);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            Column(
              children: [
                BlocBuilder<EditSkuBloc, EditSkuState>(
                  buildWhen: (previous, current) =>
                      previous.hasSavableChanges != current.hasSavableChanges ||
                      previous.status != current.status,
                  builder: (context, state) {
                    final hasChanges =
                        state.hasSavableChanges || _hasAttributeChanges;
                    return EditSkuAppBar(
                      title: AppStrings.editSkuTitle,
                      onBackTap: () => Navigator.of(context).maybePop(),
                      onSaveTap: hasChanges && !state.isSubmitting
                          ? _saveChanges
                          : null,
                    );
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(12.w, 20.h, 12.w, 104.h),
                    child: Column(
                      children: [
                        EditSkuFormCard(
                          skuNameController: _skuNameController,
                          categoryController: _categoryController,
                          barcodeController: _barcodeController,
                          skuCodeController: _skuCodeController,
                          costPriceController: _costPriceController,
                          sellingPriceController: _sellingPriceController,
                          currencyController: _currencyController,
                          unitController: _unitController,
                          onSkuNameChanged: (value) => context
                              .read<EditSkuBloc>()
                              .add(EditSkuNameChanged(value)),
                          onCategoryTap: _openCategorySheet,
                          onBarcodeChanged: (value) => context
                              .read<EditSkuBloc>()
                              .add(EditSkuBarcodeChanged(value)),
                          onBarcodeScanned: _handleBarcodeScanned,
                          onSkuCodeChanged: (value) => context
                              .read<EditSkuBloc>()
                              .add(EditSkuCodeChanged(value)),
                          onCostPriceChanged: (value) => context
                              .read<EditSkuBloc>()
                              .add(EditSkuCostPriceChanged(value)),
                          onSellingPriceChanged: (value) => context
                              .read<EditSkuBloc>()
                              .add(EditSkuSellingPriceChanged(value)),
                          onCurrencyChanged: (value) => context
                              .read<EditSkuBloc>()
                              .add(EditSkuCurrencyChanged(value)),
                          onUnitChanged: (value) => context
                              .read<EditSkuBloc>()
                              .add(EditSkuUnitOfMeasureChanged(value)),
                          onSellableChanged: (value) => context
                              .read<EditSkuBloc>()
                              .add(EditSkuSellableChanged(value)),
                        ),
                        SizedBox(height: 20.h),
                        EditSkuMediaCard(
                          attributeItems: attributes,
                          imageUrls: _imageUrls,
                          onEditAttributesTap: _openEditAttributesPage,
                          onEditMediaTap: _openEditImagesPage,
                        ),
                        SizedBox(height: 20.h),
                        // EditSkuDescriptionCard(
                        //   controller: _descriptionController,
                        //   tags: tags,
                        //   isExpanded: _isDescriptionExpanded,
                        //   onDescriptionChanged: (value) => context
                        //       .read<EditSkuBloc>()
                        //       .add(EditSkuDescriptionChanged(value)),
                        //   onToggleExpanded: () {
                        //     setState(() {
                        //       _isDescriptionExpanded = !_isDescriptionExpanded;
                        //     });
                        //   },
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BlocBuilder<EditSkuBloc, EditSkuState>(
                buildWhen: (previous, current) =>
                    previous.hasSavableChanges != current.hasSavableChanges ||
                    previous.status != current.status,
                builder: (context, state) {
                  final hasChanges =
                      state.hasSavableChanges || _hasAttributeChanges;
                  return EditSkuBottomBar(
                    isEnabled: hasChanges,
                    isLoading: state.isSubmitting,
                    onPressed: _saveChanges,
                  );
                },
              ),
            ),
            BlocSelector<EditSkuBloc, EditSkuState, bool>(
              selector: (state) => state.isSubmitting,
              builder: (context, isSubmitting) {
                if (!isSubmitting) {
                  return const SizedBox.shrink();
                }

                return Container(
                  color: Colors.black38,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
