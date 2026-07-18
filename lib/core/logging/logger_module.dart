import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';
// Use a prefix to avoid name collision with talker_logger's TalkerLogger class
import 'app_logger.dart';
import 'talker_logger.dart' as app;

/// Injectable module that provides the [AppLogger] singleton.
///
/// Talker is configured here and hidden behind the [AppLogger] abstraction.
/// No other module should instantiate Talker directly.
@module
abstract class LoggerModule {
  /// Provides a singleton [Talker] instance with console output only.
  @lazySingleton
  Talker get talker => Talker(
    settings: TalkerSettings(
      // Enabled automatically in debug builds, disabled in release.
      // To temporarily mute all logs during development,
      // set this to false — but note this also silences network logging.
      enabled: kDebugMode,
      useConsoleLogs: kDebugMode,
    ),
    logger: TalkerLogger(settings: TalkerLoggerSettings(enableColors: true)),
  );

  /// Provides the [AppLogger] abstraction backed by our [app.TalkerLogger].
  ///
  /// Business logic must always depend on [AppLogger], never on [Talker].
  @lazySingleton
  AppLogger appLogger(Talker talker) => app.TalkerLogger(talker);
}
