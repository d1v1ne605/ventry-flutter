import 'package:dartz/dartz.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_value_entity.dart';

abstract class AttributeRepository {
  /// Fetch from local DB
  Future<Either<Failure, List<AttributeEntity>>> getLocalAttributes();

  /// Sync from Remote API to local DB
  Future<Either<Failure, void>> syncAttributes();

  /// Create a new Attribute on remote and sync local
  Future<Either<Failure, AttributeEntity>> createAttribute(String name);

  /// Create a new Attribute Value on remote and sync local
  Future<Either<Failure, AttributeValueEntity>> createAttributeValue(
    String attributeUid,
    String value,
  );
}
