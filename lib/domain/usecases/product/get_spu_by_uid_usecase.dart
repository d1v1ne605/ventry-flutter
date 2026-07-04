import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/spu_entity.dart';
import 'package:ventry_flutter/domain/repositories/product/product_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class GetSpuByUidUseCase implements UseCase<SpuEntity, String> {
  final ProductRepository _repository;

  const GetSpuByUidUseCase(this._repository);

  @override
  Future<Either<Failure, SpuEntity>> call(String spuUid) {
    return _repository.getSpuByUid(spuUid);
  }
}
