import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/core/widgets/app_top_bar.dart';
import 'package:ventry_flutter/core/widgets/app_snack_bar.dart';
import 'package:ventry_flutter/core/widgets/custom_text_field.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';
import 'package:ventry_flutter/injection.dart';
import 'package:ventry_flutter/presentation/routes/router_constants.dart';
import 'package:ventry_flutter/presentation/screens/add_product/widgets/add_product_bottom_bar.dart';
import 'package:ventry_flutter/presentation/screens/add_product/widgets/add_product_dropdown.dart';
import 'package:ventry_flutter/presentation/screens/add_product/widgets/add_product_image_picker.dart';
import 'package:ventry_flutter/presentation/screens/add_product/add_product_step2_page.dart'
    as ventry_step2;
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_bloc.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_event.dart';
import 'package:ventry_flutter/presentation/screens/category_management/bloc/category_state.dart';
import 'package:ventry_flutter/presentation/screens/category_management/widgets/add_category_bottom_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_bloc.dart';
import 'package:ventry_flutter/presentation/screens/add_product/bloc/attribute_event.dart';

class AddProductStep1Page extends StatelessWidget {
  const AddProductStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<CategoryBloc>()..add(LoadCategories()),
        ),
        BlocProvider(
          create: (context) =>
              getIt<AttributeBloc>()..add(LoadAttributesEvent()),
        ),
      ],
      child: const _AddProductStep1View(),
    );
  }
}

class _AddProductStep1View extends StatefulWidget {
  const _AddProductStep1View();

  @override
  State<_AddProductStep1View> createState() => _AddProductStep1ViewState();
}

class _AddProductStep1ViewState extends State<_AddProductStep1View> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();

  CategoryEntity? _selectedCategory;
  final TextEditingController _currencyController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();

  final FocusNode _currencyFocus = FocusNode();
  final FocusNode _unitFocus = FocusNode();
  List<String> _imagePaths = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _imagePaths.add(image.path);
      });
    }
  }

  Future<void> _pickMultipleImages() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _imagePaths.addAll(images.map((e) => e.path));
      });
    }
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.size16.r),
        ),
      ),
      backgroundColor: AppColors.surface,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.size16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.uploadImage,
                  style: GoogleFonts.manrope(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                  ),
                ),
                SizedBox(height: AppSize.size16.h),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.subtitle,
                  ),
                  title: Text(
                    AppStrings.takeAPhoto,
                    style: GoogleFonts.manrope(color: AppColors.heading),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.subtitle,
                  ),
                  title: Text(
                    AppStrings.chooseFromGallery,
                    style: GoogleFonts.manrope(color: AppColors.heading),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickMultipleImages();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateBack() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(RouterName.productCatalog);
    }
  }

  void _onNextPressed() {
    if (_nameController.text.trim().isEmpty) {
      AppSnackBar.showError(context, 'Product Name is required');
      _nameFocus.requestFocus();
      return;
    }

    final attributeBloc = context.read<AttributeBloc>();
    final partialParams = CreateProductParams(
      name: _nameController.text.trim(),
      description: _descController.text.trim().isEmpty
          ? null
          : _descController.text.trim(),
      categoryUid: _selectedCategory?.uid,
      currency: _currencyController.text.trim().isEmpty
          ? null
          : _currencyController.text.trim(),
      unitOfMeasure: _unitController.text.trim().isEmpty
          ? null
          : _unitController.text.trim(),
      imageUrl: _imagePaths.isNotEmpty ? _imagePaths.first : null,
      skus: const [],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: attributeBloc,
          child: ventry_step2.AddProductStep2Page(params: partialParams),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _nameFocus.dispose();
    _descFocus.dispose();
    _currencyController.dispose();
    _unitController.dispose();
    _currencyFocus.dispose();
    _unitFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: BlocListener<CategoryBloc, CategoryState>(
        listenWhen: (previous, current) {
          return previous.actionStatus != current.actionStatus &&
              current.actionStatus == CategoryActionStatus.success &&
              current.categories.length > previous.categories.length;
        },
        listener: (context, state) {
          if (state.categories.isNotEmpty) {
            setState(() {
              _selectedCategory = state.categories.first;
            });
            AppSnackBar.showSuccess(
              context,
              AppStrings.selectedNewCategory(state.categories.first.name),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.screenBackground,
          appBar: AppTopBar(
            title: AppStrings.addProductTitle,
            leadingWidget: GestureDetector(
              onTap: _navigateBack,
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.all(AppSize.size8.r),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20.r,
                  color: AppColors.heading,
                ),
              ),
            ),
            trailingWidget: GestureDetector(
              onTap: _navigateBack,
              child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.all(AppSize.size8.r),
                child: Icon(
                  Icons.close_rounded,
                  size: 24.r,
                  color: AppColors.heading,
                ),
              ),
            ),
          ),
          body: _AddProductBody(
            nameController: _nameController,
            descController: _descController,
            nameFocus: _nameFocus,
            descFocus: _descFocus,
            selectedCategory: _selectedCategory,
            currencyController: _currencyController,
            unitController: _unitController,
            currencyFocus: _currencyFocus,
            unitFocus: _unitFocus,
            imagePaths: _imagePaths,
            onCategorySelected: (val) =>
                setState(() => _selectedCategory = val),
            onImageTap: _showImagePickerBottomSheet,
            onRemoveImage: (index) =>
                setState(() => _imagePaths.removeAt(index)),
          ),
          bottomNavigationBar: AddProductBottomBar(
            onCancel: _navigateBack,
            onNext: _onNextPressed,
          ),
        ),
      ),
    );
  }
}

