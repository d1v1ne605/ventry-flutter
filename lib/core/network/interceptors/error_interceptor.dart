import 'package:dio/dio.dart';
import '../../../core/errors/failures.dart';
import '../../../core/logging/app_logger.dart';

/// Interceptor to handle DioExceptions and map them to Failure objects
/// for consistent error handling across the application.
class ErrorInterceptor extends Interceptor {
  ErrorInterceptor(this._logger);

  final AppLogger _logger;

  static const String _serverErrorMessage = 'Server error occurred';

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
    final errorMessage = _readResponseMessage(err);

    switch (statusCode) {
      case 400:
        // Bad request
        handler.next(
          _attachFailure(err, ServerFailure('Invalid request: $errorMessage')),
        );
        break;
      case 401:
        // Unauthorized - session expired or invalid credentials
        handler.next(
          _attachFailure(
            err,
            ServerFailure(errorMessage != _serverErrorMessage 
                ? errorMessage 
                : 'Session expired. Please login again'),
          ),
        );
        break;
      case 403:
        // Forbidden - no access permission
        handler.next(_attachFailure(err, const ServerFailure('Access denied')));
        break;
      case 404:
        // Not found
        handler.next(
          _attachFailure(err, const ServerFailure('Resource not found')),
        );
        break;
      case 409:
        // Conflict
        handler.next(
          _attachFailure(err, ServerFailure('Data conflict: $errorMessage')),
        );
        break;
      case 422:
        // Unprocessable entity (validation error)
        handler.next(
          _attachFailure(err, ServerFailure('Validation error: $errorMessage')),
        );
        break;
      case 500:
      case 502:
      case 503:
      case 504:
        // Server error
        handler.next(
          _attachFailure(
            err,
            const ServerFailure('Server error. Please try again later'),
          ),
        );
        break;
      default:
        handler.next(_attachFailure(err, ServerFailure(errorMessage)));
    }
  }

  /// Handle timeout errors
  void _handleTimeoutError(DioException err, ErrorInterceptorHandler handler) {
    final message = err.type == DioExceptionType.connectionTimeout
        ? 'Connection timeout. Please check your network connection'
        : 'Response timeout. Please try again';

    handler.next(_attachFailure(err, NetworkFailure(message)));
  }

  /// Handle network connectivity errors
  void _handleNetworkError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(_attachFailure(err, const NetworkFailure()));
  }

  /// Attach Failure object to DioException for easy retrieval in repository layer
  DioException _attachFailure(DioException err, Failure failure) {
    return err.copyWith(error: failure);
  }

  String _readResponseMessage(DioException err) {
    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    return _serverErrorMessage;
  }

  /// Log error details via AppLogger.
  void _logError(DioException err) {
    _logger.error(
      'DIO ERROR | ${err.requestOptions.method} ${err.requestOptions.path} '
      '| status: ${err.response?.statusCode} | type: ${err.type}',
      error: err,
      stackTrace: err.stackTrace,
    );
  }
}
