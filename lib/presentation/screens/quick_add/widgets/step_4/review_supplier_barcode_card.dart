import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ventry_flutter/core/constants/app_size.dart';
import 'package:ventry_flutter/core/theme/app_colors.dart';

/// Card summarizing Supplier & Barcode details.
/// Features a left orange warning accent bar, a "MISSING" badge, and an editable barcode field.
class ReviewSupplierBarcodeCard extends StatefulWidget {
  const ReviewSupplierBarcodeCard({
    super.key,
    required this.supplierName,
    required this.barcodeController,
    required this.onEdit,
    this.focusNode,
  });

  final String supplierName;
  final TextEditingController barcodeController;
  final VoidCallback onEdit;
  final FocusNode? focusNode;

  @override
  State<ReviewSupplierBarcodeCard> createState() => _ReviewSupplierBarcodeCardState();
}

class _ReviewSupplierBarcodeCardState extends State<ReviewSupplierBarcodeCard> {
  late final FocusNode _focus;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focus = widget.focusNode ?? FocusNode();
    _focus.addListener(_onFocusChange);
  }

  void _onFocusChange() => setState(() => _hasFocus = _focus.hasFocus);

  @override
  void dispose() {
    if (widget.focusNode == null) _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const warningColor = Color(0xFFFFA500); // Orange warning color

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        boxShadow: AppColors.cardShadows,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSize.size12.r),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left warning accent bar
              Container(
                width: 4.w,
                color: warningColor,
              ),

              // Content Area
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppSize.size16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_shipping_outlined,
                                size: 18.r,
                                color: AppColors.subtitle,
                              ),
                              SizedBox(width: AppSize.size8.w),
                              Text(
                                'SUPPLIER & BARCODE',
                                style: GoogleFonts.manrope(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.subtitle,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: widget.onEdit,
                            child: Icon(
                              Icons.edit_outlined,
                              size: 18.r,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.size14.h),

                      // Supplier Label
                      Text(
                        'Supplier',
                        style: GoogleFonts.manrope(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.subtitle,
                        ),
                      ),
                      SizedBox(height: AppSize.size2.h),

                      // Supplier Name
                      Text(
                        widget.supplierName,
                        style: GoogleFonts.manrope(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                        ),
                      ),
                      SizedBox(height: AppSize.size14.h),

                      // Barcode Label + MISSING Badge Row
                      Row(
                        children: [
                          Text(
                            'Barcode (Optional)',
                            style: GoogleFonts.manrope(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: warningColor,
                            ),
                          ),
                          SizedBox(width: AppSize.size8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSize.size8.w,
                              vertical: AppSize.size2.h,
                            ),
                            decoration: BoxDecoration(
                              color: warningColor,
                              borderRadius: BorderRadius.circular(AppSize.size4.r),
                            ),
                            child: Text(
                              'MISSING',
                              style: GoogleFonts.manrope(
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.size4.h),

                      // Inline barcode field with warning styling
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        height: 44.h,
                        decoration: BoxDecoration(
                          color: AppColors.inputFill,
                          borderRadius: BorderRadius.circular(AppSize.size8.r),
                          border: Border.all(
                            color: _hasFocus ? AppColors.primary : warningColor,
                            width: _hasFocus ? 1.5 : 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: widget.barcodeController,
                                focusNode: _focus,
                                style: GoogleFonts.manrope(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.heading,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Scan or enter barcode',
                                  hintStyle: GoogleFonts.manrope(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textHint,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: AppSize.size12.w,
                                    vertical: AppSize.size10.h,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: AppSize.size12.w),
                              child: Icon(
                                Icons.error_outline_rounded,
                                size: 20.r,
                                color: warningColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
