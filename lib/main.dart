import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/logging/app_bloc_observer.dart';
import 'core/logging/app_logger.dart';
import 'injection.dart';
import 'presentation/routes/app_router.dart';
import 'presentation/routes/auth_notifier.dart';
import 'core/theme/app_colors.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");
  await configureDependencies();

  final logger = getIt<AppLogger>();

  // Register global BLoC observer
  Bloc.observer = AppBlocObserver(logger);

  // Capture uncaught Flutter framework errors
  FlutterError.onError = (details) {
    logger.error(
      'FlutterError: ${details.exceptionAsString()}',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  // Capture uncaught async/platform errors
  PlatformDispatcher.instance.onError = (error, stack) {
    logger.error(
      'PlatformDispatcher uncaught error',
      error: error,
      stackTrace: stack,
    );
    return true;
  };

  await getIt<AuthNotifier>().initializationComplete;

  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(428, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Ventry',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.background,
            textTheme: Theme.of(context).textTheme.apply(
              bodyColor: AppColors.textBody,
              displayColor: AppColors.textBody,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.barBackground,
              elevation: 0,
              scrolledUnderElevation: 0,
              iconTheme: IconThemeData(color: AppColors.textHeading),
              titleTextStyle: TextStyle(
                color: AppColors.textHeading,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          routerConfig: router,
        );
      },
    );
  }
}
