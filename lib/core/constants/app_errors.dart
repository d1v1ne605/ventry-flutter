class AppErrors {
  static const String unexpected = 'An unexpected error occurred';
  static const String unknown = 'Unknown error';
  static const String uploadProductImagesFailed =
      'Failed to upload product images';

  static String unsupportedImageFormat(String mimeType) {
    return 'Unsupported image format: $mimeType';
  }

  static String skuAttributeNotFound(String attributeName) {
    return 'Unable to find attribute "$attributeName" while updating the SKU';
  }
}
