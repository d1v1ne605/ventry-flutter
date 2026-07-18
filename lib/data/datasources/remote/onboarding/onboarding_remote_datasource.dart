import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ventry_flutter/data/models/onboarding/request/register_owner_request_model.dart';
import 'package:ventry_flutter/data/models/onboarding/response/register_owner_response_model.dart';

part 'onboarding_remote_datasource.g.dart';

@RestApi()
abstract class OnboardingRemoteDataSource {
  factory OnboardingRemoteDataSource(Dio dio, {String baseUrl}) =
      _OnboardingRemoteDataSource;

  @POST('/onboarding/register')
  Future<RegisterOwnerResponseModel> register(
    @Body() RegisterOwnerRequestModel body,
  );
}
