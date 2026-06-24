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
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ventry_flutter/data/datasources/local/auth/auth_local_datasource.dart';
import 'package:ventry_flutter/data/datasources/remote/auth/auth_api.dart';
import 'package:ventry_flutter/data/datasources/remote/category/category_api.dart';
import 'package:ventry_flutter/data/datasources/remote/product/product_api.dart';

@module
abstract class RegisterModule {
  @preResolve
  @lazySingleton
  Future<CookieJar> get cookieJar async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    return PersistCookieJar(
      ignoreExpires: true,
      storage: FileStorage("$appDocPath/.cookies/"),
    );
  }

  @lazySingleton
  Dio dio(
    AppLogger logger,
    CookieJar cookieJar,
    AuthInterceptor authInterceptor,
  ) =>
      Dio(
          BaseOptions(
            baseUrl: dotenv.env['BASE_URL']!,
            headers: {'Content-Type': 'application/json'},
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
          ),
        )
        ..interceptors.addAll([
          MetadataUnwrapInterceptor(),
          if (activeDioLoggerMode == LoggerMode.talker)
            LoggingInterceptor(logger)
          else
            LogInterceptor(requestBody: true, responseBody: true),
          ErrorInterceptor(logger),
          CookieManager(cookieJar),
          authInterceptor,
        ]);

  @lazySingleton
  AuthInterceptor authInterceptor(
    AuthLocalDataSource localDataSource,
    CookieJar cookieJar,
  ) {
    return AuthInterceptor(localDataSource, cookieJar);
  }

  @lazySingleton
  OnboardingRemoteDataSource onboardingRemoteDataSource(Dio dio) {
    return OnboardingRemoteDataSource(dio);
  }

  @lazySingleton
  AuthApi authApi(Dio dio) {
    return AuthApi(dio);
  }

  @lazySingleton
  CategoryApi categoryApi(Dio dio) {
    return CategoryApi(dio);
  }

  @lazySingleton
  ProductApi productApi(Dio dio) {
    return ProductApi(dio);
  }
}
