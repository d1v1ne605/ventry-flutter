import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/presentation/routes/router_constants.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_4/quick_add_step4_body.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_4/quick_add_step4_bottom_bar.dart';
import 'package:ventry_flutter/core/utils/app_formatters.dart';

/// Quick Add — Step 4: "Review & Confirm".
///
/// Matches the Figma design:
/// - AppBar with back arrow, "Add Product" title, and no right action buttons.
/// - Step 4 progress header (Review & Confirm, 100% progress indicator).
/// - Form body containing details summary cards with edit buttons:
///   - Basic Details
///   - Attributes & Variants
///   - Pricing
///   - Inventory
///   - Supplier & Barcode (with editable barcode text box)
/// - Bottom bar: Back + Next (Confirm) buttons.
///
/// Pure UI — no Bloc yet.
class QuickAddStep4Page extends StatefulWidget {
  const QuickAddStep4Page({super.key});

  @override
  State<QuickAddStep4Page> createState() => _QuickAddStep4PageState();
}

class _QuickAddStep4PageState extends State<QuickAddStep4Page> {
  final TextEditingController _barcodeController = TextEditingController();
  final FocusNode _barcodeFocusNode = FocusNode();

  void _navigateBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouterPath.quickAddStep3);
    }
  }

  void _onConfirmPressed() {
    // End of wizard -> Navigate to Product Catalog
    context.go(RouterPath.productCatalog);
  }

  @override
  void dispose() {
    _barcodeController.dispose();
    _barcodeFocusNode.dispose();
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
        ),
        body: QuickAddStep4Body(
          name: 'Premium Ergonomic Chair',
          sku: 'CHR-ERG-001',
          category: 'Furniture',
          colorText: 'Black, White',
          materialText: 'Mesh, Aluminum',
          variantsCount: 4,
          statusText: 'Ready to Sync',
          sellingPriceText: '${AppFormatters.formatPrice(1000000)} VND',
          costPriceText: '${AppFormatters.formatPrice(800000)} VND',
          marginText: '20%',
          initialStockText: '100 Pieces',
          lowStockAlertText: '10 Pieces',
          locationText: 'Warehouse A, Aisle 4',
          supplierName: 'Acme Corporation Ltd.',
          barcodeController: _barcodeController,
          barcodeFocusNode: _barcodeFocusNode,
          onEditBasicDetails: () => context.go(RouterPath.quickAdd),
          onEditAttributes: () => context.go(RouterPath.quickAddStep3),
          onEditPricing: () => context.go(RouterPath.quickAddStep2),
          onEditInventory: () => context.go(RouterPath.quickAddStep2),
          onEditSupplier: () => context.go(RouterPath.quickAddStep3),
        ),
        bottomNavigationBar: QuickAddStep4BottomBar(
          onBack: () => _navigateBack(context),
          onNext: _onConfirmPressed,
        ),
      ),
    );
  }
}
