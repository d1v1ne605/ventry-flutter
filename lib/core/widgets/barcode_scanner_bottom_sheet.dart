import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_size.dart';
import '../theme/app_colors.dart';

class BarcodeScannerBottomSheet extends StatefulWidget {
  const BarcodeScannerBottomSheet({super.key});

  @override
  State<BarcodeScannerBottomSheet> createState() =>
      _BarcodeScannerBottomSheetState();
}

class _BarcodeScannerBottomSheetState extends State<BarcodeScannerBottomSheet> {
  final MobileScannerController _controller = MobileScannerController();
  bool _isScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.6.sh, // 60% of screen height
      padding: EdgeInsets.symmetric(horizontal: AppSize.size16.w),
      decoration: BoxDecoration(
        color: AppColors.screenBackground,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.size16.r),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: EdgeInsets.only(
                top: AppSize.size12.h,
                bottom: AppSize.size16.h,
              ),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(AppSize.size2.r),
              ),
            ),
          ),
          Text(
            'Scan Barcode',
            style: GoogleFonts.manrope(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.heading,
            ),
          ),
          SizedBox(height: AppSize.size16.h),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.size12.r),
              child: MobileScanner(
                controller: _controller,
                onDetect: (capture) {
                  if (_isScanned) return;
                  final List<Barcode> barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    final rawValue = barcodes.first.rawValue;
                    if (rawValue != null && rawValue.isNotEmpty) {
                      _isScanned = true;
                      Navigator.pop(context, rawValue);
                    }
                  }
                },
              ),
            ),
          ),
          SizedBox(height: AppSize.size24.h),
        ],
      ),
    );
  }
}

Future<String?> showBarcodeScanner(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const BarcodeScannerBottomSheet(),
  );
}
