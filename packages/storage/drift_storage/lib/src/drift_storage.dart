import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:drift_storage/drift_storage.dart';

part 'drift_storage.g.dart';

@DriftDatabase(
  tables: [
    Readers,
  ],
)

class AppDatabase extends _$AppDatabase {
  static AppDatabase instance() => AppDatabase();

  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'zimbledb.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}