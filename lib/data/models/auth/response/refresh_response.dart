import 'package:freezed_annotation/freezed_annotation.dart';
import 'authenticated_user_response.dart';

part 'refresh_response.freezed.dart';
part 'refresh_response.g.dart';

@freezed
class RefreshResponse with _$RefreshResponse {
  const factory RefreshResponse({
    required String accessToken,
    required AuthenticatedUserResponse user,
  }) = _RefreshResponse;

  factory RefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshResponseFromJson(json);
}
