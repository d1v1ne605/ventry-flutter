import 'package:freezed_annotation/freezed_annotation.dart';

part 'presigned_upload_response.freezed.dart';
part 'presigned_upload_response.g.dart';

@freezed
class PresignedUploadResponse with _$PresignedUploadResponse {
  const factory PresignedUploadResponse({
    required String objectKey,
    required String uploadUrl,
    required String method,
    @Default(<String, String>{}) Map<String, String> headers,
    required int expiresInSeconds,
  }) = _PresignedUploadResponse;

  factory PresignedUploadResponse.fromJson(Map<String, dynamic> json) =>
      _$PresignedUploadResponseFromJson(json);
}
