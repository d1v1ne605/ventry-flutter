import 'package:injectable/injectable.dart';
import 'package:ventry_flutter/data/datasources/local/app_database.dart';
import 'package:ventry_flutter/data/datasources/local/attribute/attribute_local_datasource.dart';

@module
abstract class DatabaseModule {
  @singleton
  AppDatabase get appDatabase => AppDatabase();

  @lazySingleton
  AttributeLocalDataSource attributeLocalDataSource(AppDatabase db) {
    return AttributeLocalDataSourceImpl(db);
  }
}
