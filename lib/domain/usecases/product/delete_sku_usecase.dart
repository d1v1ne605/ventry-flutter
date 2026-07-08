import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/delete_sku_params.dart';
import 'package:ventry_flutter/domain/repositories/product/product_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class DeleteSkuUseCase implements UseCase<String, DeleteSkuParams> {
  final ProductRepository _repository;

  const DeleteSkuUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(DeleteSkuParams params) {
    return _repository.deleteSku(params);
  }
}
