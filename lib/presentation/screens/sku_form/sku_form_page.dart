import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/base/base_status.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';
import 'package:ventry_flutter/domain/entities/product/sku_entity.dart';
import 'package:ventry_flutter/domain/usecases/attribute/create_attribute_value_usecase.dart';
import 'package:ventry_flutter/domain/usecases/attribute/get_local_attributes_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/create_sku_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/get_latest_generated_sku_code_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/update_sku_images_usecase.dart';
import 'package:ventry_flutter/domain/usecases/product/update_sku_usecase.dart';
import 'package:ventry_flutter/injection.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_bloc.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_event.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_bloc.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_event.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/bloc/sku_form_state.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/sku_form_attributes_page.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/sku_form_images_page.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/models/editable_sku_form_image.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_app_bar.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_bottom_bar.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_category_bottom_sheet.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_form_card.dart';
import 'package:ventry_flutter/presentation/screens/sku_form/widgets/sku_form_media_card.dart';

class SkuFormPage extends StatelessWidget {
  const SkuFormPage({super.key, required this.args});

  final SkuFormPageArgs args;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => SkuFormBloc(
            getIt<AppLogger>(),
            getIt<GetLocalAttributesUseCase>(),
            getIt<CreateAttributeValueUseCase>(),
            getIt<CreateSkuUseCase>(),
            getIt<GetLatestGeneratedSkuCodeUseCase>(),
            getIt<UpdateSkuUseCase>(),
            mode: args.mode,
            initialSku: args.sku,
            updateSkuImagesUseCase: getIt<UpdateSkuImagesUseCase>(),
          ),
        ),
        BlocProvider(
          create: (_) => getIt<CategoryBloc>()..add(LoadCategories()),
        ),
      ],
      child: const _SkuFormView(),
    );
  }
}

class SkuFormPageArgs {
  const SkuFormPageArgs({required this.sku, required this.mode});

  const SkuFormPageArgs.edit(this.sku) : mode = SkuFormMode.edit;

  const SkuFormPageArgs.create(this.sku) : mode = SkuFormMode.create;

  final SkuEntity sku;
  final SkuFormMode mode;
}

class _SkuFormView extends StatefulWidget {
  const _SkuFormView();

  @override
  State<_SkuFormView> createState() => _SkuFormViewState();
}

class _SkuFormViewState extends State<_SkuFormView> {
  late final TextEditingController _skuNameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _skuCodeController;
  late final TextEditingController _costPriceController;
  late final TextEditingController _sellingPriceController;
  late final TextEditingController _currencyController;
  late final TextEditingController _unitController;

  @override
  void initState() {
    super.initState();
    final form = context.read<SkuFormBloc>().state.form;
    _skuNameController = TextEditingController(text: form.skuName);
    _categoryController = TextEditingController(text: form.categoryName);
    _barcodeController = TextEditingController(text: form.barcode);
    _skuCodeController = TextEditingController(text: form.skuCode);
    _costPriceController = TextEditingController(text: form.costPrice);
    _sellingPriceController = TextEditingController(text: form.sellingPrice);
    _currencyController = TextEditingController(text: form.currency);
    _unitController = TextEditingController(text: form.unitOfMeasure);
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
    super.dispose();
  }

