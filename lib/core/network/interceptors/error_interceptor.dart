import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/errors/failures.dart';

/// Interceptor to handle DioExceptions and map them to Failure objects
/// for consistent error handling across the application.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logError(err);

    // Categorize and handle different error types
    if (err.response != null) {
      // Server error (HTTP error response)
      _handleServerError(err, handler);
    } else if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      // Connection timeout error
      _handleTimeoutError(err, handler);
    } else if (err.type == DioExceptionType.unknown) {
      // Network connectivity error
      _handleNetworkError(err, handler);
    } else {
      // Other errors
      handler.next(err);
    }
  }

  /// Handle HTTP server errors based on status code
  void _handleServerError(DioException err, ErrorInterceptorHandler handler) {
    final statusCode = err.response?.statusCode;
    final errorMessage =
        err.response?.data?['message'] ?? 'Server error occurred';

    switch (statusCode) {
      case 400:
        // Bad request
        _attachFailure(err, ServerFailure('Invalid request: $errorMessage'));
        break;
      case 401:
        // Unauthorized - session expired
        _attachFailure(
          err,
          ServerFailure('Session expired. Please login again'),
        );
        break;
      case 403:
        // Forbidden - no access permission
        _attachFailure(err, ServerFailure('Access denied'));
        break;
      case 404:
        // Not found
        _attachFailure(err, ServerFailure('Resource not found'));
        break;
      case 409:
        // Conflict
        _attachFailure(err, ServerFailure('Data conflict: $errorMessage'));
        break;
      case 422:
        // Unprocessable entity (validation error)
        _attachFailure(err, ServerFailure('Validation error: $errorMessage'));
        break;
      case 500:
      case 502:
      case 503:
      case 504:
        // Server error
        _attachFailure(
          err,
          ServerFailure('Server error. Please try again later'),
        );
        break;
      default:
        _attachFailure(err, ServerFailure(errorMessage));
    }

    handler.next(err);
  }

  /// Handle timeout errors
  void _handleTimeoutError(DioException err, ErrorInterceptorHandler handler) {
    final message = err.type == DioExceptionType.connectionTimeout
        ? 'Connection timeout. Please check your network connection'
        : 'Response timeout. Please try again';

    _attachFailure(err, NetworkFailure(message));
    handler.next(err);
  }

  /// Handle network connectivity errors
  void _handleNetworkError(DioException err, ErrorInterceptorHandler handler) {
    _attachFailure(err, NetworkFailure('No internet connection'));
    handler.next(err);
  }

  /// Attach Failure object to DioException for easy retrieval in repository layer
  void _attachFailure(DioException err, Failure failure) {
    err = err.copyWith(error: failure);
  }

  /// Log error details (only in debug mode)
  void _logError(DioException err) {
    if (kDebugMode) {
      print('❌ DIO ERROR:');
      print('  Status Code: ${err.response?.statusCode}');
      print('  Type: ${err.type}');
      print('  Message: ${err.message}');
      print('  URL: ${err.requestOptions.path}');
      if (err.response?.data != null) {
        print('  Response: ${err.response?.data}');
      }
    }
  }
}
