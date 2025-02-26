// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ClientsTable extends Clients with TableInfo<$ClientsTable, Client> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contactInfoMeta =
      const VerificationMeta('contactInfo');
  @override
  late final GeneratedColumn<String> contactInfo = GeneratedColumn<String>(
      'contact_info', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _additionalInfoMeta =
      const VerificationMeta('additionalInfo');
  @override
  late final GeneratedColumn<String> additionalInfo = GeneratedColumn<String>(
      'additional_info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, name, contactInfo, additionalInfo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients';
  @override
  VerificationContext validateIntegrity(Insertable<Client> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('contact_info')) {
      context.handle(
          _contactInfoMeta,
          contactInfo.isAcceptableOrUnknown(
              data['contact_info']!, _contactInfoMeta));
    } else if (isInserting) {
      context.missing(_contactInfoMeta);
    }
    if (data.containsKey('additional_info')) {
      context.handle(
          _additionalInfoMeta,
          additionalInfo.isAcceptableOrUnknown(
              data['additional_info']!, _additionalInfoMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Client map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Client(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      contactInfo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_info'])!,
      additionalInfo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}additional_info']),
    );
  }

  @override
  $ClientsTable createAlias(String alias) {
    return $ClientsTable(attachedDatabase, alias);
  }
}

class Client extends DataClass implements Insertable<Client> {
  final String id;
  final String type;
  final String name;
  final String contactInfo;
  final String? additionalInfo;
  const Client(
      {required this.id,
      required this.type,
      required this.name,
      required this.contactInfo,
      this.additionalInfo});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    map['contact_info'] = Variable<String>(contactInfo);
    if (!nullToAbsent || additionalInfo != null) {
      map['additional_info'] = Variable<String>(additionalInfo);
    }
    return map;
  }

  ClientsCompanion toCompanion(bool nullToAbsent) {
    return ClientsCompanion(
      id: Value(id),
      type: Value(type),
      name: Value(name),
      contactInfo: Value(contactInfo),
      additionalInfo: additionalInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(additionalInfo),
    );
  }

  factory Client.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Client(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      contactInfo: serializer.fromJson<String>(json['contactInfo']),
      additionalInfo: serializer.fromJson<String?>(json['additionalInfo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'contactInfo': serializer.toJson<String>(contactInfo),
      'additionalInfo': serializer.toJson<String?>(additionalInfo),
    };
  }

  Client copyWith(
          {String? id,
          String? type,
          String? name,
          String? contactInfo,
          Value<String?> additionalInfo = const Value.absent()}) =>
      Client(
        id: id ?? this.id,
        type: type ?? this.type,
        name: name ?? this.name,
        contactInfo: contactInfo ?? this.contactInfo,
        additionalInfo:
            additionalInfo.present ? additionalInfo.value : this.additionalInfo,
      );
  Client copyWithCompanion(ClientsCompanion data) {
    return Client(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      contactInfo:
          data.contactInfo.present ? data.contactInfo.value : this.contactInfo,
      additionalInfo: data.additionalInfo.present
          ? data.additionalInfo.value
          : this.additionalInfo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Client(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('contactInfo: $contactInfo, ')
          ..write('additionalInfo: $additionalInfo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, name, contactInfo, additionalInfo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Client &&
          other.id == this.id &&
          other.type == this.type &&
          other.name == this.name &&
          other.contactInfo == this.contactInfo &&
          other.additionalInfo == this.additionalInfo);
}

class ClientsCompanion extends UpdateCompanion<Client> {
  final Value<String> id;
  final Value<String> type;
  final Value<String> name;
  final Value<String> contactInfo;
  final Value<String?> additionalInfo;
  final Value<int> rowid;
  const ClientsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.contactInfo = const Value.absent(),
    this.additionalInfo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClientsCompanion.insert({
    required String id,
    required String type,
    required String name,
    required String contactInfo,
    this.additionalInfo = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        name = Value(name),
        contactInfo = Value(contactInfo);
  static Insertable<Client> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? contactInfo,
    Expression<String>? additionalInfo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (contactInfo != null) 'contact_info': contactInfo,
      if (additionalInfo != null) 'additional_info': additionalInfo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClientsCompanion copyWith(
      {Value<String>? id,
      Value<String>? type,
      Value<String>? name,
      Value<String>? contactInfo,
      Value<String?>? additionalInfo,
      Value<int>? rowid}) {
    return ClientsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      contactInfo: contactInfo ?? this.contactInfo,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (contactInfo.present) {
      map['contact_info'] = Variable<String>(contactInfo.value);
    }
    if (additionalInfo.present) {
      map['additional_info'] = Variable<String>(additionalInfo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('contactInfo: $contactInfo, ')
          ..write('additionalInfo: $additionalInfo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientsTable clients = $ClientsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [clients];
}

typedef $$ClientsTableCreateCompanionBuilder = ClientsCompanion Function({
  required String id,
  required String type,
  required String name,
  required String contactInfo,
  Value<String?> additionalInfo,
  Value<int> rowid,
});
typedef $$ClientsTableUpdateCompanionBuilder = ClientsCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<String> name,
  Value<String> contactInfo,
  Value<String?> additionalInfo,
  Value<int> rowid,
});

class $$ClientsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contactInfo => $composableBuilder(
      column: $table.contactInfo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get additionalInfo => $composableBuilder(
      column: $table.additionalInfo,
      builder: (column) => ColumnFilters(column));
}

class $$ClientsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contactInfo => $composableBuilder(
      column: $table.contactInfo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get additionalInfo => $composableBuilder(
      column: $table.additionalInfo,
      builder: (column) => ColumnOrderings(column));
}

class $$ClientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsTable> {
  $$ClientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get contactInfo => $composableBuilder(
      column: $table.contactInfo, builder: (column) => column);

  GeneratedColumn<String> get additionalInfo => $composableBuilder(
      column: $table.additionalInfo, builder: (column) => column);
}

class $$ClientsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClientsTable,
    Client,
    $$ClientsTableFilterComposer,
    $$ClientsTableOrderingComposer,
    $$ClientsTableAnnotationComposer,
    $$ClientsTableCreateCompanionBuilder,
    $$ClientsTableUpdateCompanionBuilder,
    (Client, BaseReferences<_$AppDatabase, $ClientsTable, Client>),
    Client,
    PrefetchHooks Function()> {
  $$ClientsTableTableManager(_$AppDatabase db, $ClientsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> contactInfo = const Value.absent(),
            Value<String?> additionalInfo = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClientsCompanion(
            id: id,
            type: type,
            name: name,
            contactInfo: contactInfo,
            additionalInfo: additionalInfo,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String type,
            required String name,
            required String contactInfo,
            Value<String?> additionalInfo = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ClientsCompanion.insert(
            id: id,
            type: type,
            name: name,
            contactInfo: contactInfo,
            additionalInfo: additionalInfo,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ClientsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClientsTable,
    Client,
    $$ClientsTableFilterComposer,
    $$ClientsTableOrderingComposer,
    $$ClientsTableAnnotationComposer,
    $$ClientsTableCreateCompanionBuilder,
    $$ClientsTableUpdateCompanionBuilder,
    (Client, BaseReferences<_$AppDatabase, $ClientsTable, Client>),
    Client,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientsTableTableManager get clients =>
      $$ClientsTableTableManager(_db, _db.clients);
}
