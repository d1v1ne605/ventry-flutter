import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';

part 'category_response.freezed.dart';
part 'category_response.g.dart';

@freezed
class CategoryResponse with _$CategoryResponse {
  const factory CategoryResponse({
    required String uid,
    required String name,
    String? imageUrl,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CategoryResponse;

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);
}

@freezed
class DeleteCategoryResponse with _$DeleteCategoryResponse {
  const factory DeleteCategoryResponse({required String uid}) =
      _DeleteCategoryResponse;

  factory DeleteCategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteCategoryResponseFromJson(json);
}

extension CategoryResponseX on CategoryResponse {
  CategoryEntity toEntity() {
    return CategoryEntity(
      uid: uid,
      name: name,
      imageUrl: imageUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
