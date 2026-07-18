import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';
import 'package:ventry_flutter/domain/repositories/category/category_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

class UpdateCategoryParams extends Equatable {
  final String categoryUid;
  final String name;
  final String? imageUrl;

  const UpdateCategoryParams({
    required this.categoryUid,
    required this.name,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [categoryUid, name, imageUrl];
}

@lazySingleton
class UpdateCategoryUseCase
    implements UseCase<CategoryEntity, UpdateCategoryParams> {
  final CategoryRepository _repository;

  const UpdateCategoryUseCase(this._repository);

  @override
  Future<Either<Failure, CategoryEntity>> call(UpdateCategoryParams params) {
    return _repository.updateCategory(
      categoryUid: params.categoryUid,
      name: params.name,
      imageUrl: params.imageUrl,
    );
  }
}
