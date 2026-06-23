import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/category/category_entity.dart';
import 'package:ventry_flutter/domain/repositories/category/category_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

class CreateCategoryParams extends Equatable {
  final String name;
  final String? imageUrl;

  const CreateCategoryParams({required this.name, this.imageUrl});

  @override
  List<Object?> get props => [name, imageUrl];
}

@lazySingleton
class CreateCategoryUseCase implements UseCase<CategoryEntity, CreateCategoryParams> {
  final CategoryRepository _repository;

  const CreateCategoryUseCase(this._repository);

  @override
  Future<Either<Failure, CategoryEntity>> call(CreateCategoryParams params) {
    return _repository.createCategory(
      name: params.name,
      imageUrl: params.imageUrl,
    );
  }
}
