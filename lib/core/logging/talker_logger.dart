import 'package:talker/talker.dart';
import 'app_logger.dart';

/// Concrete implementation of [AppLogger] backed by Talker.
///
/// This class wraps Talker and must NOT be used directly by business logic.
/// All logging must go through [AppLogger].
class TalkerLogger implements AppLogger {
  TalkerLogger(this._talker);

  final Talker _talker;

  @override
  void debug(String message) {
    _talker.debug(message);
  }

  @override
  void info(String message) {
    _talker.info(message);
  }

  @override
  void warning(String message) {
    _talker.warning(message);
  }

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _talker.error(message, error, stackTrace);
  }
}
