import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:ventry_flutter/core/network/interceptors/auth_interceptor.dart';
import 'package:ventry_flutter/data/datasources/local/auth/auth_local_datasource.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockCookieJar extends Mock implements CookieJar {}

class MockDio extends Mock implements Dio {
  @override
  Interceptors get interceptors => Interceptors();
}

class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

class MockRequestOptions extends Mock implements RequestOptions {}

void main() {
  late AuthInterceptor interceptor;
  late MockAuthLocalDataSource mockLocalDataSource;
  late MockCookieJar mockCookieJar;
  late MockDio mockRefreshDio;
  late MockDio mockRetryDio;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(DioException(requestOptions: RequestOptions(path: '')));
    registerFallbackValue(Response(requestOptions: RequestOptions(path: '')));
  });

  setUp(() {
    mockLocalDataSource = MockAuthLocalDataSource();
    mockCookieJar = MockCookieJar();
    mockRefreshDio = MockDio();
    mockRetryDio = MockDio();

    interceptor = AuthInterceptor(
      mockLocalDataSource,
      mockCookieJar,
      testRefreshDio: mockRefreshDio,
      testRetryDio: mockRetryDio,
    );
  });

  group('AuthInterceptor Refresh Logic', () {
    test('successfully refreshes token and retries request on 401', () async {
      // Arrange
      final handler = MockErrorInterceptorHandler();
      final requestOptions = RequestOptions(path: '/api/protected', method: 'GET');
      final errorResponse = Response(
        requestOptions: requestOptions,
        statusCode: 401,
      );
      final dioException = DioException(
        requestOptions: requestOptions,
        response: errorResponse,
      );

      // Simulate successful refresh response
      // Assume MetadataUnwrapInterceptor has already unwrapped it or we provide the unwrapped format
      final refreshResponseData = {
        'accessToken': 'new_valid_token',
        'user': {
          'uid': '1',
          'username': 'test',
          'name': 'Test',
          'shopUid': 'shop1'
        }
      };
      
      when(() => mockRefreshDio.post(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/refresh'),
          statusCode: 200,
          data: refreshResponseData,
        ),
      );

      // Simulate saving token
      when(() => mockLocalDataSource.saveAccessToken(any())).thenAnswer((_) async => {});

      // Provide the new token when requested for retry
      when(() => mockLocalDataSource.getAccessToken()).thenAnswer((_) async => 'new_valid_token');

      // Simulate successful retry response
      final retryResponse = Response(
        requestOptions: requestOptions,
        statusCode: 200,
        data: {'success': true},
      );
      
      when(() => mockRetryDio.request<dynamic>(
        any(),
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      )).thenAnswer((_) async => retryResponse);

      // Act
      interceptor.onError(dioException, handler);
      
      // Allow async microtasks to complete (since onError is async but returns void)
      await Future.delayed(Duration.zero);

      // Assert
      // 1. Called refresh API
      verify(() => mockRefreshDio.post('/auth/refresh')).called(1);
      
      // 2. Saved the new token
      verify(() => mockLocalDataSource.saveAccessToken('new_valid_token')).called(1);
      
      // 3. Retried the original request
      verify(() => mockRetryDio.request<dynamic>(
        '/api/protected',
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
        options: any(named: 'options'),
      )).called(1);
      
      // 4. Resolved the original handler with the retry response
      verify(() => handler.resolve(retryResponse)).called(1);
    });

    test('passes error to next handler if refresh fails', () async {
      // Arrange
      final handler = MockErrorInterceptorHandler();
      final requestOptions = RequestOptions(path: '/api/protected');
      final errorResponse = Response(
        requestOptions: requestOptions,
        statusCode: 401,
      );
      final dioException = DioException(
        requestOptions: requestOptions,
        response: errorResponse,
      );

      // Simulate failed refresh response
      when(() => mockRefreshDio.post(any())).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/auth/refresh'),
          statusCode: 401,
        ),
      );

      // Act
      interceptor.onError(dioException, handler);
      await Future.delayed(Duration.zero);

      // Assert
      verify(() => mockRefreshDio.post('/auth/refresh')).called(1);
      // It should NOT retry
      verifyNever(() => mockRetryDio.request<dynamic>(any(), options: any(named: 'options')));
      // It should pass the error to next
      verify(() => handler.next(dioException)).called(1);
    });
  });
}
