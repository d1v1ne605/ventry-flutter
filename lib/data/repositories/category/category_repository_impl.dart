import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/core/network/dio_exception_extension.dart';
import 'package:ventry_flutter/data/datasources/remote/category/category_api.dart';
import 'package:ventry_flutter/data/models/category/request/create_category_request.dart';
import 'package:ventry_flutter/data/models/category/request/update_category_request.dart';
import 'package:ventry_flutter/data/models/category/response/category_response.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';
import 'package:ventry_flutter/domain/repositories/category/category_repository.dart';

@LazySingleton(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryApi _categoryApi;

  CategoryRepositoryImpl(this._categoryApi);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories({
    String? search,
  }) async {
    try {
      final response = await _categoryApi.getCategories(search: search);
      final entities = response.map((e) => e.toEntity()).toList();
      return Right(entities);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> createCategory({
    required String name,
    String? imageUrl,
  }) async {
    try {
      final request = CreateCategoryRequest(name: name, imageUrl: imageUrl);
      final response = await _categoryApi.createCategory(request);
      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return const Left(ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> updateCategory({
    required String categoryUid,
    required String name,
    String? imageUrl,
  }) async {
    try {
      final response = await _categoryApi.updateCategory(
        categoryUid,
        UpdateCategoryRequest(name: name, imageUrl: imageUrl),
      );
      return Right(response.toEntity());
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure(e.message ?? 'Unknown Error'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryByUid(
    String categoryUid,
  ) async {
    try {
      final response = await _categoryApi.getCategoryByUid(categoryUid);
      return Right(response.toEntity());
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure(e.message ?? 'Unknown Error'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> deleteCategory(String categoryUid) async {
    try {
      final response = await _categoryApi.deleteCategory(categoryUid);
      return Right(response.uid);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure(e.message ?? 'Unknown Error'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
