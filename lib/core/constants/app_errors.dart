class AppErrors {
  static const String unexpected = 'Đã xảy ra lỗi không mong muốn';
  static const String unknown = 'Lỗi không xác định';
  static const String noInternetConnection = 'Không có kết nối internet';
  static const String uploadProductImagesFailed =
      'Tải hình ảnh sản phẩm lên thất bại';
  static const String serverErrorOccurred = 'Đã xảy ra lỗi máy chủ';
  static const String sessionExpired =
      'Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại';
  static const String accessDenied = 'Truy cập bị từ chối';
  static const String resourceNotFound = 'Không tìm thấy tài nguyên';
  static const String serverErrorTryAgainLater =
      'Lỗi máy chủ. Vui lòng thử lại sau';
  static const String connectionTimeout =
      'Kết nối quá thời gian chờ. Vui lòng kiểm tra kết nối mạng';
  static const String responseTimeout =
      'Phản hồi quá thời gian chờ. Vui lòng thử lại';

  static String unsupportedImageFormat(String mimeType) {
    return 'Định dạng hình ảnh không được hỗ trợ: $mimeType';
  }

  static String skuAttributeNotFound(String attributeName) {
    return 'Không tìm thấy thuộc tính "$attributeName" khi cập nhật SKU';
  }

  static String unexpectedWithDetails(Object error) {
    return 'Lỗi không mong muốn: $error';
  }

  static String invalidRequest(String message) {
    return 'Yêu cầu không hợp lệ: $message';
  }

  static String dataConflict(String message) {
    return 'Xung đột dữ liệu: $message';
  }

  static String validationError(String message) {
    return 'Lỗi xác thực dữ liệu: $message';
  }

  static String localAttributeReadFailed(Object error) {
    return 'Đọc thuộc tính từ cơ sở dữ liệu cục bộ thất bại: $error';
  }
}
