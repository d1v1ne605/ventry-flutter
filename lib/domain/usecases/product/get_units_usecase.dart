import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';
import 'package:ventry_flutter/domain/repositories/product/product_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class GetUnitsUseCase implements UseCase<List<UnitEntity>, NoParams> {
  const GetUnitsUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<Either<Failure, List<UnitEntity>>> call(NoParams params) {
    return _repository.getUnits();
  }
}
