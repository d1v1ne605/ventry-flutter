import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';
import 'package:ventry_flutter/domain/repositories/category/category_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class GetCategoriesUseCase implements UseCase<List<CategoryEntity>, String?> {
  final CategoryRepository _repository;

  const GetCategoriesUseCase(this._repository);

  @override
  Future<Either<Failure, List<CategoryEntity>>> call(String? search) {
    return _repository.getCategories(search: search);
  }
}
