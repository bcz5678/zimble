// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_storage.dart';

// ignore_for_file: type=lint
class $ReadersTable extends Readers with TableInfo<$ReadersTable, Reader> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _serialNumberMeta =
      const VerificationMeta('serialNumber');
  @override
  late final GeneratedColumn<String> serialNumber = GeneratedColumn<String>(
      'serial_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _macAddressMeta =
      const VerificationMeta('macAddress');
  @override
  late final GeneratedColumn<String> macAddress = GeneratedColumn<String>(
      'mac_address', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _modelNumberMeta =
      const VerificationMeta('modelNumber');
  @override
  late final GeneratedColumn<String> modelNumber = GeneratedColumn<String>(
      'model_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, serialNumber, macAddress, modelNumber];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'readers';
  @override
  VerificationContext validateIntegrity(Insertable<Reader> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('serial_number')) {
      context.handle(
          _serialNumberMeta,
          serialNumber.isAcceptableOrUnknown(
              data['serial_number']!, _serialNumberMeta));
    } else if (isInserting) {
      context.missing(_serialNumberMeta);
    }
    if (data.containsKey('mac_address')) {
      context.handle(
          _macAddressMeta,
          macAddress.isAcceptableOrUnknown(
              data['mac_address']!, _macAddressMeta));
    }
    if (data.containsKey('model_number')) {
      context.handle(
          _modelNumberMeta,
          modelNumber.isAcceptableOrUnknown(
              data['model_number']!, _modelNumberMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Reader map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reader(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serialNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}serial_number'])!,
      macAddress: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}mac_address']),
      modelNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model_number']),
    );
  }

  @override
  $ReadersTable createAlias(String alias) {
    return $ReadersTable(attachedDatabase, alias);
  }
}

class Reader extends DataClass implements Insertable<Reader> {
  final int id;
  final String serialNumber;
  final String? macAddress;
  final String? modelNumber;
  const Reader(
      {required this.id,
      required this.serialNumber,
      this.macAddress,
      this.modelNumber});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['serial_number'] = Variable<String>(serialNumber);
    if (!nullToAbsent || macAddress != null) {
      map['mac_address'] = Variable<String>(macAddress);
    }
    if (!nullToAbsent || modelNumber != null) {
      map['model_number'] = Variable<String>(modelNumber);
    }
    return map;
  }

  ReadersCompanion toCompanion(bool nullToAbsent) {
    return ReadersCompanion(
      id: Value(id),
      serialNumber: Value(serialNumber),
      macAddress: macAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(macAddress),
      modelNumber: modelNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(modelNumber),
    );
  }

  factory Reader.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reader(
      id: serializer.fromJson<int>(json['id']),
      serialNumber: serializer.fromJson<String>(json['serialNumber']),
      macAddress: serializer.fromJson<String?>(json['macAddress']),
      modelNumber: serializer.fromJson<String?>(json['modelNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serialNumber': serializer.toJson<String>(serialNumber),
      'macAddress': serializer.toJson<String?>(macAddress),
      'modelNumber': serializer.toJson<String?>(modelNumber),
    };
  }

  Reader copyWith(
          {int? id,
          String? serialNumber,
          Value<String?> macAddress = const Value.absent(),
          Value<String?> modelNumber = const Value.absent()}) =>
      Reader(
        id: id ?? this.id,
        serialNumber: serialNumber ?? this.serialNumber,
        macAddress: macAddress.present ? macAddress.value : this.macAddress,
        modelNumber: modelNumber.present ? modelNumber.value : this.modelNumber,
      );
  Reader copyWithCompanion(ReadersCompanion data) {
    return Reader(
      id: data.id.present ? data.id.value : this.id,
      serialNumber: data.serialNumber.present
          ? data.serialNumber.value
          : this.serialNumber,
      macAddress:
          data.macAddress.present ? data.macAddress.value : this.macAddress,
      modelNumber:
          data.modelNumber.present ? data.modelNumber.value : this.modelNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reader(')
          ..write('id: $id, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('macAddress: $macAddress, ')
          ..write('modelNumber: $modelNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, serialNumber, macAddress, modelNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reader &&
          other.id == this.id &&
          other.serialNumber == this.serialNumber &&
          other.macAddress == this.macAddress &&
          other.modelNumber == this.modelNumber);
}

class ReadersCompanion extends UpdateCompanion<Reader> {
  final Value<int> id;
  final Value<String> serialNumber;
  final Value<String?> macAddress;
  final Value<String?> modelNumber;
  const ReadersCompanion({
    this.id = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.macAddress = const Value.absent(),
    this.modelNumber = const Value.absent(),
  });
  ReadersCompanion.insert({
    this.id = const Value.absent(),
    required String serialNumber,
    this.macAddress = const Value.absent(),
    this.modelNumber = const Value.absent(),
  }) : serialNumber = Value(serialNumber);
  static Insertable<Reader> custom({
    Expression<int>? id,
    Expression<String>? serialNumber,
    Expression<String>? macAddress,
    Expression<String>? modelNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (macAddress != null) 'mac_address': macAddress,
      if (modelNumber != null) 'model_number': modelNumber,
    });
  }

  ReadersCompanion copyWith(
      {Value<int>? id,
      Value<String>? serialNumber,
      Value<String?>? macAddress,
      Value<String?>? modelNumber}) {
    return ReadersCompanion(
      id: id ?? this.id,
      serialNumber: serialNumber ?? this.serialNumber,
      macAddress: macAddress ?? this.macAddress,
      modelNumber: modelNumber ?? this.modelNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serialNumber.present) {
      map['serial_number'] = Variable<String>(serialNumber.value);
    }
    if (macAddress.present) {
      map['mac_address'] = Variable<String>(macAddress.value);
    }
    if (modelNumber.present) {
      map['model_number'] = Variable<String>(modelNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadersCompanion(')
          ..write('id: $id, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('macAddress: $macAddress, ')
          ..write('modelNumber: $modelNumber')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ReadersTable readers = $ReadersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [readers];
}

typedef $$ReadersTableCreateCompanionBuilder = ReadersCompanion Function({
  Value<int> id,
  required String serialNumber,
  Value<String?> macAddress,
  Value<String?> modelNumber,
});
typedef $$ReadersTableUpdateCompanionBuilder = ReadersCompanion Function({
  Value<int> id,
  Value<String> serialNumber,
  Value<String?> macAddress,
  Value<String?> modelNumber,
});

class $$ReadersTableFilterComposer
    extends Composer<_$AppDatabase, $ReadersTable> {
  $$ReadersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get serialNumber => $composableBuilder(
      column: $table.serialNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get macAddress => $composableBuilder(
      column: $table.macAddress, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get modelNumber => $composableBuilder(
      column: $table.modelNumber, builder: (column) => ColumnFilters(column));
}

class $$ReadersTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadersTable> {
  $$ReadersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get serialNumber => $composableBuilder(
      column: $table.serialNumber,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get macAddress => $composableBuilder(
      column: $table.macAddress, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get modelNumber => $composableBuilder(
      column: $table.modelNumber, builder: (column) => ColumnOrderings(column));
}

class $$ReadersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadersTable> {
  $$ReadersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serialNumber => $composableBuilder(
      column: $table.serialNumber, builder: (column) => column);

  GeneratedColumn<String> get macAddress => $composableBuilder(
      column: $table.macAddress, builder: (column) => column);

  GeneratedColumn<String> get modelNumber => $composableBuilder(
      column: $table.modelNumber, builder: (column) => column);
}

class $$ReadersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReadersTable,
    Reader,
    $$ReadersTableFilterComposer,
    $$ReadersTableOrderingComposer,
    $$ReadersTableAnnotationComposer,
    $$ReadersTableCreateCompanionBuilder,
    $$ReadersTableUpdateCompanionBuilder,
    (Reader, BaseReferences<_$AppDatabase, $ReadersTable, Reader>),
    Reader,
    PrefetchHooks Function()> {
  $$ReadersTableTableManager(_$AppDatabase db, $ReadersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> serialNumber = const Value.absent(),
            Value<String?> macAddress = const Value.absent(),
            Value<String?> modelNumber = const Value.absent(),
          }) =>
              ReadersCompanion(
            id: id,
            serialNumber: serialNumber,
            macAddress: macAddress,
            modelNumber: modelNumber,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String serialNumber,
            Value<String?> macAddress = const Value.absent(),
            Value<String?> modelNumber = const Value.absent(),
          }) =>
              ReadersCompanion.insert(
            id: id,
            serialNumber: serialNumber,
            macAddress: macAddress,
            modelNumber: modelNumber,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReadersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReadersTable,
    Reader,
    $$ReadersTableFilterComposer,
    $$ReadersTableOrderingComposer,
    $$ReadersTableAnnotationComposer,
    $$ReadersTableCreateCompanionBuilder,
    $$ReadersTableUpdateCompanionBuilder,
    (Reader, BaseReferences<_$AppDatabase, $ReadersTable, Reader>),
    Reader,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ReadersTableTableManager get readers =>
      $$ReadersTableTableManager(_db, _db.readers);
}
