/// Abstract logging interface for the application.
///
/// All application code must depend on this abstraction,
/// never on Talker or any concrete logging implementation directly.
///
/// Usage:
/// ```dart
/// logger.debug('Cart items count: 5');
/// logger.info('User logged in');
/// logger.warning('Refresh token expired');
/// logger.error('Create order failed', error: e, stackTrace: st);
/// ```
abstract class AppLogger {
  /// Log development diagnostics.
  /// Use for: state changes, flow tracing, temporary debug info.
  void debug(String message);

  /// Log important application events.
  /// Use for: login/logout, order creation, data sync.
  void info(String message);

  /// Log recoverable issues.
  /// Use for: expired token, missing optional data, retry attempts.
  void warning(String message);

  /// Log exceptions and failures.
  /// Use for: API failures, repository exceptions, unhandled runtime errors.
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  });
}
