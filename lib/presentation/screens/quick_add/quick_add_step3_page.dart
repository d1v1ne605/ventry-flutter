import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_strings.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/product_attribute.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/models/supplier_option.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_3/quick_add_step3_body.dart';
import 'package:ventry_flutter/presentation/screens/quick_add/widgets/step_3/quick_add_step3_bottom_bar.dart';

/// Quick Add — Step 3: "Attributes & Partners".
///
/// Matches the Figma design:
/// - AppBar with back arrow, "Add Product" title, and teal drawer icon on the right.
/// - Step 3 progress bar header (Attributes & Partners, 60% progress indicator).
/// - Form body containing:
///   - Attributes dynamic lists (+ Add Attribute outlined teal button).
///   - Barcode / QR field with manual entering and Scan button.
///   - Supplier dropdown list.
/// - Bottom bar: Back + Next buttons.
///
/// Pure UI — no Bloc yet.
class QuickAddStep3Page extends StatefulWidget {
  const QuickAddStep3Page({super.key});

  @override
  State<QuickAddStep3Page> createState() => _QuickAddStep3PageState();
}

class _QuickAddStep3PageState extends State<QuickAddStep3Page> {
  final List<ProductAttribute> _attributes = [];
  final Map<String, TextEditingController> _keyControllers = {};
  final Map<String, TextEditingController> _valueControllers = {};

  final TextEditingController _barcodeController = TextEditingController();
  final FocusNode _barcodeFocusNode = FocusNode();

  SupplierOption? _selectedSupplier;

  @override
  void initState() {
    super.initState();
    // Initialize with Figma mock attributes
    _addMockAttribute('attr_1', 'Brand', 'Apple');
    _addMockAttribute('attr_2', 'Material', 'Aluminum');
    _addMockAttribute('attr_3', '', ''); // Empty editable row
  }

  void _addMockAttribute(String id, String key, String value) {
    final attr = ProductAttribute(id: id, key: key, value: value);
    _attributes.add(attr);
    _keyControllers[id] = TextEditingController(text: key);
    _valueControllers[id] = TextEditingController(text: value);
  }

  void _onAddAttribute() {
    final newId = 'attr_${DateTime.now().millisecondsSinceEpoch}';
    setState(() {
      final attr = ProductAttribute(id: newId, key: '', value: '');
      _attributes.add(attr);
      _keyControllers[newId] = TextEditingController();
      _valueControllers[newId] = TextEditingController();
    });
  }

  void _onDeleteAttribute(String id) {
    setState(() {
      _attributes.removeWhere((attr) => attr.id == id);
      _keyControllers[id]?.dispose();
      _keyControllers.remove(id);
      _valueControllers[id]?.dispose();
      _valueControllers.remove(id);
    });
  }

  void _onSupplierSelected(SupplierOption supplier) {
    setState(() => _selectedSupplier = supplier);
  }

  void _navigateBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/quick-add-step2');
    }
  }

  void _onNextPressed() {
    // End of Quick Add wizard for now -> Navigate back to Product Catalog
    context.go('/product-catalog');
  }

  @override
  void dispose() {
    for (final ctrl in _keyControllers.values) {
      ctrl.dispose();
    }
    for (final ctrl in _valueControllers.values) {
      ctrl.dispose();
    }
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
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.archive_outlined,
                size: 22.r,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        body: QuickAddStep3Body(
          attributes: _attributes,
          keyControllers: _keyControllers,
          valueControllers: _valueControllers,
          onAddAttribute: _onAddAttribute,
          onDeleteAttribute: _onDeleteAttribute,
          barcodeController: _barcodeController,
          barcodeFocusNode: _barcodeFocusNode,
          onScanTap: () {},
          suppliers: SupplierOption.defaults,
          selectedSupplier: _selectedSupplier,
          onSupplierSelected: _onSupplierSelected,
        ),
        bottomNavigationBar: QuickAddStep3BottomBar(
          onBack: () => _navigateBack(context),
          onNext: _onNextPressed,
        ),
      ),
    );
  }
}
