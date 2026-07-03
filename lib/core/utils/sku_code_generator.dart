abstract final class SkuCodeGenerator {
  SkuCodeGenerator._();

  static const String _defaultPrefix = 'SP';
  static const int _defaultNumberPadding = 6;
  static final RegExp _codePattern = RegExp(r'^([A-Za-z]+)(\d+)$');

  static String nextFromLatest(String? latestCode) {
    final trimmedCode = latestCode?.trim() ?? '';
    final match = _codePattern.firstMatch(trimmedCode);

    if (match == null) {
      return _format(_defaultPrefix, 1, _defaultNumberPadding);
    }

    final prefix = match.group(1) ?? _defaultPrefix;
    final digits = match.group(2) ?? '';
    final latestNumber = int.tryParse(digits) ?? 0;
    final width = digits.isEmpty ? _defaultNumberPadding : digits.length;

    return _format(prefix, latestNumber + 1, width);
  }

  static String _format(String prefix, int number, int width) {
    return '$prefix${number.toString().padLeft(width, '0')}';
  }
}
