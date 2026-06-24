import 'package:dartz/dartz.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories({String? search});
  Future<Either<Failure, CategoryEntity>> createCategory({
    required String name,
    String? imageUrl,
  });
  Future<Either<Failure, CategoryEntity>> updateCategory({
    required String categoryUid,
    required String name,
    String? imageUrl,
  });

  Future<Either<Failure, CategoryEntity>> getCategoryByUid(String categoryUid);

  Future<Either<Failure, String>> deleteCategory(String categoryUid);
}
