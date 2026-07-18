import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class TestScannerPage extends StatefulWidget {
  const TestScannerPage({super.key});

  @override
  State<TestScannerPage> createState() => _TestScannerPageState();
}

class _TestScannerPageState extends State<TestScannerPage> {
  String? barcodeValue;
  final MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Barcode Scanner')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  setState(() {
                    barcodeValue = barcodes.first.rawValue;
                  });
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                barcodeValue != null
                    ? 'Scanned Barcode:\n$barcodeValue'
                    : 'Point camera at a barcode',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
