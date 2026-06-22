import 'dart:convert';

import 'package:dio/dio.dart';
import '../logging/app_logger.dart';

/// Dio interceptor that logs HTTP requests, responses, and network failures.
///
/// Sensitive data policy — the following fields are automatically masked:
///   Request  headers : Authorization, Cookie
///   Request  body    : password, token, accessToken, refreshToken, otp
///   Response body    : token, accessToken, refreshToken
///
/// Log format:
///   Request  → METHOD URL
///              Headers: {...}
///              Body:    {...}
///
///   Response ← STATUS METHOD URL (duration)
///              Body: {...}
///
///   Error    ✕ STATUS METHOD URL
///              Message: ...
///              Body:    {...}
class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._logger);

  final AppLogger _logger;

  /// Keys whose values will be replaced with "***" in logs.
  static const _sensitiveBodyKeys = {
    'password',
    'token',
    'accessToken',
    'refreshToken',
    'otp',
    'secret',
    'creditCard',
  };

  static const _sensitiveHeaderKeys = {
    'authorization',
    'cookie',
    'set-cookie',
  };

  // Tracks request send time for duration calculation
  final _requestTimes = <String, DateTime>{};

  // ─── Request ───────────────────────────────────────────────────────────────

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _requestTimes[options.hashCode.toString()] = DateTime.now();

    final buffer = StringBuffer();
    buffer.writeln('┌─── REQUEST ────────────────────────────────');
    buffer.writeln('│ → ${options.method} ${options.uri}');

    // Query params
    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('│ Query  : ${options.queryParameters}');
    }

    // Headers (masked)
    final headers = _maskHeaders(options.headers);
    if (headers.isNotEmpty) {
      buffer.writeln('│ Headers: ${_formatMap(headers)}');
    }

    // Body (masked)
    final body = options.data;
    if (body != null) {
      buffer.writeln('│ Body   : ${_formatBody(body)}');
    }

    buffer.write('└────────────────────────────────────────────');

    _logger.debug(buffer.toString());
    handler.next(options);
  }

  // ─── Response ──────────────────────────────────────────────────────────────

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final duration = _popDuration(response.requestOptions);
    final options = response.requestOptions;

    final buffer = StringBuffer();
    buffer.writeln('┌─── RESPONSE ───────────────────────────────');
    buffer.writeln(
      '│ ← ${response.statusCode} ${options.method} ${options.uri}'
      '${duration != null ? ' ($duration)' : ''}',
    );

    // Response body (masked)
    final data = response.data;
    if (data != null) {
      buffer.writeln('│ Body   : ${_formatBody(data, isSensitiveContext: true)}');
    }

    buffer.write('└────────────────────────────────────────────');

    _logger.info(buffer.toString());
    handler.next(response);
  }

  // ─── Error ─────────────────────────────────────────────────────────────────

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final duration = _popDuration(err.requestOptions);
    final options = err.requestOptions;
    final response = err.response;

    final buffer = StringBuffer();
    buffer.writeln('┌─── ERROR ──────────────────────────────────');
    buffer.writeln(
      '│ ✕ ${response?.statusCode ?? 'NO_STATUS'} '
      '${options.method} ${options.uri}'
      '${duration != null ? ' ($duration)' : ''}',
    );
    buffer.writeln('│ Type   : ${err.type.name}');

    if (err.message != null) {
      buffer.writeln('│ Message: ${err.message}');
    }

    if (response?.data != null) {
      buffer.writeln('│ Body   : ${_formatBody(response!.data)}');
    }

    buffer.write('└────────────────────────────────────────────');

    _logger.error(
      buffer.toString(),
      error: err,
      stackTrace: err.stackTrace,
    );
    handler.next(err);
  }

  // ─── Helpers ───────────────────────────────────────────────────────────────

  /// Remove tracked start time and return elapsed duration string.
  String? _popDuration(RequestOptions options) {
    final start = _requestTimes.remove(options.hashCode.toString());
    if (start == null) return null;
    final ms = DateTime.now().difference(start).inMilliseconds;
    return '${ms}ms';
  }

  /// Mask sensitive header values.
  Map<String, dynamic> _maskHeaders(Map<String, dynamic> headers) {
    return {
      for (final entry in headers.entries)
        entry.key: _sensitiveHeaderKeys.contains(entry.key.toLowerCase())
            ? '***'
            : entry.value,
    };
  }

  /// Mask sensitive fields in a body Map, or return a safe string
  /// representation for non-Map bodies.
  String _formatBody(dynamic body, {bool isSensitiveContext = false}) {
    if (body is Map<String, dynamic>) {
      final masked = _maskBodyMap(body, isSensitiveContext: isSensitiveContext);
      return _formatMap(masked);
    }
    if (body is String) {
      // Try to pretty-print JSON strings
      try {
        final decoded = jsonDecode(body);
        if (decoded is Map<String, dynamic>) {
          return _formatMap(
            _maskBodyMap(decoded, isSensitiveContext: isSensitiveContext),
          );
        }
      } catch (_) {}
      return body.length > 500 ? '${body.substring(0, 500)}…' : body;
    }
    return body.toString();
  }

  Map<String, dynamic> _maskBodyMap(
    Map<String, dynamic> map, {
    bool isSensitiveContext = false,
  }) {
    return {
      for (final entry in map.entries)
        entry.key: _sensitiveBodyKeys.contains(entry.key) || isSensitiveContext
            ? (isSensitiveContext && !_sensitiveBodyKeys.contains(entry.key)
                ? (entry.value is Map
                    ? _maskBodyMap(
                        entry.value as Map<String, dynamic>,
                        isSensitiveContext: true,
                      )
                    : entry.value)
                : '***')
            : (entry.value is Map<String, dynamic>
                ? _maskBodyMap(entry.value as Map<String, dynamic>)
                : entry.value),
    };
  }

  String _formatMap(Map<String, dynamic> map) {
    final encoder = const JsonEncoder.withIndent('  ');
    return encoder.convert(map);
  }
}
