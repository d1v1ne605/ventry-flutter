import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ventry_flutter/data/models/auth/request/login_request.dart';
import 'package:ventry_flutter/data/models/auth/response/authenticated_user_response.dart';
import 'package:ventry_flutter/data/models/auth/response/login_response.dart';
import 'package:ventry_flutter/data/models/auth/response/refresh_response.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('/auth/login')
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST('/auth/refresh')
  Future<RefreshResponse> refresh();

  @POST('/auth/logout')
  Future<void> logout();

  @GET('/auth/me')
  Future<AuthenticatedUserResponse> getMe();
}
