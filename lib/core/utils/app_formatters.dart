import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppFormatters {
  AppFormatters._();

  static String formatPrice(num price) {
    // Format number with commas, e.g., 6000000 -> 6,000,000
    final format = NumberFormat('#,##0', 'en_US');
    return format.format(price);
  }

  static double parsePrice(String text) {
    if (text.isEmpty) return 0.0;
    return double.tryParse(text.replaceAll(',', '')) ?? 0.0;
  }
}

class CurrencyTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final String cleanText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    final int value = int.parse(cleanText);
    final String newText = AppFormatters.formatPrice(value);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
