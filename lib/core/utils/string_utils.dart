class StringUtils {
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return '${text[0].toUpperCase()}${text.substring(1)}';
  }

  static bool isSafeNetworkUrl(String? value) {
    if (value == null) {
      return false;
    }

    final normalized = value.trim();
    if (normalized.isEmpty) {
      return false;
    }

    final uri = Uri.tryParse(normalized);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      return false;
    }

    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') {
      return false;
    }

    final host = uri.host.toLowerCase();
    if (host == 'example.com' || host.endsWith('.example.com')) {
      return false;
    }

    return true;
  }
}
