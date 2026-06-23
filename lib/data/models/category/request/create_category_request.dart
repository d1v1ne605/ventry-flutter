import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_category_request.freezed.dart';
part 'create_category_request.g.dart';

@freezed
class CreateCategoryRequest with _$CreateCategoryRequest {
  const factory CreateCategoryRequest({
    required String name,
    String? imageUrl,
  }) = _CreateCategoryRequest;

  factory CreateCategoryRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateCategoryRequestFromJson(json);
}
