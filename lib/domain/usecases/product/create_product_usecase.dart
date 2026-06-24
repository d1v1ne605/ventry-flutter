import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/product_entity.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';
import 'package:ventry_flutter/domain/repositories/product/product_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class CreateProductUseCase implements UseCase<ProductEntity, CreateProductParams> {
  final ProductRepository _repository;

  const CreateProductUseCase(this._repository);

  @override
  Future<Either<Failure, ProductEntity>> call(CreateProductParams params) {
    return _repository.createProduct(params);
  }
}
