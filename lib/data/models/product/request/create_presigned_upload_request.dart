// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_presigned_upload_request.freezed.dart';
part 'create_presigned_upload_request.g.dart';

@freezed
class CreatePresignedUploadRequest with _$CreatePresignedUploadRequest {
  @JsonSerializable(includeIfNull: false)
  const factory CreatePresignedUploadRequest({
    required String mimeType,
    required int fileSize,
  }) = _CreatePresignedUploadRequest;

  factory CreatePresignedUploadRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePresignedUploadRequestFromJson(json);
}
