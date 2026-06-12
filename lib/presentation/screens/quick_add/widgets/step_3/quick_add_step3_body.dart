import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/product_attribute.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/supplier_option.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_3/quick_add_attributes_list.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_3/quick_add_barcode_scanner.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_3/quick_add_step3_header.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_3/quick_add_supplier_dropdown.dart';

/// Form body for Quick Add Step 3 (Attributes & Partners).
class QuickAddStep3Body extends StatelessWidget {
  const QuickAddStep3Body({
    super.key,
    required this.attributes,
    required this.keyControllers,
    required this.valueControllers,
    required this.onAddAttribute,
    required this.onDeleteAttribute,
    required this.barcodeController,
    required this.onScanTap,
    required this.suppliers,
    required this.selectedSupplier,
    required this.onSupplierSelected,
    this.barcodeFocusNode,
  });

  final List<ProductAttribute> attributes;
  final Map<String, TextEditingController> keyControllers;
  final Map<String, TextEditingController> valueControllers;
  final VoidCallback onAddAttribute;
  final void Function(String) onDeleteAttribute;
  final TextEditingController barcodeController;
  final VoidCallback onScanTap;
  final List<SupplierOption> suppliers;
  final SupplierOption? selectedSupplier;
  final void Function(SupplierOption) onSupplierSelected;
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
            child: const QuickAddStep3Header(),
          ),

          // Main Form Card
          Container(
            margin: EdgeInsets.symmetric(horizontal: AppSize.size16.w),
            padding: EdgeInsets.all(AppSize.size16.r),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSize.size12.r),
              boxShadow: AppColors.cardShadows,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Attributes dynamic lists
                QuickAddAttributesList(
                  attributes: attributes,
                  keyControllers: keyControllers,
                  valueControllers: valueControllers,
                  onAddAttribute: onAddAttribute,
                  onDeleteAttribute: onDeleteAttribute,
                ),

                SizedBox(height: AppSize.size20.h),

                // Barcode / QR Section
                QuickAddBarcodeScanner(
                  controller: barcodeController,
                  onScanTap: onScanTap,
                  focusNode: barcodeFocusNode,
                ),

                SizedBox(height: AppSize.size20.h),

                // Supplier Dropdown
                QuickAddSupplierDropdown(
                  label: 'Supplier',
                  suppliers: suppliers,
                  selectedSupplier: selectedSupplier,
                  onSelected: onSupplierSelected,
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
