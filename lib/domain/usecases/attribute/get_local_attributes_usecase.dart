import 'package:dartz/dartz.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/repositories/attribute/attribute_repository.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';

import 'package:ventry_flutter/domain/usecases/usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetLocalAttributesUseCase
    implements UseCase<List<AttributeEntity>, NoParams> {
  final AttributeRepository repository;

  GetLocalAttributesUseCase(this.repository);

  @override
  Future<Either<Failure, List<AttributeEntity>>> call(NoParams params) {
    return repository.getLocalAttributes();
  }
}
