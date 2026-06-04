import 'package:flutter_bloc/flutter_bloc.dart';
import '../errors/failures.dart';

/// BaseViewModel acts as a BaseBloc.
/// Every BLoC/Cubit in the system should inherit from this class to reuse
/// common logic such as error handling from Domain Layer, logging, and teardown.
abstract class BaseViewModel<Event, State> extends Bloc<Event, State> {
  BaseViewModel(super.initialState);

  /// Utility function to map [Failure] from Domain Layer
  /// (usually returned via dartz Either) to user-friendly UI messages.
  String mapFailureToMessage(Failure failure) {
    // Depending on how it's defined in failures.dart, you can switch-case
    /*
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server connection error. Please try again later.';
      case CacheFailure:
        return 'Cannot retrieve local data.';
      case NetworkFailure:
        return 'Please check your network connection again.';
      default:
        return 'An unknown error has occurred.';
    }
    */
    return failure.toString();
  }

  /// Common hook to track all State transitions of ViewModels.
  /// Very useful when integrating with log tracking systems like Firebase Crashlytics
  /// or printing to console during debug.
  @override
  void onTransition(Transition<Event, State> transition) {
    super.onTransition(transition);
    // TODO: Integrate internal Logger here
    // print('Transition in ${this.runtimeType}: $transition');
  }

  /// Catch unhandled exceptions that occur during Event mapping.
  @override
  void onError(Object error, StackTrace stackTrace) {
    // TODO: Send error log to alert system
    // print('Error in ${this.runtimeType}: $error');
    super.onError(error, stackTrace);
  }

  /// Place to clean up common resources (like StreamSubscriptions)
  /// when this ViewModel is destroyed.
  @override
  Future<void> close() {
    // Cancel global subscriptions if any
    return super.close();
  }
}
