import 'package:dio/dio.dart';

/// Automatically unwraps the standard API response envelope so that Retrofit
/// can deserialize directly into the business model without a wrapper class.
///
/// All API responses follow this contract:
/// ```json
/// {
///   "statusCode": 201,
///   "statusReason": "CREATED",
///   "message": "...",
///   "metadata": { <actual business data> }
/// }
/// ```
///
/// This interceptor replaces [Response.data] with [Response.data]['metadata']
/// before Retrofit calls `fromJson`. As a result:
///
/// - Every response model only defines its own fields (no wrapper boilerplate).
/// - Adding a new API endpoint requires NO changes here.
/// - Non-standard responses (no 'metadata' key) are passed through unchanged.
///
/// ⚠️  Position in interceptor list matters:
/// Dio runs onResponse handlers in **reverse** order of registration.
/// This interceptor must be registered FIRST in the list so it runs LAST
/// on the response chain — after logging has already captured the full payload.
class MetadataUnwrapInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final data = response.data;

    if (data is Map<String, dynamic> && data.containsKey('metadata')) {
      handler.next(
        Response(
          data: data['metadata'],
          headers: response.headers,
          requestOptions: response.requestOptions,
          isRedirect: response.isRedirect,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          redirects: response.redirects,
          extra: response.extra,
        ),
      );
      return;
    }

    handler.next(response);
  }
}
