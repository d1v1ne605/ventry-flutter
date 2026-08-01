import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/product/unit_entity.dart';
import 'package:ventry_flutter/domain/repositories/product/product_repository.dart';
import 'package:ventry_flutter/domain/usecases/usecase.dart';

@lazySingleton
class CreateUnitUseCase implements UseCase<UnitEntity, String> {
  const CreateUnitUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<Either<Failure, UnitEntity>> call(String name) {
    return _repository.createUnit(name.trim());
  }
}
