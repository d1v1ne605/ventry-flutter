import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/repositories/attribute/attribute_repository.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';

import 'package:ventry_flutter/domain/usecases/usecase.dart';
import 'package:injectable/injectable.dart';

class CreateAttributeParams extends Equatable {
  final String name;

  const CreateAttributeParams({required this.name});

  @override
  List<Object?> get props => [name];
}

@injectable
class CreateAttributeUseCase
    implements UseCase<AttributeEntity, CreateAttributeParams> {
  final AttributeRepository repository;

  CreateAttributeUseCase(this.repository);

  @override
  Future<Either<Failure, AttributeEntity>> call(CreateAttributeParams params) {
    return repository.createAttribute(params.name);
  }
}
