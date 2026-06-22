import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/presentation/routes/router_constants.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/product_category.dart';
import 'package:ventry_flutter/core/widgets/add_product_mode_toggle.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_1/quick_add_category_dropdown.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_1/quick_add_image_upload.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_1/quick_add_input_field.dart';

/// Quick Add — Step 1: "Add Product".
///
/// Matches the Figma frame (node 33-1314):
/// - AppBar with back arrow + "Add Product" title
/// - Simple | Professional tab switcher
/// - Form: Product Name, SKU Code (+ generate), Category dropdown,
///         Short Description (multiline), Product Image upload
/// - Bottom bar: Back + Next buttons
///
/// Pure UI — no Bloc yet.
class QuickAddStep1Page extends StatefulWidget {
  const QuickAddStep1Page({super.key});

  @override
  State<QuickAddStep1Page> createState() => _QuickAddStep1PageState();
}

class _QuickAddStep1PageState extends State<QuickAddStep1Page> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _skuFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();

  AddProductMode _mode = AddProductMode.simple;
  ProductCategory? _selectedCategory;

  /// Auto-generate a placeholder SKU.
  void _generateSku() {
    setState(() {
      _skuController.text =
          'PROD-${DateTime.now().millisecondsSinceEpoch % 100000}';
    });
  }

  void _onModeChanged(AddProductMode mode) => setState(() => _mode = mode);

  void _onCategorySelected(ProductCategory cat) =>
      setState(() => _selectedCategory = cat);

  void _navigateBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouterPath.productCatalog);
    }
  }

  void _onNextPressed() {
    context.go(RouterPath.quickAddStep2);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _descController.dispose();
    _nameFocus.dispose();
    _skuFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: _AddProductAppBar(onBack: () => _navigateBack(context)),
        body: _AddProductBody(
          mode: _mode,
          nameController: _nameController,
          skuController: _skuController,
          descController: _descController,
          nameFocus: _nameFocus,
          skuFocus: _skuFocus,
          descFocus: _descFocus,
          selectedCategory: _selectedCategory,
          onModeChanged: _onModeChanged,
          onCategorySelected: _onCategorySelected,
          onGenerateSku: _generateSku,
          onImageTap: () {},
        ),
        bottomNavigationBar: _BottomActionBar(
          onBack: () => _navigateBack(context),
          onNext: _onNextPressed,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// App Bar
// ─────────────────────────────────────────────────────────────────────────────

class _AddProductAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AddProductAppBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        onPressed: onBack,
        icon: Icon(
          Icons.arrow_back_rounded,
          size: 22.r,
          color: AppColors.heading,
        ),
      ),
      title: Text(
        AppStrings.quickAddTitle,
        style: GoogleFonts.manrope(
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.heading,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Body
// ─────────────────────────────────────────────────────────────────────────────

class _AddProductBody extends StatelessWidget {
  const _AddProductBody({
    required this.mode,
    required this.nameController,
    required this.skuController,
    required this.descController,
    required this.nameFocus,
    required this.skuFocus,
    required this.descFocus,
    required this.selectedCategory,
    required this.onModeChanged,
    required this.onCategorySelected,
    required this.onGenerateSku,
    required this.onImageTap,
  });

  final AddProductMode mode;
  final TextEditingController nameController;
  final TextEditingController skuController;
  final TextEditingController descController;
  final FocusNode nameFocus;
  final FocusNode skuFocus;
  final FocusNode descFocus;
  final ProductCategory? selectedCategory;
  final void Function(AddProductMode) onModeChanged;
  final void Function(ProductCategory) onCategorySelected;
  final VoidCallback onGenerateSku;
  final VoidCallback onImageTap;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mode toggle — full-width with horizontal padding, white bg
          Container(
            color: AppColors.surface,
            padding: EdgeInsets.fromLTRB(
              AppSize.size16.w,
              AppSize.size12.h,
              AppSize.size16.w,
              AppSize.size16.h,
            ),
            child: AddProductModeToggle(
              selectedMode: mode,
              onModeChanged: onModeChanged,
            ),
          ),
          SizedBox(height: AppSize.size8.h),
          // Form card
          Container(
            color: AppColors.surface,
            padding: EdgeInsets.all(AppSize.size16.r),
            child: _BasicInfoForm(
              nameController: nameController,
              skuController: skuController,
              descController: descController,
              nameFocus: nameFocus,
              skuFocus: skuFocus,
              descFocus: descFocus,
              selectedCategory: selectedCategory,
              onCategorySelected: onCategorySelected,
              onGenerateSku: onGenerateSku,
              onImageTap: onImageTap,
            ),
          ),
          SizedBox(height: AppSize.size24.h),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Basic Information Form
// ─────────────────────────────────────────────────────────────────────────────

class _BasicInfoForm extends StatelessWidget {
  const _BasicInfoForm({
    required this.nameController,
    required this.skuController,
    required this.descController,
    required this.nameFocus,
    required this.skuFocus,
    required this.descFocus,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onGenerateSku,
    required this.onImageTap,
  });

  final TextEditingController nameController;
  final TextEditingController skuController;
  final TextEditingController descController;
  final FocusNode nameFocus;
  final FocusNode skuFocus;
  final FocusNode descFocus;
  final ProductCategory? selectedCategory;
  final void Function(ProductCategory) onCategorySelected;
  final VoidCallback onGenerateSku;
  final VoidCallback onImageTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(title: AppStrings.quickAddBasicInfoTitle),
        SizedBox(height: AppSize.size16.h),

        // Product Name
        QuickAddInputField(
          label: AppStrings.quickAddProductNameLabel,
          controller: nameController,
          hintText: AppStrings.quickAddProductNameHint,
          focusNode: nameFocus,
          nextFocusNode: skuFocus,
        ),
        SizedBox(height: AppSize.size14.h),

        // SKU Code
        QuickAddInputField(
          label: AppStrings.quickAddSkuLabel,
          controller: skuController,
          hintText: AppStrings.quickAddSkuHint,
          focusNode: skuFocus,
          nextFocusNode: descFocus,
          suffixWidget: _GenerateSkuButton(onTap: onGenerateSku),
        ),
        SizedBox(height: AppSize.size14.h),

        // Category dropdown
        QuickAddCategoryDropdown(
          label: AppStrings.quickAddCategoryLabel,
          categories: ProductCategory.defaults,
          selectedCategory: selectedCategory,
          onSelected: onCategorySelected,
        ),
        SizedBox(height: AppSize.size14.h),

        // Short Description
        QuickAddInputField(
          label: AppStrings.quickAddDescriptionLabel,
          controller: descController,
          hintText: AppStrings.quickAddDescriptionHint,
          focusNode: descFocus,
          maxLines: 4,
          minLines: 4,
          textInputAction: TextInputAction.newline,
        ),
        SizedBox(height: AppSize.size14.h),

        // Product Image
        QuickAddImageUpload(
          label: AppStrings.quickAddImageLabel,
          onTap: onImageTap,
        ),
      ],
    );
  }
}

/// "Basic Information" section heading.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.heading,
      ),
    );
  }
}