  Future<void> _openCategorySheet() async {
    final editState = context.read<SkuFormBloc>().state;
    final selectedCategory = editState.selectedCategoryName.isEmpty
        ? null
        : CategoryEntity(
            uid: editState.selectedCategoryUid ?? editState.sourceSku.uid,
            name: editState.selectedCategoryName,
          );

    final category = await showModalBottomSheet<CategoryEntity>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<CategoryBloc>(),
        child: SkuFormCategoryBottomSheet(selectedCategory: selectedCategory),
      ),
    );

    if (category == null || !mounted) {
      return;
    }

    _categoryController.text = category.name;
    context.read<SkuFormBloc>().add(SkuFormCategoryChanged(category));
  }

  void _handleBarcodeScanned(String barcode) {
    _barcodeController.text = barcode;
    context.read<SkuFormBloc>().add(SkuFormBarcodeChanged(barcode));
  }

  void _saveChanges() {
    context.read<SkuFormBloc>().add(const SkuFormSubmitted());
  }

  Future<void> _openEditAttributesPage() async {
    final state = context.read<SkuFormBloc>().state;
    final result = await Navigator.of(context).push<List<SkuAttributeEntity>>(
      MaterialPageRoute(
        builder: (_) => SkuFormAttributesPage(
          attributes: state.attributes,
          isStructureLocked: state.isCreateMode,
        ),
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    context.read<SkuFormBloc>().add(SkuFormAttributesChanged(result));
  }

  Future<void> _openEditImagesPage() async {
    final state = context.read<SkuFormBloc>().state;
    final result = await Navigator.of(context).push<List<EditableSkuFormImage>>(
      MaterialPageRoute(
        builder: (_) => SkuFormImagesPage(images: state.images),
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    context.read<SkuFormBloc>().add(SkuFormImagesChanged(result));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SkuFormBloc, SkuFormState>(
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
                BlocBuilder<SkuFormBloc, SkuFormState>(
                  buildWhen: (previous, current) =>
                      previous.canSubmit != current.canSubmit ||
                      previous.mode != current.mode ||
                      previous.status != current.status,
                  builder: (context, state) {
                    return SkuFormAppBar(
                      title: state.isCreateMode
                          ? AppStrings.skuFormCreateTitle
                          : AppStrings.skuFormEditTitle,
                      onBackTap: () => Navigator.of(context).maybePop(),
                      onSaveTap: state.canSubmit ? _saveChanges : null,
                    );
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      AppSize.size12.w,
                      AppSize.size20.h,
                      AppSize.size12.w,
                      AppSize.size104.h,
                    ),
                    child: Column(
                      children: [
                        SkuFormFormCard(
                          skuNameController: _skuNameController,
                          categoryController: _categoryController,
                          barcodeController: _barcodeController,
                          skuCodeController: _skuCodeController,
                          costPriceController: _costPriceController,
                          sellingPriceController: _sellingPriceController,
                          currencyController: _currencyController,
                          unitController: _unitController,
                          onSkuNameChanged: (value) => context
                              .read<SkuFormBloc>()
                              .add(SkuFormNameChanged(value)),
                          onCategoryTap: _openCategorySheet,
                          onBarcodeChanged: (value) => context
                              .read<SkuFormBloc>()
                              .add(SkuFormBarcodeChanged(value)),
                          onBarcodeScanned: _handleBarcodeScanned,
                          onSkuCodeChanged: (value) => context
                              .read<SkuFormBloc>()
                              .add(SkuFormCodeChanged(value)),
                          onCostPriceChanged: (value) => context
                              .read<SkuFormBloc>()
                              .add(SkuFormCostPriceChanged(value)),
                          onSellingPriceChanged: (value) => context
                              .read<SkuFormBloc>()
                              .add(SkuFormSellingPriceChanged(value)),
                          onCurrencyChanged: (value) => context
                              .read<SkuFormBloc>()
                              .add(SkuFormCurrencyChanged(value)),
                          onUnitChanged: (value) => context
                              .read<SkuFormBloc>()
                              .add(SkuFormUnitOfMeasureChanged(value)),
                          onSellableChanged: (value) => context
                              .read<SkuFormBloc>()
                              .add(SkuFormSellableChanged(value)),
                        ),
                        SizedBox(height: AppSize.size20.h),
                        BlocBuilder<SkuFormBloc, SkuFormState>(
                          buildWhen: (previous, current) =>
                              previous.attributes != current.attributes ||
                              previous.images != current.images,
                          builder: (context, state) {
                            return SkuFormMediaCard(
                              attributeItems: state.attributes,
                              imageItems: state.images,
                              onEditAttributesTap: _openEditAttributesPage,
                              onEditMediaTap: _openEditImagesPage,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BlocBuilder<SkuFormBloc, SkuFormState>(
                buildWhen: (previous, current) =>
                    previous.canSubmit != current.canSubmit ||
                    previous.mode != current.mode ||
                    previous.status != current.status,
                builder: (context, state) {
                  return SkuFormBottomBar(
                    isEnabled: state.canSubmit,
                    isLoading: state.isSubmitting,
                    label: state.isCreateMode
                        ? AppStrings.skuFormCreateSku
                        : AppStrings.skuFormSaveChanges,
                    onPressed: _saveChanges,
                  );
                },
              ),
            ),
            BlocSelector<SkuFormBloc, SkuFormState, bool>(
              selector: (state) => state.isSubmitting,
              builder: (context, isSubmitting) {
                if (!isSubmitting) {
                  return const SizedBox.shrink();
                }

                return Container(
                  color: AppColors.loadingOverlay,
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
