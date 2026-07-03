class AppErrors {
  static const String unexpected = 'An unexpected error occurred';
  static const String unknown = 'Unknown error';
  static const String noInternetConnection = 'No internet connection';
  static const String uploadProductImagesFailed =
      'Failed to upload product images';
  static const String serverErrorOccurred = 'Server error occurred';
  static const String sessionExpired = 'Session expired. Please log in again';
  static const String accessDenied = 'Access denied';
  static const String resourceNotFound = 'Resource not found';
  static const String serverErrorTryAgainLater =
      'Server error. Please try again later';
  static const String connectionTimeout =
      'Connection timeout. Please check your network connection';
  static const String responseTimeout = 'Response timeout. Please try again';

  static String unsupportedImageFormat(String mimeType) {
    return 'Unsupported image format: $mimeType';
  }

  static String skuAttributeNotFound(String attributeName) {
    return 'Unable to find attribute "$attributeName" while updating the SKU';
  }

  static String unexpectedWithDetails(Object error) {
    return 'Unexpected error: $error';
  }

  static String invalidRequest(String message) {
    return 'Invalid request: $message';
  }

  static String dataConflict(String message) {
    return 'Data conflict: $message';
  }

  static String validationError(String message) {
    return 'Validation error: $message';
  }

  static String localAttributeReadFailed(Object error) {
    return 'Failed to read attributes from local DB: $error';
  }
}