class _AddProductBody extends StatelessWidget {
  const _AddProductBody({
    required this.nameController,
    required this.descController,
    required this.nameFocus,
    required this.descFocus,
    required this.currencyController,
    required this.unitController,
    required this.currencyFocus,
    required this.unitFocus,
    required this.selectedCategory,
    required this.imagePaths,
    required this.onCategorySelected,
    required this.onImageTap,
    required this.onRemoveImage,
  });

  final TextEditingController nameController;
  final TextEditingController descController;
  final FocusNode nameFocus;
  final FocusNode descFocus;
  final TextEditingController currencyController;
  final TextEditingController unitController;
  final FocusNode currencyFocus;
  final FocusNode unitFocus;
  final CategoryEntity? selectedCategory;
  final List<String> imagePaths;
  final void Function(CategoryEntity) onCategorySelected;
  final VoidCallback onImageTap;
  final void Function(int) onRemoveImage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress Bar Area
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSize.size16.w,
              AppSize.size16.h,
              AppSize.size16.w,
              AppSize.size8.h,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.size4.r),
                    child: LinearProgressIndicator(
                      value: 0.33,
                      backgroundColor: AppColors.divider,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                      minHeight: 8.h,
                    ),
                  ),
                ),
                SizedBox(width: AppSize.size12.w),
                Text(
                  AppStrings.addProductProgress1,
                  style: GoogleFonts.manrope(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.subtitle,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSize.size8.h),

          // Form Card
          Container(
            padding: EdgeInsets.all(AppSize.size16.r),
            margin: EdgeInsets.symmetric(horizontal: AppSize.size16.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSize.size12.r),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x080F1722),
                  offset: Offset(0, 4),
                  blurRadius: 12,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  label: AppStrings.addProductNameLabel,
                  hintText: AppStrings.addProductNameHint,
                  controller: nameController,
                  focusNode: nameFocus,
                  isRequired: true,
                ),
                SizedBox(height: AppSize.size16.h),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    return AddProductDropdown<CategoryEntity>(
                      label: AppStrings.addProductCategoryLabel,
                      items: state.categories,
                      selectedValue: selectedCategory,
                      onSelected: onCategorySelected,
                      itemAsString: (cat) => cat.name,
                      bottomAction: GestureDetector(
                        onTap: () {
                          // Close dropdown sheet
                          Navigator.of(context).pop();
                          // Open bottom sheet to create new category
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (bottomSheetContext) {
                              return BlocProvider.value(
                                value: context.read<CategoryBloc>(),
                                child: const AddCategoryBottomSheet(),
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: AppSize.size12.h,
                            horizontal: AppSize.size16.w,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: AppColors.divider),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                color: AppColors.primary,
                                size: 20.r,
                              ),
                              SizedBox(width: AppSize.size8.w),
                              Text(
                                AppStrings.createNewCategory,
                                style: GoogleFonts.manrope(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: AppSize.size16.h),
                CustomTextField(
                  label: AppStrings.addProductCurrencyLabel,
                  hintText: AppStrings.currencyHint,
                  controller: currencyController,
                  focusNode: currencyFocus,
                ),
                SizedBox(height: AppSize.size16.h),
                CustomTextField(
                  label: AppStrings.addProductUnitLabel,
                  hintText: AppStrings.unitHint,
                  controller: unitController,
                  focusNode: unitFocus,
                ),
                SizedBox(height: AppSize.size16.h),
                CustomTextField(
                  label: AppStrings.addProductDescriptionLabel,
                  hintText: AppStrings.addProductDescriptionHint,
                  controller: descController,
                  focusNode: descFocus,
                  minLines: 4,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                ),
                SizedBox(height: AppSize.size16.h),
                AddProductImagePicker(
                  label: AppStrings.addProductImageLabel,
                  imagePaths: imagePaths,
                  onTap: onImageTap,
                  onRemoveImage: onRemoveImage,
                ),
              ],
            ),
          ),
          SizedBox(height: AppSize.size24.h),
        ],
      ),
    );
  }
}
