import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/currency_option.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/storage_unit.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_2/quick_add_step2_body.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_2/quick_add_step2_bottom_bar.dart';

/// Quick Add — Step 2: "Price & Inventory".
///
/// Matches the Figma design:
/// - AppBar with back arrow, "Add Product" title, and "Step 2 of 5" badge.
/// - Form body containing:
///   - Currency dropdown
///   - Selling Price (Required) with quick suggestion chips.
///   - Cost Price (Optional) with helper text.
///   - Stock Quantity (Required)
///   - Unit of Measure dropdown
/// - Bottom info banner alert.
/// - Bottom bar: Back + Next buttons.
///
/// Pure UI — no Bloc yet.
class QuickAddStep2Page extends StatefulWidget {
  const QuickAddStep2Page({super.key});

  @override
  State<QuickAddStep2Page> createState() => _QuickAddStep2PageState();
}

class _QuickAddStep2PageState extends State<QuickAddStep2Page> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  final FocusNode _priceFocus = FocusNode();
  final FocusNode _costFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();

  CurrencyOption? _selectedCurrency = CurrencyOption.defaults.first;
  StorageUnit? _selectedUnit = StorageUnit.defaults.first;

  void _onCurrencySelected(CurrencyOption curr) =>
      setState(() => _selectedCurrency = curr);

  void _onUnitSelected(StorageUnit unit) =>
      setState(() => _selectedUnit = unit);

  void _navigateBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/quick-add');
    }
  }

  void _onNextPressed() {
    // Navigate to Product Catalog for demo flow
    context.go('/product-catalog');
  }

  @override
  void dispose() {
    _priceController.dispose();
    _costController.dispose();
    _quantityController.dispose();
    _priceFocus.dispose();
    _costFocus.dispose();
    _quantityFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            onPressed: () => _navigateBack(context),
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
          actions: [
            Center(
              child: Container(
                margin: EdgeInsets.only(right: AppSize.size16.w),
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.size10.w,
                  vertical: AppSize.size4.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  AppStrings.quickAddStep2Progress,
                  style: GoogleFonts.manrope(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.subtitle,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: QuickAddStep2Body(
          priceController: _priceController,
          costController: _costController,
          quantityController: _quantityController,
          priceFocus: _priceFocus,
          costFocus: _costFocus,
          quantityFocus: _quantityFocus,
          selectedCurrency: _selectedCurrency,
          onCurrencySelected: _onCurrencySelected,
          selectedUnit: _selectedUnit,
          onUnitSelected: _onUnitSelected,
        ),
        bottomNavigationBar: QuickAddStep2BottomBar(
          onBack: () => _navigateBack(context),
          onNext: _onNextPressed,
        ),
      ),
    );
  }
}
