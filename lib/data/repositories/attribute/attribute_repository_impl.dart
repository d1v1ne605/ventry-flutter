import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/core/constants/app_errors.dart';
import 'package:ventry_flutter/core/errors/failures.dart';
import 'package:ventry_flutter/core/network/dio_exception_extension.dart';
import 'package:ventry_flutter/data/datasources/local/attribute/attribute_local_datasource.dart';
import 'package:ventry_flutter/data/datasources/remote/attribute/attribute_api.dart';
import 'package:ventry_flutter/data/models/attribute/create_attribute_dto.dart';
import 'package:ventry_flutter/data/models/attribute/create_attribute_value_dto.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_value_entity.dart';
import 'package:ventry_flutter/domain/repositories/attribute/attribute_repository.dart';

@Injectable(as: AttributeRepository)
class AttributeRepositoryImpl implements AttributeRepository {
  final AttributeApi _attributeApi;
  final AttributeLocalDataSource _localDataSource;

  AttributeRepositoryImpl(this._attributeApi, this._localDataSource);

  @override
  Future<Either<Failure, List<AttributeEntity>>> getLocalAttributes() async {
    try {
      final attributes = await _localDataSource.getAttributes();
      return Right(attributes);
    } catch (e) {
      return Left(CacheFailure(AppErrors.localAttributeReadFailed(e)));
    }
  }

  @override
  Future<Either<Failure, void>> syncAttributes() async {
    try {
      final dtos = await _attributeApi.getAttributes();

      final mappedEntities = dtos
          .map(
            (dto) => AttributeEntity(
              uid: dto.uid,
              name: dto.name,
              createdAt: dto.createdAt,
              updatedAt: dto.updatedAt,
              values: dto.values
                  .map(
                    (vDto) => AttributeValueEntity(
                      uid: vDto.uid,
                      value: vDto.value,
                      createdAt: vDto.createdAt,
                      updatedAt: vDto.updatedAt,
                    ),
                  )
                  .toList(),
            ),
          )
          .toList();

      await _localDataSource.replaceAllAttributes(mappedEntities);
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ServerFailure(AppErrors.unexpectedWithDetails(e)));
    }
  }

  @override
  Future<Either<Failure, AttributeEntity>> createAttribute(String name) async {
    try {
      final dto = await _attributeApi.createAttribute(
        CreateAttributeDto(name: name),
      );

      final entity = AttributeEntity(
        uid: dto.uid,
        name: dto.name,
        createdAt: dto.createdAt,
        updatedAt: dto.updatedAt,
        values: const [],
      );

      await _localDataSource.insertAttribute(entity);
      return Right(entity);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ServerFailure(AppErrors.unexpectedWithDetails(e)));
    }
  }

  @override
  Future<Either<Failure, AttributeValueEntity>> createAttributeValue(
    String attributeUid,
    String value,
  ) async {
    try {
      final dto = await _attributeApi.createAttributeValue(
        attributeUid,
        CreateAttributeValueDto(value: value),
      );

      final entity = AttributeValueEntity(
        uid: dto.uid,
        value: dto.value,
        createdAt: dto.createdAt,
        updatedAt: dto.updatedAt,
      );

      await _localDataSource.insertAttributeValue(entity, attributeUid);
      return Right(entity);
    } on DioException catch (e) {
      return Left(e.toFailure());
    } catch (e) {
      return Left(ServerFailure(AppErrors.unexpectedWithDetails(e)));
    }
  }
}
