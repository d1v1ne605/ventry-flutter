import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_4/quick_add_step4_header.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_4/review_attributes_card.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_4/review_basic_details_card.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_4/review_inventory_card.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_4/review_pricing_card.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_4/review_supplier_barcode_card.dart';

/// Form body for Quick Add Step 4 (Review & Confirm).
class QuickAddStep4Body extends StatelessWidget {
  const QuickAddStep4Body({
    super.key,
    required this.name,
    required this.sku,
    required this.category,
    required this.colorText,
    required this.materialText,
    required this.variantsCount,
    required this.statusText,
    required this.sellingPriceText,
    required this.costPriceText,
    required this.marginText,
    required this.initialStockText,
    required this.lowStockAlertText,
    required this.locationText,
    required this.supplierName,
    required this.barcodeController,
    required this.onEditBasicDetails,
    required this.onEditAttributes,
    required this.onEditPricing,
    required this.onEditInventory,
    required this.onEditSupplier,
    this.barcodeFocusNode,
  });

  final String name;
  final String sku;
  final String category;
  final String colorText;
  final String materialText;
  final int variantsCount;
  final String statusText;
  final String sellingPriceText;
  final String costPriceText;
  final String marginText;
  final String initialStockText;
  final String lowStockAlertText;
  final String locationText;
  final String supplierName;
  final TextEditingController barcodeController;

  final VoidCallback onEditBasicDetails;
  final VoidCallback onEditAttributes;
  final VoidCallback onEditPricing;
  final VoidCallback onEditInventory;
  final VoidCallback onEditSupplier;

  final FocusNode? barcodeFocusNode;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Step progress bar header block
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppSize.size16.w,
              AppSize.size16.h,
              AppSize.size16.w,
              AppSize.size16.h,
            ),
            child: const QuickAddStep4Header(),
          ),

          // Cards list
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSize.size16.w),
            child: Column(
              children: [
                // 1. Basic Details
                ReviewBasicDetailsCard(
                  name: name,
                  sku: sku,
                  category: category,
                  onEdit: onEditBasicDetails,
                ),
                SizedBox(height: AppSize.size12.h),

                // 2. Attributes & Variants
                ReviewAttributesCard(
                  colorText: colorText,
                  materialText: materialText,
                  variantsCount: variantsCount,
                  statusText: statusText,
                  onEdit: onEditAttributes,
                ),
                SizedBox(height: AppSize.size12.h),

                // 3. Pricing
                ReviewPricingCard(
                  sellingPriceText: sellingPriceText,
                  costPriceText: costPriceText,
                  marginText: marginText,
                  onEdit: onEditPricing,
                ),
                SizedBox(height: AppSize.size12.h),

                // 4. Inventory
                ReviewInventoryCard(
                  initialStockText: initialStockText,
                  lowStockAlertText: lowStockAlertText,
                  locationText: locationText,
                  onEdit: onEditInventory,
                ),
                SizedBox(height: AppSize.size12.h),

                // 5. Supplier & Barcode (warning card)
                ReviewSupplierBarcodeCard(
                  supplierName: supplierName,
                  barcodeController: barcodeController,
                  onEdit: onEditSupplier,
                  focusNode: barcodeFocusNode,
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
