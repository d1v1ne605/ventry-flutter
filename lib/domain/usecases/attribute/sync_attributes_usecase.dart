import 'package:dartz/dartz.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/repositories/attribute/attribute_repository.dart';

import 'package:ventry_flutter/domain/usecases/usecase.dart';
import 'package:injectable/injectable.dart';

@injectable
class SyncAttributesUseCase implements UseCase<void, NoParams> {
  final AttributeRepository repository;

  SyncAttributesUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.syncAttributes();
  }
}
