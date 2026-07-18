import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_owner_request_model.freezed.dart';
part 'register_owner_request_model.g.dart';

@freezed
class RegisterOwnerRequestModel with _$RegisterOwnerRequestModel {
  const factory RegisterOwnerRequestModel({
    required String username,
    required String password,
    required String shopName,
    required String name,
  }) = _RegisterOwnerRequestModel;

  factory RegisterOwnerRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterOwnerRequestModelFromJson(json);
}
