import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_owner_response_model.freezed.dart';
part 'register_owner_response_model.g.dart';

@freezed
class RegisterOwnerResponseModel with _$RegisterOwnerResponseModel {
  const factory RegisterOwnerResponseModel({
    required String shopUid,
    required String userUid,
    required String username,
    required String name,
    required String role,
  }) = _RegisterOwnerResponseModel;

  factory RegisterOwnerResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterOwnerResponseModelFromJson(json);
}
