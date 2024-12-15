import 'package:drift/drift.dart';

class Readers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get serialNumber => text()();
  TextColumn get macAddress => text().nullable()();
  TextColumn get modelNumber => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}