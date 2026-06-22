import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_logger.dart';

/// Custom BLoC observer that logs all state transitions and errors.
///
/// Register in main.dart:
/// ```dart
/// Bloc.observer = AppBlocObserver(logger);
/// ```
///
/// Log format:
/// ```
/// [BlocName] Current State → Next State
/// ```
class AppBlocObserver extends BlocObserver {
  AppBlocObserver(this._logger);

  final AppLogger _logger;

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _logger.debug(
      '[${bloc.runtimeType}] '
      '${transition.currentState.runtimeType} → '
      '${transition.nextState.runtimeType}',
    );
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // Log Cubit state changes (Cubits don't emit Transitions)
    if (bloc is! Bloc) {
      // _logger.debug(
      //   '[${bloc.runtimeType}] '
      //   '${change.currentState.runtimeType} → '
      //   '${change.nextState.runtimeType}',
      // );
    }
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    _logger.error(
      '[${bloc.runtimeType}] Unhandled error',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }
}
