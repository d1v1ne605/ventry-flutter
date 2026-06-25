import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/repositories/attribute/attribute_repository.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_value_entity.dart';

import 'package:ventry_flutter/domain/usecases/usecase.dart';
import 'package:injectable/injectable.dart';

class CreateAttributeValueParams extends Equatable {
  final String attributeUid;
  final String value;

  const CreateAttributeValueParams({
    required this.attributeUid,
    required this.value,
  });

  @override
  List<Object?> get props => [attributeUid, value];
}

@injectable
class CreateAttributeValueUseCase
    implements UseCase<AttributeValueEntity, CreateAttributeValueParams> {
  final AttributeRepository repository;

  CreateAttributeValueUseCase(this.repository);

  @override
  Future<Either<Failure, AttributeValueEntity>> call(
    CreateAttributeValueParams params,
  ) {
    return repository.createAttributeValue(params.attributeUid, params.value);
  }
}
