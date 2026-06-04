import 'package:dio/dio.dart';
import 'package:flutter_mvvm_ddd_bloc/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_mvvm_ddd_bloc/core/network/interceptors/error_interceptor.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  Dio get dio =>
      Dio(
          BaseOptions(
            baseUrl: dotenv.env['BASE_URL']!,
            headers: {'Content-Type': 'application/json'},
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
          ),
        )
        ..interceptors.addAll([
          LogInterceptor(requestBody: true, responseBody: true),
          ErrorInterceptor(),
          AuthInterceptor(),
        ]);
}
