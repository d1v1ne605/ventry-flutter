import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/product_params.dart';
import 'package:ventry_flutter/domain/entities/product/sku_spu_group_list_entity.dart';
import 'package:ventry_flutter/domain/repositories/product/product_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class GetSkusUseCase implements UseCase<SkuSpuGroupListEntity, SkuQueryParams> {
  final ProductRepository _repository;

  const GetSkusUseCase(this._repository);

  @override
  Future<Either<Failure, SkuSpuGroupListEntity>> call(SkuQueryParams params) {
    return _repository.getSkus(params);
  }
}
