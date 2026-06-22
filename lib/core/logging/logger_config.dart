/// Controls which network logger is active.
///
/// Set to [LoggerMode.talker] to use the structured AppLogger (Talker).
/// Set to [LoggerMode.legacy] to revert to Dio's built-in LogInterceptor.
///
/// Only change this constant — nothing else needs to be touched.
enum LoggerMode { talker, legacy }

const LoggerMode activeDioLoggerMode = LoggerMode.talker;
// const LoggerMode activeDioLoggerMode =
//     LoggerMode.legacy; // ← uncomment to revert
