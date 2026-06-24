import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:ventry_flutter/data/models/category/request/create_category_request.dart';
import 'package:ventry_flutter/data/models/category/request/update_category_request.dart';
import 'package:ventry_flutter/data/models/category/response/category_response.dart';

part 'category_api.g.dart';

@RestApi()
abstract class CategoryApi {
  factory CategoryApi(Dio dio, {String baseUrl}) = _CategoryApi;

  @GET('/categories')
  Future<List<CategoryResponse>> getCategories({
    @Query('search') String? search,
  });

  @POST('/categories')
  Future<CategoryResponse> createCategory(
    @Body() CreateCategoryRequest request,
  );

  @PATCH('/categories/{categoryUid}')
  Future<CategoryResponse> updateCategory(
    @Path('categoryUid') String categoryUid,
    @Body() UpdateCategoryRequest request,
  );

  @GET('/categories/{categoryUid}')
  Future<CategoryResponse> getCategoryByUid(
    @Path('categoryUid') String categoryUid,
  );

  @DELETE('/categories/{categoryUid}')
  Future<DeleteCategoryResponse> deleteCategory(
    @Path('categoryUid') String categoryUid,
  );
}
