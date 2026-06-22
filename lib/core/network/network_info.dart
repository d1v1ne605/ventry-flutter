import 'package:dio/dio.dart';
import 'package:ventry_flutter/core/logging/app_logger.dart';
import 'package:ventry_flutter/core/logging/logger_config.dart';
import 'package:ventry_flutter/core/network/interceptors/auth_interceptor.dart';
import 'package:ventry_flutter/core/network/interceptors/error_interceptor.dart';
import 'package:ventry_flutter/core/network/interceptors/metadata_unwrap_interceptor.dart';
import 'package:ventry_flutter/core/network/logging_interceptor.dart';
import 'package:ventry_flutter/data/datasources/remote/onboarding/onboarding_remote_datasource.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio dio(AppLogger logger) =>
      Dio(
          BaseOptions(
            baseUrl: dotenv.env['BASE_URL']!,
            headers: {'Content-Type': 'application/json'},
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
          ),
        )
        ..interceptors.addAll([
          // MetadataUnwrapInterceptor MUST be first — Dio reverses response
          // order, so it runs last, after logging has captured the full payload.
          MetadataUnwrapInterceptor(),
          // Switch between loggers by changing activeLoggerMode in logger_config.dart
          if (activeDioLoggerMode == LoggerMode.talker)
            LoggingInterceptor(logger)
          else
            LogInterceptor(requestBody: true, responseBody: true),
          ErrorInterceptor(logger),
          AuthInterceptor(),
        ]);

  @lazySingleton
  OnboardingRemoteDataSource onboardingRemoteDataSource(Dio dio) {
    return OnboardingRemoteDataSource(dio);
  }
}
