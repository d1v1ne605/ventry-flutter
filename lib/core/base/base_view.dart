import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart'; // Make sure you use GetIt in the injection.dart file
import 'base_view_model.dart';

/// Base class for every screen/page in the application.
/// [B] is the type of BaseViewModel (Bloc).
/// [E] is the type of Event.
/// [S] is the type of State.
abstract class BaseView<B extends BaseViewModel<E, S>, E, S>
    extends StatelessWidget {
  const BaseView({super.key});

  /// This function automatically resolves BLoC from Service Locator (GetIt).
  /// Make sure that BLoC is registered in injection.config.dart
  B get bloc => GetIt.I<B>();

  /// Required function to override to draw the main interface based on State.
  Widget buildView(BuildContext context, S state);

  /// Optional function (optional hook).
  /// Used to handle side-effects such as: Show SnackBar, Dialog, Navigation...
  /// when State changes.
  void onStateListened(BuildContext context, S state) {}

  /// Optional function (optional hook).
  /// Place to call initialization events right when BLoC is just created.
  /// Example: bloc.add(FetchDataEvent());
  void onInit(B bloc) {}

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: (context) {
        final b = bloc;
        onInit(b); // Trigger initialization hook
        return b;
      },
      child: BlocConsumer<B, S>(
        listener: onStateListened,
        builder: (context, state) {
          // Handle common UI (Example: Loading Overlay, Error Layout)
          // Can be nested directly here if you need to set up for the entire app.
          return buildView(context, state);
        },
      ),
    );
  }
}
