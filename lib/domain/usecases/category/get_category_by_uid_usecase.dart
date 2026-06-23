import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';
import 'package:ventry_flutter/domain/repositories/category/category_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class GetCategoryByUidUseCase implements UseCase<CategoryEntity, String> {
  final CategoryRepository _repository;

  const GetCategoryByUidUseCase(this._repository);

  @override
  Future<Either<Failure, CategoryEntity>> call(String categoryUid) {
    return _repository.getCategoryByUid(categoryUid);
  }
}
