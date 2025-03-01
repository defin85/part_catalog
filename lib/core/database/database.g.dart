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
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, name, contactInfo, additionalInfo, deletedAt];
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
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      contactInfo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}contact_info'])!,
      additionalInfo: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}additional_info']),
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
  final String type;
  final String name;
  final String contactInfo;
  final String? additionalInfo;
  final DateTime? deletedAt;
  const ClientsItem(
      {required this.id,
      required this.type,
      required this.name,
      required this.contactInfo,
      this.additionalInfo,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    map['contact_info'] = Variable<String>(contactInfo);
    if (!nullToAbsent || additionalInfo != null) {
      map['additional_info'] = Variable<String>(additionalInfo);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  ClientsItemsCompanion toCompanion(bool nullToAbsent) {
    return ClientsItemsCompanion(
      id: Value(id),
      type: Value(type),
      name: Value(name),
      contactInfo: Value(contactInfo),
      additionalInfo: additionalInfo == null && nullToAbsent
          ? const Value.absent()
          : Value(additionalInfo),
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
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      contactInfo: serializer.fromJson<String>(json['contactInfo']),
      additionalInfo: serializer.fromJson<String?>(json['additionalInfo']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'contactInfo': serializer.toJson<String>(contactInfo),
      'additionalInfo': serializer.toJson<String?>(additionalInfo),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  ClientsItem copyWith(
          {int? id,
          String? type,
          String? name,
          String? contactInfo,
          Value<String?> additionalInfo = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      ClientsItem(
        id: id ?? this.id,
        type: type ?? this.type,
        name: name ?? this.name,
        contactInfo: contactInfo ?? this.contactInfo,
        additionalInfo:
            additionalInfo.present ? additionalInfo.value : this.additionalInfo,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  ClientsItem copyWithCompanion(ClientsItemsCompanion data) {
    return ClientsItem(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      contactInfo:
          data.contactInfo.present ? data.contactInfo.value : this.contactInfo,
      additionalInfo: data.additionalInfo.present
          ? data.additionalInfo.value
          : this.additionalInfo,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClientsItem(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('contactInfo: $contactInfo, ')
          ..write('additionalInfo: $additionalInfo, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, name, contactInfo, additionalInfo, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClientsItem &&
          other.id == this.id &&
          other.type == this.type &&
          other.name == this.name &&
          other.contactInfo == this.contactInfo &&
          other.additionalInfo == this.additionalInfo &&
          other.deletedAt == this.deletedAt);
}

class ClientsItemsCompanion extends UpdateCompanion<ClientsItem> {
  final Value<int> id;
  final Value<String> type;
  final Value<String> name;
  final Value<String> contactInfo;
  final Value<String?> additionalInfo;
  final Value<DateTime?> deletedAt;
  const ClientsItemsCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.contactInfo = const Value.absent(),
    this.additionalInfo = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  ClientsItemsCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required String name,
    required String contactInfo,
    this.additionalInfo = const Value.absent(),
    this.deletedAt = const Value.absent(),
  })  : type = Value(type),
        name = Value(name),
        contactInfo = Value(contactInfo);
  static Insertable<ClientsItem> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<String>? name,
    Expression<String>? contactInfo,
    Expression<String>? additionalInfo,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (contactInfo != null) 'contact_info': contactInfo,
      if (additionalInfo != null) 'additional_info': additionalInfo,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  ClientsItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? type,
      Value<String>? name,
      Value<String>? contactInfo,
      Value<String?>? additionalInfo,
      Value<DateTime?>? deletedAt}) {
    return ClientsItemsCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      contactInfo: contactInfo ?? this.contactInfo,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
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
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClientsItemsCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('contactInfo: $contactInfo, ')
          ..write('additionalInfo: $additionalInfo, ')
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
  static const VerificationMeta _deletedAtMeta =
      const VerificationMeta('deletedAt');
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
      'deleted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        clientId,
        vin,
        make,
        model,
        year,
        licensePlate,
        additionalInfo,
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
  final int clientId;
  final String? vin;
  final String make;
  final String model;
  final int? year;
  final String? licensePlate;
  final String? additionalInfo;
  final DateTime? deletedAt;
  const CarsItem(
      {required this.id,
      required this.clientId,
      this.vin,
      required this.make,
      required this.model,
      this.year,
      this.licensePlate,
      this.additionalInfo,
      this.deletedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
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
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  CarsItemsCompanion toCompanion(bool nullToAbsent) {
    return CarsItemsCompanion(
      id: Value(id),
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
      clientId: serializer.fromJson<int>(json['clientId']),
      vin: serializer.fromJson<String?>(json['vin']),
      make: serializer.fromJson<String>(json['make']),
      model: serializer.fromJson<String>(json['model']),
      year: serializer.fromJson<int?>(json['year']),
      licensePlate: serializer.fromJson<String?>(json['licensePlate']),
      additionalInfo: serializer.fromJson<String?>(json['additionalInfo']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'clientId': serializer.toJson<int>(clientId),
      'vin': serializer.toJson<String?>(vin),
      'make': serializer.toJson<String>(make),
      'model': serializer.toJson<String>(model),
      'year': serializer.toJson<int?>(year),
      'licensePlate': serializer.toJson<String?>(licensePlate),
      'additionalInfo': serializer.toJson<String?>(additionalInfo),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  CarsItem copyWith(
          {int? id,
          int? clientId,
          Value<String?> vin = const Value.absent(),
          String? make,
          String? model,
          Value<int?> year = const Value.absent(),
          Value<String?> licensePlate = const Value.absent(),
          Value<String?> additionalInfo = const Value.absent(),
          Value<DateTime?> deletedAt = const Value.absent()}) =>
      CarsItem(
        id: id ?? this.id,
        clientId: clientId ?? this.clientId,
        vin: vin.present ? vin.value : this.vin,
        make: make ?? this.make,
        model: model ?? this.model,
        year: year.present ? year.value : this.year,
        licensePlate:
            licensePlate.present ? licensePlate.value : this.licensePlate,
        additionalInfo:
            additionalInfo.present ? additionalInfo.value : this.additionalInfo,
        deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
      );
  CarsItem copyWithCompanion(CarsItemsCompanion data) {
    return CarsItem(
      id: data.id.present ? data.id.value : this.id,
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
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CarsItem(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('vin: $vin, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('licensePlate: $licensePlate, ')
          ..write('additionalInfo: $additionalInfo, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, clientId, vin, make, model, year,
      licensePlate, additionalInfo, deletedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CarsItem &&
          other.id == this.id &&
          other.clientId == this.clientId &&
          other.vin == this.vin &&
          other.make == this.make &&
          other.model == this.model &&
          other.year == this.year &&
          other.licensePlate == this.licensePlate &&
          other.additionalInfo == this.additionalInfo &&
          other.deletedAt == this.deletedAt);
}

class CarsItemsCompanion extends UpdateCompanion<CarsItem> {
  final Value<int> id;
  final Value<int> clientId;
  final Value<String?> vin;
  final Value<String> make;
  final Value<String> model;
  final Value<int?> year;
  final Value<String?> licensePlate;
  final Value<String?> additionalInfo;
  final Value<DateTime?> deletedAt;
  const CarsItemsCompanion({
    this.id = const Value.absent(),
    this.clientId = const Value.absent(),
    this.vin = const Value.absent(),
    this.make = const Value.absent(),
    this.model = const Value.absent(),
    this.year = const Value.absent(),
    this.licensePlate = const Value.absent(),
    this.additionalInfo = const Value.absent(),
    this.deletedAt = const Value.absent(),
  });
  CarsItemsCompanion.insert({
    this.id = const Value.absent(),
    required int clientId,
    this.vin = const Value.absent(),
    required String make,
    required String model,
    this.year = const Value.absent(),
    this.licensePlate = const Value.absent(),
    this.additionalInfo = const Value.absent(),
    this.deletedAt = const Value.absent(),
  })  : clientId = Value(clientId),
        make = Value(make),
        model = Value(model);
  static Insertable<CarsItem> custom({
    Expression<int>? id,
    Expression<int>? clientId,
    Expression<String>? vin,
    Expression<String>? make,
    Expression<String>? model,
    Expression<int>? year,
    Expression<String>? licensePlate,
    Expression<String>? additionalInfo,
    Expression<DateTime>? deletedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (clientId != null) 'client_id': clientId,
      if (vin != null) 'vin': vin,
      if (make != null) 'make': make,
      if (model != null) 'model': model,
      if (year != null) 'year': year,
      if (licensePlate != null) 'license_plate': licensePlate,
      if (additionalInfo != null) 'additional_info': additionalInfo,
      if (deletedAt != null) 'deleted_at': deletedAt,
    });
  }

  CarsItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? clientId,
      Value<String?>? vin,
      Value<String>? make,
      Value<String>? model,
      Value<int?>? year,
      Value<String?>? licensePlate,
      Value<String?>? additionalInfo,
      Value<DateTime?>? deletedAt}) {
    return CarsItemsCompanion(
      id: id ?? this.id,
      clientId: clientId ?? this.clientId,
      vin: vin ?? this.vin,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      licensePlate: licensePlate ?? this.licensePlate,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
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
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CarsItemsCompanion(')
          ..write('id: $id, ')
          ..write('clientId: $clientId, ')
          ..write('vin: $vin, ')
          ..write('make: $make, ')
          ..write('model: $model, ')
          ..write('year: $year, ')
          ..write('licensePlate: $licensePlate, ')
          ..write('additionalInfo: $additionalInfo, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }
}

class $AppInfoItemsTable extends AppInfoItems
    with TableInfo<$AppInfoItemsTable, AppInfoItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppInfoItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_info_items';
  @override
  VerificationContext validateIntegrity(Insertable<AppInfoItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppInfoItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppInfoItem(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $AppInfoItemsTable createAlias(String alias) {
    return $AppInfoItemsTable(attachedDatabase, alias);
  }
}

class AppInfoItem extends DataClass implements Insertable<AppInfoItem> {
  final String key;
  final String value;
  const AppInfoItem({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppInfoItemsCompanion toCompanion(bool nullToAbsent) {
    return AppInfoItemsCompanion(
      key: Value(key),
      value: Value(value),
    );
  }

  factory AppInfoItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppInfoItem(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppInfoItem copyWith({String? key, String? value}) => AppInfoItem(
        key: key ?? this.key,
        value: value ?? this.value,
      );
  AppInfoItem copyWithCompanion(AppInfoItemsCompanion data) {
    return AppInfoItem(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppInfoItem(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppInfoItem &&
          other.key == this.key &&
          other.value == this.value);
}

class AppInfoItemsCompanion extends UpdateCompanion<AppInfoItem> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppInfoItemsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppInfoItemsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  })  : key = Value(key),
        value = Value(value);
  static Insertable<AppInfoItem> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppInfoItemsCompanion copyWith(
      {Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return AppInfoItemsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppInfoItemsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ClientsItemsTable clientsItems = $ClientsItemsTable(this);
  late final $CarsItemsTable carsItems = $CarsItemsTable(this);
  late final $AppInfoItemsTable appInfoItems = $AppInfoItemsTable(this);
  late final ClientsDao clientsDao = ClientsDao(this as AppDatabase);
  late final CarsDao carsDao = CarsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [clientsItems, carsItems, appInfoItems];
}

typedef $$ClientsItemsTableCreateCompanionBuilder = ClientsItemsCompanion
    Function({
  Value<int> id,
  required String type,
  required String name,
  required String contactInfo,
  Value<String?> additionalInfo,
  Value<DateTime?> deletedAt,
});
typedef $$ClientsItemsTableUpdateCompanionBuilder = ClientsItemsCompanion
    Function({
  Value<int> id,
  Value<String> type,
  Value<String> name,
  Value<String> contactInfo,
  Value<String?> additionalInfo,
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

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get contactInfo => $composableBuilder(
      column: $table.contactInfo, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get additionalInfo => $composableBuilder(
      column: $table.additionalInfo,
      builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get contactInfo => $composableBuilder(
      column: $table.contactInfo, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get additionalInfo => $composableBuilder(
      column: $table.additionalInfo,
      builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get contactInfo => $composableBuilder(
      column: $table.contactInfo, builder: (column) => column);

  GeneratedColumn<String> get additionalInfo => $composableBuilder(
      column: $table.additionalInfo, builder: (column) => column);

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
    PrefetchHooks Function({bool carsItemsRefs})> {
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
            Value<String> type = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> contactInfo = const Value.absent(),
            Value<String?> additionalInfo = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
          }) =>
              ClientsItemsCompanion(
            id: id,
            type: type,
            name: name,
            contactInfo: contactInfo,
            additionalInfo: additionalInfo,
            deletedAt: deletedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String type,
            required String name,
            required String contactInfo,
            Value<String?> additionalInfo = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
          }) =>
              ClientsItemsCompanion.insert(
            id: id,
            type: type,
            name: name,
            contactInfo: contactInfo,
            additionalInfo: additionalInfo,
            deletedAt: deletedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ClientsItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({carsItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (carsItemsRefs) db.carsItems],
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
    PrefetchHooks Function({bool carsItemsRefs})>;
typedef $$CarsItemsTableCreateCompanionBuilder = CarsItemsCompanion Function({
  Value<int> id,
  required int clientId,
  Value<String?> vin,
  required String make,
  required String model,
  Value<int?> year,
  Value<String?> licensePlate,
  Value<String?> additionalInfo,
  Value<DateTime?> deletedAt,
});
typedef $$CarsItemsTableUpdateCompanionBuilder = CarsItemsCompanion Function({
  Value<int> id,
  Value<int> clientId,
  Value<String?> vin,
  Value<String> make,
  Value<String> model,
  Value<int?> year,
  Value<String?> licensePlate,
  Value<String?> additionalInfo,
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
    PrefetchHooks Function({bool clientId})> {
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
            Value<int> clientId = const Value.absent(),
            Value<String?> vin = const Value.absent(),
            Value<String> make = const Value.absent(),
            Value<String> model = const Value.absent(),
            Value<int?> year = const Value.absent(),
            Value<String?> licensePlate = const Value.absent(),
            Value<String?> additionalInfo = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
          }) =>
              CarsItemsCompanion(
            id: id,
            clientId: clientId,
            vin: vin,
            make: make,
            model: model,
            year: year,
            licensePlate: licensePlate,
            additionalInfo: additionalInfo,
            deletedAt: deletedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int clientId,
            Value<String?> vin = const Value.absent(),
            required String make,
            required String model,
            Value<int?> year = const Value.absent(),
            Value<String?> licensePlate = const Value.absent(),
            Value<String?> additionalInfo = const Value.absent(),
            Value<DateTime?> deletedAt = const Value.absent(),
          }) =>
              CarsItemsCompanion.insert(
            id: id,
            clientId: clientId,
            vin: vin,
            make: make,
            model: model,
            year: year,
            licensePlate: licensePlate,
            additionalInfo: additionalInfo,
            deletedAt: deletedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$CarsItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({clientId = false}) {
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
                return [];
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
    PrefetchHooks Function({bool clientId})>;
typedef $$AppInfoItemsTableCreateCompanionBuilder = AppInfoItemsCompanion
    Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$AppInfoItemsTableUpdateCompanionBuilder = AppInfoItemsCompanion
    Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$AppInfoItemsTableFilterComposer
    extends Composer<_$AppDatabase, $AppInfoItemsTable> {
  $$AppInfoItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$AppInfoItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppInfoItemsTable> {
  $$AppInfoItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$AppInfoItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppInfoItemsTable> {
  $$AppInfoItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppInfoItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppInfoItemsTable,
    AppInfoItem,
    $$AppInfoItemsTableFilterComposer,
    $$AppInfoItemsTableOrderingComposer,
    $$AppInfoItemsTableAnnotationComposer,
    $$AppInfoItemsTableCreateCompanionBuilder,
    $$AppInfoItemsTableUpdateCompanionBuilder,
    (
      AppInfoItem,
      BaseReferences<_$AppDatabase, $AppInfoItemsTable, AppInfoItem>
    ),
    AppInfoItem,
    PrefetchHooks Function()> {
  $$AppInfoItemsTableTableManager(_$AppDatabase db, $AppInfoItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppInfoItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppInfoItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppInfoItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppInfoItemsCompanion(
            key: key,
            value: value,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) =>
              AppInfoItemsCompanion.insert(
            key: key,
            value: value,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppInfoItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppInfoItemsTable,
    AppInfoItem,
    $$AppInfoItemsTableFilterComposer,
    $$AppInfoItemsTableOrderingComposer,
    $$AppInfoItemsTableAnnotationComposer,
    $$AppInfoItemsTableCreateCompanionBuilder,
    $$AppInfoItemsTableUpdateCompanionBuilder,
    (
      AppInfoItem,
      BaseReferences<_$AppDatabase, $AppInfoItemsTable, AppInfoItem>
    ),
    AppInfoItem,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ClientsItemsTableTableManager get clientsItems =>
      $$ClientsItemsTableTableManager(_db, _db.clientsItems);
  $$CarsItemsTableTableManager get carsItems =>
      $$CarsItemsTableTableManager(_db, _db.carsItems);
  $$AppInfoItemsTableTableManager get appInfoItems =>
      $$AppInfoItemsTableTableManager(_db, _db.appInfoItems);
}
