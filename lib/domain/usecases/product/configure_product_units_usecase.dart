import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/product_entity.dart';
import 'package:ventry_flutter/domain/entities/product/product_unit_configuration_params.dart';
import 'package:ventry_flutter/domain/repositories/product/product_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class ConfigureProductUnitsUseCase
    implements UseCase<ProductEntity, ProductUnitConfigurationParams> {
  const ConfigureProductUnitsUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<Either<Failure, ProductEntity>> call(
    ProductUnitConfigurationParams params,
  ) {
    return _repository.configureProductUnits(params);
  }
}
