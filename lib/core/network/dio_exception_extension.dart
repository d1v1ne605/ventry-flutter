import 'package:dio/dio.dart';
import '../errors/failures.dart';

extension DioExceptionX on DioException {
  Failure toFailure() {
    final attachedFailure = error;
    if (attachedFailure is Failure) {
      return attachedFailure;
    }

    final backendMessage = response?.data is Map<String, dynamic>
        ? response?.data['message'] as String?
        : null;

    return ServerFailure(
      backendMessage ?? message ?? const ServerFailure().message,
    );
  }
}
