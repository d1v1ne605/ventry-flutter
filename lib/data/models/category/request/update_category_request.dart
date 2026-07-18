import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_category_request.freezed.dart';
part 'update_category_request.g.dart';

@freezed
class UpdateCategoryRequest with _$UpdateCategoryRequest {
  const factory UpdateCategoryRequest({
    required String name,
    String? imageUrl,
  }) = _UpdateCategoryRequest;

  factory UpdateCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateCategoryRequestFromJson(json);
}
