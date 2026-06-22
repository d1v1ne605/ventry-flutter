import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain/entities/auth/user_entity.dart';

part 'authenticated_user_response.freezed.dart';
part 'authenticated_user_response.g.dart';

@freezed
class AuthenticatedUserResponse with _$AuthenticatedUserResponse {
  const factory AuthenticatedUserResponse({
    required String uid,
    required String username,
    required String name,
    required String shopUid,
  }) = _AuthenticatedUserResponse;

  factory AuthenticatedUserResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthenticatedUserResponseFromJson(json);
}

extension AuthenticatedUserResponseX on AuthenticatedUserResponse {
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      username: username,
      name: name,
      shopUid: shopUid,
    );
  }
}
