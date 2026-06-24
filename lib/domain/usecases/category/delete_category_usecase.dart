import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/repositories/category/category_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class DeleteCategoryUseCase implements UseCase<String, String> {
  final CategoryRepository _repository;

  const DeleteCategoryUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(String categoryUid) {
    return _repository.deleteCategory(categoryUid);
  }
}
