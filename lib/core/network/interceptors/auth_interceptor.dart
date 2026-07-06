import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import '../../../data/datasources/local/auth/auth_local_datasource.dart';
import '../../../domain/repositories/auth/auth_repository.dart';
import '../../../data/models/auth/response/refresh_response.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

import 'metadata_unwrap_interceptor.dart';

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource _localDataSource;
  final CookieJar _cookieJar;

  // Optional Dios for dependency injection during testing
  final Dio? _testRefreshDio;
  final Dio? _testRetryDio;

  bool _isRefreshing = false;
  final List<Completer<void>> _queuedRequests = [];

  AuthInterceptor(
    this._localDataSource,
    this._cookieJar, {
    Dio? testRefreshDio,
    Dio? testRetryDio,
  }) : _testRefreshDio = testRefreshDio,
       _testRetryDio = testRetryDio;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _localDataSource.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final options = err.response!.requestOptions;

      // Avoid looping if the refresh request itself fails with 401
      if (options.path.contains('/auth/refresh')) {
        _handleRefreshFailure();
        return handler.next(err);
      }

      if (_isRefreshing) {
        final completer = Completer<void>();
        _queuedRequests.add(completer);
        await completer.future;

        final newToken = await _localDataSource.getAccessToken();
        if (newToken != null) {
          options.headers['Authorization'] = 'Bearer $newToken';
          try {
            final retryResponse = await _retryRequest(options);
            return handler.resolve(retryResponse);
          } on DioException catch (retryErr) {
            return handler.next(retryErr);
          }
        } else {
          return handler.next(err);
        }
      } else {
        _isRefreshing = true;

        try {
          final isSuccess = await _refreshToken();

          if (isSuccess) {
            final newToken = await _localDataSource.getAccessToken();
            options.headers['Authorization'] = 'Bearer $newToken';

            for (var completer in _queuedRequests) {
              completer.complete();
            }
            _queuedRequests.clear();

            final retryResponse = await _retryRequest(options);
            return handler.resolve(retryResponse);
          } else {
            _handleRefreshFailure();
            return handler.next(err);
          }
        } catch (e) {
          _handleRefreshFailure();
          return handler.next(err);
        } finally {
          _isRefreshing = false;
        }
      }
    } else {
      handler.next(err);
    }
  }

  Future<bool> _refreshToken() async {
    try {
      // Create a fresh Dio instance to avoid interceptor loop
      final refreshDio =
          _testRefreshDio ??
          Dio(
            BaseOptions(
              baseUrl: dotenv.env['BASE_URL'] ?? '',
              headers: {'Content-Type': 'application/json'},
              connectTimeout: const Duration(seconds: 5),
              receiveTimeout: const Duration(seconds: 3),
            ),
          );
      // Attach interceptors to handle standard unwrapping and cookies
      refreshDio.interceptors.add(MetadataUnwrapInterceptor());
      refreshDio.interceptors.add(CookieManager(_cookieJar));

      final response = await refreshDio.post('/auth/refresh');

      if (response.statusCode == 200) {
        final refreshResponse = RefreshResponse.fromJson(response.data);
        await _localDataSource.saveAccessToken(refreshResponse.accessToken);
        // User sync is handled dynamically in repository if needed, or by reloading me.
        // For now, we only care about updating the access token.
        return true;
      }
    } catch (e) {
      // Refresh failed
    }
    return false;
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final retryDio =
        _testRetryDio ?? Dio(BaseOptions(baseUrl: requestOptions.baseUrl));
    // Add cookie manager just in case the original request needed it
    retryDio.interceptors.add(MetadataUnwrapInterceptor());
    retryDio.interceptors.add(CookieManager(_cookieJar));

    return retryDio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
      ),
    );
  }

  void _handleRefreshFailure() {
    for (var completer in _queuedRequests) {
      if (!completer.isCompleted) {
        // Just complete without token, requests will fail normally.
        // In a more complex scenario, we could complete with error.
        completer.complete();
      }
    }
    _queuedRequests.clear();

    // Use GetIt lazily to avoid circular dependency
    if (GetIt.I.isRegistered<AuthRepository>()) {
      GetIt.I<AuthRepository>().forceLogout();
    }
  }
}