/// Teal circular refresh icon that auto-generates a SKU code.
class _GenerateSkuButton extends StatelessWidget {
  const _GenerateSkuButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: AppSize.size12.w),
        child: Icon(
          Icons.refresh_rounded,
          size: 22.r,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom Action Bar
// ─────────────────────────────────────────────────────────────────────────────

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({required this.onBack, required this.onNext});

  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSize.size16.w,
        AppSize.size12.h,
        AppSize.size16.w,
        AppSize.size12.h + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.divider, width: AppSize.size1),
        ),
      ),
      child: Row(
        children: [
          _BackButton(onTap: onBack),
          SizedBox(width: AppSize.size12.w),
          Expanded(child: _NextButton(onTap: onNext)),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: AppSize.size20.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSize.size8.r),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chevron_left_rounded,
              size: 20.r,
              color: AppColors.subtitle,
            ),
            SizedBox(width: AppSize.size4.w),
            Text(
              AppStrings.quickAddBack,
              style: GoogleFonts.manrope(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.subtitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NextButton extends StatelessWidget {
  const _NextButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppSize.size8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.quickAddNext,
              style: GoogleFonts.manrope(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            SizedBox(width: AppSize.size8.w),
            Icon(Icons.check_circle_rounded, size: 20.r, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
