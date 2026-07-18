import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/spu_entity.dart';
import 'package:ventry_flutter/domain/entities/product/update_spu_params.dart';
import 'package:ventry_flutter/domain/repositories/product/product_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class UpdateSpuUseCase implements UseCase<SpuEntity, UpdateSpuParams> {
  final ProductRepository _repository;

  const UpdateSpuUseCase(this._repository);

  @override
  Future<Either<Failure, SpuEntity>> call(UpdateSpuParams params) {
    return _repository.updateSpu(params);
  }
}
