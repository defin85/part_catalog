// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ClientsItemsTable extends ClientsItems
    with TableInfo<$ClientsItemsTable, ClientsItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClientsItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
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
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _modifiedAtMeta =
      const VerificationMeta('modifiedAt');
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
      'modified_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        code,
        type,
        name,
        contactInfo,
        additionalInfo,
        createdAt,
        modifiedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clients_items';
  @override
  VerificationContext validateIntegrity(Insertable<ClientsItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
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
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('modified_at')) {
      context.handle(
          _modifiedAtMeta,
          modifiedAt.isAcceptableOrUnknown(
              data['modified_at']!, _modifiedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClientsItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClientsItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      contactInfo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_info'])!,
      additionalInfo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}additional_info']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      modifiedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified_at']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $ClientsItemsTable createAlias(String alias) {
    return $ClientsItemsTable(attachedDatabase, alias);
  }
}

class ClientsItem extends DataClass implements Insertable<ClientsItem> {
  final int id;
  final String uuid;
  final String code;
  final String type;
  final String name;
  final String contactInfo;
  final String? additionalInfo;
  final DateTime createdAt;
  final DateTime? modifiedAt;
  final DateTime? deletedAt;
  const ClientsItem(
      {required this.id,
      required this.uuid,
      required this.code,
      required this.type,
      required this.name,
      required this.contactInfo,
      this.additionalInfo,
      required this.createdAt,
      this.modifiedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['code'] = Variable<String>(code);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    map['contact_info'] = Variable<String>(contactInfo);
    if (!nullToAbsent || additionalInfo != null) {
      map['additional_info'] = Variable<String>(additionalInfo);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || modifiedAt != null) {
      map['modified_at'] = Variable<DateTime>(modifiedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ClientsItemsCompanion toCompanion(bool nullToAbsent) {
    return ClientsItemsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      code: Value(code),
      type: Value(type),
      name: Value(name),
      contactInfo: Value(contactInfo),
      additionalInfo: additionalInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(additionalInfo),
      createdAt: Value(createdAt),
      modifiedAt: modifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory ClientsItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClientsItem(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      code: serializer.fromJson<String>(json['code']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      contactInfo: serializer.fromJson<String>(json['contactInfo']),
      additionalInfo: serializer.fromJson<String?>(json['additionalInfo']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime?>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'code': serializer.toJson<String>(code),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'contactInfo': serializer.toJson<String>(contactInfo),
      'additionalInfo': serializer.toJson<String?>(additionalInfo),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime?>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ClientsItem copyWith(
          {int? id,
          String? uuid,
          String? code,
          String? type,
          String? name,
          String? contactInfo,
          Value<String?> additionalInfo = const Value.absent(),
          DateTime? createdAt,
          Value<DateTime?> modifiedAt = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      ClientsItem(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        code: code ?? this.code,
        type: type ?? this.type,
        name: name ?? this.name,
        contactInfo: contactInfo ?? this.contactInfo,
        additionalInfo:
            additionalInfo.present ? additionalInfo.value : this.additionalInfo,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt.present ? modifiedAt.value : this.modifiedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  ClientsItem copyWithCompanion(ClientsItemsCompanion data) {
    return ClientsItem(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      code: data.code.present ? data.code.value : this.code,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      contactInfo:
          data.contactInfo.present ? data.contactInfo.value : this.contactInfo,
      additionalInfo: data.additionalInfo.present
          ? data.additionalInfo.value
          : this.additionalInfo,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt:
          data.modifiedAt.present ? data.modifiedAt.value : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClientsItem(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('code: $code, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('contactInfo: $contactInfo, ')
          ..write('additionalInfo: $additionalInfo, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, code, type, name, contactInfo,
      additionalInfo, createdAt, modifiedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientsItem &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.code == this.code &&
          other.type == this.type &&
          other.name == this.name &&
          other.contactInfo == this.contactInfo &&
          other.additionalInfo == this.additionalInfo &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class ClientsItemsCompanion extends UpdateCompanion<ClientsItem> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> code;
  final Value<String> type;
  final Value<String> name;
  final Value<String> contactInfo;
  final Value<String?> additionalInfo;
  final Value<DateTime> createdAt;
  final Value<DateTime?> modifiedAt;
  final Value<DateTime?> deletedAt;
  const ClientsItemsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.code = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.contactInfo = const Value.absent(),
    this.additionalInfo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  ClientsItemsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required String code,
    required String type,
    required String name,
    required String contactInfo,
    this.additionalInfo = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  })  : code = Value(code),
        type = Value(type),
        name = Value(name),
        contactInfo = Value(contactInfo);
  static Insertable<ClientsItem> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? code,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? contactInfo,
    Expression<String>? additionalInfo,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (code != null) 'code': code,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (contactInfo != null) 'contact_info': contactInfo,
      if (additionalInfo != null) 'additional_info': additionalInfo,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  ClientsItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? code,
      Value<String>? type,
      Value<String>? name,
      Value<String>? contactInfo,
      Value<String?>? additionalInfo,
      Value<DateTime>? createdAt,
      Value<DateTime?>? modifiedAt,
      Value<DateTime?>? deletedAt}) {
    return ClientsItemsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      code: code ?? this.code,
      type: type ?? this.type,
      name: name ?? this.name,
      contactInfo: contactInfo ?? this.contactInfo,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
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
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsItemsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('code: $code, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('contactInfo: $contactInfo, ')
          ..write('additionalInfo: $additionalInfo, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $CarsItemsTable extends CarsItems
    with TableInfo<$CarsItemsTable, CarsItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CarsItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _clientIdMeta =
      const VerificationMeta('clientId');
  @override
  late final GeneratedColumn<int> clientId = GeneratedColumn<int>(
      'client_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES clients_items (id)'));
  static const VerificationMeta _vinMeta = const VerificationMeta('vin');
  @override
  late final GeneratedColumn<String> vin = GeneratedColumn<String>(
      'vin', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _makeMeta = const VerificationMeta('make');
  @override
  late final GeneratedColumn<String> make = GeneratedColumn<String>(
      'make', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
      'model', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _licensePlateMeta =
      const VerificationMeta('licensePlate');
  @override
  late final GeneratedColumn<String> licensePlate = GeneratedColumn<String>(
      'license_plate', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _additionalInfoMeta =
      const VerificationMeta('additionalInfo');
  @override
  late final GeneratedColumn<String> additionalInfo = GeneratedColumn<String>(
      'additional_info', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
      'code', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _modifiedAtMeta =
      const VerificationMeta('modifiedAt');
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
      'modified_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        clientId,
        vin,
        make,
        model,
        year,
        licensePlate,
        additionalInfo,
        code,
        createdAt,
        modifiedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cars_items';
  @override
  VerificationContext validateIntegrity(Insertable<CarsItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    }
    if (data.containsKey('client_id')) {
      context.handle(_clientIdMeta,
          clientId.isAcceptableOrUnknown(data['client_id']!, _clientIdMeta));
    } else if (isInserting) {
      context.missing(_clientIdMeta);
    }
    if (data.containsKey('vin')) {
      context.handle(
          _vinMeta, vin.isAcceptableOrUnknown(data['vin']!, _vinMeta));
    }
    if (data.containsKey('make')) {
      context.handle(
          _makeMeta, make.isAcceptableOrUnknown(data['make']!, _makeMeta));
    } else if (isInserting) {
      context.missing(_makeMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
          _modelMeta, model.isAcceptableOrUnknown(data['model']!, _modelMeta));
    } else if (isInserting) {
      context.missing(_modelMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    }
    if (data.containsKey('license_plate')) {
      context.handle(
          _licensePlateMeta,
          licensePlate.isAcceptableOrUnknown(
              data['license_plate']!, _licensePlateMeta));
    }
    if (data.containsKey('additional_info')) {
      context.handle(
          _additionalInfoMeta,
          additionalInfo.isAcceptableOrUnknown(
              data['additional_info']!, _additionalInfoMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('modified_at')) {
      context.handle(
          _modifiedAtMeta,
          modifiedAt.isAcceptableOrUnknown(
              data['modified_at']!, _modifiedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CarsItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CarsItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      clientId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}client_id'])!,
      vin: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}vin']),
      make: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}make'])!,
      model: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}model'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year']),
      licensePlate: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}license_plate']),
      additionalInfo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}additional_info']),
      code: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}code'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      modifiedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified_at']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $CarsItemsTable createAlias(String alias) {
    return $CarsItemsTable(attachedDatabase, alias);
  }
}

class CarsItem extends DataClass implements Insertable<CarsItem> {
  final int id;
  final String uuid;
  final int clientId;
  final String? vin;
  final String make;
  final String model;
  final int? year;
  final String? licensePlate;
  final String? additionalInfo;
  final String code;
  final DateTime createdAt;
  final DateTime? modifiedAt;
  final DateTime? deletedAt;
  const CarsItem(
      {required this.id,
      required this.uuid,
      required this.clientId,
      this.vin,
      required this.make,
      required this.model,
      this.year,
      this.licensePlate,
      this.additionalInfo,
      required this.code,
      required this.createdAt,
      this.modifiedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['client_id'] = Variable<int>(clientId);
    if (!nullToAbsent || vin != null) {
      map['vin'] = Variable<String>(vin);
    }
    map['make'] = Variable<String>(make);
    map['model'] = Variable<String>(model);
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || licensePlate != null) {
      map['license_plate'] = Variable<String>(licensePlate);
    }
    if (!nullToAbsent || additionalInfo != null) {
      map['additional_info'] = Variable<String>(additionalInfo);
    }
    map['code'] = Variable<String>(code);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || modifiedAt != null) {
      map['modified_at'] = Variable<DateTime>(modifiedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  CarsItemsCompanion toCompanion(bool nullToAbsent) {
    return CarsItemsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      clientId: Value(clientId),
      vin: vin == null && nullToAbsent ? const Value.absent() : Value(vin),
      make: Value(make),
      model: Value(model),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      licensePlate: licensePlate == null && nullToAbsent
          ? const Value.absent()
          : Value(licensePlate),
      additionalInfo: additionalInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(additionalInfo),
      code: Value(code),
      createdAt: Value(createdAt),
      modifiedAt: modifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory CarsItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CarsItem(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      clientId: serializer.fromJson<int>(json['clientId']),
      vin: serializer.fromJson<String?>(json['vin']),
      make: serializer.fromJson<String>(json['make']),
      model: serializer.fromJson<String>(json['model']),
      year: serializer.fromJson<int?>(json['year']),
      licensePlate: serializer.fromJson<String?>(json['licensePlate']),
      additionalInfo: serializer.fromJson<String?>(json['additionalInfo']),
      code: serializer.fromJson<String>(json['code']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime?>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'clientId': serializer.toJson<int>(clientId),
      'vin': serializer.toJson<String?>(vin),
      'make': serializer.toJson<String>(make),
      'model': serializer.toJson<String>(model),
      'year': serializer.toJson<int?>(year),
      'licensePlate': serializer.toJson<String?>(licensePlate),
      'additionalInfo': serializer.toJson<String?>(additionalInfo),
      'code': serializer.toJson<String>(code),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime?>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  CarsItem copyWith(
          {int? id,
          String? uuid,
          int? clientId,
          Value<String?> vin = const Value.absent(),
          String? make,
          String? model,
          Value<int?> year = const Value.absent(),
          Value<String?> licensePlate = const Value.absent(),
          Value<String?> additionalInfo = const Value.absent(),
          String? code,
          DateTime? createdAt,
          Value<DateTime?> modifiedAt = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      CarsItem(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        clientId: clientId ?? this.clientId,
        vin: vin.present ? vin.value : this.vin,
        make: make ?? this.make,
        model: model ?? this.model,
        year: year.present ? year.value : this.year,
        licensePlate:
            licensePlate.present ? licensePlate.value : this.licensePlate,
        additionalInfo:
            additionalInfo.present ? additionalInfo.value : this.additionalInfo,
        code: code ?? this.code,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt.present ? modifiedAt.value : this.modifiedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  CarsItem copyWithCompanion(CarsItemsCompanion data) {
    return CarsItem(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      clientId: data.clientId.present ? data.clientId.value : this.clientId,
      vin: data.vin.present ? data.vin.value : this.vin,
      make: data.make.present ? data.make.value : this.make,
      model: data.model.present ? data.model.value : this.model,
      year: data.year.present ? data.year.value : this.year,
      licensePlate: data.licensePlate.present
          ? data.licensePlate.value
          : this.licensePlate,
      additionalInfo: data.additionalInfo.present
          ? data.additionalInfo.value
          : this.additionalInfo,
      code: data.code.present ? data.code.value : this.code,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt:
          data.modifiedAt.present ? data.modifiedAt.value : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CarsItem(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('clientId: $clientId, ')
          ..write('vin: $vin, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('licensePlate: $licensePlate, ')
          ..write('additionalInfo: $additionalInfo, ')
          ..write('code: $code, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uuid, clientId, vin, make, model, year,
      licensePlate, additionalInfo, code, createdAt, modifiedAt, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CarsItem &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.clientId == this.clientId &&
          other.vin == this.vin &&
          other.make == this.make &&
          other.model == this.model &&
          other.year == this.year &&
          other.licensePlate == this.licensePlate &&
          other.additionalInfo == this.additionalInfo &&
          other.code == this.code &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class CarsItemsCompanion extends UpdateCompanion<CarsItem> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<int> clientId;
  final Value<String?> vin;
  final Value<String> make;
  final Value<String> model;
  final Value<int?> year;
  final Value<String?> licensePlate;
  final Value<String?> additionalInfo;
  final Value<String> code;
  final Value<DateTime> createdAt;
  final Value<DateTime?> modifiedAt;
  final Value<DateTime?> deletedAt;
  const CarsItemsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.clientId = const Value.absent(),
    this.vin = const Value.absent(),
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.licensePlate = const Value.absent(),
    this.additionalInfo = const Value.absent(),
    this.code = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  CarsItemsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required int clientId,
    this.vin = const Value.absent(),
    required String make,
    required String model,
    this.year = const Value.absent(),
    this.licensePlate = const Value.absent(),
    this.additionalInfo = const Value.absent(),
    this.code = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  })  : clientId = Value(clientId),
        make = Value(make),
        model = Value(model);
  static Insertable<CarsItem> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<int>? clientId,
    Expression<String>? vin,
    Expression<String>? make,
    Expression<String>? model,
    Expression<int>? year,
    Expression<String>? licensePlate,
    Expression<String>? additionalInfo,
    Expression<String>? code,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (clientId != null) 'client_id': clientId,
      if (vin != null) 'vin': vin,
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (licensePlate != null) 'license_plate': licensePlate,
      if (additionalInfo != null) 'additional_info': additionalInfo,
      if (code != null) 'code': code,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  CarsItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<int>? clientId,
      Value<String?>? vin,
      Value<String>? make,
      Value<String>? model,
      Value<int?>? year,
      Value<String?>? licensePlate,
      Value<String?>? additionalInfo,
      Value<String>? code,
      Value<DateTime>? createdAt,
      Value<DateTime?>? modifiedAt,
      Value<DateTime?>? deletedAt}) {
    return CarsItemsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      clientId: clientId ?? this.clientId,
      vin: vin ?? this.vin,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      licensePlate: licensePlate ?? this.licensePlate,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (clientId.present) {
      map['client_id'] = Variable<int>(clientId.value);
    }
    if (vin.present) {
      map['vin'] = Variable<String>(vin.value);
    }
    if (make.present) {
      map['make'] = Variable<String>(make.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (licensePlate.present) {
      map['license_plate'] = Variable<String>(licensePlate.value);
    }
    if (additionalInfo.present) {
      map['additional_info'] = Variable<String>(additionalInfo.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarsItemsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('clientId: $clientId, ')
          ..write('vin: $vin, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('licensePlate: $licensePlate, ')
          ..write('additionalInfo: $additionalInfo, ')
          ..write('code: $code, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $OrdersItemsTable extends OrdersItems
    with TableInfo<$OrdersItemsTable, OrdersItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _clientUuidMeta =
      const VerificationMeta('clientUuid');
  @override
  late final GeneratedColumn<String> clientUuid = GeneratedColumn<String>(
      'client_uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES clients_items (uuid)'));
  static const VerificationMeta _carUuidMeta =
      const VerificationMeta('carUuid');
  @override
  late final GeneratedColumn<String> carUuid = GeneratedColumn<String>(
      'car_uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES cars_items (uuid)'));
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
      'number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _scheduledDateMeta =
      const VerificationMeta('scheduledDate');
  @override
  late final GeneratedColumn<DateTime> scheduledDate =
      GeneratedColumn<DateTime>('scheduled_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _completedAtMeta =
      const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
      'completed_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _isPostedMeta =
      const VerificationMeta('isPosted');
  @override
  late final GeneratedColumn<bool> isPosted = GeneratedColumn<bool>(
      'is_posted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_posted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _modifiedAtMeta =
      const VerificationMeta('modifiedAt');
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
      'modified_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        clientUuid,
        carUuid,
        number,
        date,
        scheduledDate,
        completedAt,
        status,
        description,
        totalAmount,
        isPosted,
        createdAt,
        modifiedAt,
        deletedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders_items';
  @override
  VerificationContext validateIntegrity(Insertable<OrdersItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    }
    if (data.containsKey('client_uuid')) {
      context.handle(
          _clientUuidMeta,
          clientUuid.isAcceptableOrUnknown(
              data['client_uuid']!, _clientUuidMeta));
    } else if (isInserting) {
      context.missing(_clientUuidMeta);
    }
    if (data.containsKey('car_uuid')) {
      context.handle(_carUuidMeta,
          carUuid.isAcceptableOrUnknown(data['car_uuid']!, _carUuidMeta));
    } else if (isInserting) {
      context.missing(_carUuidMeta);
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
          _scheduledDateMeta,
          scheduledDate.isAcceptableOrUnknown(
              data['scheduled_date']!, _scheduledDateMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(
          _completedAtMeta,
          completedAt.isAcceptableOrUnknown(
              data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    }
    if (data.containsKey('is_posted')) {
      context.handle(_isPostedMeta,
          isPosted.isAcceptableOrUnknown(data['is_posted']!, _isPostedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
          _modifiedAtMeta,
          modifiedAt.isAcceptableOrUnknown(
              data['modified_at']!, _modifiedAtMeta));
    }
    if (data.containsKey('deleted_at')) {
      context.handle(_deletedAtMeta,
          deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrdersItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrdersItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      clientUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_uuid'])!,
      carUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}car_uuid'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}number'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      scheduledDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}scheduled_date']),
      completedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}completed_at']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      isPosted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_posted'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      modifiedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified_at']),
      deletedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}deleted_at']),
    );
  }

  @override
  $OrdersItemsTable createAlias(String alias) {
    return $OrdersItemsTable(attachedDatabase, alias);
  }
}

class OrdersItem extends DataClass implements Insertable<OrdersItem> {
  final int id;
  final String uuid;
  final String clientUuid;
  final String carUuid;
  final String number;
  final DateTime date;
  final DateTime? scheduledDate;
  final DateTime? completedAt;
  final String status;
  final String? description;
  final double totalAmount;
  final bool isPosted;
  final DateTime createdAt;
  final DateTime? modifiedAt;
  final DateTime? deletedAt;
  const OrdersItem(
      {required this.id,
      required this.uuid,
      required this.clientUuid,
      required this.carUuid,
      required this.number,
      required this.date,
      this.scheduledDate,
      this.completedAt,
      required this.status,
      this.description,
      required this.totalAmount,
      required this.isPosted,
      required this.createdAt,
      this.modifiedAt,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['client_uuid'] = Variable<String>(clientUuid);
    map['car_uuid'] = Variable<String>(carUuid);
    map['number'] = Variable<String>(number);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || scheduledDate != null) {
      map['scheduled_date'] = Variable<DateTime>(scheduledDate);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['total_amount'] = Variable<double>(totalAmount);
    map['is_posted'] = Variable<bool>(isPosted);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || modifiedAt != null) {
      map['modified_at'] = Variable<DateTime>(modifiedAt);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  OrdersItemsCompanion toCompanion(bool nullToAbsent) {
    return OrdersItemsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      clientUuid: Value(clientUuid),
      carUuid: Value(carUuid),
      number: Value(number),
      date: Value(date),
      scheduledDate: scheduledDate == null && nullToAbsent
          ? const Value.absent()
          : Value(scheduledDate),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      status: Value(status),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      totalAmount: Value(totalAmount),
      isPosted: Value(isPosted),
      createdAt: Value(createdAt),
      modifiedAt: modifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(modifiedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory OrdersItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrdersItem(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      clientUuid: serializer.fromJson<String>(json['clientUuid']),
      carUuid: serializer.fromJson<String>(json['carUuid']),
      number: serializer.fromJson<String>(json['number']),
      date: serializer.fromJson<DateTime>(json['date']),
      scheduledDate: serializer.fromJson<DateTime?>(json['scheduledDate']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      status: serializer.fromJson<String>(json['status']),
      description: serializer.fromJson<String?>(json['description']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      isPosted: serializer.fromJson<bool>(json['isPosted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime?>(json['modifiedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'clientUuid': serializer.toJson<String>(clientUuid),
      'carUuid': serializer.toJson<String>(carUuid),
      'number': serializer.toJson<String>(number),
      'date': serializer.toJson<DateTime>(date),
      'scheduledDate': serializer.toJson<DateTime?>(scheduledDate),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'status': serializer.toJson<String>(status),
      'description': serializer.toJson<String?>(description),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'isPosted': serializer.toJson<bool>(isPosted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime?>(modifiedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  OrdersItem copyWith(
          {int? id,
          String? uuid,
          String? clientUuid,
          String? carUuid,
          String? number,
          DateTime? date,
          Value<DateTime?> scheduledDate = const Value.absent(),
          Value<DateTime?> completedAt = const Value.absent(),
          String? status,
          Value<String?> description = const Value.absent(),
          double? totalAmount,
          bool? isPosted,
          DateTime? createdAt,
          Value<DateTime?> modifiedAt = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      OrdersItem(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        clientUuid: clientUuid ?? this.clientUuid,
        carUuid: carUuid ?? this.carUuid,
        number: number ?? this.number,
        date: date ?? this.date,
        scheduledDate:
            scheduledDate.present ? scheduledDate.value : this.scheduledDate,
        completedAt: completedAt.present ? completedAt.value : this.completedAt,
        status: status ?? this.status,
        description: description.present ? description.value : this.description,
        totalAmount: totalAmount ?? this.totalAmount,
        isPosted: isPosted ?? this.isPosted,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt.present ? modifiedAt.value : this.modifiedAt,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  OrdersItem copyWithCompanion(OrdersItemsCompanion data) {
    return OrdersItem(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      clientUuid:
          data.clientUuid.present ? data.clientUuid.value : this.clientUuid,
      carUuid: data.carUuid.present ? data.carUuid.value : this.carUuid,
      number: data.number.present ? data.number.value : this.number,
      date: data.date.present ? data.date.value : this.date,
      scheduledDate: data.scheduledDate.present
          ? data.scheduledDate.value
          : this.scheduledDate,
      completedAt:
          data.completedAt.present ? data.completedAt.value : this.completedAt,
      status: data.status.present ? data.status.value : this.status,
      description:
          data.description.present ? data.description.value : this.description,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      isPosted: data.isPosted.present ? data.isPosted.value : this.isPosted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt:
          data.modifiedAt.present ? data.modifiedAt.value : this.modifiedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrdersItem(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('carUuid: $carUuid, ')
          ..write('number: $number, ')
          ..write('date: $date, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('completedAt: $completedAt, ')
          ..write('status: $status, ')
          ..write('description: $description, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('isPosted: $isPosted, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      uuid,
      clientUuid,
      carUuid,
      number,
      date,
      scheduledDate,
      completedAt,
      status,
      description,
      totalAmount,
      isPosted,
      createdAt,
      modifiedAt,
      deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrdersItem &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.clientUuid == this.clientUuid &&
          other.carUuid == this.carUuid &&
          other.number == this.number &&
          other.date == this.date &&
          other.scheduledDate == this.scheduledDate &&
          other.completedAt == this.completedAt &&
          other.status == this.status &&
          other.description == this.description &&
          other.totalAmount == this.totalAmount &&
          other.isPosted == this.isPosted &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt &&
          other.deletedAt == this.deletedAt);
}

class OrdersItemsCompanion extends UpdateCompanion<OrdersItem> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> clientUuid;
  final Value<String> carUuid;
  final Value<String> number;
  final Value<DateTime> date;
  final Value<DateTime?> scheduledDate;
  final Value<DateTime?> completedAt;
  final Value<String> status;
  final Value<String?> description;
  final Value<double> totalAmount;
  final Value<bool> isPosted;
  final Value<DateTime> createdAt;
  final Value<DateTime?> modifiedAt;
  final Value<DateTime?> deletedAt;
  const OrdersItemsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.clientUuid = const Value.absent(),
    this.carUuid = const Value.absent(),
    this.number = const Value.absent(),
    this.date = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.description = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.isPosted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  OrdersItemsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required String clientUuid,
    required String carUuid,
    required String number,
    required DateTime date,
    this.scheduledDate = const Value.absent(),
    this.completedAt = const Value.absent(),
    required String status,
    this.description = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.isPosted = const Value.absent(),
    required DateTime createdAt,
    this.modifiedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
  })  : clientUuid = Value(clientUuid),
        carUuid = Value(carUuid),
        number = Value(number),
        date = Value(date),
        status = Value(status),
        createdAt = Value(createdAt);
  static Insertable<OrdersItem> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? clientUuid,
    Expression<String>? carUuid,
    Expression<String>? number,
    Expression<DateTime>? date,
    Expression<DateTime>? scheduledDate,
    Expression<DateTime>? completedAt,
    Expression<String>? status,
    Expression<String>? description,
    Expression<double>? totalAmount,
    Expression<bool>? isPosted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (clientUuid != null) 'client_uuid': clientUuid,
      if (carUuid != null) 'car_uuid': carUuid,
      if (number != null) 'number': number,
      if (date != null) 'date': date,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (completedAt != null) 'completed_at': completedAt,
      if (status != null) 'status': status,
      if (description != null) 'description': description,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (isPosted != null) 'is_posted': isPosted,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  OrdersItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? clientUuid,
      Value<String>? carUuid,
      Value<String>? number,
      Value<DateTime>? date,
      Value<DateTime?>? scheduledDate,
      Value<DateTime?>? completedAt,
      Value<String>? status,
      Value<String?>? description,
      Value<double>? totalAmount,
      Value<bool>? isPosted,
      Value<DateTime>? createdAt,
      Value<DateTime?>? modifiedAt,
      Value<DateTime?>? deletedAt}) {
    return OrdersItemsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      clientUuid: clientUuid ?? this.clientUuid,
      carUuid: carUuid ?? this.carUuid,
      number: number ?? this.number,
      date: date ?? this.date,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      completedAt: completedAt ?? this.completedAt,
      status: status ?? this.status,
      description: description ?? this.description,
      totalAmount: totalAmount ?? this.totalAmount,
      isPosted: isPosted ?? this.isPosted,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (clientUuid.present) {
      map['client_uuid'] = Variable<String>(clientUuid.value);
    }
    if (carUuid.present) {
      map['car_uuid'] = Variable<String>(carUuid.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<DateTime>(scheduledDate.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (isPosted.present) {
      map['is_posted'] = Variable<bool>(isPosted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersItemsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('clientUuid: $clientUuid, ')
          ..write('carUuid: $carUuid, ')
          ..write('number: $number, ')
          ..write('date: $date, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('completedAt: $completedAt, ')
          ..write('status: $status, ')
          ..write('description: $description, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('isPosted: $isPosted, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $OrderPartsItemsTable extends OrderPartsItems
    with TableInfo<$OrderPartsItemsTable, OrderPartsItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderPartsItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _documentUuidMeta =
      const VerificationMeta('documentUuid');
  @override
  late final GeneratedColumn<String> documentUuid = GeneratedColumn<String>(
      'document_uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orders_items (uuid)'));
  static const VerificationMeta _lineNumberMeta =
      const VerificationMeta('lineNumber');
  @override
  late final GeneratedColumn<int> lineNumber = GeneratedColumn<int>(
      'line_number', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _partNumberMeta =
      const VerificationMeta('partNumber');
  @override
  late final GeneratedColumn<String> partNumber = GeneratedColumn<String>(
      'part_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
      'brand', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
      'quantity', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _supplierNameMeta =
      const VerificationMeta('supplierName');
  @override
  late final GeneratedColumn<String> supplierName = GeneratedColumn<String>(
      'supplier_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deliveryDaysMeta =
      const VerificationMeta('deliveryDays');
  @override
  late final GeneratedColumn<int> deliveryDays = GeneratedColumn<int>(
      'delivery_days', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _isOrderedMeta =
      const VerificationMeta('isOrdered');
  @override
  late final GeneratedColumn<bool> isOrdered = GeneratedColumn<bool>(
      'is_ordered', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_ordered" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isReceivedMeta =
      const VerificationMeta('isReceived');
  @override
  late final GeneratedColumn<bool> isReceived = GeneratedColumn<bool>(
      'is_received', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_received" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _modifiedAtMeta =
      const VerificationMeta('modifiedAt');
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
      'modified_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        documentUuid,
        lineNumber,
        partNumber,
        name,
        brand,
        quantity,
        price,
        supplierName,
        deliveryDays,
        isOrdered,
        isReceived,
        createdAt,
        modifiedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_parts_items';
  @override
  VerificationContext validateIntegrity(Insertable<OrderPartsItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    }
    if (data.containsKey('document_uuid')) {
      context.handle(
          _documentUuidMeta,
          documentUuid.isAcceptableOrUnknown(
              data['document_uuid']!, _documentUuidMeta));
    } else if (isInserting) {
      context.missing(_documentUuidMeta);
    }
    if (data.containsKey('line_number')) {
      context.handle(
          _lineNumberMeta,
          lineNumber.isAcceptableOrUnknown(
              data['line_number']!, _lineNumberMeta));
    }
    if (data.containsKey('part_number')) {
      context.handle(
          _partNumberMeta,
          partNumber.isAcceptableOrUnknown(
              data['part_number']!, _partNumberMeta));
    } else if (isInserting) {
      context.missing(_partNumberMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
          _brandMeta, brand.isAcceptableOrUnknown(data['brand']!, _brandMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('supplier_name')) {
      context.handle(
          _supplierNameMeta,
          supplierName.isAcceptableOrUnknown(
              data['supplier_name']!, _supplierNameMeta));
    }
    if (data.containsKey('delivery_days')) {
      context.handle(
          _deliveryDaysMeta,
          deliveryDays.isAcceptableOrUnknown(
              data['delivery_days']!, _deliveryDaysMeta));
    }
    if (data.containsKey('is_ordered')) {
      context.handle(_isOrderedMeta,
          isOrdered.isAcceptableOrUnknown(data['is_ordered']!, _isOrderedMeta));
    }
    if (data.containsKey('is_received')) {
      context.handle(
          _isReceivedMeta,
          isReceived.isAcceptableOrUnknown(
              data['is_received']!, _isReceivedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
          _modifiedAtMeta,
          modifiedAt.isAcceptableOrUnknown(
              data['modified_at']!, _modifiedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderPartsItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderPartsItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      documentUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_uuid'])!,
      lineNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line_number'])!,
      partNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}part_number'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      brand: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}brand']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}quantity'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      supplierName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_name']),
      deliveryDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}delivery_days']),
      isOrdered: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_ordered'])!,
      isReceived: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_received'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      modifiedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified_at']),
    );
  }

  @override
  $OrderPartsItemsTable createAlias(String alias) {
    return $OrderPartsItemsTable(attachedDatabase, alias);
  }
}

class OrderPartsItem extends DataClass implements Insertable<OrderPartsItem> {
  final int id;
  final String uuid;
  final String documentUuid;
  final int lineNumber;
  final String partNumber;
  final String name;
  final String? brand;
  final double quantity;
  final double price;
  final String? supplierName;
  final int? deliveryDays;
  final bool isOrdered;
  final bool isReceived;
  final DateTime createdAt;
  final DateTime? modifiedAt;
  const OrderPartsItem(
      {required this.id,
      required this.uuid,
      required this.documentUuid,
      required this.lineNumber,
      required this.partNumber,
      required this.name,
      this.brand,
      required this.quantity,
      required this.price,
      this.supplierName,
      this.deliveryDays,
      required this.isOrdered,
      required this.isReceived,
      required this.createdAt,
      this.modifiedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['document_uuid'] = Variable<String>(documentUuid);
    map['line_number'] = Variable<int>(lineNumber);
    map['part_number'] = Variable<String>(partNumber);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    map['quantity'] = Variable<double>(quantity);
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || supplierName != null) {
      map['supplier_name'] = Variable<String>(supplierName);
    }
    if (!nullToAbsent || deliveryDays != null) {
      map['delivery_days'] = Variable<int>(deliveryDays);
    }
    map['is_ordered'] = Variable<bool>(isOrdered);
    map['is_received'] = Variable<bool>(isReceived);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || modifiedAt != null) {
      map['modified_at'] = Variable<DateTime>(modifiedAt);
    }
    return map;
  }

  OrderPartsItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderPartsItemsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      documentUuid: Value(documentUuid),
      lineNumber: Value(lineNumber),
      partNumber: Value(partNumber),
      name: Value(name),
      brand:
          brand == null && nullToAbsent ? const Value.absent() : Value(brand),
      quantity: Value(quantity),
      price: Value(price),
      supplierName: supplierName == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierName),
      deliveryDays: deliveryDays == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryDays),
      isOrdered: Value(isOrdered),
      isReceived: Value(isReceived),
      createdAt: Value(createdAt),
      modifiedAt: modifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(modifiedAt),
    );
  }

  factory OrderPartsItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderPartsItem(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      documentUuid: serializer.fromJson<String>(json['documentUuid']),
      lineNumber: serializer.fromJson<int>(json['lineNumber']),
      partNumber: serializer.fromJson<String>(json['partNumber']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      quantity: serializer.fromJson<double>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
      supplierName: serializer.fromJson<String?>(json['supplierName']),
      deliveryDays: serializer.fromJson<int?>(json['deliveryDays']),
      isOrdered: serializer.fromJson<bool>(json['isOrdered']),
      isReceived: serializer.fromJson<bool>(json['isReceived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime?>(json['modifiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'documentUuid': serializer.toJson<String>(documentUuid),
      'lineNumber': serializer.toJson<int>(lineNumber),
      'partNumber': serializer.toJson<String>(partNumber),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'quantity': serializer.toJson<double>(quantity),
      'price': serializer.toJson<double>(price),
      'supplierName': serializer.toJson<String?>(supplierName),
      'deliveryDays': serializer.toJson<int?>(deliveryDays),
      'isOrdered': serializer.toJson<bool>(isOrdered),
      'isReceived': serializer.toJson<bool>(isReceived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime?>(modifiedAt),
    };
  }

  OrderPartsItem copyWith(
          {int? id,
          String? uuid,
          String? documentUuid,
          int? lineNumber,
          String? partNumber,
          String? name,
          Value<String?> brand = const Value.absent(),
          double? quantity,
          double? price,
          Value<String?> supplierName = const Value.absent(),
          Value<int?> deliveryDays = const Value.absent(),
          bool? isOrdered,
          bool? isReceived,
          DateTime? createdAt,
          Value<DateTime?> modifiedAt = const Value.absent()}) =>
      OrderPartsItem(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        documentUuid: documentUuid ?? this.documentUuid,
        lineNumber: lineNumber ?? this.lineNumber,
        partNumber: partNumber ?? this.partNumber,
        name: name ?? this.name,
        brand: brand.present ? brand.value : this.brand,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        supplierName:
            supplierName.present ? supplierName.value : this.supplierName,
        deliveryDays:
            deliveryDays.present ? deliveryDays.value : this.deliveryDays,
        isOrdered: isOrdered ?? this.isOrdered,
        isReceived: isReceived ?? this.isReceived,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt.present ? modifiedAt.value : this.modifiedAt,
      );
  OrderPartsItem copyWithCompanion(OrderPartsItemsCompanion data) {
    return OrderPartsItem(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      documentUuid: data.documentUuid.present
          ? data.documentUuid.value
          : this.documentUuid,
      lineNumber:
          data.lineNumber.present ? data.lineNumber.value : this.lineNumber,
      partNumber:
          data.partNumber.present ? data.partNumber.value : this.partNumber,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
      supplierName: data.supplierName.present
          ? data.supplierName.value
          : this.supplierName,
      deliveryDays: data.deliveryDays.present
          ? data.deliveryDays.value
          : this.deliveryDays,
      isOrdered: data.isOrdered.present ? data.isOrdered.value : this.isOrdered,
      isReceived:
          data.isReceived.present ? data.isReceived.value : this.isReceived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt:
          data.modifiedAt.present ? data.modifiedAt.value : this.modifiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderPartsItem(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('documentUuid: $documentUuid, ')
          ..write('lineNumber: $lineNumber, ')
          ..write('partNumber: $partNumber, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('supplierName: $supplierName, ')
          ..write('deliveryDays: $deliveryDays, ')
          ..write('isOrdered: $isOrdered, ')
          ..write('isReceived: $isReceived, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      uuid,
      documentUuid,
      lineNumber,
      partNumber,
      name,
      brand,
      quantity,
      price,
      supplierName,
      deliveryDays,
      isOrdered,
      isReceived,
      createdAt,
      modifiedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderPartsItem &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.documentUuid == this.documentUuid &&
          other.lineNumber == this.lineNumber &&
          other.partNumber == this.partNumber &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.supplierName == this.supplierName &&
          other.deliveryDays == this.deliveryDays &&
          other.isOrdered == this.isOrdered &&
          other.isReceived == this.isReceived &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt);
}

class OrderPartsItemsCompanion extends UpdateCompanion<OrderPartsItem> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> documentUuid;
  final Value<int> lineNumber;
  final Value<String> partNumber;
  final Value<String> name;
  final Value<String?> brand;
  final Value<double> quantity;
  final Value<double> price;
  final Value<String?> supplierName;
  final Value<int?> deliveryDays;
  final Value<bool> isOrdered;
  final Value<bool> isReceived;
  final Value<DateTime> createdAt;
  final Value<DateTime?> modifiedAt;
  const OrderPartsItemsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.documentUuid = const Value.absent(),
    this.lineNumber = const Value.absent(),
    this.partNumber = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.supplierName = const Value.absent(),
    this.deliveryDays = const Value.absent(),
    this.isOrdered = const Value.absent(),
    this.isReceived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
  });
  OrderPartsItemsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required String documentUuid,
    this.lineNumber = const Value.absent(),
    required String partNumber,
    required String name,
    this.brand = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.supplierName = const Value.absent(),
    this.deliveryDays = const Value.absent(),
    this.isOrdered = const Value.absent(),
    this.isReceived = const Value.absent(),
    required DateTime createdAt,
    this.modifiedAt = const Value.absent(),
  })  : documentUuid = Value(documentUuid),
        partNumber = Value(partNumber),
        name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<OrderPartsItem> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? documentUuid,
    Expression<int>? lineNumber,
    Expression<String>? partNumber,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<double>? quantity,
    Expression<double>? price,
    Expression<String>? supplierName,
    Expression<int>? deliveryDays,
    Expression<bool>? isOrdered,
    Expression<bool>? isReceived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (documentUuid != null) 'document_uuid': documentUuid,
      if (lineNumber != null) 'line_number': lineNumber,
      if (partNumber != null) 'part_number': partNumber,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (supplierName != null) 'supplier_name': supplierName,
      if (deliveryDays != null) 'delivery_days': deliveryDays,
      if (isOrdered != null) 'is_ordered': isOrdered,
      if (isReceived != null) 'is_received': isReceived,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
    });
  }

  OrderPartsItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? documentUuid,
      Value<int>? lineNumber,
      Value<String>? partNumber,
      Value<String>? name,
      Value<String?>? brand,
      Value<double>? quantity,
      Value<double>? price,
      Value<String?>? supplierName,
      Value<int?>? deliveryDays,
      Value<bool>? isOrdered,
      Value<bool>? isReceived,
      Value<DateTime>? createdAt,
      Value<DateTime?>? modifiedAt}) {
    return OrderPartsItemsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      documentUuid: documentUuid ?? this.documentUuid,
      lineNumber: lineNumber ?? this.lineNumber,
      partNumber: partNumber ?? this.partNumber,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      supplierName: supplierName ?? this.supplierName,
      deliveryDays: deliveryDays ?? this.deliveryDays,
      isOrdered: isOrdered ?? this.isOrdered,
      isReceived: isReceived ?? this.isReceived,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (documentUuid.present) {
      map['document_uuid'] = Variable<String>(documentUuid.value);
    }
    if (lineNumber.present) {
      map['line_number'] = Variable<int>(lineNumber.value);
    }
    if (partNumber.present) {
      map['part_number'] = Variable<String>(partNumber.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (supplierName.present) {
      map['supplier_name'] = Variable<String>(supplierName.value);
    }
    if (deliveryDays.present) {
      map['delivery_days'] = Variable<int>(deliveryDays.value);
    }
    if (isOrdered.present) {
      map['is_ordered'] = Variable<bool>(isOrdered.value);
    }
    if (isReceived.present) {
      map['is_received'] = Variable<bool>(isReceived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderPartsItemsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('documentUuid: $documentUuid, ')
          ..write('lineNumber: $lineNumber, ')
          ..write('partNumber: $partNumber, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('supplierName: $supplierName, ')
          ..write('deliveryDays: $deliveryDays, ')
          ..write('isOrdered: $isOrdered, ')
          ..write('isReceived: $isReceived, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt')
          ..write(')'))
        .toString();
  }
}

class $OrderServicesItemsTable extends OrderServicesItems
    with TableInfo<$OrderServicesItemsTable, OrderServicesItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderServicesItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
      'uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => const Uuid().v4());
  static const VerificationMeta _documentUuidMeta =
      const VerificationMeta('documentUuid');
  @override
  late final GeneratedColumn<String> documentUuid = GeneratedColumn<String>(
      'document_uuid', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES orders_items (uuid)'));
  static const VerificationMeta _lineNumberMeta =
      const VerificationMeta('lineNumber');
  @override
  late final GeneratedColumn<int> lineNumber = GeneratedColumn<int>(
      'line_number', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _durationMeta =
      const VerificationMeta('duration');
  @override
  late final GeneratedColumn<double> duration = GeneratedColumn<double>(
      'duration', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _performedByMeta =
      const VerificationMeta('performedBy');
  @override
  late final GeneratedColumn<String> performedBy = GeneratedColumn<String>(
      'performed_by', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isCompletedMeta =
      const VerificationMeta('isCompleted');
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
      'is_completed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_completed" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _modifiedAtMeta =
      const VerificationMeta('modifiedAt');
  @override
  late final GeneratedColumn<DateTime> modifiedAt = GeneratedColumn<DateTime>(
      'modified_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        uuid,
        documentUuid,
        lineNumber,
        name,
        description,
        price,
        duration,
        performedBy,
        isCompleted,
        createdAt,
        modifiedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_services_items';
  @override
  VerificationContext validateIntegrity(Insertable<OrderServicesItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uuid')) {
      context.handle(
          _uuidMeta, uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta));
    }
    if (data.containsKey('document_uuid')) {
      context.handle(
          _documentUuidMeta,
          documentUuid.isAcceptableOrUnknown(
              data['document_uuid']!, _documentUuidMeta));
    } else if (isInserting) {
      context.missing(_documentUuidMeta);
    }
    if (data.containsKey('line_number')) {
      context.handle(
          _lineNumberMeta,
          lineNumber.isAcceptableOrUnknown(
              data['line_number']!, _lineNumberMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta,
          duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    }
    if (data.containsKey('performed_by')) {
      context.handle(
          _performedByMeta,
          performedBy.isAcceptableOrUnknown(
              data['performed_by']!, _performedByMeta));
    }
    if (data.containsKey('is_completed')) {
      context.handle(
          _isCompletedMeta,
          isCompleted.isAcceptableOrUnknown(
              data['is_completed']!, _isCompletedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('modified_at')) {
      context.handle(
          _modifiedAtMeta,
          modifiedAt.isAcceptableOrUnknown(
              data['modified_at']!, _modifiedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderServicesItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderServicesItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      uuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}uuid'])!,
      documentUuid: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}document_uuid'])!,
      lineNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}line_number'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      duration: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}duration']),
      performedBy: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}performed_by']),
      isCompleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_completed'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      modifiedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}modified_at']),
    );
  }

  @override
  $OrderServicesItemsTable createAlias(String alias) {
    return $OrderServicesItemsTable(attachedDatabase, alias);
  }
}

class OrderServicesItem extends DataClass
    implements Insertable<OrderServicesItem> {
  final int id;
  final String uuid;
  final String documentUuid;
  final int lineNumber;
  final String name;
  final String? description;
  final double price;
  final double? duration;
  final String? performedBy;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? modifiedAt;
  const OrderServicesItem(
      {required this.id,
      required this.uuid,
      required this.documentUuid,
      required this.lineNumber,
      required this.name,
      this.description,
      required this.price,
      this.duration,
      this.performedBy,
      required this.isCompleted,
      required this.createdAt,
      this.modifiedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uuid'] = Variable<String>(uuid);
    map['document_uuid'] = Variable<String>(documentUuid);
    map['line_number'] = Variable<int>(lineNumber);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['price'] = Variable<double>(price);
    if (!nullToAbsent || duration != null) {
      map['duration'] = Variable<double>(duration);
    }
    if (!nullToAbsent || performedBy != null) {
      map['performed_by'] = Variable<String>(performedBy);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || modifiedAt != null) {
      map['modified_at'] = Variable<DateTime>(modifiedAt);
    }
    return map;
  }

  OrderServicesItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderServicesItemsCompanion(
      id: Value(id),
      uuid: Value(uuid),
      documentUuid: Value(documentUuid),
      lineNumber: Value(lineNumber),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      price: Value(price),
      duration: duration == null && nullToAbsent
          ? const Value.absent()
          : Value(duration),
      performedBy: performedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(performedBy),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
      modifiedAt: modifiedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(modifiedAt),
    );
  }

  factory OrderServicesItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderServicesItem(
      id: serializer.fromJson<int>(json['id']),
      uuid: serializer.fromJson<String>(json['uuid']),
      documentUuid: serializer.fromJson<String>(json['documentUuid']),
      lineNumber: serializer.fromJson<int>(json['lineNumber']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      price: serializer.fromJson<double>(json['price']),
      duration: serializer.fromJson<double?>(json['duration']),
      performedBy: serializer.fromJson<String?>(json['performedBy']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      modifiedAt: serializer.fromJson<DateTime?>(json['modifiedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uuid': serializer.toJson<String>(uuid),
      'documentUuid': serializer.toJson<String>(documentUuid),
      'lineNumber': serializer.toJson<int>(lineNumber),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'price': serializer.toJson<double>(price),
      'duration': serializer.toJson<double?>(duration),
      'performedBy': serializer.toJson<String?>(performedBy),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'modifiedAt': serializer.toJson<DateTime?>(modifiedAt),
    };
  }

  OrderServicesItem copyWith(
          {int? id,
          String? uuid,
          String? documentUuid,
          int? lineNumber,
          String? name,
          Value<String?> description = const Value.absent(),
          double? price,
          Value<double?> duration = const Value.absent(),
          Value<String?> performedBy = const Value.absent(),
          bool? isCompleted,
          DateTime? createdAt,
          Value<DateTime?> modifiedAt = const Value.absent()}) =>
      OrderServicesItem(
        id: id ?? this.id,
        uuid: uuid ?? this.uuid,
        documentUuid: documentUuid ?? this.documentUuid,
        lineNumber: lineNumber ?? this.lineNumber,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        price: price ?? this.price,
        duration: duration.present ? duration.value : this.duration,
        performedBy: performedBy.present ? performedBy.value : this.performedBy,
        isCompleted: isCompleted ?? this.isCompleted,
        createdAt: createdAt ?? this.createdAt,
        modifiedAt: modifiedAt.present ? modifiedAt.value : this.modifiedAt,
      );
  OrderServicesItem copyWithCompanion(OrderServicesItemsCompanion data) {
    return OrderServicesItem(
      id: data.id.present ? data.id.value : this.id,
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      documentUuid: data.documentUuid.present
          ? data.documentUuid.value
          : this.documentUuid,
      lineNumber:
          data.lineNumber.present ? data.lineNumber.value : this.lineNumber,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      price: data.price.present ? data.price.value : this.price,
      duration: data.duration.present ? data.duration.value : this.duration,
      performedBy:
          data.performedBy.present ? data.performedBy.value : this.performedBy,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      modifiedAt:
          data.modifiedAt.present ? data.modifiedAt.value : this.modifiedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderServicesItem(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('documentUuid: $documentUuid, ')
          ..write('lineNumber: $lineNumber, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('duration: $duration, ')
          ..write('performedBy: $performedBy, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      uuid,
      documentUuid,
      lineNumber,
      name,
      description,
      price,
      duration,
      performedBy,
      isCompleted,
      createdAt,
      modifiedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderServicesItem &&
          other.id == this.id &&
          other.uuid == this.uuid &&
          other.documentUuid == this.documentUuid &&
          other.lineNumber == this.lineNumber &&
          other.name == this.name &&
          other.description == this.description &&
          other.price == this.price &&
          other.duration == this.duration &&
          other.performedBy == this.performedBy &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt &&
          other.modifiedAt == this.modifiedAt);
}

class OrderServicesItemsCompanion extends UpdateCompanion<OrderServicesItem> {
  final Value<int> id;
  final Value<String> uuid;
  final Value<String> documentUuid;
  final Value<int> lineNumber;
  final Value<String> name;
  final Value<String?> description;
  final Value<double> price;
  final Value<double?> duration;
  final Value<String?> performedBy;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime?> modifiedAt;
  const OrderServicesItemsCompanion({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    this.documentUuid = const Value.absent(),
    this.lineNumber = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.price = const Value.absent(),
    this.duration = const Value.absent(),
    this.performedBy = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.modifiedAt = const Value.absent(),
  });
  OrderServicesItemsCompanion.insert({
    this.id = const Value.absent(),
    this.uuid = const Value.absent(),
    required String documentUuid,
    this.lineNumber = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.price = const Value.absent(),
    this.duration = const Value.absent(),
    this.performedBy = const Value.absent(),
    this.isCompleted = const Value.absent(),
    required DateTime createdAt,
    this.modifiedAt = const Value.absent(),
  })  : documentUuid = Value(documentUuid),
        name = Value(name),
        createdAt = Value(createdAt);
  static Insertable<OrderServicesItem> custom({
    Expression<int>? id,
    Expression<String>? uuid,
    Expression<String>? documentUuid,
    Expression<int>? lineNumber,
    Expression<String>? name,
    Expression<String>? description,
    Expression<double>? price,
    Expression<double>? duration,
    Expression<String>? performedBy,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? modifiedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uuid != null) 'uuid': uuid,
      if (documentUuid != null) 'document_uuid': documentUuid,
      if (lineNumber != null) 'line_number': lineNumber,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (price != null) 'price': price,
      if (duration != null) 'duration': duration,
      if (performedBy != null) 'performed_by': performedBy,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (modifiedAt != null) 'modified_at': modifiedAt,
    });
  }

  OrderServicesItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? uuid,
      Value<String>? documentUuid,
      Value<int>? lineNumber,
      Value<String>? name,
      Value<String?>? description,
      Value<double>? price,
      Value<double?>? duration,
      Value<String?>? performedBy,
      Value<bool>? isCompleted,
      Value<DateTime>? createdAt,
      Value<DateTime?>? modifiedAt}) {
    return OrderServicesItemsCompanion(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      documentUuid: documentUuid ?? this.documentUuid,
      lineNumber: lineNumber ?? this.lineNumber,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      performedBy: performedBy ?? this.performedBy,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (documentUuid.present) {
      map['document_uuid'] = Variable<String>(documentUuid.value);
    }
    if (lineNumber.present) {
      map['line_number'] = Variable<int>(lineNumber.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (duration.present) {
      map['duration'] = Variable<double>(duration.value);
    }
    if (performedBy.present) {
      map['performed_by'] = Variable<String>(performedBy.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (modifiedAt.present) {
      map['modified_at'] = Variable<DateTime>(modifiedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderServicesItemsCompanion(')
          ..write('id: $id, ')
          ..write('uuid: $uuid, ')
          ..write('documentUuid: $documentUuid, ')
          ..write('lineNumber: $lineNumber, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('price: $price, ')
          ..write('duration: $duration, ')
          ..write('performedBy: $performedBy, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('modifiedAt: $modifiedAt')
          ..write(')'))
        .toString();
  }
}

class $SupplierSettingsItemsTable extends SupplierSettingsItems
    with TableInfo<$SupplierSettingsItemsTable, SupplierSettingsItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplierSettingsItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _supplierCodeMeta =
      const VerificationMeta('supplierCode');
  @override
  late final GeneratedColumn<String> supplierCode = GeneratedColumn<String>(
      'supplier_code', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _isEnabledMeta =
      const VerificationMeta('isEnabled');
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
      'is_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _encryptedCredentialsMeta =
      const VerificationMeta('encryptedCredentials');
  @override
  late final GeneratedColumn<String> encryptedCredentials =
      GeneratedColumn<String>('encrypted_credentials', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastCheckStatusMeta =
      const VerificationMeta('lastCheckStatus');
  @override
  late final GeneratedColumn<String> lastCheckStatus = GeneratedColumn<String>(
      'last_check_status', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastCheckMessageMeta =
      const VerificationMeta('lastCheckMessage');
  @override
  late final GeneratedColumn<String> lastCheckMessage = GeneratedColumn<String>(
      'last_check_message', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _lastSuccessfulCheckAtMeta =
      const VerificationMeta('lastSuccessfulCheckAt');
  @override
  late final GeneratedColumn<DateTime> lastSuccessfulCheckAt =
      GeneratedColumn<DateTime>('last_successful_check_at', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _clientIdentifierAtSupplierMeta =
      const VerificationMeta('clientIdentifierAtSupplier');
  @override
  late final GeneratedColumn<String> clientIdentifierAtSupplier =
      GeneratedColumn<String>(
          'client_identifier_at_supplier', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _additionalConfigMeta =
      const VerificationMeta('additionalConfig');
  @override
  late final GeneratedColumn<String> additionalConfig = GeneratedColumn<String>(
      'additional_config', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  static const VerificationMeta _updatedAtMeta =
      const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
      'updated_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        supplierCode,
        isEnabled,
        encryptedCredentials,
        lastCheckStatus,
        lastCheckMessage,
        lastSuccessfulCheckAt,
        clientIdentifierAtSupplier,
        additionalConfig,
        createdAt,
        updatedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplier_settings';
  @override
  VerificationContext validateIntegrity(
      Insertable<SupplierSettingsItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('supplier_code')) {
      context.handle(
          _supplierCodeMeta,
          supplierCode.isAcceptableOrUnknown(
              data['supplier_code']!, _supplierCodeMeta));
    } else if (isInserting) {
      context.missing(_supplierCodeMeta);
    }
    if (data.containsKey('is_enabled')) {
      context.handle(_isEnabledMeta,
          isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta));
    }
    if (data.containsKey('encrypted_credentials')) {
      context.handle(
          _encryptedCredentialsMeta,
          encryptedCredentials.isAcceptableOrUnknown(
              data['encrypted_credentials']!, _encryptedCredentialsMeta));
    }
    if (data.containsKey('last_check_status')) {
      context.handle(
          _lastCheckStatusMeta,
          lastCheckStatus.isAcceptableOrUnknown(
              data['last_check_status']!, _lastCheckStatusMeta));
    }
    if (data.containsKey('last_check_message')) {
      context.handle(
          _lastCheckMessageMeta,
          lastCheckMessage.isAcceptableOrUnknown(
              data['last_check_message']!, _lastCheckMessageMeta));
    }
    if (data.containsKey('last_successful_check_at')) {
      context.handle(
          _lastSuccessfulCheckAtMeta,
          lastSuccessfulCheckAt.isAcceptableOrUnknown(
              data['last_successful_check_at']!, _lastSuccessfulCheckAtMeta));
    }
    if (data.containsKey('client_identifier_at_supplier')) {
      context.handle(
          _clientIdentifierAtSupplierMeta,
          clientIdentifierAtSupplier.isAcceptableOrUnknown(
              data['client_identifier_at_supplier']!,
              _clientIdentifierAtSupplierMeta));
    }
    if (data.containsKey('additional_config')) {
      context.handle(
          _additionalConfigMeta,
          additionalConfig.isAcceptableOrUnknown(
              data['additional_config']!, _additionalConfigMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta,
          updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SupplierSettingsItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplierSettingsItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      supplierCode: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}supplier_code'])!,
      isEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_enabled'])!,
      encryptedCredentials: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}encrypted_credentials']),
      lastCheckStatus: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_check_status']),
      lastCheckMessage: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}last_check_message']),
      lastSuccessfulCheckAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime,
          data['${effectivePrefix}last_successful_check_at']),
      clientIdentifierAtSupplier: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}client_identifier_at_supplier']),
      additionalConfig: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}additional_config']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
      updatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SupplierSettingsItemsTable createAlias(String alias) {
    return $SupplierSettingsItemsTable(attachedDatabase, alias);
  }
}

class SupplierSettingsItem extends DataClass
    implements Insertable<SupplierSettingsItem> {
  final int id;
  final String supplierCode;
  final bool isEnabled;

  /// Зашифрованные учетные данные (логин, пароль, API-ключ в виде JSON-строки, затем зашифрованной).
  /// Может храниться как BLOB, если шифрование дает бинарные данные,
  /// или как TEXT, если результат шифрования - base64 строка.
  /// Выберем TEXT для простоты, предполагая base64.
  final String? encryptedCredentials;

  /// Статус последней проверки ("success", "error_auth", "error_network", "not_checked" и т.д.).
  final String? lastCheckStatus;
  final String? lastCheckMessage;
  final DateTime? lastSuccessfulCheckAt;

  /// ID клиента у поставщика (если есть, например, после успешной регистрации/подключения).
  final String? clientIdentifierAtSupplier;

  /// JSON-строка для хранения специфичных для поставщика настроек
  /// (например, выбранный VKORG для Armtek, список выбранных складов и т.д.).
  final String? additionalConfig;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SupplierSettingsItem(
      {required this.id,
      required this.supplierCode,
      required this.isEnabled,
      this.encryptedCredentials,
      this.lastCheckStatus,
      this.lastCheckMessage,
      this.lastSuccessfulCheckAt,
      this.clientIdentifierAtSupplier,
      this.additionalConfig,
      required this.createdAt,
      required this.updatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['supplier_code'] = Variable<String>(supplierCode);
    map['is_enabled'] = Variable<bool>(isEnabled);
    if (!nullToAbsent || encryptedCredentials != null) {
      map['encrypted_credentials'] = Variable<String>(encryptedCredentials);
    }
    if (!nullToAbsent || lastCheckStatus != null) {
      map['last_check_status'] = Variable<String>(lastCheckStatus);
    }
    if (!nullToAbsent || lastCheckMessage != null) {
      map['last_check_message'] = Variable<String>(lastCheckMessage);
    }
    if (!nullToAbsent || lastSuccessfulCheckAt != null) {
      map['last_successful_check_at'] =
          Variable<DateTime>(lastSuccessfulCheckAt);
    }
    if (!nullToAbsent || clientIdentifierAtSupplier != null) {
      map['client_identifier_at_supplier'] =
          Variable<String>(clientIdentifierAtSupplier);
    }
    if (!nullToAbsent || additionalConfig != null) {
      map['additional_config'] = Variable<String>(additionalConfig);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SupplierSettingsItemsCompanion toCompanion(bool nullToAbsent) {
    return SupplierSettingsItemsCompanion(
      id: Value(id),
      supplierCode: Value(supplierCode),
      isEnabled: Value(isEnabled),
      encryptedCredentials: encryptedCredentials == null && nullToAbsent
          ? const Value.absent()
          : Value(encryptedCredentials),
      lastCheckStatus: lastCheckStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCheckStatus),
      lastCheckMessage: lastCheckMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCheckMessage),
      lastSuccessfulCheckAt: lastSuccessfulCheckAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSuccessfulCheckAt),
      clientIdentifierAtSupplier:
          clientIdentifierAtSupplier == null && nullToAbsent
              ? const Value.absent()
              : Value(clientIdentifierAtSupplier),
      additionalConfig: additionalConfig == null && nullToAbsent
          ? const Value.absent()
          : Value(additionalConfig),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SupplierSettingsItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplierSettingsItem(
      id: serializer.fromJson<int>(json['id']),
      supplierCode: serializer.fromJson<String>(json['supplierCode']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      encryptedCredentials:
          serializer.fromJson<String?>(json['encryptedCredentials']),
      lastCheckStatus: serializer.fromJson<String?>(json['lastCheckStatus']),
      lastCheckMessage: serializer.fromJson<String?>(json['lastCheckMessage']),
      lastSuccessfulCheckAt:
          serializer.fromJson<DateTime?>(json['lastSuccessfulCheckAt']),
      clientIdentifierAtSupplier:
          serializer.fromJson<String?>(json['clientIdentifierAtSupplier']),
      additionalConfig: serializer.fromJson<String?>(json['additionalConfig']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'supplierCode': serializer.toJson<String>(supplierCode),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'encryptedCredentials': serializer.toJson<String?>(encryptedCredentials),
      'lastCheckStatus': serializer.toJson<String?>(lastCheckStatus),
      'lastCheckMessage': serializer.toJson<String?>(lastCheckMessage),
      'lastSuccessfulCheckAt':
          serializer.toJson<DateTime?>(lastSuccessfulCheckAt),
      'clientIdentifierAtSupplier':
          serializer.toJson<String?>(clientIdentifierAtSupplier),
      'additionalConfig': serializer.toJson<String?>(additionalConfig),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SupplierSettingsItem copyWith(
          {int? id,
          String? supplierCode,
          bool? isEnabled,
          Value<String?> encryptedCredentials = const Value.absent(),
          Value<String?> lastCheckStatus = const Value.absent(),
          Value<String?> lastCheckMessage = const Value.absent(),
          Value<DateTime?> lastSuccessfulCheckAt = const Value.absent(),
          Value<String?> clientIdentifierAtSupplier = const Value.absent(),
          Value<String?> additionalConfig = const Value.absent(),
          DateTime? createdAt,
          DateTime? updatedAt}) =>
      SupplierSettingsItem(
        id: id ?? this.id,
        supplierCode: supplierCode ?? this.supplierCode,
        isEnabled: isEnabled ?? this.isEnabled,
        encryptedCredentials: encryptedCredentials.present
            ? encryptedCredentials.value
            : this.encryptedCredentials,
        lastCheckStatus: lastCheckStatus.present
            ? lastCheckStatus.value
            : this.lastCheckStatus,
        lastCheckMessage: lastCheckMessage.present
            ? lastCheckMessage.value
            : this.lastCheckMessage,
        lastSuccessfulCheckAt: lastSuccessfulCheckAt.present
            ? lastSuccessfulCheckAt.value
            : this.lastSuccessfulCheckAt,
        clientIdentifierAtSupplier: clientIdentifierAtSupplier.present
            ? clientIdentifierAtSupplier.value
            : this.clientIdentifierAtSupplier,
        additionalConfig: additionalConfig.present
            ? additionalConfig.value
            : this.additionalConfig,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  SupplierSettingsItem copyWithCompanion(SupplierSettingsItemsCompanion data) {
    return SupplierSettingsItem(
      id: data.id.present ? data.id.value : this.id,
      supplierCode: data.supplierCode.present
          ? data.supplierCode.value
          : this.supplierCode,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      encryptedCredentials: data.encryptedCredentials.present
          ? data.encryptedCredentials.value
          : this.encryptedCredentials,
      lastCheckStatus: data.lastCheckStatus.present
          ? data.lastCheckStatus.value
          : this.lastCheckStatus,
      lastCheckMessage: data.lastCheckMessage.present
          ? data.lastCheckMessage.value
          : this.lastCheckMessage,
      lastSuccessfulCheckAt: data.lastSuccessfulCheckAt.present
          ? data.lastSuccessfulCheckAt.value
          : this.lastSuccessfulCheckAt,
      clientIdentifierAtSupplier: data.clientIdentifierAtSupplier.present
          ? data.clientIdentifierAtSupplier.value
          : this.clientIdentifierAtSupplier,
      additionalConfig: data.additionalConfig.present
          ? data.additionalConfig.value
          : this.additionalConfig,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplierSettingsItem(')
          ..write('id: $id, ')
          ..write('supplierCode: $supplierCode, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('encryptedCredentials: $encryptedCredentials, ')
          ..write('lastCheckStatus: $lastCheckStatus, ')
          ..write('lastCheckMessage: $lastCheckMessage, ')
          ..write('lastSuccessfulCheckAt: $lastSuccessfulCheckAt, ')
          ..write('clientIdentifierAtSupplier: $clientIdentifierAtSupplier, ')
          ..write('additionalConfig: $additionalConfig, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      supplierCode,
      isEnabled,
      encryptedCredentials,
      lastCheckStatus,
      lastCheckMessage,
      lastSuccessfulCheckAt,
      clientIdentifierAtSupplier,
      additionalConfig,
      createdAt,
      updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplierSettingsItem &&
          other.id == this.id &&
          other.supplierCode == this.supplierCode &&
          other.isEnabled == this.isEnabled &&
          other.encryptedCredentials == this.encryptedCredentials &&
          other.lastCheckStatus == this.lastCheckStatus &&
          other.lastCheckMessage == this.lastCheckMessage &&
          other.lastSuccessfulCheckAt == this.lastSuccessfulCheckAt &&
          other.clientIdentifierAtSupplier == this.clientIdentifierAtSupplier &&
          other.additionalConfig == this.additionalConfig &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SupplierSettingsItemsCompanion
    extends UpdateCompanion<SupplierSettingsItem> {
  final Value<int> id;
  final Value<String> supplierCode;
  final Value<bool> isEnabled;
  final Value<String?> encryptedCredentials;
  final Value<String?> lastCheckStatus;
  final Value<String?> lastCheckMessage;
  final Value<DateTime?> lastSuccessfulCheckAt;
  final Value<String?> clientIdentifierAtSupplier;
  final Value<String?> additionalConfig;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const SupplierSettingsItemsCompanion({
    this.id = const Value.absent(),
    this.supplierCode = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.encryptedCredentials = const Value.absent(),
    this.lastCheckStatus = const Value.absent(),
    this.lastCheckMessage = const Value.absent(),
    this.lastSuccessfulCheckAt = const Value.absent(),
    this.clientIdentifierAtSupplier = const Value.absent(),
    this.additionalConfig = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  SupplierSettingsItemsCompanion.insert({
    this.id = const Value.absent(),
    required String supplierCode,
    this.isEnabled = const Value.absent(),
    this.encryptedCredentials = const Value.absent(),
    this.lastCheckStatus = const Value.absent(),
    this.lastCheckMessage = const Value.absent(),
    this.lastSuccessfulCheckAt = const Value.absent(),
    this.clientIdentifierAtSupplier = const Value.absent(),
    this.additionalConfig = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : supplierCode = Value(supplierCode);
  static Insertable<SupplierSettingsItem> custom({
    Expression<int>? id,
    Expression<String>? supplierCode,
    Expression<bool>? isEnabled,
    Expression<String>? encryptedCredentials,
    Expression<String>? lastCheckStatus,
    Expression<String>? lastCheckMessage,
    Expression<DateTime>? lastSuccessfulCheckAt,
    Expression<String>? clientIdentifierAtSupplier,
    Expression<String>? additionalConfig,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (supplierCode != null) 'supplier_code': supplierCode,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (encryptedCredentials != null)
        'encrypted_credentials': encryptedCredentials,
      if (lastCheckStatus != null) 'last_check_status': lastCheckStatus,
      if (lastCheckMessage != null) 'last_check_message': lastCheckMessage,
      if (lastSuccessfulCheckAt != null)
        'last_successful_check_at': lastSuccessfulCheckAt,
      if (clientIdentifierAtSupplier != null)
        'client_identifier_at_supplier': clientIdentifierAtSupplier,
      if (additionalConfig != null) 'additional_config': additionalConfig,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  SupplierSettingsItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? supplierCode,
      Value<bool>? isEnabled,
      Value<String?>? encryptedCredentials,
      Value<String?>? lastCheckStatus,
      Value<String?>? lastCheckMessage,
      Value<DateTime?>? lastSuccessfulCheckAt,
      Value<String?>? clientIdentifierAtSupplier,
      Value<String?>? additionalConfig,
      Value<DateTime>? createdAt,
      Value<DateTime>? updatedAt}) {
    return SupplierSettingsItemsCompanion(
      id: id ?? this.id,
      supplierCode: supplierCode ?? this.supplierCode,
      isEnabled: isEnabled ?? this.isEnabled,
      encryptedCredentials: encryptedCredentials ?? this.encryptedCredentials,
      lastCheckStatus: lastCheckStatus ?? this.lastCheckStatus,
      lastCheckMessage: lastCheckMessage ?? this.lastCheckMessage,
      lastSuccessfulCheckAt:
          lastSuccessfulCheckAt ?? this.lastSuccessfulCheckAt,
      clientIdentifierAtSupplier:
          clientIdentifierAtSupplier ?? this.clientIdentifierAtSupplier,
      additionalConfig: additionalConfig ?? this.additionalConfig,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (supplierCode.present) {
      map['supplier_code'] = Variable<String>(supplierCode.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (encryptedCredentials.present) {
      map['encrypted_credentials'] =
          Variable<String>(encryptedCredentials.value);
    }
    if (lastCheckStatus.present) {
      map['last_check_status'] = Variable<String>(lastCheckStatus.value);
    }
    if (lastCheckMessage.present) {
      map['last_check_message'] = Variable<String>(lastCheckMessage.value);
    }
    if (lastSuccessfulCheckAt.present) {
      map['last_successful_check_at'] =
          Variable<DateTime>(lastSuccessfulCheckAt.value);
    }
    if (clientIdentifierAtSupplier.present) {
      map['client_identifier_at_supplier'] =
          Variable<String>(clientIdentifierAtSupplier.value);
    }
    if (additionalConfig.present) {
      map['additional_config'] = Variable<String>(additionalConfig.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupplierSettingsItemsCompanion(')
          ..write('id: $id, ')
          ..write('supplierCode: $supplierCode, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('encryptedCredentials: $encryptedCredentials, ')
          ..write('lastCheckStatus: $lastCheckStatus, ')
          ..write('lastCheckMessage: $lastCheckMessage, ')
          ..write('lastSuccessfulCheckAt: $lastSuccessfulCheckAt, ')
          ..write('clientIdentifierAtSupplier: $clientIdentifierAtSupplier, ')
          ..write('additionalConfig: $additionalConfig, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientsItemsTable clientsItems = $ClientsItemsTable(this);
  late final $CarsItemsTable carsItems = $CarsItemsTable(this);
  late final $OrdersItemsTable ordersItems = $OrdersItemsTable(this);
  late final $OrderPartsItemsTable orderPartsItems =
      $OrderPartsItemsTable(this);
  late final $OrderServicesItemsTable orderServicesItems =
      $OrderServicesItemsTable(this);
  late final $SupplierSettingsItemsTable supplierSettingsItems =
      $SupplierSettingsItemsTable(this);
  late final ClientsDao clientsDao = ClientsDao(this as AppDatabase);
  late final CarsDao carsDao = CarsDao(this as AppDatabase);
  late final OrdersDao ordersDao = OrdersDao(this as AppDatabase);
  late final SupplierSettingsDao supplierSettingsDao =
      SupplierSettingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        clientsItems,
        carsItems,
        ordersItems,
        orderPartsItems,
        orderServicesItems,
        supplierSettingsItems
      ];
}

typedef $$ClientsItemsTableCreateCompanionBuilder = ClientsItemsCompanion
    Function({
  Value<int> id,
  Value<String> uuid,
  required String code,
  required String type,
  required String name,
  required String contactInfo,
  Value<String?> additionalInfo,
  Value<DateTime> createdAt,
  Value<DateTime?> modifiedAt,
  Value<DateTime?> deletedAt,
});
typedef $$ClientsItemsTableUpdateCompanionBuilder = ClientsItemsCompanion
    Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> code,
  Value<String> type,
  Value<String> name,
  Value<String> contactInfo,
  Value<String?> additionalInfo,
  Value<DateTime> createdAt,
  Value<DateTime?> modifiedAt,
  Value<DateTime?> deletedAt,
});

final class $$ClientsItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ClientsItemsTable, ClientsItem> {
  $$ClientsItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CarsItemsTable, List<CarsItem>>
      _carsItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.carsItems,
          aliasName:
              $_aliasNameGenerator(db.clientsItems.id, db.carsItems.clientId));

  $$CarsItemsTableProcessedTableManager get carsItemsRefs {
    final manager = $$CarsItemsTableTableManager($_db, $_db.carsItems)
        .filter((f) => f.clientId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_carsItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OrdersItemsTable, List<OrdersItem>>
      _ordersItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.ordersItems,
              aliasName: $_aliasNameGenerator(
                  db.clientsItems.uuid, db.ordersItems.clientUuid));

  $$OrdersItemsTableProcessedTableManager get ordersItemsRefs {
    final manager = $$OrdersItemsTableTableManager($_db, $_db.ordersItems)
        .filter(
            (f) => f.clientUuid.uuid.sqlEquals($_itemColumn<String>('uuid')!));

    final cache = $_typedResult.readTableOrNull(_ordersItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ClientsItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ClientsItemsTable> {
  $$ClientsItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contactInfo => $composableBuilder(
      column: $table.contactInfo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get additionalInfo => $composableBuilder(
      column: $table.additionalInfo,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> carsItemsRefs(
      Expression<bool> Function($$CarsItemsTableFilterComposer f) f) {
    final $$CarsItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.carsItems,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CarsItemsTableFilterComposer(
              $db: $db,
              $table: $db.carsItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> ordersItemsRefs(
      Expression<bool> Function($$OrdersItemsTableFilterComposer f) f) {
    final $$OrdersItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.uuid,
        referencedTable: $db.ordersItems,
        getReferencedColumn: (t) => t.clientUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersItemsTableFilterComposer(
              $db: $db,
              $table: $db.ordersItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientsItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ClientsItemsTable> {
  $$ClientsItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contactInfo => $composableBuilder(
      column: $table.contactInfo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get additionalInfo => $composableBuilder(
      column: $table.additionalInfo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));
}

class $$ClientsItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClientsItemsTable> {
  $$ClientsItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get contactInfo => $composableBuilder(
      column: $table.contactInfo, builder: (column) => column);

  GeneratedColumn<String> get additionalInfo => $composableBuilder(
      column: $table.additionalInfo, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> carsItemsRefs<T extends Object>(
      Expression<T> Function($$CarsItemsTableAnnotationComposer a) f) {
    final $$CarsItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.carsItems,
        getReferencedColumn: (t) => t.clientId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CarsItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.carsItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> ordersItemsRefs<T extends Object>(
      Expression<T> Function($$OrdersItemsTableAnnotationComposer a) f) {
    final $$OrdersItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.uuid,
        referencedTable: $db.ordersItems,
        getReferencedColumn: (t) => t.clientUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.ordersItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ClientsItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ClientsItemsTable,
    ClientsItem,
    $$ClientsItemsTableFilterComposer,
    $$ClientsItemsTableOrderingComposer,
    $$ClientsItemsTableAnnotationComposer,
    $$ClientsItemsTableCreateCompanionBuilder,
    $$ClientsItemsTableUpdateCompanionBuilder,
    (ClientsItem, $$ClientsItemsTableReferences),
    ClientsItem,
    PrefetchHooks Function({bool carsItemsRefs, bool ordersItemsRefs})> {
  $$ClientsItemsTableTableManager(_$AppDatabase db, $ClientsItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClientsItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClientsItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClientsItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> contactInfo = const Value.absent(),
            Value<String?> additionalInfo = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> modifiedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
          }) =>
              ClientsItemsCompanion(
            id: id,
            uuid: uuid,
            code: code,
            type: type,
            name: name,
            contactInfo: contactInfo,
            additionalInfo: additionalInfo,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            deletedAt: deletedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            required String code,
            required String type,
            required String name,
            required String contactInfo,
            Value<String?> additionalInfo = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> modifiedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
          }) =>
              ClientsItemsCompanion.insert(
            id: id,
            uuid: uuid,
            code: code,
            type: type,
            name: name,
            contactInfo: contactInfo,
            additionalInfo: additionalInfo,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            deletedAt: deletedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ClientsItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {carsItemsRefs = false, ordersItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (carsItemsRefs) db.carsItems,
                if (ordersItemsRefs) db.ordersItems
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (carsItemsRefs)
                    await $_getPrefetchedData<ClientsItem, $ClientsItemsTable,
                            CarsItem>(
                        currentTable: table,
                        referencedTable: $$ClientsItemsTableReferences
                            ._carsItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ClientsItemsTableReferences(db, table, p0)
                                .carsItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.clientId == item.id),
                        typedResults: items),
                  if (ordersItemsRefs)
                    await $_getPrefetchedData<ClientsItem, $ClientsItemsTable,
                            OrdersItem>(
                        currentTable: table,
                        referencedTable: $$ClientsItemsTableReferences
                            ._ordersItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ClientsItemsTableReferences(db, table, p0)
                                .ordersItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.clientUuid == item.uuid),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ClientsItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ClientsItemsTable,
    ClientsItem,
    $$ClientsItemsTableFilterComposer,
    $$ClientsItemsTableOrderingComposer,
    $$ClientsItemsTableAnnotationComposer,
    $$ClientsItemsTableCreateCompanionBuilder,
    $$ClientsItemsTableUpdateCompanionBuilder,
    (ClientsItem, $$ClientsItemsTableReferences),
    ClientsItem,
    PrefetchHooks Function({bool carsItemsRefs, bool ordersItemsRefs})>;
typedef $$CarsItemsTableCreateCompanionBuilder = CarsItemsCompanion Function({
  Value<int> id,
  Value<String> uuid,
  required int clientId,
  Value<String?> vin,
  required String make,
  required String model,
  Value<int?> year,
  Value<String?> licensePlate,
  Value<String?> additionalInfo,
  Value<String> code,
  Value<DateTime> createdAt,
  Value<DateTime?> modifiedAt,
  Value<DateTime?> deletedAt,
});
typedef $$CarsItemsTableUpdateCompanionBuilder = CarsItemsCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<int> clientId,
  Value<String?> vin,
  Value<String> make,
  Value<String> model,
  Value<int?> year,
  Value<String?> licensePlate,
  Value<String?> additionalInfo,
  Value<String> code,
  Value<DateTime> createdAt,
  Value<DateTime?> modifiedAt,
  Value<DateTime?> deletedAt,
});

final class $$CarsItemsTableReferences
    extends BaseReferences<_$AppDatabase, $CarsItemsTable, CarsItem> {
  $$CarsItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsItemsTable _clientIdTable(_$AppDatabase db) =>
      db.clientsItems.createAlias(
          $_aliasNameGenerator(db.carsItems.clientId, db.clientsItems.id));

  $$ClientsItemsTableProcessedTableManager get clientId {
    final $_column = $_itemColumn<int>('client_id')!;

    final manager = $$ClientsItemsTableTableManager($_db, $_db.clientsItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$OrdersItemsTable, List<OrdersItem>>
      _ordersItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.ordersItems,
          aliasName:
              $_aliasNameGenerator(db.carsItems.uuid, db.ordersItems.carUuid));

  $$OrdersItemsTableProcessedTableManager get ordersItemsRefs {
    final manager = $$OrdersItemsTableTableManager($_db, $_db.ordersItems)
        .filter((f) => f.carUuid.uuid.sqlEquals($_itemColumn<String>('uuid')!));

    final cache = $_typedResult.readTableOrNull(_ordersItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$CarsItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CarsItemsTable> {
  $$CarsItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get vin => $composableBuilder(
      column: $table.vin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get make => $composableBuilder(
      column: $table.make, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get licensePlate => $composableBuilder(
      column: $table.licensePlate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get additionalInfo => $composableBuilder(
      column: $table.additionalInfo,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  $$ClientsItemsTableFilterComposer get clientId {
    final $$ClientsItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clientsItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsItemsTableFilterComposer(
              $db: $db,
              $table: $db.clientsItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> ordersItemsRefs(
      Expression<bool> Function($$OrdersItemsTableFilterComposer f) f) {
    final $$OrdersItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.uuid,
        referencedTable: $db.ordersItems,
        getReferencedColumn: (t) => t.carUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersItemsTableFilterComposer(
              $db: $db,
              $table: $db.ordersItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CarsItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CarsItemsTable> {
  $$CarsItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get vin => $composableBuilder(
      column: $table.vin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get make => $composableBuilder(
      column: $table.make, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get model => $composableBuilder(
      column: $table.model, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get year => $composableBuilder(
      column: $table.year, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get licensePlate => $composableBuilder(
      column: $table.licensePlate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get additionalInfo => $composableBuilder(
      column: $table.additionalInfo,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get code => $composableBuilder(
      column: $table.code, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  $$ClientsItemsTableOrderingComposer get clientId {
    final $$ClientsItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clientsItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsItemsTableOrderingComposer(
              $db: $db,
              $table: $db.clientsItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$CarsItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CarsItemsTable> {
  $$CarsItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get vin =>
      $composableBuilder(column: $table.vin, builder: (column) => column);

  GeneratedColumn<String> get make =>
      $composableBuilder(column: $table.make, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get licensePlate => $composableBuilder(
      column: $table.licensePlate, builder: (column) => column);

  GeneratedColumn<String> get additionalInfo => $composableBuilder(
      column: $table.additionalInfo, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$ClientsItemsTableAnnotationComposer get clientId {
    final $$ClientsItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientId,
        referencedTable: $db.clientsItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.clientsItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> ordersItemsRefs<T extends Object>(
      Expression<T> Function($$OrdersItemsTableAnnotationComposer a) f) {
    final $$OrdersItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.uuid,
        referencedTable: $db.ordersItems,
        getReferencedColumn: (t) => t.carUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.ordersItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$CarsItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CarsItemsTable,
    CarsItem,
    $$CarsItemsTableFilterComposer,
    $$CarsItemsTableOrderingComposer,
    $$CarsItemsTableAnnotationComposer,
    $$CarsItemsTableCreateCompanionBuilder,
    $$CarsItemsTableUpdateCompanionBuilder,
    (CarsItem, $$CarsItemsTableReferences),
    CarsItem,
    PrefetchHooks Function({bool clientId, bool ordersItemsRefs})> {
  $$CarsItemsTableTableManager(_$AppDatabase db, $CarsItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CarsItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CarsItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CarsItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<int> clientId = const Value.absent(),
            Value<String?> vin = const Value.absent(),
            Value<String> make = const Value.absent(),
            Value<String> model = const Value.absent(),
            Value<int?> year = const Value.absent(),
            Value<String?> licensePlate = const Value.absent(),
            Value<String?> additionalInfo = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> modifiedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
          }) =>
              CarsItemsCompanion(
            id: id,
            uuid: uuid,
            clientId: clientId,
            vin: vin,
            make: make,
            model: model,
            year: year,
            licensePlate: licensePlate,
            additionalInfo: additionalInfo,
            code: code,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            deletedAt: deletedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            required int clientId,
            Value<String?> vin = const Value.absent(),
            required String make,
            required String model,
            Value<int?> year = const Value.absent(),
            Value<String?> licensePlate = const Value.absent(),
            Value<String?> additionalInfo = const Value.absent(),
            Value<String> code = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> modifiedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
          }) =>
              CarsItemsCompanion.insert(
            id: id,
            uuid: uuid,
            clientId: clientId,
            vin: vin,
            make: make,
            model: model,
            year: year,
            licensePlate: licensePlate,
            additionalInfo: additionalInfo,
            code: code,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            deletedAt: deletedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CarsItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({clientId = false, ordersItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ordersItemsRefs) db.ordersItems],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (clientId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.clientId,
                    referencedTable:
                        $$CarsItemsTableReferences._clientIdTable(db),
                    referencedColumn:
                        $$CarsItemsTableReferences._clientIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordersItemsRefs)
                    await $_getPrefetchedData<CarsItem, $CarsItemsTable,
                            OrdersItem>(
                        currentTable: table,
                        referencedTable: $$CarsItemsTableReferences
                            ._ordersItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$CarsItemsTableReferences(db, table, p0)
                                .ordersItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.carUuid == item.uuid),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$CarsItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CarsItemsTable,
    CarsItem,
    $$CarsItemsTableFilterComposer,
    $$CarsItemsTableOrderingComposer,
    $$CarsItemsTableAnnotationComposer,
    $$CarsItemsTableCreateCompanionBuilder,
    $$CarsItemsTableUpdateCompanionBuilder,
    (CarsItem, $$CarsItemsTableReferences),
    CarsItem,
    PrefetchHooks Function({bool clientId, bool ordersItemsRefs})>;
typedef $$OrdersItemsTableCreateCompanionBuilder = OrdersItemsCompanion
    Function({
  Value<int> id,
  Value<String> uuid,
  required String clientUuid,
  required String carUuid,
  required String number,
  required DateTime date,
  Value<DateTime?> scheduledDate,
  Value<DateTime?> completedAt,
  required String status,
  Value<String?> description,
  Value<double> totalAmount,
  Value<bool> isPosted,
  required DateTime createdAt,
  Value<DateTime?> modifiedAt,
  Value<DateTime?> deletedAt,
});
typedef $$OrdersItemsTableUpdateCompanionBuilder = OrdersItemsCompanion
    Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> clientUuid,
  Value<String> carUuid,
  Value<String> number,
  Value<DateTime> date,
  Value<DateTime?> scheduledDate,
  Value<DateTime?> completedAt,
  Value<String> status,
  Value<String?> description,
  Value<double> totalAmount,
  Value<bool> isPosted,
  Value<DateTime> createdAt,
  Value<DateTime?> modifiedAt,
  Value<DateTime?> deletedAt,
});

final class $$OrdersItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersItemsTable, OrdersItem> {
  $$OrdersItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ClientsItemsTable _clientUuidTable(_$AppDatabase db) =>
      db.clientsItems.createAlias($_aliasNameGenerator(
          db.ordersItems.clientUuid, db.clientsItems.uuid));

  $$ClientsItemsTableProcessedTableManager get clientUuid {
    final $_column = $_itemColumn<String>('client_uuid')!;

    final manager = $$ClientsItemsTableTableManager($_db, $_db.clientsItems)
        .filter((f) => f.uuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_clientUuidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $CarsItemsTable _carUuidTable(_$AppDatabase db) =>
      db.carsItems.createAlias(
          $_aliasNameGenerator(db.ordersItems.carUuid, db.carsItems.uuid));

  $$CarsItemsTableProcessedTableManager get carUuid {
    final $_column = $_itemColumn<String>('car_uuid')!;

    final manager = $$CarsItemsTableTableManager($_db, $_db.carsItems)
        .filter((f) => f.uuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_carUuidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$OrderPartsItemsTable, List<OrderPartsItem>>
      _orderPartsItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.orderPartsItems,
              aliasName: $_aliasNameGenerator(
                  db.ordersItems.uuid, db.orderPartsItems.documentUuid));

  $$OrderPartsItemsTableProcessedTableManager get orderPartsItemsRefs {
    final manager =
        $$OrderPartsItemsTableTableManager($_db, $_db.orderPartsItems).filter(
            (f) =>
                f.documentUuid.uuid.sqlEquals($_itemColumn<String>('uuid')!));

    final cache =
        $_typedResult.readTableOrNull(_orderPartsItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$OrderServicesItemsTable, List<OrderServicesItem>>
      _orderServicesItemsRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.orderServicesItems,
              aliasName: $_aliasNameGenerator(
                  db.ordersItems.uuid, db.orderServicesItems.documentUuid));

  $$OrderServicesItemsTableProcessedTableManager get orderServicesItemsRefs {
    final manager =
        $$OrderServicesItemsTableTableManager($_db, $_db.orderServicesItems)
            .filter((f) =>
                f.documentUuid.uuid.sqlEquals($_itemColumn<String>('uuid')!));

    final cache =
        $_typedResult.readTableOrNull(_orderServicesItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$OrdersItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersItemsTable> {
  $$OrdersItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isPosted => $composableBuilder(
      column: $table.isPosted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnFilters(column));

  $$ClientsItemsTableFilterComposer get clientUuid {
    final $$ClientsItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientUuid,
        referencedTable: $db.clientsItems,
        getReferencedColumn: (t) => t.uuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsItemsTableFilterComposer(
              $db: $db,
              $table: $db.clientsItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CarsItemsTableFilterComposer get carUuid {
    final $$CarsItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.carUuid,
        referencedTable: $db.carsItems,
        getReferencedColumn: (t) => t.uuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CarsItemsTableFilterComposer(
              $db: $db,
              $table: $db.carsItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> orderPartsItemsRefs(
      Expression<bool> Function($$OrderPartsItemsTableFilterComposer f) f) {
    final $$OrderPartsItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.uuid,
        referencedTable: $db.orderPartsItems,
        getReferencedColumn: (t) => t.documentUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderPartsItemsTableFilterComposer(
              $db: $db,
              $table: $db.orderPartsItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> orderServicesItemsRefs(
      Expression<bool> Function($$OrderServicesItemsTableFilterComposer f) f) {
    final $$OrderServicesItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.uuid,
        referencedTable: $db.orderServicesItems,
        getReferencedColumn: (t) => t.documentUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderServicesItemsTableFilterComposer(
              $db: $db,
              $table: $db.orderServicesItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrdersItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersItemsTable> {
  $$OrdersItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isPosted => $composableBuilder(
      column: $table.isPosted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
      column: $table.deletedAt, builder: (column) => ColumnOrderings(column));

  $$ClientsItemsTableOrderingComposer get clientUuid {
    final $$ClientsItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientUuid,
        referencedTable: $db.clientsItems,
        getReferencedColumn: (t) => t.uuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsItemsTableOrderingComposer(
              $db: $db,
              $table: $db.clientsItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CarsItemsTableOrderingComposer get carUuid {
    final $$CarsItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.carUuid,
        referencedTable: $db.carsItems,
        getReferencedColumn: (t) => t.uuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CarsItemsTableOrderingComposer(
              $db: $db,
              $table: $db.carsItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrdersItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersItemsTable> {
  $$OrdersItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get scheduledDate => $composableBuilder(
      column: $table.scheduledDate, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
      column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<bool> get isPosted =>
      $composableBuilder(column: $table.isPosted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  $$ClientsItemsTableAnnotationComposer get clientUuid {
    final $$ClientsItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.clientUuid,
        referencedTable: $db.clientsItems,
        getReferencedColumn: (t) => t.uuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ClientsItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.clientsItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$CarsItemsTableAnnotationComposer get carUuid {
    final $$CarsItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.carUuid,
        referencedTable: $db.carsItems,
        getReferencedColumn: (t) => t.uuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$CarsItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.carsItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> orderPartsItemsRefs<T extends Object>(
      Expression<T> Function($$OrderPartsItemsTableAnnotationComposer a) f) {
    final $$OrderPartsItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.uuid,
        referencedTable: $db.orderPartsItems,
        getReferencedColumn: (t) => t.documentUuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderPartsItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.orderPartsItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> orderServicesItemsRefs<T extends Object>(
      Expression<T> Function($$OrderServicesItemsTableAnnotationComposer a) f) {
    final $$OrderServicesItemsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.uuid,
            referencedTable: $db.orderServicesItems,
            getReferencedColumn: (t) => t.documentUuid,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$OrderServicesItemsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.orderServicesItems,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$OrdersItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrdersItemsTable,
    OrdersItem,
    $$OrdersItemsTableFilterComposer,
    $$OrdersItemsTableOrderingComposer,
    $$OrdersItemsTableAnnotationComposer,
    $$OrdersItemsTableCreateCompanionBuilder,
    $$OrdersItemsTableUpdateCompanionBuilder,
    (OrdersItem, $$OrdersItemsTableReferences),
    OrdersItem,
    PrefetchHooks Function(
        {bool clientUuid,
        bool carUuid,
        bool orderPartsItemsRefs,
        bool orderServicesItemsRefs})> {
  $$OrdersItemsTableTableManager(_$AppDatabase db, $OrdersItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> clientUuid = const Value.absent(),
            Value<String> carUuid = const Value.absent(),
            Value<String> number = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<DateTime?> scheduledDate = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<bool> isPosted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> modifiedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
          }) =>
              OrdersItemsCompanion(
            id: id,
            uuid: uuid,
            clientUuid: clientUuid,
            carUuid: carUuid,
            number: number,
            date: date,
            scheduledDate: scheduledDate,
            completedAt: completedAt,
            status: status,
            description: description,
            totalAmount: totalAmount,
            isPosted: isPosted,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            deletedAt: deletedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            required String clientUuid,
            required String carUuid,
            required String number,
            required DateTime date,
            Value<DateTime?> scheduledDate = const Value.absent(),
            Value<DateTime?> completedAt = const Value.absent(),
            required String status,
            Value<String?> description = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<bool> isPosted = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> modifiedAt = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
          }) =>
              OrdersItemsCompanion.insert(
            id: id,
            uuid: uuid,
            clientUuid: clientUuid,
            carUuid: carUuid,
            number: number,
            date: date,
            scheduledDate: scheduledDate,
            completedAt: completedAt,
            status: status,
            description: description,
            totalAmount: totalAmount,
            isPosted: isPosted,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
            deletedAt: deletedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OrdersItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {clientUuid = false,
              carUuid = false,
              orderPartsItemsRefs = false,
              orderServicesItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (orderPartsItemsRefs) db.orderPartsItems,
                if (orderServicesItemsRefs) db.orderServicesItems
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (clientUuid) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.clientUuid,
                    referencedTable:
                        $$OrdersItemsTableReferences._clientUuidTable(db),
                    referencedColumn:
                        $$OrdersItemsTableReferences._clientUuidTable(db).uuid,
                  ) as T;
                }
                if (carUuid) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.carUuid,
                    referencedTable:
                        $$OrdersItemsTableReferences._carUuidTable(db),
                    referencedColumn:
                        $$OrdersItemsTableReferences._carUuidTable(db).uuid,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderPartsItemsRefs)
                    await $_getPrefetchedData<OrdersItem, $OrdersItemsTable,
                            OrderPartsItem>(
                        currentTable: table,
                        referencedTable: $$OrdersItemsTableReferences
                            ._orderPartsItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdersItemsTableReferences(db, table, p0)
                                .orderPartsItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.documentUuid == item.uuid),
                        typedResults: items),
                  if (orderServicesItemsRefs)
                    await $_getPrefetchedData<OrdersItem, $OrdersItemsTable,
                            OrderServicesItem>(
                        currentTable: table,
                        referencedTable: $$OrdersItemsTableReferences
                            ._orderServicesItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdersItemsTableReferences(db, table, p0)
                                .orderServicesItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.documentUuid == item.uuid),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$OrdersItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrdersItemsTable,
    OrdersItem,
    $$OrdersItemsTableFilterComposer,
    $$OrdersItemsTableOrderingComposer,
    $$OrdersItemsTableAnnotationComposer,
    $$OrdersItemsTableCreateCompanionBuilder,
    $$OrdersItemsTableUpdateCompanionBuilder,
    (OrdersItem, $$OrdersItemsTableReferences),
    OrdersItem,
    PrefetchHooks Function(
        {bool clientUuid,
        bool carUuid,
        bool orderPartsItemsRefs,
        bool orderServicesItemsRefs})>;
typedef $$OrderPartsItemsTableCreateCompanionBuilder = OrderPartsItemsCompanion
    Function({
  Value<int> id,
  Value<String> uuid,
  required String documentUuid,
  Value<int> lineNumber,
  required String partNumber,
  required String name,
  Value<String?> brand,
  Value<double> quantity,
  Value<double> price,
  Value<String?> supplierName,
  Value<int?> deliveryDays,
  Value<bool> isOrdered,
  Value<bool> isReceived,
  required DateTime createdAt,
  Value<DateTime?> modifiedAt,
});
typedef $$OrderPartsItemsTableUpdateCompanionBuilder = OrderPartsItemsCompanion
    Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> documentUuid,
  Value<int> lineNumber,
  Value<String> partNumber,
  Value<String> name,
  Value<String?> brand,
  Value<double> quantity,
  Value<double> price,
  Value<String?> supplierName,
  Value<int?> deliveryDays,
  Value<bool> isOrdered,
  Value<bool> isReceived,
  Value<DateTime> createdAt,
  Value<DateTime?> modifiedAt,
});

final class $$OrderPartsItemsTableReferences extends BaseReferences<
    _$AppDatabase, $OrderPartsItemsTable, OrderPartsItem> {
  $$OrderPartsItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $OrdersItemsTable _documentUuidTable(_$AppDatabase db) =>
      db.ordersItems.createAlias($_aliasNameGenerator(
          db.orderPartsItems.documentUuid, db.ordersItems.uuid));

  $$OrdersItemsTableProcessedTableManager get documentUuid {
    final $_column = $_itemColumn<String>('document_uuid')!;

    final manager = $$OrdersItemsTableTableManager($_db, $_db.ordersItems)
        .filter((f) => f.uuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentUuidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OrderPartsItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderPartsItemsTable> {
  $$OrderPartsItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lineNumber => $composableBuilder(
      column: $table.lineNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get partNumber => $composableBuilder(
      column: $table.partNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplierName => $composableBuilder(
      column: $table.supplierName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get deliveryDays => $composableBuilder(
      column: $table.deliveryDays, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isOrdered => $composableBuilder(
      column: $table.isOrdered, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isReceived => $composableBuilder(
      column: $table.isReceived, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnFilters(column));

  $$OrdersItemsTableFilterComposer get documentUuid {
    final $$OrdersItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.documentUuid,
        referencedTable: $db.ordersItems,
        getReferencedColumn: (t) => t.uuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersItemsTableFilterComposer(
              $db: $db,
              $table: $db.ordersItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderPartsItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderPartsItemsTable> {
  $$OrderPartsItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lineNumber => $composableBuilder(
      column: $table.lineNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get partNumber => $composableBuilder(
      column: $table.partNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get brand => $composableBuilder(
      column: $table.brand, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplierName => $composableBuilder(
      column: $table.supplierName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get deliveryDays => $composableBuilder(
      column: $table.deliveryDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isOrdered => $composableBuilder(
      column: $table.isOrdered, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isReceived => $composableBuilder(
      column: $table.isReceived, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnOrderings(column));

  $$OrdersItemsTableOrderingComposer get documentUuid {
    final $$OrdersItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.documentUuid,
        referencedTable: $db.ordersItems,
        getReferencedColumn: (t) => t.uuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersItemsTableOrderingComposer(
              $db: $db,
              $table: $db.ordersItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderPartsItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderPartsItemsTable> {
  $$OrderPartsItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get lineNumber => $composableBuilder(
      column: $table.lineNumber, builder: (column) => column);

  GeneratedColumn<String> get partNumber => $composableBuilder(
      column: $table.partNumber, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get supplierName => $composableBuilder(
      column: $table.supplierName, builder: (column) => column);

  GeneratedColumn<int> get deliveryDays => $composableBuilder(
      column: $table.deliveryDays, builder: (column) => column);

  GeneratedColumn<bool> get isOrdered =>
      $composableBuilder(column: $table.isOrdered, builder: (column) => column);

  GeneratedColumn<bool> get isReceived => $composableBuilder(
      column: $table.isReceived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => column);

  $$OrdersItemsTableAnnotationComposer get documentUuid {
    final $$OrdersItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.documentUuid,
        referencedTable: $db.ordersItems,
        getReferencedColumn: (t) => t.uuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.ordersItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderPartsItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrderPartsItemsTable,
    OrderPartsItem,
    $$OrderPartsItemsTableFilterComposer,
    $$OrderPartsItemsTableOrderingComposer,
    $$OrderPartsItemsTableAnnotationComposer,
    $$OrderPartsItemsTableCreateCompanionBuilder,
    $$OrderPartsItemsTableUpdateCompanionBuilder,
    (OrderPartsItem, $$OrderPartsItemsTableReferences),
    OrderPartsItem,
    PrefetchHooks Function({bool documentUuid})> {
  $$OrderPartsItemsTableTableManager(
      _$AppDatabase db, $OrderPartsItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderPartsItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderPartsItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderPartsItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> documentUuid = const Value.absent(),
            Value<int> lineNumber = const Value.absent(),
            Value<String> partNumber = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> brand = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String?> supplierName = const Value.absent(),
            Value<int?> deliveryDays = const Value.absent(),
            Value<bool> isOrdered = const Value.absent(),
            Value<bool> isReceived = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> modifiedAt = const Value.absent(),
          }) =>
              OrderPartsItemsCompanion(
            id: id,
            uuid: uuid,
            documentUuid: documentUuid,
            lineNumber: lineNumber,
            partNumber: partNumber,
            name: name,
            brand: brand,
            quantity: quantity,
            price: price,
            supplierName: supplierName,
            deliveryDays: deliveryDays,
            isOrdered: isOrdered,
            isReceived: isReceived,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            required String documentUuid,
            Value<int> lineNumber = const Value.absent(),
            required String partNumber,
            required String name,
            Value<String?> brand = const Value.absent(),
            Value<double> quantity = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String?> supplierName = const Value.absent(),
            Value<int?> deliveryDays = const Value.absent(),
            Value<bool> isOrdered = const Value.absent(),
            Value<bool> isReceived = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> modifiedAt = const Value.absent(),
          }) =>
              OrderPartsItemsCompanion.insert(
            id: id,
            uuid: uuid,
            documentUuid: documentUuid,
            lineNumber: lineNumber,
            partNumber: partNumber,
            name: name,
            brand: brand,
            quantity: quantity,
            price: price,
            supplierName: supplierName,
            deliveryDays: deliveryDays,
            isOrdered: isOrdered,
            isReceived: isReceived,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OrderPartsItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({documentUuid = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (documentUuid) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.documentUuid,
                    referencedTable:
                        $$OrderPartsItemsTableReferences._documentUuidTable(db),
                    referencedColumn: $$OrderPartsItemsTableReferences
                        ._documentUuidTable(db)
                        .uuid,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OrderPartsItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrderPartsItemsTable,
    OrderPartsItem,
    $$OrderPartsItemsTableFilterComposer,
    $$OrderPartsItemsTableOrderingComposer,
    $$OrderPartsItemsTableAnnotationComposer,
    $$OrderPartsItemsTableCreateCompanionBuilder,
    $$OrderPartsItemsTableUpdateCompanionBuilder,
    (OrderPartsItem, $$OrderPartsItemsTableReferences),
    OrderPartsItem,
    PrefetchHooks Function({bool documentUuid})>;
typedef $$OrderServicesItemsTableCreateCompanionBuilder
    = OrderServicesItemsCompanion Function({
  Value<int> id,
  Value<String> uuid,
  required String documentUuid,
  Value<int> lineNumber,
  required String name,
  Value<String?> description,
  Value<double> price,
  Value<double?> duration,
  Value<String?> performedBy,
  Value<bool> isCompleted,
  required DateTime createdAt,
  Value<DateTime?> modifiedAt,
});
typedef $$OrderServicesItemsTableUpdateCompanionBuilder
    = OrderServicesItemsCompanion Function({
  Value<int> id,
  Value<String> uuid,
  Value<String> documentUuid,
  Value<int> lineNumber,
  Value<String> name,
  Value<String?> description,
  Value<double> price,
  Value<double?> duration,
  Value<String?> performedBy,
  Value<bool> isCompleted,
  Value<DateTime> createdAt,
  Value<DateTime?> modifiedAt,
});

final class $$OrderServicesItemsTableReferences extends BaseReferences<
    _$AppDatabase, $OrderServicesItemsTable, OrderServicesItem> {
  $$OrderServicesItemsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $OrdersItemsTable _documentUuidTable(_$AppDatabase db) =>
      db.ordersItems.createAlias($_aliasNameGenerator(
          db.orderServicesItems.documentUuid, db.ordersItems.uuid));

  $$OrdersItemsTableProcessedTableManager get documentUuid {
    final $_column = $_itemColumn<String>('document_uuid')!;

    final manager = $$OrdersItemsTableTableManager($_db, $_db.ordersItems)
        .filter((f) => f.uuid.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentUuidTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OrderServicesItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderServicesItemsTable> {
  $$OrderServicesItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lineNumber => $composableBuilder(
      column: $table.lineNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get performedBy => $composableBuilder(
      column: $table.performedBy, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnFilters(column));

  $$OrdersItemsTableFilterComposer get documentUuid {
    final $$OrdersItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.documentUuid,
        referencedTable: $db.ordersItems,
        getReferencedColumn: (t) => t.uuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersItemsTableFilterComposer(
              $db: $db,
              $table: $db.ordersItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderServicesItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderServicesItemsTable> {
  $$OrderServicesItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get uuid => $composableBuilder(
      column: $table.uuid, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lineNumber => $composableBuilder(
      column: $table.lineNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get duration => $composableBuilder(
      column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get performedBy => $composableBuilder(
      column: $table.performedBy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => ColumnOrderings(column));

  $$OrdersItemsTableOrderingComposer get documentUuid {
    final $$OrdersItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.documentUuid,
        referencedTable: $db.ordersItems,
        getReferencedColumn: (t) => t.uuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersItemsTableOrderingComposer(
              $db: $db,
              $table: $db.ordersItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderServicesItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderServicesItemsTable> {
  $$OrderServicesItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<int> get lineNumber => $composableBuilder(
      column: $table.lineNumber, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<String> get performedBy => $composableBuilder(
      column: $table.performedBy, builder: (column) => column);

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
      column: $table.isCompleted, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get modifiedAt => $composableBuilder(
      column: $table.modifiedAt, builder: (column) => column);

  $$OrdersItemsTableAnnotationComposer get documentUuid {
    final $$OrdersItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.documentUuid,
        referencedTable: $db.ordersItems,
        getReferencedColumn: (t) => t.uuid,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.ordersItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderServicesItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrderServicesItemsTable,
    OrderServicesItem,
    $$OrderServicesItemsTableFilterComposer,
    $$OrderServicesItemsTableOrderingComposer,
    $$OrderServicesItemsTableAnnotationComposer,
    $$OrderServicesItemsTableCreateCompanionBuilder,
    $$OrderServicesItemsTableUpdateCompanionBuilder,
    (OrderServicesItem, $$OrderServicesItemsTableReferences),
    OrderServicesItem,
    PrefetchHooks Function({bool documentUuid})> {
  $$OrderServicesItemsTableTableManager(
      _$AppDatabase db, $OrderServicesItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderServicesItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderServicesItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderServicesItemsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            Value<String> documentUuid = const Value.absent(),
            Value<int> lineNumber = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double?> duration = const Value.absent(),
            Value<String?> performedBy = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime?> modifiedAt = const Value.absent(),
          }) =>
              OrderServicesItemsCompanion(
            id: id,
            uuid: uuid,
            documentUuid: documentUuid,
            lineNumber: lineNumber,
            name: name,
            description: description,
            price: price,
            duration: duration,
            performedBy: performedBy,
            isCompleted: isCompleted,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> uuid = const Value.absent(),
            required String documentUuid,
            Value<int> lineNumber = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double?> duration = const Value.absent(),
            Value<String?> performedBy = const Value.absent(),
            Value<bool> isCompleted = const Value.absent(),
            required DateTime createdAt,
            Value<DateTime?> modifiedAt = const Value.absent(),
          }) =>
              OrderServicesItemsCompanion.insert(
            id: id,
            uuid: uuid,
            documentUuid: documentUuid,
            lineNumber: lineNumber,
            name: name,
            description: description,
            price: price,
            duration: duration,
            performedBy: performedBy,
            isCompleted: isCompleted,
            createdAt: createdAt,
            modifiedAt: modifiedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OrderServicesItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({documentUuid = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (documentUuid) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.documentUuid,
                    referencedTable: $$OrderServicesItemsTableReferences
                        ._documentUuidTable(db),
                    referencedColumn: $$OrderServicesItemsTableReferences
                        ._documentUuidTable(db)
                        .uuid,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OrderServicesItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrderServicesItemsTable,
    OrderServicesItem,
    $$OrderServicesItemsTableFilterComposer,
    $$OrderServicesItemsTableOrderingComposer,
    $$OrderServicesItemsTableAnnotationComposer,
    $$OrderServicesItemsTableCreateCompanionBuilder,
    $$OrderServicesItemsTableUpdateCompanionBuilder,
    (OrderServicesItem, $$OrderServicesItemsTableReferences),
    OrderServicesItem,
    PrefetchHooks Function({bool documentUuid})>;
typedef $$SupplierSettingsItemsTableCreateCompanionBuilder
    = SupplierSettingsItemsCompanion Function({
  Value<int> id,
  required String supplierCode,
  Value<bool> isEnabled,
  Value<String?> encryptedCredentials,
  Value<String?> lastCheckStatus,
  Value<String?> lastCheckMessage,
  Value<DateTime?> lastSuccessfulCheckAt,
  Value<String?> clientIdentifierAtSupplier,
  Value<String?> additionalConfig,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});
typedef $$SupplierSettingsItemsTableUpdateCompanionBuilder
    = SupplierSettingsItemsCompanion Function({
  Value<int> id,
  Value<String> supplierCode,
  Value<bool> isEnabled,
  Value<String?> encryptedCredentials,
  Value<String?> lastCheckStatus,
  Value<String?> lastCheckMessage,
  Value<DateTime?> lastSuccessfulCheckAt,
  Value<String?> clientIdentifierAtSupplier,
  Value<String?> additionalConfig,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
});

class $$SupplierSettingsItemsTableFilterComposer
    extends Composer<_$AppDatabase, $SupplierSettingsItemsTable> {
  $$SupplierSettingsItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get supplierCode => $composableBuilder(
      column: $table.supplierCode, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isEnabled => $composableBuilder(
      column: $table.isEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get encryptedCredentials => $composableBuilder(
      column: $table.encryptedCredentials,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastCheckStatus => $composableBuilder(
      column: $table.lastCheckStatus,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastCheckMessage => $composableBuilder(
      column: $table.lastCheckMessage,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSuccessfulCheckAt => $composableBuilder(
      column: $table.lastSuccessfulCheckAt,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientIdentifierAtSupplier => $composableBuilder(
      column: $table.clientIdentifierAtSupplier,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get additionalConfig => $composableBuilder(
      column: $table.additionalConfig,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SupplierSettingsItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplierSettingsItemsTable> {
  $$SupplierSettingsItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get supplierCode => $composableBuilder(
      column: $table.supplierCode,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
      column: $table.isEnabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get encryptedCredentials => $composableBuilder(
      column: $table.encryptedCredentials,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastCheckStatus => $composableBuilder(
      column: $table.lastCheckStatus,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastCheckMessage => $composableBuilder(
      column: $table.lastCheckMessage,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSuccessfulCheckAt => $composableBuilder(
      column: $table.lastSuccessfulCheckAt,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientIdentifierAtSupplier => $composableBuilder(
      column: $table.clientIdentifierAtSupplier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get additionalConfig => $composableBuilder(
      column: $table.additionalConfig,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
      column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SupplierSettingsItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplierSettingsItemsTable> {
  $$SupplierSettingsItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get supplierCode => $composableBuilder(
      column: $table.supplierCode, builder: (column) => column);

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);

  GeneratedColumn<String> get encryptedCredentials => $composableBuilder(
      column: $table.encryptedCredentials, builder: (column) => column);

  GeneratedColumn<String> get lastCheckStatus => $composableBuilder(
      column: $table.lastCheckStatus, builder: (column) => column);

  GeneratedColumn<String> get lastCheckMessage => $composableBuilder(
      column: $table.lastCheckMessage, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSuccessfulCheckAt => $composableBuilder(
      column: $table.lastSuccessfulCheckAt, builder: (column) => column);

  GeneratedColumn<String> get clientIdentifierAtSupplier => $composableBuilder(
      column: $table.clientIdentifierAtSupplier, builder: (column) => column);

  GeneratedColumn<String> get additionalConfig => $composableBuilder(
      column: $table.additionalConfig, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SupplierSettingsItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SupplierSettingsItemsTable,
    SupplierSettingsItem,
    $$SupplierSettingsItemsTableFilterComposer,
    $$SupplierSettingsItemsTableOrderingComposer,
    $$SupplierSettingsItemsTableAnnotationComposer,
    $$SupplierSettingsItemsTableCreateCompanionBuilder,
    $$SupplierSettingsItemsTableUpdateCompanionBuilder,
    (
      SupplierSettingsItem,
      BaseReferences<_$AppDatabase, $SupplierSettingsItemsTable,
          SupplierSettingsItem>
    ),
    SupplierSettingsItem,
    PrefetchHooks Function()> {
  $$SupplierSettingsItemsTableTableManager(
      _$AppDatabase db, $SupplierSettingsItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplierSettingsItemsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplierSettingsItemsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplierSettingsItemsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> supplierCode = const Value.absent(),
            Value<bool> isEnabled = const Value.absent(),
            Value<String?> encryptedCredentials = const Value.absent(),
            Value<String?> lastCheckStatus = const Value.absent(),
            Value<String?> lastCheckMessage = const Value.absent(),
            Value<DateTime?> lastSuccessfulCheckAt = const Value.absent(),
            Value<String?> clientIdentifierAtSupplier = const Value.absent(),
            Value<String?> additionalConfig = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SupplierSettingsItemsCompanion(
            id: id,
            supplierCode: supplierCode,
            isEnabled: isEnabled,
            encryptedCredentials: encryptedCredentials,
            lastCheckStatus: lastCheckStatus,
            lastCheckMessage: lastCheckMessage,
            lastSuccessfulCheckAt: lastSuccessfulCheckAt,
            clientIdentifierAtSupplier: clientIdentifierAtSupplier,
            additionalConfig: additionalConfig,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String supplierCode,
            Value<bool> isEnabled = const Value.absent(),
            Value<String?> encryptedCredentials = const Value.absent(),
            Value<String?> lastCheckStatus = const Value.absent(),
            Value<String?> lastCheckMessage = const Value.absent(),
            Value<DateTime?> lastSuccessfulCheckAt = const Value.absent(),
            Value<String?> clientIdentifierAtSupplier = const Value.absent(),
            Value<String?> additionalConfig = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<DateTime> updatedAt = const Value.absent(),
          }) =>
              SupplierSettingsItemsCompanion.insert(
            id: id,
            supplierCode: supplierCode,
            isEnabled: isEnabled,
            encryptedCredentials: encryptedCredentials,
            lastCheckStatus: lastCheckStatus,
            lastCheckMessage: lastCheckMessage,
            lastSuccessfulCheckAt: lastSuccessfulCheckAt,
            clientIdentifierAtSupplier: clientIdentifierAtSupplier,
            additionalConfig: additionalConfig,
            createdAt: createdAt,
            updatedAt: updatedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SupplierSettingsItemsTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $SupplierSettingsItemsTable,
        SupplierSettingsItem,
        $$SupplierSettingsItemsTableFilterComposer,
        $$SupplierSettingsItemsTableOrderingComposer,
        $$SupplierSettingsItemsTableAnnotationComposer,
        $$SupplierSettingsItemsTableCreateCompanionBuilder,
        $$SupplierSettingsItemsTableUpdateCompanionBuilder,
        (
          SupplierSettingsItem,
          BaseReferences<_$AppDatabase, $SupplierSettingsItemsTable,
              SupplierSettingsItem>
        ),
        SupplierSettingsItem,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientsItemsTableTableManager get clientsItems =>
      $$ClientsItemsTableTableManager(_db, _db.clientsItems);
  $$CarsItemsTableTableManager get carsItems =>
      $$CarsItemsTableTableManager(_db, _db.carsItems);
  $$OrdersItemsTableTableManager get ordersItems =>
      $$OrdersItemsTableTableManager(_db, _db.ordersItems);
  $$OrderPartsItemsTableTableManager get orderPartsItems =>
      $$OrderPartsItemsTableTableManager(_db, _db.orderPartsItems);
  $$OrderServicesItemsTableTableManager get orderServicesItems =>
      $$OrderServicesItemsTableTableManager(_db, _db.orderServicesItems);
  $$SupplierSettingsItemsTableTableManager get supplierSettingsItems =>
      $$SupplierSettingsItemsTableTableManager(_db, _db.supplierSettingsItems);
}
