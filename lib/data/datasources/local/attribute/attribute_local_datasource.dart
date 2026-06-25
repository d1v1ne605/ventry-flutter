import 'package:drift/drift.dart';
import 'package:ventry_flutter/data/datasources/local/app_database.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_entity.dart';
import 'package:ventry_flutter/domain/entities/attribute/attribute_value_entity.dart';

abstract class AttributeLocalDataSource {
  Future<List<AttributeEntity>> getAttributes();
  Future<void> replaceAllAttributes(List<AttributeEntity> attributes);
  Future<void> insertAttribute(AttributeEntity attribute);
  Future<void> insertAttributeValue(AttributeValueEntity value, String attributeUid);
}

class AttributeLocalDataSourceImpl implements AttributeLocalDataSource {
  final AppDatabase _db;

  AttributeLocalDataSourceImpl(this._db);

  @override
  Future<List<AttributeEntity>> getAttributes() async {
    final attributesData = await _db.select(_db.attributes).get();
    
    final result = <AttributeEntity>[];
    for (final attr in attributesData) {
      final valuesData = await (_db.select(_db.attributeValues)
            ..where((t) => t.attributeUid.equals(attr.uid)))
          .get();
      
      final mappedValues = valuesData.map((val) => AttributeValueEntity(
        uid: val.uid,
        value: val.value,
        createdAt: val.createdAt,
        updatedAt: val.updatedAt,
      )).toList();
      
      result.add(AttributeEntity(
        uid: attr.uid,
        name: attr.name,
        createdAt: attr.createdAt,
        updatedAt: attr.updatedAt,
        values: mappedValues,
      ));
    }
    
    return result;
  }

  @override
  Future<void> replaceAllAttributes(List<AttributeEntity> attributes) async {
    await _db.transaction(() async {
      await _db.delete(_db.attributeValues).go();
      await _db.delete(_db.attributes).go();

      for (final attr in attributes) {
        await _db.into(_db.attributes).insert(AttributesCompanion.insert(
          uid: attr.uid,
          name: attr.name,
          createdAt: attr.createdAt,
          updatedAt: attr.updatedAt,
        ));
        
        for (final val in attr.values) {
          await _db.into(_db.attributeValues).insert(AttributeValuesCompanion.insert(
            uid: val.uid,
            attributeUid: attr.uid,
            value: val.value,
            createdAt: val.createdAt,
            updatedAt: val.updatedAt,
          ));
        }
      }
    });
  }

  @override
  Future<void> insertAttribute(AttributeEntity attribute) async {
    await _db.into(_db.attributes).insert(
      AttributesCompanion.insert(
        uid: attribute.uid,
        name: attribute.name,
        createdAt: attribute.createdAt,
        updatedAt: attribute.updatedAt,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  @override
  Future<void> insertAttributeValue(AttributeValueEntity value, String attributeUid) async {
    await _db.into(_db.attributeValues).insert(
      AttributeValuesCompanion.insert(
        uid: value.uid,
        attributeUid: attributeUid,
        value: value.value,
        createdAt: value.createdAt,
        updatedAt: value.updatedAt,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }
}
