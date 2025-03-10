# Tree View:
```
.\lib
├─core
│ ├─database
│ │ ├─daos
│ │ │ ├─cars_dao.dart
│ │ │ ├─cars_dao.g.dart
│ │ │ ├─clients_dao.dart
│ │ │ └─clients_dao.g.dart
│ │ ├─database.dart
│ │ ├─database.g.dart
│ │ ├─database_logger.dart
│ │ ├─items
│ │ │ ├─app_info_items.dart
│ │ │ ├─cars_items.dart
│ │ │ └─clients_items.dart
│ │ └─schema_synchronizer.dart
│ ├─schemas
│ │ └─app_schema.json
│ ├─service_locator.dart
│ └─utils
│   ├─json_converter.dart
│   └─logger_config.dart
├─features
│ ├─clients
│ │ ├─models
│ │ │ ├─client.dart
│ │ │ ├─client.g.dart
│ │ │ └─client_type.dart
│ │ ├─screens
│ │ │ └─clients_screen.dart
│ │ └─services
│ │   └─client_service.dart
│ ├─orders
│ │ ├─models
│ │ │ ├─order.dart
│ │ │ ├─order.g.dart
│ │ │ ├─order_item.dart
│ │ │ └─order_item.g.dart
│ │ ├─screens
│ │ └─services
│ ├─parts_catalog
│ │ ├─api
│ │ │ ├─PartsCatalogsRestAPI.md
│ │ │ ├─api_client_parts_catalogs.dart
│ │ │ └─api_client_parts_catalogs.g.dart
│ │ ├─models
│ │ │ ├─car2.dart
│ │ │ ├─car2.freezed.dart
│ │ │ ├─car2.g.dart
│ │ │ ├─car_info.dart
│ │ │ ├─car_info.freezed.dart
│ │ │ ├─car_info.g.dart
│ │ │ ├─car_parameter.dart
│ │ │ ├─car_parameter.freezed.dart
│ │ │ ├─car_parameter.g.dart
│ │ │ ├─car_parameter_idx.dart
│ │ │ ├─car_parameter_idx.freezed.dart
│ │ │ ├─car_parameter_idx.g.dart
│ │ │ ├─car_parameter_info.dart
│ │ │ ├─car_parameter_info.freezed.dart
│ │ │ ├─car_parameter_info.g.dart
│ │ │ ├─catalog.dart
│ │ │ ├─catalog.freezed.dart
│ │ │ ├─catalog.g.dart
│ │ │ ├─error.dart
│ │ │ ├─error.freezed.dart
│ │ │ ├─error.g.dart
│ │ │ ├─example_prices_response.dart
│ │ │ ├─example_prices_response.freezed.dart
│ │ │ ├─example_prices_response.g.dart
│ │ │ ├─group.dart
│ │ │ ├─group.freezed.dart
│ │ │ ├─group.g.dart
│ │ │ ├─groups_tree.dart
│ │ │ ├─groups_tree.freezed.dart
│ │ │ ├─groups_tree.g.dart
│ │ │ ├─groups_tree_response.dart
│ │ │ ├─groups_tree_response.freezed.dart
│ │ │ ├─groups_tree_response.g.dart
│ │ │ ├─ip.dart
│ │ │ ├─ip.freezed.dart
│ │ │ ├─ip.g.dart
│ │ │ ├─model.dart
│ │ │ ├─model.freezed.dart
│ │ │ ├─model.g.dart
│ │ │ ├─option_code.dart
│ │ │ ├─option_code.freezed.dart
│ │ │ ├─option_code.g.dart
│ │ │ ├─part.dart
│ │ │ ├─part.freezed.dart
│ │ │ ├─part.g.dart
│ │ │ ├─part_name.dart
│ │ │ ├─part_name.freezed.dart
│ │ │ ├─part_name.g.dart
│ │ │ ├─parts.dart
│ │ │ ├─parts.freezed.dart
│ │ │ ├─parts.g.dart
│ │ │ ├─parts_group.dart
│ │ │ ├─parts_group.freezed.dart
│ │ │ ├─parts_group.g.dart
│ │ │ ├─position.dart
│ │ │ ├─position.freezed.dart
│ │ │ ├─position.g.dart
│ │ │ ├─schema_model.dart
│ │ │ ├─schema_model.freezed.dart
│ │ │ ├─schema_model.g.dart
│ │ │ ├─schemas_response.dart
│ │ │ ├─schemas_response.freezed.dart
│ │ │ ├─schemas_response.g.dart
│ │ │ ├─suggest.dart
│ │ │ ├─suggest.freezed.dart
│ │ │ └─suggest.g.dart
│ │ ├─screens
│ │ └─widgets
│ │   ├─car_info_widget.dart
│ │   └─schema_list_widget.dart
│ ├─suppliers
│ │ ├─api
│ │ └─models
│ │   ├─price_offer.dart
│ │   ├─price_offer.g.dart
│ │   ├─supplier.dart
│ │   └─supplier.g.dart
│ └─vehicles
│   ├─models
│   │ ├─car.dart
│   │ └─car.g.dart
│   ├─screens
│   │ └─cars_screen.dart
│   └─services
│     └─car_service.dart
├─main.dart
└─models
```

# Content:

## lib\core\database\daos\cars_dao.dart
```dart
import 'package:drift/drift.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/items/cars_items.dart';
import 'package:part_catalog/core/database/items/clients_items.dart';

part 'cars_dao.g.dart';

/// {@template cars_dao}
/// Объект доступа к данным для работы с автомобилями.
/// {@endtemplate}
@DriftAccessor(tables: [CarsItems, ClientsItems])
class CarsDao extends DatabaseAccessor<AppDatabase> with _$CarsDaoMixin {
  /// {@macro cars_dao}
  CarsDao(super.db);

  /// Возвращает поток списка всех автомобилей.
  Stream<List<CarsItem>> watchAllCars() {
    return (select(carsItems)..where((c) => c.deletedAt.isNull())).watch();
  }

  /// Возвращает поток списка автомобилей, принадлежащих указанному клиенту.
  Stream<List<CarsItem>> watchClientCars(int clientId) {
    return (select(carsItems)
          ..where((c) => c.clientId.equals(clientId) & c.deletedAt.isNull()))
        .watch();
  }

  /// Возвращает автомобиль по его идентификатору.
  Future<CarsItem?> getCarById(int id) {
    return (select(carsItems)
          ..where((c) => c.id.equals(id) & c.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Добавляет новую запись об автомобиле.
  Future<int> insertCar(CarsItemsCompanion car) {
    return into(carsItems).insert(car);
  }

  /// Обновляет информацию об автомобиле.
  Future<bool> updateCar(CarsItemsCompanion car) {
    return update(carsItems).replace(car);
  }

  /// Мягкое удаление автомобиля.
  Future<int> softDeleteCar(int id) {
    return (update(carsItems)..where((c) => c.id.equals(id)))
        .write(CarsItemsCompanion(deletedAt: Value(DateTime.now())));
  }

  /// Возвращает список автомобилей с информацией о владельцах.
  Future<List<CarWithOwner>> getCarsWithOwners() {
    final query = select(carsItems).join([
      innerJoin(
        clientsItems,
        clientsItems.id.equalsExp(carsItems.clientId),
      )
    ]);

    return query.map((row) {
      final car = row.readTable(carsItems);
      final client = row.readTable(clientsItems);

      return CarWithOwner(
        car: car,
        ownerName: client.name,
        ownerType: client.type,
      );
    }).get();
  }
}

/// Модель для представления результатов запроса автомобиля с владельцем.
class CarWithOwner {
  final CarsItem car;
  final String ownerName;
  final String ownerType;

  CarWithOwner({
    required this.car,
    required this.ownerName,
    required this.ownerType,
  });
}

```

## lib\core\database\daos\cars_dao.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cars_dao.dart';

// ignore_for_file: type=lint
mixin _$CarsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientsItemsTable get clientsItems => attachedDatabase.clientsItems;
  $CarsItemsTable get carsItems => attachedDatabase.carsItems;
}

```

## lib\core\database\daos\clients_dao.dart
```dart
import 'package:drift/drift.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/items/clients_items.dart';

part 'clients_dao.g.dart';

/// {@template clients_dao}
/// DAO для работы с таблицей клиентов.
/// {@endtemplate}
@DriftAccessor(tables: [ClientsItems])
class ClientsDao extends DatabaseAccessor<AppDatabase> with _$ClientsDaoMixin {
  /// {@macro clients_dao}
  ClientsDao(super.db);

  /// Возвращает поток списка активных клиентов.
  Stream<List<ClientsItem>> watchActiveClients() {
    return (select(clientsItems)..where((c) => c.deletedAt.isNull())).watch();
  }

  /// Возвращает клиента по идентификатору.
  Future<ClientsItem?> getClientById(int id) {
    return (select(clientsItems)
          ..where((c) => c.id.equals(id) & c.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Добавляет нового клиента.
  Future<int> insertClient(ClientsItemsCompanion client) {
    return into(clientsItems).insert(client);
  }

  /// Обновляет данные клиента.
  Future<bool> updateClient(ClientsItemsCompanion client) {
    return update(clientsItems).replace(client);
  }

  /// Выполняет soft-delete клиента.
  Future<int> softDeleteClient(int id) {
    return (update(clientsItems)..where((c) => c.id.equals(id)))
        .write(ClientsItemsCompanion(deletedAt: Value(DateTime.now())));
  }

  /// Возвращает список всех клиентов.
  Future<List<ClientsItem>> getAllClients({bool includeDeleted = false}) {
    final query = select(clientsItems);
    if (!includeDeleted) {
      query.where((c) => c.deletedAt.isNull());
    }
    return query.get();
  }

  /// Фильтрует клиентов по типу.
  Future<List<ClientsItem>> getClientsByType(String type) {
    return (select(clientsItems)
          ..where((c) => c.type.equals(type) & c.deletedAt.isNull()))
        .get();
  }

  /// Восстанавливает удалённого клиента.
  Future<int> restoreClient(int id) {
    return (update(clientsItems)..where((c) => c.id.equals(id)))
        .write(const ClientsItemsCompanion(deletedAt: Value(null)));
  }

  /// Поиск клиентов по имени или контактной информации.
  Future<List<ClientsItem>> searchClients(String query) {
    final lowerQuery = '%${query.toLowerCase()}%';
    return (select(clientsItems)
          ..where((c) =>
              c.name.lower().like(lowerQuery) |
              c.contactInfo.lower().like(lowerQuery) & c.deletedAt.isNull()))
        .get();
  }

  /// Подсчитывает количество клиентов по типу.
  Future<int> countClientsByType(String type) async {
    final query = selectOnly(clientsItems)
      ..addColumns([countAll()])
      ..where(clientsItems.type.equals(type) & clientsItems.deletedAt.isNull());

    final result = await query.getSingle();
    return result.read(countAll()) ?? 0;
  }

  /// Получает поток с количеством клиентов (для обновления бейджей в UI).
  Stream<int> watchClientCount() {
    final query = selectOnly(clientsItems)
      ..addColumns([countAll()])
      ..where(clientsItems.deletedAt.isNull());

    return query.watchSingle().map((row) => row.read(countAll()) ?? 0);
  }
}

```

## lib\core\database\daos\clients_dao.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clients_dao.dart';

// ignore_for_file: type=lint
mixin _$ClientsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClientsItemsTable get clientsItems => attachedDatabase.clientsItems;
}

```

## lib\core\database\database.dart
```dart
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:drift/native.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'dart:io';
import 'package:logger/logger.dart';
import 'schema_synchronizer.dart';

// Новые пути импорта
import 'items/clients_items.dart';
import 'items/cars_items.dart';
import 'items/app_info_items.dart';
import 'daos/clients_dao.dart';
import 'daos/cars_dao.dart';

part 'database.g.dart';

/// {@template app_database}
/// База данных приложения, использующая Drift ORM.
/// {@endtemplate}
@DriftDatabase(
  tables: [ClientsItems, CarsItems, AppInfoItems],
  daos: [ClientsDao, CarsDao],
) // Обновлены имена таблиц
class AppDatabase extends _$AppDatabase {
  /// {@macro app_database}
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// Логгер для отслеживания операций с базой данных.
  final Logger _logger = Logger();

  @override
  int get schemaVersion => 7; // Увеличиваем версию из-за изменения схемы

  /// Получает экземпляр DAO клиентов.
  @override
  ClientsDao get clientsDao => ClientsDao(this);

  /// Получает экземпляр DAO автомобилей.
  @override
  CarsDao get carsDao => CarsDao(this);

  // Определите стратегию миграции
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          // Создаём все таблицы при первом запуске
          await m.createAll();
          await setAppVersion(schemaVersion);
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Создаем таблицу AppInfo, если её ещё нет (нужно в любом случае)
          await m.createTable(appInfoItems);
          // Обновляем версию в таблице AppInfo
          await setAppVersion(to);
        },
        beforeOpen: (details) async {
          if (details.wasCreated) {
            _logger.i('База данных была создана с нуля');
          }

          // Включаем внешние ключи
          await customStatement('PRAGMA foreign_keys = ON');

          if (details.hadUpgrade) {
            _logger.i(
                'База данных была обновлена с версии ${details.versionBefore} до ${details.versionNow}');
          }

          // Проверяем, требуется ли синхронизация схемы
          await _checkAndSynchronizeSchema();
        },
      );

  /// Проверяет необходимость синхронизации схемы и выполняет её при необходимости
  Future<void> _checkAndSynchronizeSchema() async {
    try {
      // Проверяем, существует ли таблица AppInfo
      final tableExists = await customSelect(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='app_info'",
      ).get().then((result) => result.isNotEmpty);

      if (!tableExists) {
        _logger.i('Таблица app_info не найдена, создаем её');
        await customStatement('''
          CREATE TABLE IF NOT EXISTS app_info (
            key TEXT PRIMARY KEY,
            value TEXT NOT NULL
          )
        ''');
        await setAppVersion(schemaVersion);
        await _runSchemaSynchronization();
        return;
      }

      // Получаем сохраненную версию схемы
      final savedVersion = await getAppVersion();
      if (savedVersion == null || savedVersion != schemaVersion) {
        _logger.i('Обнаружено несоответствие версий: '
            'сохраненная=$savedVersion, текущая=$schemaVersion');

        await _runSchemaSynchronization();

        // Обновляем версию после синхронизации
        await setAppVersion(schemaVersion);
      } else {
        _logger.i(
            'Синхронизация схемы не требуется, версии совпадают: $savedVersion');
      }
    } catch (e) {
      _logger.e('Ошибка при проверке/синхронизации схемы: $e');
    }
  }

  /// Запускает синхронизацию схемы БД
  Future<void> _runSchemaSynchronization() async {
    _logger.i('Запуск синхронизации схемы БД...');

    final synchronizer = SchemaSynchronizer(this, _logger);
    await synchronizer.synchronize();

    _logger.i('Синхронизация схемы завершена');
  }

  /// Получает сохраненную версию схемы из таблицы AppInfo
  Future<int?> getAppVersion() async {
    try {
      final result = await (select(appInfoItems)
            ..where((t) => t.key.equals('schema_version')))
          .getSingleOrNull();

      return result != null ? int.tryParse(result.value) : null;
    } catch (e) {
      _logger.e('Ошибка при получении версии схемы: $e');
      return null;
    }
  }

  /// Сохраняет версию схемы в таблицу AppInfo
  Future<void> setAppVersion(int version) async {
    try {
      await into(appInfoItems).insertOnConflictUpdate(
        AppInfoItemsCompanion.insert(
          key: 'schema_version',
          value: version.toString(),
        ),
      );
      _logger.i('Версия схемы $version сохранена в БД');
    } catch (e) {
      _logger.e('Ошибка при сохранении версии схемы: $e');
    }
  }

  /// Удаляет файл базы данных.
  ///
  /// Используется для отладки и сброса базы данных к начальному состоянию.
  Future<void> deleteDatabase() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    if (await file.exists()) {
      await file.delete();
      close();
      _logger.i('База данных была удалена');
    }
  }

  /// Создает резервную копию базы данных.
  ///
  /// Возвращает путь к созданному файлу резервной копии.
  Future<String> backupDatabase() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dbFolder.path, 'db.sqlite'));
    final backupFolder = Directory(p.join(dbFolder.path, 'backups'));

    if (!await backupFolder.exists()) {
      await backupFolder.create(recursive: true);
    }

    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final backupFile =
        File(p.join(backupFolder.path, 'db_backup_$timestamp.sqlite'));

    await dbFile.copy(backupFile.path);
    _logger.i('Создана резервная копия БД: ${backupFile.path}');
    return backupFile.path;
  }

  /// Сбрасывает базу данных (удаляет и создает заново)
  ///
  /// Создает временный файл и переключает приложение на него,
  /// чтобы безопасно удалить оригинальный файл базы данных.
  Future<void> resetDatabase() async {
    try {
      _logger.i('Начинаем процесс сброса базы данных...');

      // Закрываем текущее соединение
      close();

      // Создаем временный файл для хранения новой базы данных
      final dbFolder = await getApplicationDocumentsDirectory();
      final oldDbPath = p.join(dbFolder.path, 'db.sqlite');
      final tempDbPath = p.join(dbFolder.path,
          'db_temp_${DateTime.now().millisecondsSinceEpoch}.sqlite');

      // Создаем пустой временный файл
      final tempFile = File(tempDbPath);
      if (!await tempFile.exists()) {
        await tempFile.create();
        _logger.i('Создан временный файл: $tempDbPath');
      }

      // Удаляем старый файл, если можно
      final oldFile = File(oldDbPath);
      if (await oldFile.exists()) {
        try {
          await oldFile.delete();
          _logger.i('Старый файл базы данных удален');
        } catch (e) {
          _logger.w('Не удалось удалить старый файл базы данных: $e');
          // Если не удалось удалить, попробуем переименовать
          final backupPath = p.join(dbFolder.path,
              'db_old_${DateTime.now().millisecondsSinceEpoch}.sqlite');
          await oldFile.rename(backupPath);
          _logger.i('Старый файл базы данных переименован в: $backupPath');
        }
      }

      // Перемещаем временный файл на место основного
      await tempFile.rename(oldDbPath);
      _logger.i('Временный файл перемещен на место основного');

      _logger.i('База данных успешно сброшена');
    } catch (e) {
      _logger.e('Ошибка при сбросе базы данных: $e');
      rethrow;
    }
  }

  /// Проверяет существование всех таблиц и создает их при необходимости
  Future<void> ensureDatabaseReady() async {
    // Проверяем существование таблицы клиентов
    final clientsTableExists = await customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='clients_items'",
    ).get().then((result) => result.isNotEmpty);

    if (!clientsTableExists) {
      _logger
          .w('Таблица clients_items не найдена, выполняем создание схемы...');

      // Создаем все таблицы принудительно
      final migrator = Migrator(this);
      for (var table in allTables) {
        _logger.i('Создание таблицы: ${table.actualTableName}');
        await migrator.createTable(table);
      }

      // Обновляем версию
      await setAppVersion(schemaVersion);

      _logger.i('Инициализация схемы БД завершена');
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Обходное решение для старых версий Android
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    return NativeDatabase.createInBackground(file);
  });
}

```

## lib\core\database\database.g.dart
```dart
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

```

## lib\core\database\database_logger.dart
```dart
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';

/// {@template database_logger}
/// Декоратор QueryExecutor, который добавляет логирование SQL-запросов.
/// {@endtemplate}
class DatabaseLogger extends QueryExecutorUser {
  /// {@macro database_logger}
  DatabaseLogger(this.executor, this.logger, {required this.version});

  final Logger logger;
  final QueryExecutor executor;
  final int version;

  Future<void> runCustom(String statement, [List<Object?>? args]) async {
    final stopwatch = Stopwatch()..start();
    try {
      await executor.runCustom(statement,
          args ?? []); // Исправлено: добавлен дефолтный пустой список
      logger.d(
          'SQL [${stopwatch.elapsedMilliseconds}ms] $statement ${args ?? ''}');
    } catch (e) {
      logger.e('SQL Error: $e on $statement ${args ?? ''}');
      rethrow;
    }
  }

  Future<List<Map<String, Object?>>> runSelect(String statement,
      [List<Object?>? args]) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result =
          await executor.runSelect(statement, args ?? []); // Исправлено
      logger.d(
          'SQL [${stopwatch.elapsedMilliseconds}ms] $statement ${args ?? ''} -> ${result.length} rows');
      return result;
    } catch (e) {
      logger.e('SQL Error: $e on $statement ${args ?? ''}');
      rethrow;
    }
  }

  @override
  int get schemaVersion => version;

  @override
  Future<void> beforeOpen(QueryExecutor user, OpeningDetails details) async {
    logger.i(
        'Opening database v${details.versionNow} (previous: ${details.versionBefore})');
    // Если executor реализует QueryExecutorUser, можно делегировать вызов:
    if (executor is QueryExecutorUser) {
      await (executor as QueryExecutorUser).beforeOpen(user, details);
    }
  }

  Future<int> runInsert(String statement, [List<Object?>? args]) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result =
          await executor.runInsert(statement, args ?? []); // Исправлено
      logger.d(
          'SQL INSERT [${stopwatch.elapsedMilliseconds}ms] $statement ${args ?? ''} -> ID: $result');
      return result;
    } catch (e) {
      logger.e('SQL Error: $e on $statement ${args ?? ''}');
      rethrow;
    }
  }

  Future<int> runUpdate(String statement, [List<Object?>? args]) async {
    final stopwatch = Stopwatch()..start();
    try {
      final result =
          await executor.runUpdate(statement, args ?? []); // Исправлено
      logger.d(
          'SQL UPDATE [${stopwatch.elapsedMilliseconds}ms] $statement ${args ?? ''} -> $result rows affected');
      return result;
    } catch (e) {
      logger.e('SQL Error: $e on $statement ${args ?? ''}');
      rethrow;
    }
  }
}

```

## lib\core\database\items\app_info_items.dart
```dart
import 'package:drift/drift.dart';

/// {@template app_info_items}
/// Таблица для хранения метаданных приложения.
/// {@endtemplate}
class AppInfoItems extends Table {
  TextColumn get key => text().named('key')();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

```

## lib\core\database\items\cars_items.dart
```dart
import 'package:drift/drift.dart';
import 'clients_items.dart';

/// {@template cars_items}
/// Таблица автомобилей для хранения в базе данных.
/// {@endtemplate}
class CarsItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get clientId => integer().references(ClientsItems, #id)();
  TextColumn get vin => text().nullable()();
  TextColumn get make => text()();
  TextColumn get model => text()();
  IntColumn get year => integer().nullable()();
  TextColumn get licensePlate => text().nullable()();
  TextColumn get additionalInfo => text().nullable()();
  // Дата и время удаления, null если запись активна
  DateTimeColumn get deletedAt => dateTime().nullable()();
  // Метод для фильтрации только активных записей
  Expression<bool> get isActive => deletedAt.isNull();

  // Убираем ограничение из определения таблицы
  // и заменяем его на индекс

  // Определяем индексы для таблицы
  List<Index> get indexes => [
        // Индекс для улучшения производительности поиска по clientId
        Index(
          'cars_client_id_idx',
          'CREATE INDEX "cars_client_id_idx" ON "cars_items"("client_id")',
        ),
        // Уникальный индекс для vin с частичным условием
        Index(
          'cars_vin_unique_idx',
          'CREATE UNIQUE INDEX "cars_vin_unique_idx" ON "cars_items"("vin") WHERE "vin" IS NOT NULL',
        ),
      ];
}

```

## lib\core\database\items\clients_items.dart
```dart
import 'package:drift/drift.dart';

/// {@template clients_items}
/// Таблица клиентов для хранения в базе данных.
/// {@endtemplate}
class ClientsItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get type => text()();
  TextColumn get name => text()();
  TextColumn get contactInfo => text()();
  TextColumn get additionalInfo => text().nullable()();
  DateTimeColumn get deletedAt =>
      dateTime().nullable()(); // Для поддержки мягкого удаления

  // Не нужно явно задавать primaryKey при использовании autoIncrement
}

```

## lib\core\database\schema_synchronizer.dart
```dart
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/core/database/database.dart';

/// {@template schema_synchronizer}
/// Утилита для синхронизации схемы базы данных с моделями ORM.
/// Используется для автоматического обновления таблиц при изменении схемы.
/// {@endtemplate}
class SchemaSynchronizer {
  /// {@macro schema_synchronizer}
  SchemaSynchronizer(this._db, this._logger);

  final AppDatabase _db;
  final Logger _logger;

  /// Выполняет синхронизацию схемы базы данных с моделями ORM.
  Future<void> synchronize() async {
    _logger.i('Начало синхронизации схемы базы данных');

    // Получаем все таблицы из кода ORM
    final ormTables = _db.allTables;

    // Запрашиваем информацию о существующих таблицах из SQLite
    final existingTables = await _getExistingTables();

    // Создаём временный экземпляр Migrator для создания таблиц
    final migrator = Migrator(_db);

    // Сравниваем и обновляем таблицы
    for (final table in ormTables) {
      final tableName = table.actualTableName;

      if (!existingTables.contains(tableName)) {
        // Таблица не существует - создаём её
        _logger.i('Создание отсутствующей таблицы: $tableName');
        await migrator.createTable(table);
      } else {
        // Таблица существует - проверяем структуру и обновляем при необходимости
        await _syncTableColumns(table);
      }
    }

    _logger.i('Синхронизация схемы базы данных завершена');
  }

  /// Получает список имен существующих таблиц в базе данных.
  Future<List<String>> _getExistingTables() async {
    final result = await _db
        .customSelect(
          'SELECT name FROM sqlite_master WHERE type="table" AND name NOT LIKE "sqlite_%"',
        )
        .get();

    return result.map((row) => row.read<String>('name')).toList();
  }

  /// Синхронизирует структуру колонок таблицы.
  Future<void> _syncTableColumns(TableInfo table) async {
    final tableName = table.actualTableName;

    // Получаем информацию о колонках из базы данных
    final existingColumns = await _getExistingColumns(tableName);

    // Получаем информацию о колонках из модели
    final modelColumns = table.columnsByName.keys.toSet();

    // Проверяем на недостающие колонки
    final missingColumns = modelColumns.difference(existingColumns);

    if (missingColumns.isNotEmpty) {
      _logger.i(
          'Найдены отсутствующие колонки в таблице $tableName: $missingColumns');

      // Добавляем недостающие колонки
      for (final columnName in missingColumns) {
        final column = table.columnsByName[columnName]!;
        await _addColumn(tableName, column);
      }
    }
  }

  /// Получает список имен колонок в таблице.
  Future<Set<String>> _getExistingColumns(String tableName) async {
    final result = await _db
        .customSelect(
          'PRAGMA table_info($tableName)',
        )
        .get();

    return Set.from(result.map((row) => row.read<String>('name')));
  }

  /// Добавляет колонку в существующую таблицу.
  Future<void> _addColumn(String tableName, GeneratedColumn column) async {
    final columnType = _getSqlType(column);
    // В более старых версиях Drift свойство nullable находится непосредственно на колонке
    final nullableText = column.$nullable ? '' : ' NOT NULL';
    final defaultValue = _getDefaultValue(column);

    _logger.i('Добавление колонки ${column.name} в таблицу $tableName');

    await _db.customStatement(
      'ALTER TABLE $tableName ADD COLUMN ${column.name} $columnType$nullableText$defaultValue',
    );
  }

  /// Определяет SQL-тип для колонки.
  String _getSqlType(GeneratedColumn column) {
    // Для более старых версий Drift, которые используют другое API
    if (column is IntColumn) {
      return 'INTEGER';
    } else if (column is TextColumn) {
      return 'TEXT';
    } else if (column is BoolColumn) {
      return 'INTEGER';
    } else if (column is DateTimeColumn) {
      return 'INTEGER';
    } else if (column is BlobColumn) {
      return 'BLOB';
    } else if (column is RealColumn) {
      return 'REAL';
    } else {
      return 'TEXT'; // По умолчанию для неизвестных типов
    }
  }

  /// Получает выражение для значения по умолчанию.
  String _getDefaultValue(GeneratedColumn column) {
    // SQLite требует DEFAULT для NOT NULL колонок при изменении таблицы
    if (!column.$nullable) {
      if (column is IntColumn) {
        return ' DEFAULT 0';
      } else if (column is TextColumn) {
        return ' DEFAULT ""';
      } else if (column is BoolColumn) {
        return ' DEFAULT 0';
      } else if (column is RealColumn) {
        return ' DEFAULT 0.0';
      }
    }
    return '';
  }
}

```

## lib\core\schemas\app_schema.json
```json
{
    "definitions": {
        "Client": {
            "type": "object",
            "properties": {
                "id": {
                    "type": "string",
                    "description": "Уникальный идентификатор клиента"
                },
                "type": {
                    "type": "string",
                    "description": "Тип клиента (физическое или юридическое лицо)",
                    "enum": [
                        "physical",
                        "legal"
                    ]
                },
                "name": {
                    "type": "string",
                    "description": "ФИО для физического лица или название организации для юридического лица"
                },
                "contactInfo": {
                    "type": "string",
                    "description": "Контактная информация (телефон, email, адрес)"
                },
                "additionalInfo": {
                    "type": "string",
                    "description": "Дополнительная информация"
                }
            },
            "required": [
                "id",
                "type",
                "name",
                "contactInfo"
            ]
        },
        "Car": {
            "type": "object",
            "properties": {
                "id": {
                    "type": "string",
                    "description": "Уникальный идентификатор автомобиля"
                },
                "clientId": {
                    "type": "string",
                    "description": "Идентификатор клиента-владельца"
                },
                "vin": {
                    "type": "string",
                    "description": "VIN-код"
                },
                "make": {
                    "type": "string",
                    "description": "Марка автомобиля"
                },
                "model": {
                    "type": "string",
                    "description": "Модель автомобиля"
                },
                "year": {
                    "type": "integer",
                    "description": "Год выпуска"
                },
                "licensePlate": {
                    "type": "string",
                    "description": "Номерной знак"
                },
                "additionalInfo": {
                    "type": "string",
                    "description": "Дополнительная информация"
                }
            },
            "required": [
                "id",
                "clientId",
                "vin",
                "make",
                "model",
                "year"
            ]
        },
        "Order": {
            "type": "object",
            "properties": {
                "id": {
                    "type": "string",
                    "description": "Уникальный идентификатор заказ-наряда"
                },
                "clientId": {
                    "type": "string",
                    "description": "Идентификатор клиента"
                },
                "carId": {
                    "type": "string",
                    "description": "Идентификатор автомобиля"
                },
                "date": {
                    "type": "string",
                    "format": "date",
                    "description": "Дата создания заказ-наряда"
                },
                "description": {
                    "type": "string",
                    "description": "Описание проблемы"
                },
                "workItems": {
                    "type": "array",
                    "items": {
                        "type": "object",
                        "properties": {
                            "description": {
                                "type": "string",
                                "description": "Описание работы"
                            },
                            "cost": {
                                "type": "number",
                                "format": "float",
                                "description": "Стоимость работы"
                            }
                        },
                        "required": [
                            "description",
                            "cost"
                        ]
                    },
                    "description": "Список работ (описание и стоимость)"
                },
                "orderItems": {
                    "type": "array",
                    "items": {
                        "$ref": "#/definitions/OrderItem"
                    },
                    "description": "Список запчастей (с ценами и сроками поставки)"
                },
                "totalCost": {
                    "type": "number",
                    "format": "float",
                    "description": "Общая стоимость"
                },
                "status": {
                    "type": "string",
                    "description": "Статус заказ-наряда",
                    "enum": [
                        "created",
                        "inProgress",
                        "completed"
                    ]
                }
            },
            "required": [
                "id",
                "clientId",
                "carId",
                "date",
                "description",
                "workItems",
                "orderItems",
                "totalCost",
                "status"
            ]
        },
        "OrderItem": {
            "type": "object",
            "properties": {
                "id": {
                    "type": "string",
                    "description": "Уникальный идентификатор позиции"
                },
                "orderId": {
                    "type": "string",
                    "description": "Идентификатор заказ-наряда"
                },
                "partNumber": {
                    "type": "string",
                    "description": "Артикул запчасти"
                },
                "partName": {
                    "type": "string",
                    "description": "Название запчасти"
                },
                "quantity": {
                    "type": "integer",
                    "description": "Количество"
                },
                "price": {
                    "type": "number",
                    "format": "float",
                    "description": "Цена за единицу"
                },
                "supplier": {
                    "type": "string",
                    "description": "Поставщик"
                },
                "deliveryTime": {
                    "type": "string",
                    "description": "Срок поставки"
                }
            },
            "required": [
                "id",
                "orderId",
                "partNumber",
                "partName",
                "quantity",
                "price",
                "supplier",
                "deliveryTime"
            ]
        },
        "Supplier": {
            "type": "object",
            "properties": {
                "id": {
                    "type": "string",
                    "description": "Уникальный идентификатор поставщика"
                },
                "name": {
                    "type": "string",
                    "description": "Название поставщика"
                },
                "contactInfo": {
                    "type": "string",
                    "description": "Контактная информация"
                }
            },
            "required": [
                "id",
                "name",
                "contactInfo"
            ]
        },
        "PriceOffer": {
            "type": "object",
            "properties": {
                "partNumber": {
                    "type": "string",
                    "description": "Артикул запчасти"
                },
                "price": {
                    "type": "number",
                    "format": "float",
                    "description": "Цена"
                },
                "deliveryTime": {
                    "type": "string",
                    "description": "Срок поставки"
                },
                "supplierId": {
                    "type": "string",
                    "description": "Идентификатор поставщика"
                }
            },
            "required": [
                "partNumber",
                "price",
                "deliveryTime",
                "supplierId"
            ]
        }
    }
}
```

## lib\core\service_locator.dart
```dart
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:part_catalog/features/parts_catalog/api/api_client_parts_catalogs.dart';
import 'package:part_catalog/features/clients/services/client_service.dart'; // Import ClientService
import 'package:part_catalog/core/database/database.dart'; // Import AppDatabase
import 'package:part_catalog/features/vehicles/services/car_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Регистрируем Dio
  locator.registerLazySingleton(() => Dio());

  // Регистрируем ApiClientPartsCatalogs
  locator.registerLazySingleton(() => ApiClientPartsCatalogs(locator<Dio>()));

  // Регистрация базы данных как синглтона
  locator.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Регистрация сервисов
  locator.registerLazySingleton<ClientService>(
      () => ClientService(locator<AppDatabase>()));
  locator.registerLazySingleton<CarService>(
      () => CarService(locator<AppDatabase>()));
}

```

## lib\core\utils\json_converter.dart
```dart
import 'dart:convert';
import 'package:drift/drift.dart';

/// {@template json_converter}
/// Конвертер для преобразования объектов в JSON и обратно для хранения в базе данных.
/// {@endtemplate}
class JsonConverter<T> extends TypeConverter<T, String> {
  /// {@macro json_converter}
  /// [fromJson] - функция, преобразующая JSON-объект в объект типа T
  const JsonConverter(this.fromJson);

  /// Функция для преобразования JSON-объекта в объект типа T
  final T Function(Map<String, dynamic>) fromJson;

  @override
  T fromSql(String fromDb) {
    return fromJson(json.decode(fromDb) as Map<String, dynamic>);
  }

  @override
  String toSql(T value) {
    return json.encode(value);
  }
}

// Примечание: OrderItems должен быть определен в отдельном файле
// например в lib/features/orders/models/order_entity.dart

// Пример использования в таблице:
/*
class OrderItems extends Table {
  // ...другие колонки...

  // Хранение дополнительных опций как JSON
  TextColumn get options => text().map(JsonConverter<Map<String, dynamic>>(
        (json) => json,
      ))();
}
*/

```

## lib\core\utils\logger_config.dart
```dart
import 'package:logger/logger.dart';

class AppLoggers {
  static final Logger coreLogger =
      Logger(printer: PrettyPrinter(methodCount: 2), level: Level.trace);
  static final Logger networkLogger =
      Logger(printer: PrettyPrinter(methodCount: 1), level: Level.info);
  static final Logger databaseLogger =
      Logger(printer: PrettyPrinter(methodCount: 1), level: Level.debug);
  static final Logger uiLogger =
      Logger(printer: PrettyPrinter(methodCount: 0), level: Level.warning);

  // Логгеры для конкретных компонентов
  static Logger clientsLogger = Logger(
      printer: PrettyPrinter(
          methodCount: 1,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart));
  static Logger vehiclesLogger = Logger(
      printer: PrettyPrinter(
          methodCount: 1,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart));
  static Logger suppliersLogger = Logger(
      printer: PrettyPrinter(
          methodCount: 1,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart));
}

```

## lib\features\clients\models\client.dart
```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:part_catalog/features/clients/models/client_type.dart';

part 'client.g.dart';

/// {@template client}
/// Модель данных для представления клиента.
/// {@endtemplate}
@JsonSerializable(converters: [ClientTypeConverter()]) // Add converter
class Client {
  /// {@macro client}
  Client({
    required this.id,
    required this.type,
    required this.name,
    required this.contactInfo,
    this.additionalInfo,
  });

  /// Уникальный идентификатор клиента.
  @JsonKey(name: 'id')
  final int id; // Изменено с String на int

  /// Тип клиента (physical, legal, individualEntrepreneur, other).
  @JsonKey(name: 'type')
  final ClientType type;

  /// ФИО для физического лица или название организации для юридического лица.
  @JsonKey(name: 'name')
  final String name;

  /// Контактная информация (телефон, email, адрес).
  @JsonKey(name: 'contactInfo')
  final String contactInfo;

  /// Дополнительная информация.
  @JsonKey(name: 'additionalInfo')
  final String? additionalInfo;

  /// Преобразование JSON в объект `Client`.
  factory Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

  /// Преобразование объекта `Client` в JSON.
  Map<String, dynamic> toJson() => _$ClientToJson(this);
}

/// {@template client_type_converter}
/// Конвертер для преобразования ClientType из/в JSON.
/// {@endtemplate}
class ClientTypeConverter implements JsonConverter<ClientType, String> {
  /// {@macro client_type_converter}
  const ClientTypeConverter();

  @override
  ClientType fromJson(String json) {
    switch (json) {
      case 'Физическое лицо':
        return ClientType.physical;
      case 'Юридическое лицо':
        return ClientType.legal;
      case 'Индивидуальный предприниматель':
        return ClientType.individualEntrepreneur;
      case 'Другое':
        return ClientType.other;
      default:
        throw ArgumentError('Unknown ClientType: $json');
    }
  }

  @override
  String toJson(ClientType object) {
    return object.displayName;
  }
}

```

## lib\features\clients\models\client.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Client _$ClientFromJson(Map<String, dynamic> json) => Client(
      id: (json['id'] as num).toInt(),
      type: const ClientTypeConverter().fromJson(json['type'] as String),
      name: json['name'] as String,
      contactInfo: json['contactInfo'] as String,
      additionalInfo: json['additionalInfo'] as String?,
    );

Map<String, dynamic> _$ClientToJson(Client instance) => <String, dynamic>{
      'id': instance.id,
      'type': const ClientTypeConverter().toJson(instance.type),
      'name': instance.name,
      'contactInfo': instance.contactInfo,
      'additionalInfo': instance.additionalInfo,
    };

```

## lib\features\clients\models\client_type.dart
```dart
/// {@template client_type}
/// Тип клиента.
/// {@endtemplate}
enum ClientType {
  /// {@macro client_type}
  physical,

  /// {@macro client_type}
  legal,

  /// {@macro client_type}
  individualEntrepreneur,

  /// {@macro client_type}
  other,
}

/// {@template client_type_extension}
/// Расширение для перечисления ClientType.
/// {@endtemplate}
extension ClientTypeExtension on ClientType {
  /// {@macro client_type_extension}
  String get displayName {
    switch (this) {
      case ClientType.physical:
        return 'Физическое лицо';
      case ClientType.legal:
        return 'Юридическое лицо';
      case ClientType.individualEntrepreneur:
        return 'Индивидуальный предприниматель';
      case ClientType.other:
        return 'Другое';
    }
  }

  static ClientType fromString(String value) {
    switch (value) {
      case 'physical':
        return ClientType.physical;
      case 'legal':
        return ClientType.legal;
      case 'individualEntrepreneur':
        return ClientType.individualEntrepreneur;
      case 'other':
        return ClientType.other;
      default:
        return ClientType.physical;
    }
  }
}

extension ParseToString on ClientType {
  String toShortString() {
    return toString().split('.').last;
  }
}

```

## lib\features\clients\screens\clients_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/clients/models/client.dart';
import 'package:part_catalog/features/clients/models/client_type.dart';
import 'package:part_catalog/features/clients/services/client_service.dart';
import 'package:part_catalog/features/vehicles/services/car_service.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  final ClientService _clientService = locator<ClientService>();
  bool _isDbError = false;

  @override
  Widget build(BuildContext context) {
    if (_isDbError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ошибка базы данных')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Ошибка доступа к базе данных'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Получаем ScaffoldMessengerState до асинхронной операции
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  try {
                    // Сбрасываем базу данных
                    final db = locator<AppDatabase>();
                    await db.resetDatabase();

                    // Обновляем экземпляры в сервис-локаторе
                    locator.unregister<AppDatabase>();
                    locator.registerSingleton<AppDatabase>(AppDatabase());

                    // Обновляем все сервисы, зависящие от БД
                    locator.unregister<ClientService>();
                    locator.unregister<CarService>();
                    locator.registerLazySingleton<ClientService>(
                        () => ClientService(locator<AppDatabase>()));
                    locator.registerLazySingleton<CarService>(
                        () => CarService(locator<AppDatabase>()));

                    setState(() {
                      _isDbError = false;
                    });

                    // Используем сохраненный scaffoldMessenger
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                          content: Text('База данных успешно сброшена')),
                    );
                  } catch (e) {
                    // Показываем сообщение об ошибке
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                          content: Text('Ошибка при сбросе базы данных: $e')),
                    );
                  }
                },
                child: const Text('Сбросить базу данных'),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Клиенты'),
      ),
      // Используем StreamBuilder для реактивного обновления списка клиентов
      body: StreamBuilder<List<Client>>(
        // Подписываемся на поток данных из сервиса
        stream: _clientService.watchClients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Проверяем, связана ли ошибка с отсутствием таблицы
            if (snapshot.error.toString().contains('no such table')) {
              // Устанавливаем флаг ошибки БД, который перерисует виджет
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isDbError = true;
                });
              });
            }
            return Center(
              child: Text(
                'Ошибка загрузки данных: ${snapshot.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          final clients = snapshot.data ?? [];

          if (clients.isEmpty) {
            return const Center(
              child: Text(
                  'Список клиентов пуст. Добавьте клиента, нажав на кнопку "+"'),
            );
          }

          return ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index];
              return Dismissible(
                key: Key(client.id.toString()),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Удалить клиента?'),
                            content: Text(
                                'Вы действительно хотите удалить клиента ${client.name}?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Отмена'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Удалить'),
                              ),
                            ],
                          );
                        },
                      ) ??
                      false;
                },
                onDismissed: (direction) async {
                  // Получаем ScaffoldMessengerState до асинхронной операции
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  await _clientService.deleteClient(client.id);
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text('Клиент ${client.name} удален')),
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: client.type == ClientType.physical
                        ? Colors.blue
                        : Colors.orange,
                    child: Icon(
                      client.type == ClientType.physical
                          ? Icons.person
                          : Icons.business,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(client.name),
                  subtitle: Text(client.contactInfo),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _editClient(client),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addClient,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addClient() async {
    final client = await _showClientDialog(context);
    if (client != null) {
      await _clientService.addClient(client);
    }
  }

  Future<void> _editClient(Client client) async {
    final updatedClient = await _showClientDialog(context, client: client);
    if (updatedClient != null) {
      await _clientService.updateClient(updatedClient);
    }
  }

  /// Показывает диалог для добавления/редактирования клиента.
  ///
  /// [client] - существующий клиент для редактирования, null для нового клиента.
  ///
  /// Возвращает новый или обновленный объект [Client] или null, если отменено.
  Future<Client?> _showClientDialog(BuildContext context,
      {Client? client}) async {
    // Создаём контроллеры для полей ввода с начальными значениями из клиента (если есть)
    final nameController = TextEditingController(text: client?.name);
    final contactInfoController =
        TextEditingController(text: client?.contactInfo);
    final additionalInfoController =
        TextEditingController(text: client?.additionalInfo);

    // Начальное значение типа клиента
    ClientType selectedType = client?.type ?? ClientType.physical;

    // Состояние валидации формы
    bool isValid =
        client != null; // для новых клиентов изначально невалидная форма

    // Создаём ключ для формы (для валидации)
    final formKey = GlobalKey<FormState>();

    return showDialog<Client>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          // Функция валидации формы
          void validateForm() {
            setState(() {
              isValid = formKey.currentState?.validate() ?? false;
            });
          }

          return AlertDialog(
            title: Text(
                client == null ? 'Добавить клиента' : 'Редактировать клиента'),
            content: Form(
              key: formKey,
              onChanged: validateForm,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Выпадающий список для типа клиента
                    DropdownButtonFormField<ClientType>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Тип клиента',
                        prefixIcon: Icon(Icons.category),
                        border: OutlineInputBorder(),
                      ),
                      items: ClientType.values.map((type) {
                        IconData iconData;
                        Color iconColor;

                        switch (type) {
                          case ClientType.physical:
                            iconData = Icons.person;
                            iconColor = Colors.blue;
                            break;
                          case ClientType.legal:
                            iconData = Icons.business;
                            iconColor = Colors.orange;
                            break;
                          case ClientType.individualEntrepreneur:
                            iconData = Icons.business_center;
                            iconColor = Colors.green;
                            break;
                          case ClientType.other:
                            iconData = Icons.help_outline;
                            iconColor = Colors.grey;
                            break;
                        }

                        return DropdownMenuItem<ClientType>(
                          value: type,
                          child: Row(
                            children: [
                              Icon(iconData, color: iconColor, size: 18),
                              const SizedBox(width: 8),
                              Text(type.displayName),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (ClientType? value) {
                        if (value != null) {
                          setState(() {
                            selectedType = value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // Поле ввода имени/наименования клиента
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: selectedType == ClientType.physical
                            ? 'ФИО клиента'
                            : 'Наименование организации',
                        prefixIcon: Icon(
                          selectedType == ClientType.physical
                              ? Icons.person
                              : Icons.business,
                        ),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Поле обязательно для заполнения';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 16),

                    // Поле ввода контактной информации
                    TextFormField(
                      controller: contactInfoController,
                      decoration: const InputDecoration(
                        labelText: 'Контактная информация',
                        prefixIcon: Icon(Icons.contact_phone),
                        hintText: 'Телефон, email, адрес',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Поле обязательно для заполнения';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 16),

                    // Поле ввода дополнительной информации (опционально)
                    TextFormField(
                      controller: additionalInfoController,
                      decoration: const InputDecoration(
                        labelText: 'Дополнительная информация',
                        prefixIcon: Icon(Icons.info_outline),
                        hintText: 'Примечания, особые условия и т.д.',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Отмена'),
              ),
              TextButton(
                onPressed: isValid
                    ? () {
                        // Создаем объект клиента из введенных данных
                        final result = Client(
                          id: client?.id ??
                              0, // 0 для новых клиентов (ID присвоит БД)
                          type: selectedType,
                          name: nameController.text.trim(),
                          contactInfo: contactInfoController.text.trim(),
                          additionalInfo:
                              additionalInfoController.text.trim().isNotEmpty
                                  ? additionalInfoController.text.trim()
                                  : null,
                        );
                        Navigator.of(context).pop(result);
                      }
                    : null, // Если форма невалидна, кнопка будет неактивна
                child: Text(client == null ? 'Добавить' : 'Сохранить'),
              ),
            ],
          );
        });
      },
    );
  }
}

```

## lib\features\clients\services\client_service.dart
```dart
import 'package:drift/drift.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/features/clients/models/client.dart';
import 'package:part_catalog/features/clients/models/client_type.dart';
import 'package:logger/logger.dart';

/// {@template client_service}
/// Сервис для управления клиентами в базе данных.
/// {@endtemplate}
class ClientService {
  /// {@macro client_service}
  ClientService(this._db) : _logger = Logger();

  final AppDatabase _db;
  final Logger _logger;

  /// Возвращает поток списка клиентов, обновляемый при изменениях в БД.
  Stream<List<Client>> watchClients() {
    _logger.i('Запрос потока списка активных клиентов');
    return _db.clientsDao.watchActiveClients().map(
          (clients) => clients.map(_mapToModel).toList(),
        );
  }

  /// Получает клиента по идентификатору.
  Future<Client?> getClientById(int id) async {
    _logger.i('Запрос клиента с ID: $id');
    final clientItem = await _db.clientsDao.getClientById(id);
    if (clientItem == null) return null;
    return _mapToModel(clientItem);
  }

  /// Добавляет нового клиента.
  Future<int> addClient(Client client) {
    _logger.i('Добавление нового клиента: ${client.name}');
    final companion = _mapToCompanion(client);
    return _db.clientsDao.insertClient(companion);
  }

  /// Обновляет существующего клиента.
  Future<bool> updateClient(Client client) {
    _logger.i('Обновление клиента с ID: ${client.id}');
    final companion = _mapToCompanion(client, withId: true);
    return _db.clientsDao.updateClient(companion);
  }

  /// Удаляет клиента (мягкое удаление).
  Future<int> deleteClient(int id) {
    _logger.i('Мягкое удаление клиента с ID: $id');
    return _db.clientsDao.softDeleteClient(id);
  }

  /// Возвращает список всех клиентов, включая удалённых.
  Future<List<Client>> getAllClients({bool includeDeleted = false}) async {
    _logger
        .i('Запрос списка всех клиентов (включая удалённых: $includeDeleted)');
    final clientItems =
        await _db.clientsDao.getAllClients(includeDeleted: includeDeleted);
    return clientItems.map(_mapToModel).toList();
  }

  /// Фильтрует клиентов по типу.
  Future<List<Client>> getClientsByType(ClientType type) async {
    _logger.i('Фильтрация клиентов по типу: ${type.toString()}');
    final clientItems =
        await _db.clientsDao.getClientsByType(type.toShortString());
    return clientItems.map(_mapToModel).toList();
  }

  /// Восстанавливает удалённого клиента.
  Future<int> restoreClient(int id) {
    _logger.i('Восстановление удалённого клиента с ID: $id');
    return _db.clientsDao.restoreClient(id);
  }

  /// Создаёт нового клиента вместе с его автомобилями в одной транзакции.
  Future<int> createClientWithCars(
      Client client, List<CarsItemsCompanion> cars) {
    _logger.i(
        'Создание клиента с автомобилями: ${client.name}, количество автомобилей: ${cars.length}');
    final clientCompanion = _mapToCompanion(client);
    return _db.transaction(() async {
      // Создаём клиента и получаем его ID
      final clientId = await _db.clientsDao.insertClient(clientCompanion);

      // Добавляем все автомобили этому клиенту
      for (var car in cars) {
        final carWithClientId = car.copyWith(clientId: Value(clientId));
        await _db.carsDao.insertCar(carWithClientId);
      }

      return clientId;
    });
  }

  /// Поиск клиентов по имени или контактной информации.
  Future<List<Client>> searchClients(String query) async {
    _logger.i('Поиск клиентов по запросу: $query');
    final clientItems = await _db.clientsDao.searchClients(query);
    return clientItems.map(_mapToModel).toList();
  }

  /// Преобразует запись из базы данных в бизнес-модель клиента.
  Client _mapToModel(ClientsItem item) {
    return Client(
      id: item.id,
      type: ClientTypeExtension.fromString(item.type),
      name: item.name,
      contactInfo: item.contactInfo,
      additionalInfo: item.additionalInfo,
    );
  }

  /// Преобразует бизнес-модель в модель базы данных.
  ClientsItemsCompanion _mapToCompanion(Client client, {bool withId = false}) {
    var companion = ClientsItemsCompanion(
      type: Value(client.type.toShortString()),
      name: Value(client.name),
      contactInfo: Value(client.contactInfo),
      additionalInfo: Value(client.additionalInfo),
    );

    if (withId) {
      companion = companion.copyWith(id: Value(client.id));
    }

    return companion;
  }
}

```

## lib\features\orders\models\order.dart
```dart
import 'package:json_annotation/json_annotation.dart';
import 'package:part_catalog/features/orders/models/order_item.dart';

part 'order.g.dart';

/// {@template order}
/// Модель данных для представления заказ-наряда.
/// {@endtemplate}
@JsonSerializable()
class Order {
  /// {@macro order}
  Order({
    required this.id,
    required this.clientId,
    required this.carId,
    required this.date,
    required this.description,
    required this.workItems,
    required this.orderItems,
    required this.totalCost,
    required this.status,
  });

  /// Уникальный идентификатор заказ-наряда.
  @JsonKey(name: 'id')
  final String id;

  /// Идентификатор клиента.
  @JsonKey(name: 'clientId')
  final String clientId;

  /// Идентификатор автомобиля.
  @JsonKey(name: 'carId')
  final String carId;

  /// Дата создания заказ-наряда.
  @JsonKey(name: 'date')
  final String date;

  /// Описание проблемы.
  @JsonKey(name: 'description')
  final String description;

  /// Список работ (описание и стоимость).
  @JsonKey(name: 'workItems')
  final List<WorkItem> workItems;

  /// Список запчастей (с ценами и сроками поставки).
  @JsonKey(name: 'orderItems')
  final List<OrderItem> orderItems;

  /// Общая стоимость.
  @JsonKey(name: 'totalCost')
  final double totalCost;

  /// Статус заказ-наряда (created, inProgress, completed).
  @JsonKey(name: 'status')
  final String status;

  /// Преобразование JSON в объект `Order`.
  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);

  /// Преобразование объекта `Order` в JSON.
  Map<String, dynamic> toJson() => _$OrderToJson(this);
}

/// {@template work_item}
/// Модель данных для представления работы в заказ-наряде.
/// {@endtemplate}
@JsonSerializable()
class WorkItem {
  /// {@macro work_item}
  WorkItem({
    required this.description,
    required this.cost,
  });

  /// Описание работы.
  @JsonKey(name: 'description')
  final String description;

  /// Стоимость работы.
  @JsonKey(name: 'cost')
  final double cost;

  /// Преобразование JSON в объект `WorkItem`.
  factory WorkItem.fromJson(Map<String, dynamic> json) =>
      _$WorkItemFromJson(json);

  /// Преобразование объекта `WorkItem` в JSON.
  Map<String, dynamic> toJson() => _$WorkItemToJson(this);
}

```

## lib\features\orders\models\order.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Order _$OrderFromJson(Map<String, dynamic> json) => Order(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      carId: json['carId'] as String,
      date: json['date'] as String,
      description: json['description'] as String,
      workItems: (json['workItems'] as List<dynamic>)
          .map((e) => WorkItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      orderItems: (json['orderItems'] as List<dynamic>)
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCost: (json['totalCost'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$OrderToJson(Order instance) => <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'carId': instance.carId,
      'date': instance.date,
      'description': instance.description,
      'workItems': instance.workItems,
      'orderItems': instance.orderItems,
      'totalCost': instance.totalCost,
      'status': instance.status,
    };

WorkItem _$WorkItemFromJson(Map<String, dynamic> json) => WorkItem(
      description: json['description'] as String,
      cost: (json['cost'] as num).toDouble(),
    );

Map<String, dynamic> _$WorkItemToJson(WorkItem instance) => <String, dynamic>{
      'description': instance.description,
      'cost': instance.cost,
    };

```

## lib\features\orders\models\order_item.dart
```dart
import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

/// {@template order_item}
/// Модель данных для представления позиции в заказ-наряде.
/// {@endtemplate}
@JsonSerializable()
class OrderItem {
  /// {@macro order_item}
  OrderItem({
    required this.id,
    required this.orderId,
    required this.partNumber,
    required this.partName,
    required this.quantity,
    required this.price,
    required this.supplier,
    required this.deliveryTime,
  });

  /// Уникальный идентификатор позиции.
  @JsonKey(name: 'id')
  final String id;

  /// Идентификатор заказ-наряда.
  @JsonKey(name: 'orderId')
  final String orderId;

  /// Артикул запчасти.
  @JsonKey(name: 'partNumber')
  final String partNumber;

  /// Название запчасти.
  @JsonKey(name: 'partName')
  final String partName;

  /// Количество.
  @JsonKey(name: 'quantity')
  final int quantity;

  /// Цена за единицу.
  @JsonKey(name: 'price')
  final double price;

  /// Поставщик.
  @JsonKey(name: 'supplier')
  final String supplier;

  /// Срок поставки.
  @JsonKey(name: 'deliveryTime')
  final String deliveryTime;

  /// Преобразование JSON в объект `OrderItem`.
  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);

  /// Преобразование объекта `OrderItem` в JSON.
  Map<String, dynamic> toJson() => _$OrderItemToJson(this);
}

```

## lib\features\orders\models\order_item.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => OrderItem(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      partNumber: json['partNumber'] as String,
      partName: json['partName'] as String,
      quantity: (json['quantity'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      supplier: json['supplier'] as String,
      deliveryTime: json['deliveryTime'] as String,
    );

Map<String, dynamic> _$OrderItemToJson(OrderItem instance) => <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'partNumber': instance.partNumber,
      'partName': instance.partName,
      'quantity': instance.quantity,
      'price': instance.price,
      'supplier': instance.supplier,
      'deliveryTime': instance.deliveryTime,
    };

```

## lib\features\parts_catalog\api\PartsCatalogsRestAPI.md
```md
openapi: 3.0.0
info:
  title: Catalogs API
  version: 1.15.0
  description: |
    Open source clients:
    - [pc-client-slim](https://github.com/alex-ello/pc-client-slim) PHP based opensource client
security:
  - ApiKey: []
tags:
  - name: Ip
  - name: Catalogs
  - name: Cars
  - name: Groups
  - name: Parts
  - name: Groups tree
paths:
  /ip/:
    get:
      operationId: getIp
      tags:
        - Ip
      summary: Get user ip
      responses:
        '200':
          description: Id
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Ip'
  /catalogs/:
    get:
      operationId: getCatalogs
      tags:
        - Catalogs
      summary: Get available catalogs
      security:
        - ApiKey: []
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                title: array
                description: Catalog list
                type: array
                items:
                  $ref: '#/components/schemas/Catalog'
  '/catalogs/{catalogId}/models/':
    get:
      operationId: getModels
      tags:
        - Cars
      summary: Get catalog car models
      security:
        - ApiKey: []
      parameters:
        - name: catalogId
          in: path
          description: Catalog id
          required: true
          schema:
            type: string
            default: bmw
      responses:
        '200':
          description: Model list
          content:
            application/json:
              schema:
                title: Array
                type: array
                items:
                  $ref: '#/components/schemas/Model'
        '400':
          $ref: '#/components/responses/badRequest'
        '403':
          $ref: '#/components/responses/accessDeny'
        '404':
          $ref: '#/components/responses/notFound'
  '/catalogs/{catalogId}/cars2/':
    get:
      operationId: getCars2
      tags:
        - Cars
      summary: Get car list of catalog
      description: Attention! Vehicle identifier may change over time.
      security:
        - ApiKey: []
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
        - name: catalogId
          in: path
          description: Catalog id
          required: true
          schema:
            type: string
            default: bmw
        - name: modelId
          in: query
          description: Model id
          required: true
          schema:
            type: string
        - name: parameter
          in: query
          description: Filter cars by car parameter indexes (idx)
          required: false
          style: form
          explode: false
          schema:
            type: array
            items:
              type: array
              items:
                $ref: '#/components/schemas/CarParameterIdx'
        - name: page
          in: query
          required: false
          description: |-
            Page number (pagination). 
            Page number value must be greater than 0. Can output 25 cars on page
          schema:
            type: integer
            minimum: 0
      responses:
        '200':
          description: OK
          headers:
            X-Total-Count:
              schema:
                type: integer
          content:
            application/json:
              schema:
                title: array
                description: Car list
                type: array
                items:
                  $ref: '#/components/schemas/Car2'
        '400':
          $ref: '#/components/responses/badRequest'
        '403':
          $ref: '#/components/responses/accessDeny'
  '/catalogs/{catalogId}/cars2/{carId}':
    get:
      operationId: getCarsById2
      tags:
        - Cars
      summary: GET catalog car by id
      description: Attention! Vehicle identifier may change over time.
      security:
        - ApiKey: []
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
        - name: catalogId
          in: path
          description: Catalog id
          required: true
          schema:
            type: string
            default: bmw
        - name: carId
          in: path
          description: Car id
          required: true
          schema:
            type: string
        - name: criteria
          in: query
          description: criteria
          required: false
          schema:
            type: string
      responses:
        '200':
          description: OK
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Car2'
        '400':
          $ref: '#/components/responses/badRequest'
        '403':
          $ref: '#/components/responses/accessDeny'
  '/catalogs/{catalogId}/cars-parameters/':
    get:
      operationId: getCarsParameters
      tags:
        - Cars
      summary: Get cars filters of selected catalog
      security:
        - ApiKey: []
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
        - name: catalogId
          in: path
          description: Catalog id
          required: true
          schema:
            type: string
            default: bmw
        - name: modelId
          in: query
          description: Model id
          required: true
          schema:
            type: string
        - name: parameter
          in: query
          description: Filter parameters by idx
          required: false
          style: form
          explode: false
          example: 5651b9c4e2f55b54efe465354b3491e7,59e742688f05ca5ecc71a35cc2ff31c5
          schema:
            type: array
            items:
              type: array
              items:
                $ref: '#/components/schemas/CarParameterIdx'
      responses:
        '200':
          description: Filter
          headers:
            X-Cars-Count:
              description: Cars count filtered by parameters
              schema:
                type: integer
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/CarParameterInfo'
        '400':
          $ref: '#/components/responses/badRequest'
        '422':
          $ref: '#/components/responses/parameterMissing'
  '/catalogs/{catalogId}/groups2/':
    get:
      operationId: getGroups
      tags:
        - Groups
      summary: Get catalog groups
      description: >-
        With empty identifier shows main groups of catalog. It is necessary to
        select groups by ID until the "hasParts" value is true. The "hasParts"
        value indicates that the group contains spare parts. The list of spare
        parts can be received by the method parts2.
      security:
        - ApiKey: []
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
        - name: catalogId
          in: path
          description: Catalog id
          required: true
          schema:
            type: string
            default: bmw
        - name: carId
          in: query
          schema:
            type: string
          required: true
        - name: groupId
          in: query
          required: false
          description: Group id
          schema:
            type: string
        - name: criteria
          in: query
          required: false
          description: >-
            Filters outcoming groups depending on criteria string. Criteria
            string can obtain from "car/info" method
          schema:
            type: string
      responses:
        '200':
          description: Catalog groups
          content:
            application/json:
              schema:
                title: Array
                type: array
                items:
                  $ref: '#/components/schemas/Group'
              example:
                - id: "MfCfmoAxMjI4fEE"
                  hasSubgroups: true
                  hasParts: false
                  name: "Accessories"
                  img: "//img.example.com/r/250x250/land_rover_2014_12/1228/A.png"
                  description: ""
                - id: "IzLwn5qAMTIyOHxB8J-agUEwMfCfmoJBMDEwMDV8TFQwMTIwPD4"
                  hasSubgroups: false
                  hasParts: true
                  name: "Auxiliary Lighting-Fog Lamps"
                  img: "//img.example.com/r/250x250/land_rover_2014_12/1228/lt0120().png"
                  description: ""
          links:
            getSubgroups:
              operationId: getGroups
              parameters:
                catalogId: '$request.path.catalogId'
                carId: '$request.query.carId'
                groupId: '$response.body#/0/id'
                criteria: '$request.query.criteria'
              description: >-
                If parameter `hasParts: false`
            getParts:
              operationId: getParts
              parameters:
                catalogId: '$request.path.catalogId'
                carId: '$request.query.carId'
                groupId: '$response.body#/0/id'
                criteria: '$request.query.criteria'
              description: >-
                If parameter `hasParts: true`

        '400':
          $ref: '#/components/responses/badRequest'
        '403':
          $ref: '#/components/responses/accessDeny'
        '404':
          $ref: '#/components/responses/notFound'
  /car/info:
    get:
      operationId: getCarInfo
      security:
        - ApiKey: []
      tags:
        - Cars
      summary: Get car info by VIN or FRAME
      description: You may specify VIN or FRAME number in query. Attention! Vehicle identifier may change over time.
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
        - name: q
          in: query
          description: >-
            Automatically detects type of input data and performs search of cars
            by VIN or FRAME number depending on input data
          schema:
            type: string
        - name: catalogs
          in: query
          description: List of comma-separated Catalog IDs for search by vin or frame in selected catalogs
          explode: false
          schema:
            type: string
            example: kia,bmw,chevrolet,hyundai

      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                title: Array
                type: array
                items:
                  $ref: '#/components/schemas/CarInfo'
        '400':
          $ref: '#/components/responses/badRequest'
        '403':
          $ref: '#/components/responses/accessDeny'
  '/catalogs/{catalogId}/parts2':
    get:
      operationId: getParts2
      tags:
        - Parts
      summary: Get catalog parts.
      description: >-
        Get catalog parts. In case you receive IDs of groups with the value
        "hasParts=false", you get error 400 (No details found with specified
        parameters).
      security:
        - ApiKey: []
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
        - $ref: '#/components/parameters/XRedirectTemplate'
        - name: catalogId
          in: path
          description: Catalog id
          required: true
          schema:
            type: string
            default: bmw
        - name: carId
          in: query
          description: Car id
          required: true
          schema:
            type: string
        - name: groupId
          in: query
          description: Group id
          required: true
          schema:
            type: string
        - name: criteria
          in: query
          description: Additional criteria string
          schema:
            type: string
      responses:
        '200':
          description: Parts list
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Parts'
        '400':
          $ref: '#/components/responses/badRequest'
        '403':
          $ref: '#/components/responses/accessDeny'
        '404':
          description: No details found with specified parameters
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
  '/catalogs/{catalogId}/groups-suggest':
    get:
      operationId: getGroupsSuggest
      tags:
        - Groups
      summary: Get group suggest.
      description: Suggest parts with relative to group id
      security:
        - ApiKey: []
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
        - name: catalogId
          in: path
          description: Catalog id
          required: true
          schema:
            type: string
            default: bmw
        - name: q
          in: query
          description: First letters of searching part
          required: true
          example: 'bat'
          schema:
            type: string
      responses:
        '200':
          description: Suggest list
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Suggest'
        '400':
          $ref: '#/components/responses/badRequest'
        '403':
          $ref: '#/components/responses/accessDeny'
        '404':
          description: Search string is empty
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
  '/catalogs/{catalogId}/groups-by-sid':
    get:
      deprecated: true
      operationId: getGroupsBySid
      tags:
        - Groups
      summary: Get groups by search id.
      description: Get groups by search id
      security:
        - ApiKey: []
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
        - name: catalogId
          in: path
          description: Catalog id
          required: true
          schema:
            type: string
            default: bmw
        - name: sid
          in: query
          description: Search id from group suggest
          required: true
          example: '12345'
          schema:
            type: string
        - name: carId
          in: query
          description: Car id
          required: true
          schema:
            type: string
        - name: criteria
          in: query
          description: Additional criteria string
          schema:
            type: string
        - name: text
          in: query
          description: This field is the name of the part. After searching for groups by sid, we can sort the groups by text, where there may be a part with this name.
          schema:
            type: string
      responses:
        '200':
          description: Suggest list
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Group'
        '400':
          $ref: '#/components/responses/badRequest'
        '403':
          $ref: '#/components/responses/accessDeny'
        '404':
          description: Search string is empty
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
  /example/prices:
    get:
      operationId: "getExamplePrices"
      summary: "Get prices of part"
      description: |
        This endpoint is a demonstration example showing how to retrieve information about prices and availability of parts by unique product code and brand. It is intended for developers and API architects as an illustration of potential functionality, not as a ready-to-use solution for production environments.
      tags:
        - Example
      parameters:
        - in: "query"
          required: true
          name: "code"
          schema:
            type: "string"
        - in: "query"
          name: "brand"
          required: true
          schema:
            type: "string"
      responses:
        200:
          description: ""
          content:
            application/json:
              schema:
                type: "array"
                items:
                  $ref: "#/components/schemas/ExamplePricesResponse"
        default:
          description: Any error 400 - 500
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
  /catalogs/{catalogId}/groups-tree:
    get:
      operationId: "Get groups tree"
      description: "Get groups tree"
      tags:
        - Groups tree
      parameters:
        - in: "path"
          required: true
          name: "catalogId"
          schema:
            type: "string"
        - in: "query"
          name: "carId"
          schema:
            type: "string"
        - in: "query"
          name: "criteria"
          schema:
            type: "string"
        - in: "query"
          name: "cached"
          description: A flag that determines whether the general unfiltered group tree should be retrieved from the cache or filtered tree with increased latency should be retrieved.
          schema:
            type: "boolean"
      responses:
        200:
          description: ""
          content:
            application/json:
              schema:
                type: "array"
                items:
                  $ref: "#/components/schemas/GroupsTreeResponse"
        default:
          description: Any error 400 - 500
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
  /catalogs/{catalogId}/schemas:
    get:
      operationId: "Get schemas"
      description: "Get schemas that lead to detail pages."
      tags:
        - Groups tree
      parameters:
        - in: "query"
          required: true
          name: "carId"
          schema:
            type: "string"
        - in: "path"
          required: true
          name: "catalogId"
          schema:
            type: "string"
            example: "toyota"
        - in: "query"
          name: "branchId"
          description: Id for filter schemas by branch id. Branch id it is group id.
          schema:
            type: "string"
        - in: "query"
          name: "criteria"
          schema:
            type: "string"
        - in: "query"
          name: "page"
          description: The page number. One response can contain a maximum of 24 elements.
          schema:
            type: "integer"
            default: 0
            minimum: 0
        - in: "query"
          name: "partNameIds"
          description: Part name ids for filter schemas
          example: "56,85"
          schema:
            type: "string"
        - in: "query"
          name: "partName"
          description: Part name for filter schemas
          example: "Air filter"
          schema:
            type: "string"
      responses:
        200:
          description: ""
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/SchemasResponse"
          headers:
            X-Total-Count:
              schema:
                type: integer
              description: The total number of items available for extraction.
        default:
          description: Any error 400 - 500
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
servers:
  - url: '/v1'
components:
  responses:
    accessDeny:
      description: Access deny
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    parameterMissing:
      description: Unprocessable Entity
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    notFound:
      description: Not Found
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    badRequest:
      description: Bad Request
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
  securitySchemes:
    ApiKey:
      type: apiKey
      description: Authorization by ApiKey
      name: Authorization
      in: header
  schemas:
    Ip:
      properties:
        ip:
          description: ip value
          type: string
    CarParameterInfo:
      properties:
        key:
          type: string
        name:
          type: string
        values:
          type: array
          items:
            type: object
            properties:
              idx:
                $ref: '#/components/schemas/CarParameterIdx'
              value:
                type: string
        sortOrder:
          type: integer
          description: 'You can sort the parameters in the external interface in the sort order 
                from minimum to maximum. The smaller the sortOrder, the higher the priority of the parameter.'
    CarParameterIdx:
      description: Index of car parameter (idx)
      type: string
    Parts:
      description: Parts description
      required:
        - img
        - partGroups
      properties:
        img:
          description: URL of full-size parts group image
          type: string
        imgDescription:
          description: Parts group description
          type: string
        partGroups:
          description: Parts group list
          type: array
          items:
            $ref: '#/components/schemas/PartsGroup'
        positions:
          description: Positions of blocks with a number on image
          type: array
          items:
            description: Position of block with a part number on image
            type: object
            properties:
              number:
                description: Number on image
                type: string
              coordinates:
                description:
                  Coordinate data<br />
                  X - horizontal coordinate relative to the upper left of the full-size image, in pixels<br />
                  Y - vertical coordinate relative to the upper left of the full-size image, in pixels<br />
                  H - height of block with a part number on the full-size image, in pixels<br />
                  W - width of block with a part number on the full-size image, in pixels
                type: array
                items:
                  description: 'array (X, Y, H, W)'
                  type: number
                minItems: 4
                maxItems: 4
    PartsGroup:
      description: Parts group
      type: object
      required:
        - parts
      properties:
        name:
          description: Part name
          type: string
        number:
          description: Parts group number
          type: string
        positionNumber:
          description: Parts group position number on image
          type: string
        description:
          description: Parts group description. Installation notes, applicability. Description of the part or group of parts.
          type: string
        parts:
          description: Group detail list
          type: array
          items:
            $ref: '#/components/schemas/Part'
    Group:
      description: Group
      required:
        - id
        - name
      properties:
        id:
          description: Group id
          type: string
        parentId:
          description: Parent id. Can be `null` if there is no parent
          type: string
        hasSubgroups:
          description: Indicates that the group has subgroups
          type: boolean
        hasParts:
          description: Indicates that the group has parts
          type: boolean
        name:
          description: Group name
          type: string
        img:
          description: Group image
          type: string
        description:
          description: Group description
          type: string
    Car2:
      description: Car
      required:
        - id
        - catalogId
        - name
      properties:
        id:
          description: |-
            Is a car identifier in the Parts-Catalogs system; 
            this parameter is not constant and can change when updating catalogs
          type: string
        catalogId:
          description: Catalog id
          type: string
        name:
          description: Car name
          type: string
        description:
          description: Car description
          type: string
        modelId:
          description: Car model id
          type: string
          example: 'd3190764f126fabbf56bf3e36efbd56a'
        modelName:
          description: Car model name
          type: string
        modelImg:
          description: Model image URL
          type: string
        vin:
          description: Car vin
          type: string
        frame:
          description: Car frame
          type: string
        criteria:
          description: |-
            Criteria is a parameter, which contains info by VIN taken from the "car/info" method; 
            this parameter is used to filter groups and parts for a specified VIN
          type: string
        brand:
          description: Car brand
          type: string
        groupsTreeAvailable:
          description: Groups tree method availability flag
          type: boolean
        parameters:
          description: Car parameters
          type: array
          items:
            type: object
            properties:
              idx:
                type: string
                description: hash id of car param
              key:
                type: string
              name:
                type: string
              value:
                type: string
              sortOrder:
                type: integer
                description: 'You can sort the parameters in the external interface in the sort order 
                from minimum to maximum. The smaller the sortOrder, the higher the priority of the parameter.'
    CarFilterValues:
      title: Car filter
      description: The values of the specific complectation parameter
      properties:
        name:
          description: Parameter name
          type: object
          properties:
            id:
              description: Parameter id
              type: string
            key:
              description: Inner key of parameter
              type: string
            text:
              description: Parameter text
              type: string
        values:
          description: Parameter value
          type: array
          items:
            type: object
            properties:
              id:
                type: string
                description: Parameter value id
              text:
                type: string
                description: Parameter value text
    Model:
      title: Models
      description: Car model
      required:
        - id
        - name
      properties:
        id:
          description: Model id
          type: string
        name:
          description: Model name
          type: string
        img:
          description: Model image URL
          type: string
    Catalog:
      title: Catalog
      required:
        - id
        - name
        - modelsCount
      properties:
        id:
          description: Catalog id
          type: string
        name:
          description: Catalog name
          type: string
        modelsCount:
          type: integer
    Error:
      title: Error
      description: Error response to request
      required:
        - code
        - message
      properties:
        code:
          description: Response code
          type: integer
          format: int32
        errorCode:
          description: Error code
          type: string
        message:
          description: Text message
          type: string
    CarInfo:
      properties:
        title:
          type: string
        catalogId:
          description: Catalog id
          type: string
        brand:
          description: Car brand
          type: string
        modelId:
          description: Car model id
          type: string
          example: '5bb58a3cab059a189ef92be181380fd5'
        carId:
          description: Car id
          type: string
        criteria:
          description: 'Additional criterias to search in groups, subgroups and parts'
          type: string
        vin:
          description: Car vin
          type: string
        frame:
          description: Car frame
          type: string
        modelName:
          description: Car model name
          type: string
        description:
          description: Car description
          type: string
        groupsTreeAvailable:
          description: Groups tree method availability flag
          type: boolean
        optionCodes:
          description: Car option codes
          type: array
          items:
            properties:
              code:
                type: string
              description:
                type: string
        parameters:
          description: Car parameters
          type: array
          items:
            type: object
            properties:
              idx:
                type: string
                description: hash id of car param
              key:
                type: string
              name:
                type: string
              value:
                type: string
              sortOrder:
                type: integer
                description: 'You can sort the parameters in the external interface in the sort order 
                from minimum to maximum. The smaller the sortOrder, the higher the priority of the parameter.'
    Part:
      description: Part
      type: object
      properties:
        id:
          description: Part id
          type: string
        nameId:
          nullable: true
          description: Name id
          type: string
        name:
          description: Name
          type: string
        number:
          description: Part number
          type: string
        notice:
          type: string
          description: |-
            Short note.
            It can has url for go to sections in gui.
            To get url in this field, you must send header with template for your gui url.
        description:
          description: |-
            Part description. Installation notes, applicability. Replacements. Description and characteristics of the part.
            It can has url for go to sections in gui.
            To get url in this field, you must send header with template for your gui url.
          type: string
        positionNumber:
          description: Position number on image group
          type: string
        url:
          description: Search results URL
          type: string
    Suggest:
      description: suggest
      type: object
      properties:
        sid:
          description: search id
          type: string
          example: '12345'
        name:
          description: Name
          type: string
          example: 'battery'
    ExamplePricesResponse:
      properties:
        id:
          type: "string"
        title:
          type: "string"
        code:
          type: "string"
        brand:
          type: "string"
        price:
          type: "string"
        basketQty:
          type: "string"
        inStockQty:
          type: "string"
        rating:
          type: "string"
        delivery:
          type: "string"
        payload:
          type: "object"
          additionalProperties:
            type: "string"
    SchemasResponse:
      properties:
        group:
          nullable: true
          oneOf:
            - $ref: "#/components/schemas/Group"
        list:
          type: "array"
          items:
            $ref: "#/components/schemas/Schema"
    Schema:
      properties:
        groupId:
          nullable: false
          type: "string"
          example: "IzLwn5qAMDA08J-agTg0RTQyOULwn5SwMjI18J-QkjU4NfCfkIk4NEU0MjlC"
        img:
          nullable: true
          type: "string"
          example: "//img.parts-catalogs.com/toyota_2022_12/usa/84E429B.png"
        name:
          nullable: false
          type: "string"
          example: "ENGINE & TRANSMISSION ILLUST NO. 1 OF 7"
        description:
          nullable: true
          type: "string"
          example: ""
        partNames:
          type: "array"
          items:
            $ref: "#/components/schemas/PartName"
    PartName:
      properties:
        id:
          nullable: false
          type: "string"
        name:
          nullable: false
          type: "string"
    GroupsTreeResponse:
      properties:
        id:
          nullable: false
          type: "string"
        name:
          nullable: false
          type: "string"
        parentId:
          nullable: true
          type: "string"
        subGroups:
          nullable: false
          type: "array"
          items:
            $ref: "#/components/schemas/GroupsTree"
    GroupsTree:
      properties:
        id:
          nullable: false
          type: "string"
        name:
          nullable: false
          type: "string"
        parentId:
          nullable: true
          type: "string"
        subGroups:
          nullable: false
          type: "array"
          example: [ ]
  parameters:
    AcceptLanguage:
      name: Accept-Language
      in: header
      description: Language of return data
      schema:
        type: string
        default: en
        enum: [en, ru, de, bg, fr, es, he]
    XRedirectTemplate:
      name: x-redirect-template
      in: header
      description:  |-
        Template for your gui url.
        In template must be 2 templates separated by commas for go to group list and parts list.
        If vin is not used, then you do not need to pass criteria and vin to the template.
      schema:
        type: string
        example: parts <a href="#/parts?catalogId=%catalogId%&modelId=%modelId%&carId=%carId%&groupId=%groupId%&q=%vin%&criteria=%criteria%">%text%</a>, groups <a href="#/groups?catalogId=%catalogId%&modelId=%modelId%&carId=%carId%&groupsPath=%groupId%&q=%vin%&criteria=%criteria%">%text%</a>
```

## lib\features\parts_catalog\api\api_client_parts_catalogs.dart
```dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:part_catalog/features/parts_catalog/models/catalog.dart';
import 'package:part_catalog/features/parts_catalog/models/model.dart';
import 'package:part_catalog/features/parts_catalog/models/car2.dart';
import 'package:part_catalog/features/parts_catalog/models/car_parameter_info.dart';
import 'package:part_catalog/features/parts_catalog/models/group.dart';
import 'package:part_catalog/features/parts_catalog/models/car_info.dart';
import 'package:part_catalog/features/parts_catalog/models/parts.dart';
import 'package:part_catalog/features/parts_catalog/models/suggest.dart';
import 'package:part_catalog/features/parts_catalog/models/example_prices_response.dart';
import 'package:part_catalog/features/parts_catalog/models/groups_tree_response.dart';
import 'package:part_catalog/features/parts_catalog/models/schemas_response.dart';

part 'api_client_parts_catalogs.g.dart';

/// {@template api_client_parts_catalogs}
/// Клиент для взаимодействия с API каталогов.
/// {@endtemplate}
@RestApi(baseUrl: "https://api.parts-catalogs.com/v1")
abstract class ApiClientPartsCatalogs {
  /// {@macro api_client_parts_catalogs}
  factory ApiClientPartsCatalogs(Dio dio) = _ApiClientPartsCatalogs;

  /// Получает список доступных каталогов.
  ///
  /// Параметры:
  ///   - apiKey: Ключ API для авторизации.
  ///   - language: Язык, на котором нужно получить данные.
  @GET("/catalogs/")
  Future<List<Catalog>> getCatalogs(@Header("Authorization") String apiKey,
      @Header("Accept-Language") String language);

  /// Получает список моделей автомобилей для указанного каталога.
  @GET("/catalogs/{catalogId}/models/")
  Future<List<Model>> getModels(
    @Path("catalogId") String catalogId,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
  );

  /// Получает список автомобилей для указанного каталога и модели.
  @GET("/catalogs/{catalogId}/cars2/")
  Future<List<Car2>> getCars2(
    @Path("catalogId") String catalogId,
    @Query("modelId") String modelId,
    @Query("parameter") List<List<String>>? parameter,
    @Query("page") int? page,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
  );

  /// Получает информацию об автомобиле по ID.
  @GET("/catalogs/{catalogId}/cars2/{carId}")
  Future<Car2> getCarsById2(
    @Path("catalogId") String catalogId,
    @Path("carId") String carId,
    @Query("criteria") String? criteria,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
  );

  /// Получает параметры фильтрации автомобилей для указанного каталога.
  @GET("/catalogs/{catalogId}/cars-parameters/")
  Future<List<CarParameterInfo>> getCarsParameters(
    @Path("catalogId") String catalogId,
    @Query("modelId") String modelId,
    @Query("parameter") List<List<String>>? parameter,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
  );

  /// Получает список групп для указанного каталога и автомобиля.
  @GET("/catalogs/{catalogId}/groups2/")
  Future<List<Group>> getGroups(
    @Path("catalogId") String catalogId,
    @Query("carId") String carId,
    @Query("groupId") String? groupId,
    @Query("criteria") String? criteria,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
  );

  /// Получает информацию об автомобиле по VIN или FRAME.
  @GET("/car/info")
  Future<List<CarInfo>> getCarInfo(
    @Query("q") String q,
    @Query("catalogs") String? catalogs,
    @Header("Authorization") String apiKey, // Added Authorization header
    @Header("Accept-Language") String language,
  );

  /// Получает список запчастей для указанного каталога, автомобиля и группы.
  @GET("/catalogs/{catalogId}/parts2")
  Future<Parts> getParts2(
    @Path("catalogId") String catalogId,
    @Query("carId") String carId,
    @Query("groupId") String groupId,
    @Query("criteria") String? criteria,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
    @Header("x-redirect-template") String? xRedirectTemplate,
  );

  /// Получает список предложений для поиска групп.
  @GET("/catalogs/{catalogId}/groups-suggest")
  Future<List<Suggest>> getGroupsSuggest(
    @Path("catalogId") String catalogId,
    @Query("q") String q,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
  );

  /// Получает список групп по ID поиска.
  @GET("/catalogs/{catalogId}/groups-by-sid")
  Future<List<Group>> getGroupsBySid(
    @Path("catalogId") String catalogId,
    @Query("sid") String sid,
    @Query("carId") String carId,
    @Query("criteria") String? criteria,
    @Query("text") String? text,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
  );

  /// Получает пример цен на запчасти.
  @GET("/example/prices")
  Future<List<ExamplePricesResponse>> getExamplePrices(
    @Query("code") String code,
    @Query("brand") String brand,
    @Header("Authorization") String apiKey,
  );

  /// Получает дерево групп.
  @GET("/catalogs/{catalogId}/groups-tree")
  Future<List<GroupsTreeResponse>> getGroupsTree(
    @Path("catalogId") String catalogId,
    @Query("carId") String? carId,
    @Query("criteria") String? criteria,
    @Query("cached") bool? cached,
    @Header("Authorization") String apiKey,
  );

  /// Получает схемы, ведущие к страницам деталей.
  @GET("/catalogs/{catalogId}/schemas")
  Future<SchemasResponse> getSchemas(
    @Path("catalogId") String catalogId,
    @Query("carId") String carId,
    @Query("branchId") String? branchId,
    @Query("criteria") String? criteria,
    @Query("page") int? page,
    @Query("partNameIds") String? partNameIds,
    @Query("partName") String? partName,
    @Header("Authorization") String apiKey,
    @Header("Accept-Language") String language,
  );
  // Другие endpoints
}

```

## lib\features\parts_catalog\api\api_client_parts_catalogs.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client_parts_catalogs.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations

class _ApiClientPartsCatalogs implements ApiClientPartsCatalogs {
  _ApiClientPartsCatalogs(this._dio, {this.baseUrl, this.errorLogger}) {
    baseUrl ??= 'https://api.parts-catalogs.com/v1';
  }

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Future<List<Catalog>> getCatalogs(String apiKey, String language) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': apiKey,
      r'Accept-Language': language,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<Catalog>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/catalogs/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<Catalog> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => Catalog.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<Model>> getModels(
    String catalogId,
    String apiKey,
    String language,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{
      r'Authorization': apiKey,
      r'Accept-Language': language,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<Model>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/catalogs/${catalogId}/models/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<Model> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => Model.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<Car2>> getCars2(
    String catalogId,
    String modelId,
    List<List<String>>? parameter,
    int? page,
    String apiKey,
    String language,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'modelId': modelId,
      r'parameter': parameter,
      r'page': page,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Authorization': apiKey,
      r'Accept-Language': language,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<Car2>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/catalogs/${catalogId}/cars2/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<Car2> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => Car2.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Car2> getCarsById2(
    String catalogId,
    String carId,
    String? criteria,
    String apiKey,
    String language,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'criteria': criteria};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Authorization': apiKey,
      r'Accept-Language': language,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Car2>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/catalogs/${catalogId}/cars2/${carId}',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late Car2 _value;
    try {
      _value = Car2.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<CarParameterInfo>> getCarsParameters(
    String catalogId,
    String modelId,
    List<List<String>>? parameter,
    String apiKey,
    String language,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'modelId': modelId,
      r'parameter': parameter,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Authorization': apiKey,
      r'Accept-Language': language,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<CarParameterInfo>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/catalogs/${catalogId}/cars-parameters/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<CarParameterInfo> _value;
    try {
      _value = _result.data!
          .map(
            (dynamic i) => CarParameterInfo.fromJson(i as Map<String, dynamic>),
          )
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<Group>> getGroups(
    String catalogId,
    String carId,
    String? groupId,
    String? criteria,
    String apiKey,
    String language,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'carId': carId,
      r'groupId': groupId,
      r'criteria': criteria,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Authorization': apiKey,
      r'Accept-Language': language,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<Group>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/catalogs/${catalogId}/groups2/',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<Group> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => Group.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<CarInfo>> getCarInfo(
    String q,
    String? catalogs,
    String apiKey,
    String language,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'q': q, r'catalogs': catalogs};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Authorization': apiKey,
      r'Accept-Language': language,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<CarInfo>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/car/info',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<CarInfo> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => CarInfo.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<Parts> getParts2(
    String catalogId,
    String carId,
    String groupId,
    String? criteria,
    String apiKey,
    String language,
    String? xRedirectTemplate,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'carId': carId,
      r'groupId': groupId,
      r'criteria': criteria,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Authorization': apiKey,
      r'Accept-Language': language,
      r'x-redirect-template': xRedirectTemplate,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<Parts>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/catalogs/${catalogId}/parts2',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late Parts _value;
    try {
      _value = Parts.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<Suggest>> getGroupsSuggest(
    String catalogId,
    String q,
    String apiKey,
    String language,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'q': q};
    final _headers = <String, dynamic>{
      r'Authorization': apiKey,
      r'Accept-Language': language,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<Suggest>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/catalogs/${catalogId}/groups-suggest',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<Suggest> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => Suggest.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<Group>> getGroupsBySid(
    String catalogId,
    String sid,
    String carId,
    String? criteria,
    String? text,
    String apiKey,
    String language,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'sid': sid,
      r'carId': carId,
      r'criteria': criteria,
      r'text': text,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Authorization': apiKey,
      r'Accept-Language': language,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<Group>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/catalogs/${catalogId}/groups-by-sid',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<Group> _value;
    try {
      _value = _result.data!
          .map((dynamic i) => Group.fromJson(i as Map<String, dynamic>))
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<ExamplePricesResponse>> getExamplePrices(
    String code,
    String brand,
    String apiKey,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'code': code, r'brand': brand};
    final _headers = <String, dynamic>{r'Authorization': apiKey};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<ExamplePricesResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/example/prices',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<ExamplePricesResponse> _value;
    try {
      _value = _result.data!
          .map(
            (dynamic i) =>
                ExamplePricesResponse.fromJson(i as Map<String, dynamic>),
          )
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<List<GroupsTreeResponse>> getGroupsTree(
    String catalogId,
    String? carId,
    String? criteria,
    bool? cached,
    String apiKey,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'carId': carId,
      r'criteria': criteria,
      r'cached': cached,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{r'Authorization': apiKey};
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<List<GroupsTreeResponse>>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/catalogs/${catalogId}/groups-tree',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<List<dynamic>>(_options);
    late List<GroupsTreeResponse> _value;
    try {
      _value = _result.data!
          .map(
            (dynamic i) =>
                GroupsTreeResponse.fromJson(i as Map<String, dynamic>),
          )
          .toList();
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  @override
  Future<SchemasResponse> getSchemas(
    String catalogId,
    String carId,
    String? branchId,
    String? criteria,
    int? page,
    String? partNameIds,
    String? partName,
    String apiKey,
    String language,
  ) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'carId': carId,
      r'branchId': branchId,
      r'criteria': criteria,
      r'page': page,
      r'partNameIds': partNameIds,
      r'partName': partName,
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{
      r'Authorization': apiKey,
      r'Accept-Language': language,
    };
    _headers.removeWhere((k, v) => v == null);
    const Map<String, dynamic>? _data = null;
    final _options = _setStreamType<SchemasResponse>(
      Options(method: 'GET', headers: _headers, extra: _extra)
          .compose(
            _dio.options,
            '/catalogs/${catalogId}/schemas',
            queryParameters: queryParameters,
            data: _data,
          )
          .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<Map<String, dynamic>>(_options);
    late SchemasResponse _value;
    try {
      _value = SchemasResponse.fromJson(_result.data!);
    } on Object catch (e, s) {
      errorLogger?.logError(e, s, _options);
      rethrow;
    }
    return _value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

```

## lib\features\parts_catalog\models\car2.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'car2.freezed.dart';
part 'car2.g.dart';

/// {@template car2}
/// Модель данных для автомобиля (Car2).
/// {@endtemplate}
@freezed
class Car2 with _$Car2 {
  /// {@macro car2}
  factory Car2({
    /// Идентификатор автомобиля.
    @JsonKey(name: 'id') required String id,

    /// Идентификатор каталога.
    @JsonKey(name: 'catalogId') required String catalogId,

    /// Название автомобиля.
    @JsonKey(name: 'name') required String name,

    /// Описание автомобиля.
    @JsonKey(name: 'description') String? description,

    /// Идентификатор модели автомобиля.
    @JsonKey(name: 'modelId') String? modelId,

    /// Название модели автомобиля.
    @JsonKey(name: 'modelName') String? modelName,

    /// URL изображения модели автомобиля.
    @JsonKey(name: 'modelImg') String? modelImg,

    /// VIN автомобиля.
    @JsonKey(name: 'vin') String? vin,

    /// FRAME автомобиля.
    @JsonKey(name: 'frame') String? frame,

    /// Критерии для фильтрации групп и запчастей.
    @JsonKey(name: 'criteria') String? criteria,

    /// Бренд автомобиля.
    @JsonKey(name: 'brand') String? brand,

    /// Флаг доступности дерева групп.
    @JsonKey(name: 'groupsTreeAvailable') bool? groupsTreeAvailable,

    /// Параметры автомобиля.
    @JsonKey(name: 'parameters') List<CarParameter>? parameters,
  }) = _Car2;

  /// Преобразует JSON в объект [Car2].
  factory Car2.fromJson(Map<String, dynamic> json) => _$Car2FromJson(json);
}

/// {@template car_parameter}
/// Модель данных для параметра автомобиля.
/// {@endtemplate}
@freezed
class CarParameter with _$CarParameter {
  /// {@macro car_parameter}
  factory CarParameter({
    /// Hash ID параметра автомобиля.
    @JsonKey(name: 'idx') String? idx,

    /// Ключ параметра автомобиля.
    @JsonKey(name: 'key') String? key,

    /// Название параметра автомобиля.
    @JsonKey(name: 'name') String? name,

    /// Значение параметра автомобиля.
    @JsonKey(name: 'value') String? value,

    /// Порядок сортировки параметра автомобиля.
    @JsonKey(name: 'sortOrder') int? sortOrder,
  }) = _CarParameter;

  /// Преобразует JSON в объект [CarParameter].
  factory CarParameter.fromJson(Map<String, dynamic> json) =>
      _$CarParameterFromJson(json);
}

```

## lib\features\parts_catalog\models\car2.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Car2 _$Car2FromJson(Map<String, dynamic> json) {
  return _Car2.fromJson(json);
}

/// @nodoc
mixin _$Car2 {
  /// Идентификатор автомобиля.
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  /// Идентификатор каталога.
  @JsonKey(name: 'catalogId')
  String get catalogId => throw _privateConstructorUsedError;

  /// Название автомобиля.
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// Описание автомобиля.
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// Идентификатор модели автомобиля.
  @JsonKey(name: 'modelId')
  String? get modelId => throw _privateConstructorUsedError;

  /// Название модели автомобиля.
  @JsonKey(name: 'modelName')
  String? get modelName => throw _privateConstructorUsedError;

  /// URL изображения модели автомобиля.
  @JsonKey(name: 'modelImg')
  String? get modelImg => throw _privateConstructorUsedError;

  /// VIN автомобиля.
  @JsonKey(name: 'vin')
  String? get vin => throw _privateConstructorUsedError;

  /// FRAME автомобиля.
  @JsonKey(name: 'frame')
  String? get frame => throw _privateConstructorUsedError;

  /// Критерии для фильтрации групп и запчастей.
  @JsonKey(name: 'criteria')
  String? get criteria => throw _privateConstructorUsedError;

  /// Бренд автомобиля.
  @JsonKey(name: 'brand')
  String? get brand => throw _privateConstructorUsedError;

  /// Флаг доступности дерева групп.
  @JsonKey(name: 'groupsTreeAvailable')
  bool? get groupsTreeAvailable => throw _privateConstructorUsedError;

  /// Параметры автомобиля.
  @JsonKey(name: 'parameters')
  List<CarParameter>? get parameters => throw _privateConstructorUsedError;

  /// Serializes this Car2 to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Car2
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $Car2CopyWith<Car2> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $Car2CopyWith<$Res> {
  factory $Car2CopyWith(Car2 value, $Res Function(Car2) then) =
      _$Car2CopyWithImpl<$Res, Car2>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'catalogId') String catalogId,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'modelId') String? modelId,
      @JsonKey(name: 'modelName') String? modelName,
      @JsonKey(name: 'modelImg') String? modelImg,
      @JsonKey(name: 'vin') String? vin,
      @JsonKey(name: 'frame') String? frame,
      @JsonKey(name: 'criteria') String? criteria,
      @JsonKey(name: 'brand') String? brand,
      @JsonKey(name: 'groupsTreeAvailable') bool? groupsTreeAvailable,
      @JsonKey(name: 'parameters') List<CarParameter>? parameters});
}

/// @nodoc
class _$Car2CopyWithImpl<$Res, $Val extends Car2>
    implements $Car2CopyWith<$Res> {
  _$Car2CopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Car2
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? catalogId = null,
    Object? name = null,
    Object? description = freezed,
    Object? modelId = freezed,
    Object? modelName = freezed,
    Object? modelImg = freezed,
    Object? vin = freezed,
    Object? frame = freezed,
    Object? criteria = freezed,
    Object? brand = freezed,
    Object? groupsTreeAvailable = freezed,
    Object? parameters = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      catalogId: null == catalogId
          ? _value.catalogId
          : catalogId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      modelId: freezed == modelId
          ? _value.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String?,
      modelName: freezed == modelName
          ? _value.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
      modelImg: freezed == modelImg
          ? _value.modelImg
          : modelImg // ignore: cast_nullable_to_non_nullable
              as String?,
      vin: freezed == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      frame: freezed == frame
          ? _value.frame
          : frame // ignore: cast_nullable_to_non_nullable
              as String?,
      criteria: freezed == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      groupsTreeAvailable: freezed == groupsTreeAvailable
          ? _value.groupsTreeAvailable
          : groupsTreeAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      parameters: freezed == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<CarParameter>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$Car2ImplCopyWith<$Res> implements $Car2CopyWith<$Res> {
  factory _$$Car2ImplCopyWith(
          _$Car2Impl value, $Res Function(_$Car2Impl) then) =
      __$$Car2ImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'catalogId') String catalogId,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'modelId') String? modelId,
      @JsonKey(name: 'modelName') String? modelName,
      @JsonKey(name: 'modelImg') String? modelImg,
      @JsonKey(name: 'vin') String? vin,
      @JsonKey(name: 'frame') String? frame,
      @JsonKey(name: 'criteria') String? criteria,
      @JsonKey(name: 'brand') String? brand,
      @JsonKey(name: 'groupsTreeAvailable') bool? groupsTreeAvailable,
      @JsonKey(name: 'parameters') List<CarParameter>? parameters});
}

/// @nodoc
class __$$Car2ImplCopyWithImpl<$Res>
    extends _$Car2CopyWithImpl<$Res, _$Car2Impl>
    implements _$$Car2ImplCopyWith<$Res> {
  __$$Car2ImplCopyWithImpl(_$Car2Impl _value, $Res Function(_$Car2Impl) _then)
      : super(_value, _then);

  /// Create a copy of Car2
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? catalogId = null,
    Object? name = null,
    Object? description = freezed,
    Object? modelId = freezed,
    Object? modelName = freezed,
    Object? modelImg = freezed,
    Object? vin = freezed,
    Object? frame = freezed,
    Object? criteria = freezed,
    Object? brand = freezed,
    Object? groupsTreeAvailable = freezed,
    Object? parameters = freezed,
  }) {
    return _then(_$Car2Impl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      catalogId: null == catalogId
          ? _value.catalogId
          : catalogId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      modelId: freezed == modelId
          ? _value.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String?,
      modelName: freezed == modelName
          ? _value.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
      modelImg: freezed == modelImg
          ? _value.modelImg
          : modelImg // ignore: cast_nullable_to_non_nullable
              as String?,
      vin: freezed == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      frame: freezed == frame
          ? _value.frame
          : frame // ignore: cast_nullable_to_non_nullable
              as String?,
      criteria: freezed == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      groupsTreeAvailable: freezed == groupsTreeAvailable
          ? _value.groupsTreeAvailable
          : groupsTreeAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      parameters: freezed == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<CarParameter>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$Car2Impl implements _Car2 {
  _$Car2Impl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'catalogId') required this.catalogId,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'modelId') this.modelId,
      @JsonKey(name: 'modelName') this.modelName,
      @JsonKey(name: 'modelImg') this.modelImg,
      @JsonKey(name: 'vin') this.vin,
      @JsonKey(name: 'frame') this.frame,
      @JsonKey(name: 'criteria') this.criteria,
      @JsonKey(name: 'brand') this.brand,
      @JsonKey(name: 'groupsTreeAvailable') this.groupsTreeAvailable,
      @JsonKey(name: 'parameters') final List<CarParameter>? parameters})
      : _parameters = parameters;

  factory _$Car2Impl.fromJson(Map<String, dynamic> json) =>
      _$$Car2ImplFromJson(json);

  /// Идентификатор автомобиля.
  @override
  @JsonKey(name: 'id')
  final String id;

  /// Идентификатор каталога.
  @override
  @JsonKey(name: 'catalogId')
  final String catalogId;

  /// Название автомобиля.
  @override
  @JsonKey(name: 'name')
  final String name;

  /// Описание автомобиля.
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// Идентификатор модели автомобиля.
  @override
  @JsonKey(name: 'modelId')
  final String? modelId;

  /// Название модели автомобиля.
  @override
  @JsonKey(name: 'modelName')
  final String? modelName;

  /// URL изображения модели автомобиля.
  @override
  @JsonKey(name: 'modelImg')
  final String? modelImg;

  /// VIN автомобиля.
  @override
  @JsonKey(name: 'vin')
  final String? vin;

  /// FRAME автомобиля.
  @override
  @JsonKey(name: 'frame')
  final String? frame;

  /// Критерии для фильтрации групп и запчастей.
  @override
  @JsonKey(name: 'criteria')
  final String? criteria;

  /// Бренд автомобиля.
  @override
  @JsonKey(name: 'brand')
  final String? brand;

  /// Флаг доступности дерева групп.
  @override
  @JsonKey(name: 'groupsTreeAvailable')
  final bool? groupsTreeAvailable;

  /// Параметры автомобиля.
  final List<CarParameter>? _parameters;

  /// Параметры автомобиля.
  @override
  @JsonKey(name: 'parameters')
  List<CarParameter>? get parameters {
    final value = _parameters;
    if (value == null) return null;
    if (_parameters is EqualUnmodifiableListView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Car2(id: $id, catalogId: $catalogId, name: $name, description: $description, modelId: $modelId, modelName: $modelName, modelImg: $modelImg, vin: $vin, frame: $frame, criteria: $criteria, brand: $brand, groupsTreeAvailable: $groupsTreeAvailable, parameters: $parameters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Car2Impl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.catalogId, catalogId) ||
                other.catalogId == catalogId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.modelId, modelId) || other.modelId == modelId) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName) &&
            (identical(other.modelImg, modelImg) ||
                other.modelImg == modelImg) &&
            (identical(other.vin, vin) || other.vin == vin) &&
            (identical(other.frame, frame) || other.frame == frame) &&
            (identical(other.criteria, criteria) ||
                other.criteria == criteria) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.groupsTreeAvailable, groupsTreeAvailable) ||
                other.groupsTreeAvailable == groupsTreeAvailable) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      catalogId,
      name,
      description,
      modelId,
      modelName,
      modelImg,
      vin,
      frame,
      criteria,
      brand,
      groupsTreeAvailable,
      const DeepCollectionEquality().hash(_parameters));

  /// Create a copy of Car2
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$Car2ImplCopyWith<_$Car2Impl> get copyWith =>
      __$$Car2ImplCopyWithImpl<_$Car2Impl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$Car2ImplToJson(
      this,
    );
  }
}

abstract class _Car2 implements Car2 {
  factory _Car2(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'catalogId') required final String catalogId,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'description') final String? description,
          @JsonKey(name: 'modelId') final String? modelId,
          @JsonKey(name: 'modelName') final String? modelName,
          @JsonKey(name: 'modelImg') final String? modelImg,
          @JsonKey(name: 'vin') final String? vin,
          @JsonKey(name: 'frame') final String? frame,
          @JsonKey(name: 'criteria') final String? criteria,
          @JsonKey(name: 'brand') final String? brand,
          @JsonKey(name: 'groupsTreeAvailable') final bool? groupsTreeAvailable,
          @JsonKey(name: 'parameters') final List<CarParameter>? parameters}) =
      _$Car2Impl;

  factory _Car2.fromJson(Map<String, dynamic> json) = _$Car2Impl.fromJson;

  /// Идентификатор автомобиля.
  @override
  @JsonKey(name: 'id')
  String get id;

  /// Идентификатор каталога.
  @override
  @JsonKey(name: 'catalogId')
  String get catalogId;

  /// Название автомобиля.
  @override
  @JsonKey(name: 'name')
  String get name;

  /// Описание автомобиля.
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// Идентификатор модели автомобиля.
  @override
  @JsonKey(name: 'modelId')
  String? get modelId;

  /// Название модели автомобиля.
  @override
  @JsonKey(name: 'modelName')
  String? get modelName;

  /// URL изображения модели автомобиля.
  @override
  @JsonKey(name: 'modelImg')
  String? get modelImg;

  /// VIN автомобиля.
  @override
  @JsonKey(name: 'vin')
  String? get vin;

  /// FRAME автомобиля.
  @override
  @JsonKey(name: 'frame')
  String? get frame;

  /// Критерии для фильтрации групп и запчастей.
  @override
  @JsonKey(name: 'criteria')
  String? get criteria;

  /// Бренд автомобиля.
  @override
  @JsonKey(name: 'brand')
  String? get brand;

  /// Флаг доступности дерева групп.
  @override
  @JsonKey(name: 'groupsTreeAvailable')
  bool? get groupsTreeAvailable;

  /// Параметры автомобиля.
  @override
  @JsonKey(name: 'parameters')
  List<CarParameter>? get parameters;

  /// Create a copy of Car2
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$Car2ImplCopyWith<_$Car2Impl> get copyWith =>
      throw _privateConstructorUsedError;
}

CarParameter _$CarParameterFromJson(Map<String, dynamic> json) {
  return _CarParameter.fromJson(json);
}

/// @nodoc
mixin _$CarParameter {
  /// Hash ID параметра автомобиля.
  @JsonKey(name: 'idx')
  String? get idx => throw _privateConstructorUsedError;

  /// Ключ параметра автомобиля.
  @JsonKey(name: 'key')
  String? get key => throw _privateConstructorUsedError;

  /// Название параметра автомобиля.
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// Значение параметра автомобиля.
  @JsonKey(name: 'value')
  String? get value => throw _privateConstructorUsedError;

  /// Порядок сортировки параметра автомобиля.
  @JsonKey(name: 'sortOrder')
  int? get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this CarParameter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarParameterCopyWith<CarParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarParameterCopyWith<$Res> {
  factory $CarParameterCopyWith(
          CarParameter value, $Res Function(CarParameter) then) =
      _$CarParameterCopyWithImpl<$Res, CarParameter>;
  @useResult
  $Res call(
      {@JsonKey(name: 'idx') String? idx,
      @JsonKey(name: 'key') String? key,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'value') String? value,
      @JsonKey(name: 'sortOrder') int? sortOrder});
}

/// @nodoc
class _$CarParameterCopyWithImpl<$Res, $Val extends CarParameter>
    implements $CarParameterCopyWith<$Res> {
  _$CarParameterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = freezed,
    Object? key = freezed,
    Object? name = freezed,
    Object? value = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_value.copyWith(
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CarParameterImplCopyWith<$Res>
    implements $CarParameterCopyWith<$Res> {
  factory _$$CarParameterImplCopyWith(
          _$CarParameterImpl value, $Res Function(_$CarParameterImpl) then) =
      __$$CarParameterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'idx') String? idx,
      @JsonKey(name: 'key') String? key,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'value') String? value,
      @JsonKey(name: 'sortOrder') int? sortOrder});
}

/// @nodoc
class __$$CarParameterImplCopyWithImpl<$Res>
    extends _$CarParameterCopyWithImpl<$Res, _$CarParameterImpl>
    implements _$$CarParameterImplCopyWith<$Res> {
  __$$CarParameterImplCopyWithImpl(
      _$CarParameterImpl _value, $Res Function(_$CarParameterImpl) _then)
      : super(_value, _then);

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = freezed,
    Object? key = freezed,
    Object? name = freezed,
    Object? value = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_$CarParameterImpl(
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarParameterImpl implements _CarParameter {
  _$CarParameterImpl(
      {@JsonKey(name: 'idx') this.idx,
      @JsonKey(name: 'key') this.key,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'value') this.value,
      @JsonKey(name: 'sortOrder') this.sortOrder});

  factory _$CarParameterImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarParameterImplFromJson(json);

  /// Hash ID параметра автомобиля.
  @override
  @JsonKey(name: 'idx')
  final String? idx;

  /// Ключ параметра автомобиля.
  @override
  @JsonKey(name: 'key')
  final String? key;

  /// Название параметра автомобиля.
  @override
  @JsonKey(name: 'name')
  final String? name;

  /// Значение параметра автомобиля.
  @override
  @JsonKey(name: 'value')
  final String? value;

  /// Порядок сортировки параметра автомобиля.
  @override
  @JsonKey(name: 'sortOrder')
  final int? sortOrder;

  @override
  String toString() {
    return 'CarParameter(idx: $idx, key: $key, name: $name, value: $value, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarParameterImpl &&
            (identical(other.idx, idx) || other.idx == idx) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, idx, key, name, value, sortOrder);

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarParameterImplCopyWith<_$CarParameterImpl> get copyWith =>
      __$$CarParameterImplCopyWithImpl<_$CarParameterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarParameterImplToJson(
      this,
    );
  }
}

abstract class _CarParameter implements CarParameter {
  factory _CarParameter(
      {@JsonKey(name: 'idx') final String? idx,
      @JsonKey(name: 'key') final String? key,
      @JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'value') final String? value,
      @JsonKey(name: 'sortOrder') final int? sortOrder}) = _$CarParameterImpl;

  factory _CarParameter.fromJson(Map<String, dynamic> json) =
      _$CarParameterImpl.fromJson;

  /// Hash ID параметра автомобиля.
  @override
  @JsonKey(name: 'idx')
  String? get idx;

  /// Ключ параметра автомобиля.
  @override
  @JsonKey(name: 'key')
  String? get key;

  /// Название параметра автомобиля.
  @override
  @JsonKey(name: 'name')
  String? get name;

  /// Значение параметра автомобиля.
  @override
  @JsonKey(name: 'value')
  String? get value;

  /// Порядок сортировки параметра автомобиля.
  @override
  @JsonKey(name: 'sortOrder')
  int? get sortOrder;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarParameterImplCopyWith<_$CarParameterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\car2.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car2.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$Car2Impl _$$Car2ImplFromJson(Map<String, dynamic> json) => _$Car2Impl(
      id: json['id'] as String,
      catalogId: json['catalogId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      modelId: json['modelId'] as String?,
      modelName: json['modelName'] as String?,
      modelImg: json['modelImg'] as String?,
      vin: json['vin'] as String?,
      frame: json['frame'] as String?,
      criteria: json['criteria'] as String?,
      brand: json['brand'] as String?,
      groupsTreeAvailable: json['groupsTreeAvailable'] as bool?,
      parameters: (json['parameters'] as List<dynamic>?)
          ?.map((e) => CarParameter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$Car2ImplToJson(_$Car2Impl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'catalogId': instance.catalogId,
      'name': instance.name,
      'description': instance.description,
      'modelId': instance.modelId,
      'modelName': instance.modelName,
      'modelImg': instance.modelImg,
      'vin': instance.vin,
      'frame': instance.frame,
      'criteria': instance.criteria,
      'brand': instance.brand,
      'groupsTreeAvailable': instance.groupsTreeAvailable,
      'parameters': instance.parameters,
    };

_$CarParameterImpl _$$CarParameterImplFromJson(Map<String, dynamic> json) =>
    _$CarParameterImpl(
      idx: json['idx'] as String?,
      key: json['key'] as String?,
      name: json['name'] as String?,
      value: json['value'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CarParameterImplToJson(_$CarParameterImpl instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'key': instance.key,
      'name': instance.name,
      'value': instance.value,
      'sortOrder': instance.sortOrder,
    };

```

## lib\features\parts_catalog\models\car_info.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/features/parts_catalog/models/car_parameter.dart';
import 'package:part_catalog/features/parts_catalog/models/option_code.dart';

part 'car_info.freezed.dart';
part 'car_info.g.dart';

/// {@template car_info}
/// Модель данных для информации об автомобиле.
/// {@endtemplate}
@freezed
class CarInfo with _$CarInfo {
  /// {@macro car_info}
  factory CarInfo({
    /// Заголовок.
    @JsonKey(name: 'title') String? title,

    /// Идентификатор каталога.
    @JsonKey(name: 'catalogId') String? catalogId,

    /// Бренд автомобиля.
    @JsonKey(name: 'brand') String? brand,

    /// Идентификатор модели автомобиля.
    @JsonKey(name: 'modelId') String? modelId,

    /// Идентификатор автомобиля.
    @JsonKey(name: 'carId') String? carId,

    /// Критерии для поиска.
    @JsonKey(name: 'criteria') String? criteria,

    /// VIN автомобиля.
    @JsonKey(name: 'vin') String? vin,

    /// FRAME автомобиля.
    @JsonKey(name: 'frame') String? frame,

    /// Название модели автомобиля.
    @JsonKey(name: 'modelName') String? modelName,

    /// Описание автомобиля.
    @JsonKey(name: 'description') String? description,

    /// Флаг доступности дерева групп.
    @JsonKey(name: 'groupsTreeAvailable') bool? groupsTreeAvailable,

    /// Список кодов опций автомобиля.
    @JsonKey(name: 'optionCodes') List<OptionCode>? optionCodes,

    /// Список параметров автомобиля.
    @JsonKey(name: 'parameters') List<CarParameter>? parameters,
  }) = _CarInfo;

  /// Преобразует JSON в объект [CarInfo].
  factory CarInfo.fromJson(Map<String, dynamic> json) =>
      _$CarInfoFromJson(json);
}

```

## lib\features\parts_catalog\models\car_info.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CarInfo _$CarInfoFromJson(Map<String, dynamic> json) {
  return _CarInfo.fromJson(json);
}

/// @nodoc
mixin _$CarInfo {
  /// Заголовок.
  @JsonKey(name: 'title')
  String? get title => throw _privateConstructorUsedError;

  /// Идентификатор каталога.
  @JsonKey(name: 'catalogId')
  String? get catalogId => throw _privateConstructorUsedError;

  /// Бренд автомобиля.
  @JsonKey(name: 'brand')
  String? get brand => throw _privateConstructorUsedError;

  /// Идентификатор модели автомобиля.
  @JsonKey(name: 'modelId')
  String? get modelId => throw _privateConstructorUsedError;

  /// Идентификатор автомобиля.
  @JsonKey(name: 'carId')
  String? get carId => throw _privateConstructorUsedError;

  /// Критерии для поиска.
  @JsonKey(name: 'criteria')
  String? get criteria => throw _privateConstructorUsedError;

  /// VIN автомобиля.
  @JsonKey(name: 'vin')
  String? get vin => throw _privateConstructorUsedError;

  /// FRAME автомобиля.
  @JsonKey(name: 'frame')
  String? get frame => throw _privateConstructorUsedError;

  /// Название модели автомобиля.
  @JsonKey(name: 'modelName')
  String? get modelName => throw _privateConstructorUsedError;

  /// Описание автомобиля.
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// Флаг доступности дерева групп.
  @JsonKey(name: 'groupsTreeAvailable')
  bool? get groupsTreeAvailable => throw _privateConstructorUsedError;

  /// Список кодов опций автомобиля.
  @JsonKey(name: 'optionCodes')
  List<OptionCode>? get optionCodes => throw _privateConstructorUsedError;

  /// Список параметров автомобиля.
  @JsonKey(name: 'parameters')
  List<CarParameter>? get parameters => throw _privateConstructorUsedError;

  /// Serializes this CarInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarInfoCopyWith<CarInfo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarInfoCopyWith<$Res> {
  factory $CarInfoCopyWith(CarInfo value, $Res Function(CarInfo) then) =
      _$CarInfoCopyWithImpl<$Res, CarInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'title') String? title,
      @JsonKey(name: 'catalogId') String? catalogId,
      @JsonKey(name: 'brand') String? brand,
      @JsonKey(name: 'modelId') String? modelId,
      @JsonKey(name: 'carId') String? carId,
      @JsonKey(name: 'criteria') String? criteria,
      @JsonKey(name: 'vin') String? vin,
      @JsonKey(name: 'frame') String? frame,
      @JsonKey(name: 'modelName') String? modelName,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'groupsTreeAvailable') bool? groupsTreeAvailable,
      @JsonKey(name: 'optionCodes') List<OptionCode>? optionCodes,
      @JsonKey(name: 'parameters') List<CarParameter>? parameters});
}

/// @nodoc
class _$CarInfoCopyWithImpl<$Res, $Val extends CarInfo>
    implements $CarInfoCopyWith<$Res> {
  _$CarInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? catalogId = freezed,
    Object? brand = freezed,
    Object? modelId = freezed,
    Object? carId = freezed,
    Object? criteria = freezed,
    Object? vin = freezed,
    Object? frame = freezed,
    Object? modelName = freezed,
    Object? description = freezed,
    Object? groupsTreeAvailable = freezed,
    Object? optionCodes = freezed,
    Object? parameters = freezed,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      catalogId: freezed == catalogId
          ? _value.catalogId
          : catalogId // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      modelId: freezed == modelId
          ? _value.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String?,
      carId: freezed == carId
          ? _value.carId
          : carId // ignore: cast_nullable_to_non_nullable
              as String?,
      criteria: freezed == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String?,
      vin: freezed == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      frame: freezed == frame
          ? _value.frame
          : frame // ignore: cast_nullable_to_non_nullable
              as String?,
      modelName: freezed == modelName
          ? _value.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      groupsTreeAvailable: freezed == groupsTreeAvailable
          ? _value.groupsTreeAvailable
          : groupsTreeAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      optionCodes: freezed == optionCodes
          ? _value.optionCodes
          : optionCodes // ignore: cast_nullable_to_non_nullable
              as List<OptionCode>?,
      parameters: freezed == parameters
          ? _value.parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<CarParameter>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CarInfoImplCopyWith<$Res> implements $CarInfoCopyWith<$Res> {
  factory _$$CarInfoImplCopyWith(
          _$CarInfoImpl value, $Res Function(_$CarInfoImpl) then) =
      __$$CarInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'title') String? title,
      @JsonKey(name: 'catalogId') String? catalogId,
      @JsonKey(name: 'brand') String? brand,
      @JsonKey(name: 'modelId') String? modelId,
      @JsonKey(name: 'carId') String? carId,
      @JsonKey(name: 'criteria') String? criteria,
      @JsonKey(name: 'vin') String? vin,
      @JsonKey(name: 'frame') String? frame,
      @JsonKey(name: 'modelName') String? modelName,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'groupsTreeAvailable') bool? groupsTreeAvailable,
      @JsonKey(name: 'optionCodes') List<OptionCode>? optionCodes,
      @JsonKey(name: 'parameters') List<CarParameter>? parameters});
}

/// @nodoc
class __$$CarInfoImplCopyWithImpl<$Res>
    extends _$CarInfoCopyWithImpl<$Res, _$CarInfoImpl>
    implements _$$CarInfoImplCopyWith<$Res> {
  __$$CarInfoImplCopyWithImpl(
      _$CarInfoImpl _value, $Res Function(_$CarInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CarInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? catalogId = freezed,
    Object? brand = freezed,
    Object? modelId = freezed,
    Object? carId = freezed,
    Object? criteria = freezed,
    Object? vin = freezed,
    Object? frame = freezed,
    Object? modelName = freezed,
    Object? description = freezed,
    Object? groupsTreeAvailable = freezed,
    Object? optionCodes = freezed,
    Object? parameters = freezed,
  }) {
    return _then(_$CarInfoImpl(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      catalogId: freezed == catalogId
          ? _value.catalogId
          : catalogId // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      modelId: freezed == modelId
          ? _value.modelId
          : modelId // ignore: cast_nullable_to_non_nullable
              as String?,
      carId: freezed == carId
          ? _value.carId
          : carId // ignore: cast_nullable_to_non_nullable
              as String?,
      criteria: freezed == criteria
          ? _value.criteria
          : criteria // ignore: cast_nullable_to_non_nullable
              as String?,
      vin: freezed == vin
          ? _value.vin
          : vin // ignore: cast_nullable_to_non_nullable
              as String?,
      frame: freezed == frame
          ? _value.frame
          : frame // ignore: cast_nullable_to_non_nullable
              as String?,
      modelName: freezed == modelName
          ? _value.modelName
          : modelName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      groupsTreeAvailable: freezed == groupsTreeAvailable
          ? _value.groupsTreeAvailable
          : groupsTreeAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      optionCodes: freezed == optionCodes
          ? _value._optionCodes
          : optionCodes // ignore: cast_nullable_to_non_nullable
              as List<OptionCode>?,
      parameters: freezed == parameters
          ? _value._parameters
          : parameters // ignore: cast_nullable_to_non_nullable
              as List<CarParameter>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarInfoImpl implements _CarInfo {
  _$CarInfoImpl(
      {@JsonKey(name: 'title') this.title,
      @JsonKey(name: 'catalogId') this.catalogId,
      @JsonKey(name: 'brand') this.brand,
      @JsonKey(name: 'modelId') this.modelId,
      @JsonKey(name: 'carId') this.carId,
      @JsonKey(name: 'criteria') this.criteria,
      @JsonKey(name: 'vin') this.vin,
      @JsonKey(name: 'frame') this.frame,
      @JsonKey(name: 'modelName') this.modelName,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'groupsTreeAvailable') this.groupsTreeAvailable,
      @JsonKey(name: 'optionCodes') final List<OptionCode>? optionCodes,
      @JsonKey(name: 'parameters') final List<CarParameter>? parameters})
      : _optionCodes = optionCodes,
        _parameters = parameters;

  factory _$CarInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarInfoImplFromJson(json);

  /// Заголовок.
  @override
  @JsonKey(name: 'title')
  final String? title;

  /// Идентификатор каталога.
  @override
  @JsonKey(name: 'catalogId')
  final String? catalogId;

  /// Бренд автомобиля.
  @override
  @JsonKey(name: 'brand')
  final String? brand;

  /// Идентификатор модели автомобиля.
  @override
  @JsonKey(name: 'modelId')
  final String? modelId;

  /// Идентификатор автомобиля.
  @override
  @JsonKey(name: 'carId')
  final String? carId;

  /// Критерии для поиска.
  @override
  @JsonKey(name: 'criteria')
  final String? criteria;

  /// VIN автомобиля.
  @override
  @JsonKey(name: 'vin')
  final String? vin;

  /// FRAME автомобиля.
  @override
  @JsonKey(name: 'frame')
  final String? frame;

  /// Название модели автомобиля.
  @override
  @JsonKey(name: 'modelName')
  final String? modelName;

  /// Описание автомобиля.
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// Флаг доступности дерева групп.
  @override
  @JsonKey(name: 'groupsTreeAvailable')
  final bool? groupsTreeAvailable;

  /// Список кодов опций автомобиля.
  final List<OptionCode>? _optionCodes;

  /// Список кодов опций автомобиля.
  @override
  @JsonKey(name: 'optionCodes')
  List<OptionCode>? get optionCodes {
    final value = _optionCodes;
    if (value == null) return null;
    if (_optionCodes is EqualUnmodifiableListView) return _optionCodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Список параметров автомобиля.
  final List<CarParameter>? _parameters;

  /// Список параметров автомобиля.
  @override
  @JsonKey(name: 'parameters')
  List<CarParameter>? get parameters {
    final value = _parameters;
    if (value == null) return null;
    if (_parameters is EqualUnmodifiableListView) return _parameters;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'CarInfo(title: $title, catalogId: $catalogId, brand: $brand, modelId: $modelId, carId: $carId, criteria: $criteria, vin: $vin, frame: $frame, modelName: $modelName, description: $description, groupsTreeAvailable: $groupsTreeAvailable, optionCodes: $optionCodes, parameters: $parameters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarInfoImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.catalogId, catalogId) ||
                other.catalogId == catalogId) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.modelId, modelId) || other.modelId == modelId) &&
            (identical(other.carId, carId) || other.carId == carId) &&
            (identical(other.criteria, criteria) ||
                other.criteria == criteria) &&
            (identical(other.vin, vin) || other.vin == vin) &&
            (identical(other.frame, frame) || other.frame == frame) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.groupsTreeAvailable, groupsTreeAvailable) ||
                other.groupsTreeAvailable == groupsTreeAvailable) &&
            const DeepCollectionEquality()
                .equals(other._optionCodes, _optionCodes) &&
            const DeepCollectionEquality()
                .equals(other._parameters, _parameters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      catalogId,
      brand,
      modelId,
      carId,
      criteria,
      vin,
      frame,
      modelName,
      description,
      groupsTreeAvailable,
      const DeepCollectionEquality().hash(_optionCodes),
      const DeepCollectionEquality().hash(_parameters));

  /// Create a copy of CarInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarInfoImplCopyWith<_$CarInfoImpl> get copyWith =>
      __$$CarInfoImplCopyWithImpl<_$CarInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarInfoImplToJson(
      this,
    );
  }
}

abstract class _CarInfo implements CarInfo {
  factory _CarInfo(
          {@JsonKey(name: 'title') final String? title,
          @JsonKey(name: 'catalogId') final String? catalogId,
          @JsonKey(name: 'brand') final String? brand,
          @JsonKey(name: 'modelId') final String? modelId,
          @JsonKey(name: 'carId') final String? carId,
          @JsonKey(name: 'criteria') final String? criteria,
          @JsonKey(name: 'vin') final String? vin,
          @JsonKey(name: 'frame') final String? frame,
          @JsonKey(name: 'modelName') final String? modelName,
          @JsonKey(name: 'description') final String? description,
          @JsonKey(name: 'groupsTreeAvailable') final bool? groupsTreeAvailable,
          @JsonKey(name: 'optionCodes') final List<OptionCode>? optionCodes,
          @JsonKey(name: 'parameters') final List<CarParameter>? parameters}) =
      _$CarInfoImpl;

  factory _CarInfo.fromJson(Map<String, dynamic> json) = _$CarInfoImpl.fromJson;

  /// Заголовок.
  @override
  @JsonKey(name: 'title')
  String? get title;

  /// Идентификатор каталога.
  @override
  @JsonKey(name: 'catalogId')
  String? get catalogId;

  /// Бренд автомобиля.
  @override
  @JsonKey(name: 'brand')
  String? get brand;

  /// Идентификатор модели автомобиля.
  @override
  @JsonKey(name: 'modelId')
  String? get modelId;

  /// Идентификатор автомобиля.
  @override
  @JsonKey(name: 'carId')
  String? get carId;

  /// Критерии для поиска.
  @override
  @JsonKey(name: 'criteria')
  String? get criteria;

  /// VIN автомобиля.
  @override
  @JsonKey(name: 'vin')
  String? get vin;

  /// FRAME автомобиля.
  @override
  @JsonKey(name: 'frame')
  String? get frame;

  /// Название модели автомобиля.
  @override
  @JsonKey(name: 'modelName')
  String? get modelName;

  /// Описание автомобиля.
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// Флаг доступности дерева групп.
  @override
  @JsonKey(name: 'groupsTreeAvailable')
  bool? get groupsTreeAvailable;

  /// Список кодов опций автомобиля.
  @override
  @JsonKey(name: 'optionCodes')
  List<OptionCode>? get optionCodes;

  /// Список параметров автомобиля.
  @override
  @JsonKey(name: 'parameters')
  List<CarParameter>? get parameters;

  /// Create a copy of CarInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarInfoImplCopyWith<_$CarInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\car_info.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CarInfoImpl _$$CarInfoImplFromJson(Map<String, dynamic> json) =>
    _$CarInfoImpl(
      title: json['title'] as String?,
      catalogId: json['catalogId'] as String?,
      brand: json['brand'] as String?,
      modelId: json['modelId'] as String?,
      carId: json['carId'] as String?,
      criteria: json['criteria'] as String?,
      vin: json['vin'] as String?,
      frame: json['frame'] as String?,
      modelName: json['modelName'] as String?,
      description: json['description'] as String?,
      groupsTreeAvailable: json['groupsTreeAvailable'] as bool?,
      optionCodes: (json['optionCodes'] as List<dynamic>?)
          ?.map((e) => OptionCode.fromJson(e as Map<String, dynamic>))
          .toList(),
      parameters: (json['parameters'] as List<dynamic>?)
          ?.map((e) => CarParameter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$CarInfoImplToJson(_$CarInfoImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'catalogId': instance.catalogId,
      'brand': instance.brand,
      'modelId': instance.modelId,
      'carId': instance.carId,
      'criteria': instance.criteria,
      'vin': instance.vin,
      'frame': instance.frame,
      'modelName': instance.modelName,
      'description': instance.description,
      'groupsTreeAvailable': instance.groupsTreeAvailable,
      'optionCodes': instance.optionCodes,
      'parameters': instance.parameters,
    };

```

## lib\features\parts_catalog\models\car_parameter.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_parameter.freezed.dart';
part 'car_parameter.g.dart';

/// {@template car_parameter}
/// Модель данных для параметра автомобиля.
/// {@endtemplate}
@freezed
class CarParameter with _$CarParameter {
  /// {@macro car_parameter}
  factory CarParameter({
    /// Hash ID параметра автомобиля.
    @JsonKey(name: 'idx') String? idx,

    /// Ключ параметра автомобиля.
    @JsonKey(name: 'key') String? key,

    /// Название параметра автомобиля.
    @JsonKey(name: 'name') String? name,

    /// Значение параметра автомобиля.
    @JsonKey(name: 'value') String? value,

    /// Порядок сортировки параметра автомобиля.
    @JsonKey(name: 'sortOrder') int? sortOrder,
  }) = _CarParameter;

  /// Преобразует JSON в объект [CarParameter].
  factory CarParameter.fromJson(Map<String, dynamic> json) =>
      _$CarParameterFromJson(json);
}

```

## lib\features\parts_catalog\models\car_parameter.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_parameter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CarParameter _$CarParameterFromJson(Map<String, dynamic> json) {
  return _CarParameter.fromJson(json);
}

/// @nodoc
mixin _$CarParameter {
  /// Hash ID параметра автомобиля.
  @JsonKey(name: 'idx')
  String? get idx => throw _privateConstructorUsedError;

  /// Ключ параметра автомобиля.
  @JsonKey(name: 'key')
  String? get key => throw _privateConstructorUsedError;

  /// Название параметра автомобиля.
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// Значение параметра автомобиля.
  @JsonKey(name: 'value')
  String? get value => throw _privateConstructorUsedError;

  /// Порядок сортировки параметра автомобиля.
  @JsonKey(name: 'sortOrder')
  int? get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this CarParameter to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarParameterCopyWith<CarParameter> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarParameterCopyWith<$Res> {
  factory $CarParameterCopyWith(
          CarParameter value, $Res Function(CarParameter) then) =
      _$CarParameterCopyWithImpl<$Res, CarParameter>;
  @useResult
  $Res call(
      {@JsonKey(name: 'idx') String? idx,
      @JsonKey(name: 'key') String? key,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'value') String? value,
      @JsonKey(name: 'sortOrder') int? sortOrder});
}

/// @nodoc
class _$CarParameterCopyWithImpl<$Res, $Val extends CarParameter>
    implements $CarParameterCopyWith<$Res> {
  _$CarParameterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = freezed,
    Object? key = freezed,
    Object? name = freezed,
    Object? value = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_value.copyWith(
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CarParameterImplCopyWith<$Res>
    implements $CarParameterCopyWith<$Res> {
  factory _$$CarParameterImplCopyWith(
          _$CarParameterImpl value, $Res Function(_$CarParameterImpl) then) =
      __$$CarParameterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'idx') String? idx,
      @JsonKey(name: 'key') String? key,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'value') String? value,
      @JsonKey(name: 'sortOrder') int? sortOrder});
}

/// @nodoc
class __$$CarParameterImplCopyWithImpl<$Res>
    extends _$CarParameterCopyWithImpl<$Res, _$CarParameterImpl>
    implements _$$CarParameterImplCopyWith<$Res> {
  __$$CarParameterImplCopyWithImpl(
      _$CarParameterImpl _value, $Res Function(_$CarParameterImpl) _then)
      : super(_value, _then);

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = freezed,
    Object? key = freezed,
    Object? name = freezed,
    Object? value = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_$CarParameterImpl(
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarParameterImpl implements _CarParameter {
  _$CarParameterImpl(
      {@JsonKey(name: 'idx') this.idx,
      @JsonKey(name: 'key') this.key,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'value') this.value,
      @JsonKey(name: 'sortOrder') this.sortOrder});

  factory _$CarParameterImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarParameterImplFromJson(json);

  /// Hash ID параметра автомобиля.
  @override
  @JsonKey(name: 'idx')
  final String? idx;

  /// Ключ параметра автомобиля.
  @override
  @JsonKey(name: 'key')
  final String? key;

  /// Название параметра автомобиля.
  @override
  @JsonKey(name: 'name')
  final String? name;

  /// Значение параметра автомобиля.
  @override
  @JsonKey(name: 'value')
  final String? value;

  /// Порядок сортировки параметра автомобиля.
  @override
  @JsonKey(name: 'sortOrder')
  final int? sortOrder;

  @override
  String toString() {
    return 'CarParameter(idx: $idx, key: $key, name: $name, value: $value, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarParameterImpl &&
            (identical(other.idx, idx) || other.idx == idx) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, idx, key, name, value, sortOrder);

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarParameterImplCopyWith<_$CarParameterImpl> get copyWith =>
      __$$CarParameterImplCopyWithImpl<_$CarParameterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarParameterImplToJson(
      this,
    );
  }
}

abstract class _CarParameter implements CarParameter {
  factory _CarParameter(
      {@JsonKey(name: 'idx') final String? idx,
      @JsonKey(name: 'key') final String? key,
      @JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'value') final String? value,
      @JsonKey(name: 'sortOrder') final int? sortOrder}) = _$CarParameterImpl;

  factory _CarParameter.fromJson(Map<String, dynamic> json) =
      _$CarParameterImpl.fromJson;

  /// Hash ID параметра автомобиля.
  @override
  @JsonKey(name: 'idx')
  String? get idx;

  /// Ключ параметра автомобиля.
  @override
  @JsonKey(name: 'key')
  String? get key;

  /// Название параметра автомобиля.
  @override
  @JsonKey(name: 'name')
  String? get name;

  /// Значение параметра автомобиля.
  @override
  @JsonKey(name: 'value')
  String? get value;

  /// Порядок сортировки параметра автомобиля.
  @override
  @JsonKey(name: 'sortOrder')
  int? get sortOrder;

  /// Create a copy of CarParameter
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarParameterImplCopyWith<_$CarParameterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\car_parameter.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_parameter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CarParameterImpl _$$CarParameterImplFromJson(Map<String, dynamic> json) =>
    _$CarParameterImpl(
      idx: json['idx'] as String?,
      key: json['key'] as String?,
      name: json['name'] as String?,
      value: json['value'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CarParameterImplToJson(_$CarParameterImpl instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'key': instance.key,
      'name': instance.name,
      'value': instance.value,
      'sortOrder': instance.sortOrder,
    };

```

## lib\features\parts_catalog\models\car_parameter_idx.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_parameter_idx.freezed.dart';
part 'car_parameter_idx.g.dart';

/// {@template car_parameter_idx}
/// Модель данных для индекса параметра автомобиля.
/// {@endtemplate}
@freezed
class CarParameterIdx with _$CarParameterIdx {
  /// {@macro car_parameter_idx}
  factory CarParameterIdx({
    /// Индекс параметра автомобиля.
    @JsonKey(name: 'idx') String? idx,
  }) = _CarParameterIdx;

  /// Преобразует JSON в объект [CarParameterIdx].
  factory CarParameterIdx.fromJson(Map<String, dynamic> json) =>
      _$CarParameterIdxFromJson(json);
}

```

## lib\features\parts_catalog\models\car_parameter_idx.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_parameter_idx.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CarParameterIdx _$CarParameterIdxFromJson(Map<String, dynamic> json) {
  return _CarParameterIdx.fromJson(json);
}

/// @nodoc
mixin _$CarParameterIdx {
  /// Индекс параметра автомобиля.
  @JsonKey(name: 'idx')
  String? get idx => throw _privateConstructorUsedError;

  /// Serializes this CarParameterIdx to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarParameterIdx
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarParameterIdxCopyWith<CarParameterIdx> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarParameterIdxCopyWith<$Res> {
  factory $CarParameterIdxCopyWith(
          CarParameterIdx value, $Res Function(CarParameterIdx) then) =
      _$CarParameterIdxCopyWithImpl<$Res, CarParameterIdx>;
  @useResult
  $Res call({@JsonKey(name: 'idx') String? idx});
}

/// @nodoc
class _$CarParameterIdxCopyWithImpl<$Res, $Val extends CarParameterIdx>
    implements $CarParameterIdxCopyWith<$Res> {
  _$CarParameterIdxCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarParameterIdx
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = freezed,
  }) {
    return _then(_value.copyWith(
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CarParameterIdxImplCopyWith<$Res>
    implements $CarParameterIdxCopyWith<$Res> {
  factory _$$CarParameterIdxImplCopyWith(_$CarParameterIdxImpl value,
          $Res Function(_$CarParameterIdxImpl) then) =
      __$$CarParameterIdxImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'idx') String? idx});
}

/// @nodoc
class __$$CarParameterIdxImplCopyWithImpl<$Res>
    extends _$CarParameterIdxCopyWithImpl<$Res, _$CarParameterIdxImpl>
    implements _$$CarParameterIdxImplCopyWith<$Res> {
  __$$CarParameterIdxImplCopyWithImpl(
      _$CarParameterIdxImpl _value, $Res Function(_$CarParameterIdxImpl) _then)
      : super(_value, _then);

  /// Create a copy of CarParameterIdx
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idx = freezed,
  }) {
    return _then(_$CarParameterIdxImpl(
      idx: freezed == idx
          ? _value.idx
          : idx // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarParameterIdxImpl implements _CarParameterIdx {
  _$CarParameterIdxImpl({@JsonKey(name: 'idx') this.idx});

  factory _$CarParameterIdxImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarParameterIdxImplFromJson(json);

  /// Индекс параметра автомобиля.
  @override
  @JsonKey(name: 'idx')
  final String? idx;

  @override
  String toString() {
    return 'CarParameterIdx(idx: $idx)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarParameterIdxImpl &&
            (identical(other.idx, idx) || other.idx == idx));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, idx);

  /// Create a copy of CarParameterIdx
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarParameterIdxImplCopyWith<_$CarParameterIdxImpl> get copyWith =>
      __$$CarParameterIdxImplCopyWithImpl<_$CarParameterIdxImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarParameterIdxImplToJson(
      this,
    );
  }
}

abstract class _CarParameterIdx implements CarParameterIdx {
  factory _CarParameterIdx({@JsonKey(name: 'idx') final String? idx}) =
      _$CarParameterIdxImpl;

  factory _CarParameterIdx.fromJson(Map<String, dynamic> json) =
      _$CarParameterIdxImpl.fromJson;

  /// Индекс параметра автомобиля.
  @override
  @JsonKey(name: 'idx')
  String? get idx;

  /// Create a copy of CarParameterIdx
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarParameterIdxImplCopyWith<_$CarParameterIdxImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\car_parameter_idx.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_parameter_idx.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CarParameterIdxImpl _$$CarParameterIdxImplFromJson(
        Map<String, dynamic> json) =>
    _$CarParameterIdxImpl(
      idx: json['idx'] as String?,
    );

Map<String, dynamic> _$$CarParameterIdxImplToJson(
        _$CarParameterIdxImpl instance) =>
    <String, dynamic>{
      'idx': instance.idx,
    };

```

## lib\features\parts_catalog\models\car_parameter_info.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_parameter_info.freezed.dart';
part 'car_parameter_info.g.dart';

/// {@template car_parameter_info}
/// Модель данных для информации о параметре автомобиля.
/// {@endtemplate}
@freezed
class CarParameterInfo with _$CarParameterInfo {
  /// {@macro car_parameter_info}
  factory CarParameterInfo({
    /// Ключ параметра.
    @JsonKey(name: 'key') String? key,

    /// Название параметра.
    @JsonKey(name: 'name') String? name,

    /// Список значений параметра.
    @JsonKey(name: 'values') List<CarFilterValues>? values,

    /// Порядок сортировки параметра.
    @JsonKey(name: 'sortOrder') int? sortOrder,
  }) = _CarParameterInfo;

  /// Преобразует JSON в объект [CarParameterInfo].
  factory CarParameterInfo.fromJson(Map<String, dynamic> json) =>
      _$CarParameterInfoFromJson(json);
}

/// {@template car_filter_values}
/// Модель данных для значений фильтра автомобиля.
/// {@endtemplate}
@freezed
class CarFilterValues with _$CarFilterValues {
  /// {@macro car_filter_values}
  factory CarFilterValues({
    /// Идентификатор значения.
    @JsonKey(name: 'id') String? id,

    /// Текст значения.
    @JsonKey(name: 'text') String? text,
  }) = _CarFilterValues;

  /// Преобразует JSON в объект [CarFilterValues].
  factory CarFilterValues.fromJson(Map<String, dynamic> json) =>
      _$CarFilterValuesFromJson(json);
}

```

## lib\features\parts_catalog\models\car_parameter_info.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_parameter_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CarParameterInfo _$CarParameterInfoFromJson(Map<String, dynamic> json) {
  return _CarParameterInfo.fromJson(json);
}

/// @nodoc
mixin _$CarParameterInfo {
  /// Ключ параметра.
  @JsonKey(name: 'key')
  String? get key => throw _privateConstructorUsedError;

  /// Название параметра.
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// Список значений параметра.
  @JsonKey(name: 'values')
  List<CarFilterValues>? get values => throw _privateConstructorUsedError;

  /// Порядок сортировки параметра.
  @JsonKey(name: 'sortOrder')
  int? get sortOrder => throw _privateConstructorUsedError;

  /// Serializes this CarParameterInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarParameterInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarParameterInfoCopyWith<CarParameterInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarParameterInfoCopyWith<$Res> {
  factory $CarParameterInfoCopyWith(
          CarParameterInfo value, $Res Function(CarParameterInfo) then) =
      _$CarParameterInfoCopyWithImpl<$Res, CarParameterInfo>;
  @useResult
  $Res call(
      {@JsonKey(name: 'key') String? key,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'values') List<CarFilterValues>? values,
      @JsonKey(name: 'sortOrder') int? sortOrder});
}

/// @nodoc
class _$CarParameterInfoCopyWithImpl<$Res, $Val extends CarParameterInfo>
    implements $CarParameterInfoCopyWith<$Res> {
  _$CarParameterInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarParameterInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? name = freezed,
    Object? values = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_value.copyWith(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      values: freezed == values
          ? _value.values
          : values // ignore: cast_nullable_to_non_nullable
              as List<CarFilterValues>?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CarParameterInfoImplCopyWith<$Res>
    implements $CarParameterInfoCopyWith<$Res> {
  factory _$$CarParameterInfoImplCopyWith(_$CarParameterInfoImpl value,
          $Res Function(_$CarParameterInfoImpl) then) =
      __$$CarParameterInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'key') String? key,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'values') List<CarFilterValues>? values,
      @JsonKey(name: 'sortOrder') int? sortOrder});
}

/// @nodoc
class __$$CarParameterInfoImplCopyWithImpl<$Res>
    extends _$CarParameterInfoCopyWithImpl<$Res, _$CarParameterInfoImpl>
    implements _$$CarParameterInfoImplCopyWith<$Res> {
  __$$CarParameterInfoImplCopyWithImpl(_$CarParameterInfoImpl _value,
      $Res Function(_$CarParameterInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CarParameterInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = freezed,
    Object? name = freezed,
    Object? values = freezed,
    Object? sortOrder = freezed,
  }) {
    return _then(_$CarParameterInfoImpl(
      key: freezed == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      values: freezed == values
          ? _value._values
          : values // ignore: cast_nullable_to_non_nullable
              as List<CarFilterValues>?,
      sortOrder: freezed == sortOrder
          ? _value.sortOrder
          : sortOrder // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarParameterInfoImpl implements _CarParameterInfo {
  _$CarParameterInfoImpl(
      {@JsonKey(name: 'key') this.key,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'values') final List<CarFilterValues>? values,
      @JsonKey(name: 'sortOrder') this.sortOrder})
      : _values = values;

  factory _$CarParameterInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarParameterInfoImplFromJson(json);

  /// Ключ параметра.
  @override
  @JsonKey(name: 'key')
  final String? key;

  /// Название параметра.
  @override
  @JsonKey(name: 'name')
  final String? name;

  /// Список значений параметра.
  final List<CarFilterValues>? _values;

  /// Список значений параметра.
  @override
  @JsonKey(name: 'values')
  List<CarFilterValues>? get values {
    final value = _values;
    if (value == null) return null;
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Порядок сортировки параметра.
  @override
  @JsonKey(name: 'sortOrder')
  final int? sortOrder;

  @override
  String toString() {
    return 'CarParameterInfo(key: $key, name: $name, values: $values, sortOrder: $sortOrder)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarParameterInfoImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._values, _values) &&
            (identical(other.sortOrder, sortOrder) ||
                other.sortOrder == sortOrder));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, name,
      const DeepCollectionEquality().hash(_values), sortOrder);

  /// Create a copy of CarParameterInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarParameterInfoImplCopyWith<_$CarParameterInfoImpl> get copyWith =>
      __$$CarParameterInfoImplCopyWithImpl<_$CarParameterInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarParameterInfoImplToJson(
      this,
    );
  }
}

abstract class _CarParameterInfo implements CarParameterInfo {
  factory _CarParameterInfo(
          {@JsonKey(name: 'key') final String? key,
          @JsonKey(name: 'name') final String? name,
          @JsonKey(name: 'values') final List<CarFilterValues>? values,
          @JsonKey(name: 'sortOrder') final int? sortOrder}) =
      _$CarParameterInfoImpl;

  factory _CarParameterInfo.fromJson(Map<String, dynamic> json) =
      _$CarParameterInfoImpl.fromJson;

  /// Ключ параметра.
  @override
  @JsonKey(name: 'key')
  String? get key;

  /// Название параметра.
  @override
  @JsonKey(name: 'name')
  String? get name;

  /// Список значений параметра.
  @override
  @JsonKey(name: 'values')
  List<CarFilterValues>? get values;

  /// Порядок сортировки параметра.
  @override
  @JsonKey(name: 'sortOrder')
  int? get sortOrder;

  /// Create a copy of CarParameterInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarParameterInfoImplCopyWith<_$CarParameterInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CarFilterValues _$CarFilterValuesFromJson(Map<String, dynamic> json) {
  return _CarFilterValues.fromJson(json);
}

/// @nodoc
mixin _$CarFilterValues {
  /// Идентификатор значения.
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;

  /// Текст значения.
  @JsonKey(name: 'text')
  String? get text => throw _privateConstructorUsedError;

  /// Serializes this CarFilterValues to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarFilterValues
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarFilterValuesCopyWith<CarFilterValues> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarFilterValuesCopyWith<$Res> {
  factory $CarFilterValuesCopyWith(
          CarFilterValues value, $Res Function(CarFilterValues) then) =
      _$CarFilterValuesCopyWithImpl<$Res, CarFilterValues>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id, @JsonKey(name: 'text') String? text});
}

/// @nodoc
class _$CarFilterValuesCopyWithImpl<$Res, $Val extends CarFilterValues>
    implements $CarFilterValuesCopyWith<$Res> {
  _$CarFilterValuesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarFilterValues
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? text = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CarFilterValuesImplCopyWith<$Res>
    implements $CarFilterValuesCopyWith<$Res> {
  factory _$$CarFilterValuesImplCopyWith(_$CarFilterValuesImpl value,
          $Res Function(_$CarFilterValuesImpl) then) =
      __$$CarFilterValuesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id, @JsonKey(name: 'text') String? text});
}

/// @nodoc
class __$$CarFilterValuesImplCopyWithImpl<$Res>
    extends _$CarFilterValuesCopyWithImpl<$Res, _$CarFilterValuesImpl>
    implements _$$CarFilterValuesImplCopyWith<$Res> {
  __$$CarFilterValuesImplCopyWithImpl(
      _$CarFilterValuesImpl _value, $Res Function(_$CarFilterValuesImpl) _then)
      : super(_value, _then);

  /// Create a copy of CarFilterValues
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? text = freezed,
  }) {
    return _then(_$CarFilterValuesImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      text: freezed == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CarFilterValuesImpl implements _CarFilterValues {
  _$CarFilterValuesImpl(
      {@JsonKey(name: 'id') this.id, @JsonKey(name: 'text') this.text});

  factory _$CarFilterValuesImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarFilterValuesImplFromJson(json);

  /// Идентификатор значения.
  @override
  @JsonKey(name: 'id')
  final String? id;

  /// Текст значения.
  @override
  @JsonKey(name: 'text')
  final String? text;

  @override
  String toString() {
    return 'CarFilterValues(id: $id, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarFilterValuesImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text);

  /// Create a copy of CarFilterValues
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarFilterValuesImplCopyWith<_$CarFilterValuesImpl> get copyWith =>
      __$$CarFilterValuesImplCopyWithImpl<_$CarFilterValuesImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarFilterValuesImplToJson(
      this,
    );
  }
}

abstract class _CarFilterValues implements CarFilterValues {
  factory _CarFilterValues(
      {@JsonKey(name: 'id') final String? id,
      @JsonKey(name: 'text') final String? text}) = _$CarFilterValuesImpl;

  factory _CarFilterValues.fromJson(Map<String, dynamic> json) =
      _$CarFilterValuesImpl.fromJson;

  /// Идентификатор значения.
  @override
  @JsonKey(name: 'id')
  String? get id;

  /// Текст значения.
  @override
  @JsonKey(name: 'text')
  String? get text;

  /// Create a copy of CarFilterValues
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarFilterValuesImplCopyWith<_$CarFilterValuesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\car_parameter_info.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_parameter_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CarParameterInfoImpl _$$CarParameterInfoImplFromJson(
        Map<String, dynamic> json) =>
    _$CarParameterInfoImpl(
      key: json['key'] as String?,
      name: json['name'] as String?,
      values: (json['values'] as List<dynamic>?)
          ?.map((e) => CarFilterValues.fromJson(e as Map<String, dynamic>))
          .toList(),
      sortOrder: (json['sortOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$CarParameterInfoImplToJson(
        _$CarParameterInfoImpl instance) =>
    <String, dynamic>{
      'key': instance.key,
      'name': instance.name,
      'values': instance.values,
      'sortOrder': instance.sortOrder,
    };

_$CarFilterValuesImpl _$$CarFilterValuesImplFromJson(
        Map<String, dynamic> json) =>
    _$CarFilterValuesImpl(
      id: json['id'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$$CarFilterValuesImplToJson(
        _$CarFilterValuesImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
    };

```

## lib\features\parts_catalog\models\catalog.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'catalog.freezed.dart';
part 'catalog.g.dart';

/// {@template catalog}
/// Модель данных для каталога.
/// {@endtemplate}
@freezed
class Catalog with _$Catalog {
  /// {@macro catalog}
  factory Catalog({
    /// Идентификатор каталога.
    @JsonKey(name: 'id') required String id,

    /// Название каталога.
    @JsonKey(name: 'name') required String name,

    /// Количество моделей в каталоге.
    @JsonKey(name: 'models_count') required int modelsCount,
  }) = _Catalog;

  /// Преобразует JSON в объект [Catalog].
  factory Catalog.fromJson(Map<String, dynamic> json) =>
      _$CatalogFromJson(json);
}

```

## lib\features\parts_catalog\models\catalog.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'catalog.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Catalog _$CatalogFromJson(Map<String, dynamic> json) {
  return _Catalog.fromJson(json);
}

/// @nodoc
mixin _$Catalog {
  /// Идентификатор каталога.
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  /// Название каталога.
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// Количество моделей в каталоге.
  @JsonKey(name: 'models_count')
  int get modelsCount => throw _privateConstructorUsedError;

  /// Serializes this Catalog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Catalog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CatalogCopyWith<Catalog> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CatalogCopyWith<$Res> {
  factory $CatalogCopyWith(Catalog value, $Res Function(Catalog) then) =
      _$CatalogCopyWithImpl<$Res, Catalog>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'models_count') int modelsCount});
}

/// @nodoc
class _$CatalogCopyWithImpl<$Res, $Val extends Catalog>
    implements $CatalogCopyWith<$Res> {
  _$CatalogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Catalog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? modelsCount = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      modelsCount: null == modelsCount
          ? _value.modelsCount
          : modelsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CatalogImplCopyWith<$Res> implements $CatalogCopyWith<$Res> {
  factory _$$CatalogImplCopyWith(
          _$CatalogImpl value, $Res Function(_$CatalogImpl) then) =
      __$$CatalogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'models_count') int modelsCount});
}

/// @nodoc
class __$$CatalogImplCopyWithImpl<$Res>
    extends _$CatalogCopyWithImpl<$Res, _$CatalogImpl>
    implements _$$CatalogImplCopyWith<$Res> {
  __$$CatalogImplCopyWithImpl(
      _$CatalogImpl _value, $Res Function(_$CatalogImpl) _then)
      : super(_value, _then);

  /// Create a copy of Catalog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? modelsCount = null,
  }) {
    return _then(_$CatalogImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      modelsCount: null == modelsCount
          ? _value.modelsCount
          : modelsCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CatalogImpl implements _Catalog {
  _$CatalogImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'models_count') required this.modelsCount});

  factory _$CatalogImpl.fromJson(Map<String, dynamic> json) =>
      _$$CatalogImplFromJson(json);

  /// Идентификатор каталога.
  @override
  @JsonKey(name: 'id')
  final String id;

  /// Название каталога.
  @override
  @JsonKey(name: 'name')
  final String name;

  /// Количество моделей в каталоге.
  @override
  @JsonKey(name: 'models_count')
  final int modelsCount;

  @override
  String toString() {
    return 'Catalog(id: $id, name: $name, modelsCount: $modelsCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CatalogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.modelsCount, modelsCount) ||
                other.modelsCount == modelsCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, modelsCount);

  /// Create a copy of Catalog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CatalogImplCopyWith<_$CatalogImpl> get copyWith =>
      __$$CatalogImplCopyWithImpl<_$CatalogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CatalogImplToJson(
      this,
    );
  }
}

abstract class _Catalog implements Catalog {
  factory _Catalog(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'models_count') required final int modelsCount}) =
      _$CatalogImpl;

  factory _Catalog.fromJson(Map<String, dynamic> json) = _$CatalogImpl.fromJson;

  /// Идентификатор каталога.
  @override
  @JsonKey(name: 'id')
  String get id;

  /// Название каталога.
  @override
  @JsonKey(name: 'name')
  String get name;

  /// Количество моделей в каталоге.
  @override
  @JsonKey(name: 'models_count')
  int get modelsCount;

  /// Create a copy of Catalog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CatalogImplCopyWith<_$CatalogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\catalog.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CatalogImpl _$$CatalogImplFromJson(Map<String, dynamic> json) =>
    _$CatalogImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      modelsCount: (json['models_count'] as num).toInt(),
    );

Map<String, dynamic> _$$CatalogImplToJson(_$CatalogImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'models_count': instance.modelsCount,
    };

```

## lib\features\parts_catalog\models\error.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'error.freezed.dart';
part 'error.g.dart';

/// {@template error}
/// Модель данных для ошибки.
/// {@endtemplate}
@freezed
class Error with _$Error {
  /// {@macro error}
  factory Error({
    /// Код ошибки.
    @JsonKey(name: 'code') int? code,

    /// Код ошибки (строковый).
    @JsonKey(name: 'errorCode') String? errorCode,

    /// Сообщение об ошибке.
    @JsonKey(name: 'message') String? message,
  }) = _Error;

  /// Преобразует JSON в объект [Error].
  factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);
}

```

## lib\features\parts_catalog\models\error.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Error _$ErrorFromJson(Map<String, dynamic> json) {
  return _Error.fromJson(json);
}

/// @nodoc
mixin _$Error {
  /// Код ошибки.
  @JsonKey(name: 'code')
  int? get code => throw _privateConstructorUsedError;

  /// Код ошибки (строковый).
  @JsonKey(name: 'errorCode')
  String? get errorCode => throw _privateConstructorUsedError;

  /// Сообщение об ошибке.
  @JsonKey(name: 'message')
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this Error to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ErrorCopyWith<Error> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ErrorCopyWith<$Res> {
  factory $ErrorCopyWith(Error value, $Res Function(Error) then) =
      _$ErrorCopyWithImpl<$Res, Error>;
  @useResult
  $Res call(
      {@JsonKey(name: 'code') int? code,
      @JsonKey(name: 'errorCode') String? errorCode,
      @JsonKey(name: 'message') String? message});
}

/// @nodoc
class _$ErrorCopyWithImpl<$Res, $Val extends Error>
    implements $ErrorCopyWith<$Res> {
  _$ErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? errorCode = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> implements $ErrorCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'code') int? code,
      @JsonKey(name: 'errorCode') String? errorCode,
      @JsonKey(name: 'message') String? message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$ErrorCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? errorCode = freezed,
    Object? message = freezed,
  }) {
    return _then(_$ErrorImpl(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ErrorImpl implements _Error {
  _$ErrorImpl(
      {@JsonKey(name: 'code') this.code,
      @JsonKey(name: 'errorCode') this.errorCode,
      @JsonKey(name: 'message') this.message});

  factory _$ErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$ErrorImplFromJson(json);

  /// Код ошибки.
  @override
  @JsonKey(name: 'code')
  final int? code;

  /// Код ошибки (строковый).
  @override
  @JsonKey(name: 'errorCode')
  final String? errorCode;

  /// Сообщение об ошибке.
  @override
  @JsonKey(name: 'message')
  final String? message;

  @override
  String toString() {
    return 'Error(code: $code, errorCode: $errorCode, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, errorCode, message);

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ErrorImplToJson(
      this,
    );
  }
}

abstract class _Error implements Error {
  factory _Error(
      {@JsonKey(name: 'code') final int? code,
      @JsonKey(name: 'errorCode') final String? errorCode,
      @JsonKey(name: 'message') final String? message}) = _$ErrorImpl;

  factory _Error.fromJson(Map<String, dynamic> json) = _$ErrorImpl.fromJson;

  /// Код ошибки.
  @override
  @JsonKey(name: 'code')
  int? get code;

  /// Код ошибки (строковый).
  @override
  @JsonKey(name: 'errorCode')
  String? get errorCode;

  /// Сообщение об ошибке.
  @override
  @JsonKey(name: 'message')
  String? get message;

  /// Create a copy of Error
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\error.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ErrorImpl _$$ErrorImplFromJson(Map<String, dynamic> json) => _$ErrorImpl(
      code: (json['code'] as num?)?.toInt(),
      errorCode: json['errorCode'] as String?,
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$ErrorImplToJson(_$ErrorImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'errorCode': instance.errorCode,
      'message': instance.message,
    };

```

## lib\features\parts_catalog\models\example_prices_response.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'example_prices_response.freezed.dart';
part 'example_prices_response.g.dart';

/// {@template example_prices_response}
/// Модель данных для ответа с примером цен.
/// {@endtemplate}
@freezed
class ExamplePricesResponse with _$ExamplePricesResponse {
  /// {@macro example_prices_response}
  factory ExamplePricesResponse({
    /// Идентификатор.
    @JsonKey(name: 'id') String? id,

    /// Название.
    @JsonKey(name: 'title') String? title,

    /// Код.
    @JsonKey(name: 'code') String? code,

    /// Бренд.
    @JsonKey(name: 'brand') String? brand,

    /// Цена.
    @JsonKey(name: 'price') String? price,

    /// Количество в корзине.
    @JsonKey(name: 'basketQty') String? basketQty,

    /// Количество в наличии.
    @JsonKey(name: 'inStockQty') String? inStockQty,

    /// Рейтинг.
    @JsonKey(name: 'rating') String? rating,

    /// Доставка.
    @JsonKey(name: 'delivery') String? delivery,

    /// Полезная нагрузка (payload).
    @JsonKey(name: 'payload') Map<String, String>? payload,
  }) = _ExamplePricesResponse;

  /// Преобразует JSON в объект [ExamplePricesResponse].
  factory ExamplePricesResponse.fromJson(Map<String, dynamic> json) =>
      _$ExamplePricesResponseFromJson(json);
}

```

## lib\features\parts_catalog\models\example_prices_response.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_prices_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ExamplePricesResponse _$ExamplePricesResponseFromJson(
    Map<String, dynamic> json) {
  return _ExamplePricesResponse.fromJson(json);
}

/// @nodoc
mixin _$ExamplePricesResponse {
  /// Идентификатор.
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;

  /// Название.
  @JsonKey(name: 'title')
  String? get title => throw _privateConstructorUsedError;

  /// Код.
  @JsonKey(name: 'code')
  String? get code => throw _privateConstructorUsedError;

  /// Бренд.
  @JsonKey(name: 'brand')
  String? get brand => throw _privateConstructorUsedError;

  /// Цена.
  @JsonKey(name: 'price')
  String? get price => throw _privateConstructorUsedError;

  /// Количество в корзине.
  @JsonKey(name: 'basketQty')
  String? get basketQty => throw _privateConstructorUsedError;

  /// Количество в наличии.
  @JsonKey(name: 'inStockQty')
  String? get inStockQty => throw _privateConstructorUsedError;

  /// Рейтинг.
  @JsonKey(name: 'rating')
  String? get rating => throw _privateConstructorUsedError;

  /// Доставка.
  @JsonKey(name: 'delivery')
  String? get delivery => throw _privateConstructorUsedError;

  /// Полезная нагрузка (payload).
  @JsonKey(name: 'payload')
  Map<String, String>? get payload => throw _privateConstructorUsedError;

  /// Serializes this ExamplePricesResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExamplePricesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExamplePricesResponseCopyWith<ExamplePricesResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExamplePricesResponseCopyWith<$Res> {
  factory $ExamplePricesResponseCopyWith(ExamplePricesResponse value,
          $Res Function(ExamplePricesResponse) then) =
      _$ExamplePricesResponseCopyWithImpl<$Res, ExamplePricesResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'title') String? title,
      @JsonKey(name: 'code') String? code,
      @JsonKey(name: 'brand') String? brand,
      @JsonKey(name: 'price') String? price,
      @JsonKey(name: 'basketQty') String? basketQty,
      @JsonKey(name: 'inStockQty') String? inStockQty,
      @JsonKey(name: 'rating') String? rating,
      @JsonKey(name: 'delivery') String? delivery,
      @JsonKey(name: 'payload') Map<String, String>? payload});
}

/// @nodoc
class _$ExamplePricesResponseCopyWithImpl<$Res,
        $Val extends ExamplePricesResponse>
    implements $ExamplePricesResponseCopyWith<$Res> {
  _$ExamplePricesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExamplePricesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? code = freezed,
    Object? brand = freezed,
    Object? price = freezed,
    Object? basketQty = freezed,
    Object? inStockQty = freezed,
    Object? rating = freezed,
    Object? delivery = freezed,
    Object? payload = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String?,
      basketQty: freezed == basketQty
          ? _value.basketQty
          : basketQty // ignore: cast_nullable_to_non_nullable
              as String?,
      inStockQty: freezed == inStockQty
          ? _value.inStockQty
          : inStockQty // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as String?,
      delivery: freezed == delivery
          ? _value.delivery
          : delivery // ignore: cast_nullable_to_non_nullable
              as String?,
      payload: freezed == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExamplePricesResponseImplCopyWith<$Res>
    implements $ExamplePricesResponseCopyWith<$Res> {
  factory _$$ExamplePricesResponseImplCopyWith(
          _$ExamplePricesResponseImpl value,
          $Res Function(_$ExamplePricesResponseImpl) then) =
      __$$ExamplePricesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'title') String? title,
      @JsonKey(name: 'code') String? code,
      @JsonKey(name: 'brand') String? brand,
      @JsonKey(name: 'price') String? price,
      @JsonKey(name: 'basketQty') String? basketQty,
      @JsonKey(name: 'inStockQty') String? inStockQty,
      @JsonKey(name: 'rating') String? rating,
      @JsonKey(name: 'delivery') String? delivery,
      @JsonKey(name: 'payload') Map<String, String>? payload});
}

/// @nodoc
class __$$ExamplePricesResponseImplCopyWithImpl<$Res>
    extends _$ExamplePricesResponseCopyWithImpl<$Res,
        _$ExamplePricesResponseImpl>
    implements _$$ExamplePricesResponseImplCopyWith<$Res> {
  __$$ExamplePricesResponseImplCopyWithImpl(_$ExamplePricesResponseImpl _value,
      $Res Function(_$ExamplePricesResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExamplePricesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? title = freezed,
    Object? code = freezed,
    Object? brand = freezed,
    Object? price = freezed,
    Object? basketQty = freezed,
    Object? inStockQty = freezed,
    Object? rating = freezed,
    Object? delivery = freezed,
    Object? payload = freezed,
  }) {
    return _then(_$ExamplePricesResponseImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String?,
      basketQty: freezed == basketQty
          ? _value.basketQty
          : basketQty // ignore: cast_nullable_to_non_nullable
              as String?,
      inStockQty: freezed == inStockQty
          ? _value.inStockQty
          : inStockQty // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as String?,
      delivery: freezed == delivery
          ? _value.delivery
          : delivery // ignore: cast_nullable_to_non_nullable
              as String?,
      payload: freezed == payload
          ? _value._payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ExamplePricesResponseImpl implements _ExamplePricesResponse {
  _$ExamplePricesResponseImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'title') this.title,
      @JsonKey(name: 'code') this.code,
      @JsonKey(name: 'brand') this.brand,
      @JsonKey(name: 'price') this.price,
      @JsonKey(name: 'basketQty') this.basketQty,
      @JsonKey(name: 'inStockQty') this.inStockQty,
      @JsonKey(name: 'rating') this.rating,
      @JsonKey(name: 'delivery') this.delivery,
      @JsonKey(name: 'payload') final Map<String, String>? payload})
      : _payload = payload;

  factory _$ExamplePricesResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExamplePricesResponseImplFromJson(json);

  /// Идентификатор.
  @override
  @JsonKey(name: 'id')
  final String? id;

  /// Название.
  @override
  @JsonKey(name: 'title')
  final String? title;

  /// Код.
  @override
  @JsonKey(name: 'code')
  final String? code;

  /// Бренд.
  @override
  @JsonKey(name: 'brand')
  final String? brand;

  /// Цена.
  @override
  @JsonKey(name: 'price')
  final String? price;

  /// Количество в корзине.
  @override
  @JsonKey(name: 'basketQty')
  final String? basketQty;

  /// Количество в наличии.
  @override
  @JsonKey(name: 'inStockQty')
  final String? inStockQty;

  /// Рейтинг.
  @override
  @JsonKey(name: 'rating')
  final String? rating;

  /// Доставка.
  @override
  @JsonKey(name: 'delivery')
  final String? delivery;

  /// Полезная нагрузка (payload).
  final Map<String, String>? _payload;

  /// Полезная нагрузка (payload).
  @override
  @JsonKey(name: 'payload')
  Map<String, String>? get payload {
    final value = _payload;
    if (value == null) return null;
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ExamplePricesResponse(id: $id, title: $title, code: $code, brand: $brand, price: $price, basketQty: $basketQty, inStockQty: $inStockQty, rating: $rating, delivery: $delivery, payload: $payload)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExamplePricesResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.basketQty, basketQty) ||
                other.basketQty == basketQty) &&
            (identical(other.inStockQty, inStockQty) ||
                other.inStockQty == inStockQty) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.delivery, delivery) ||
                other.delivery == delivery) &&
            const DeepCollectionEquality().equals(other._payload, _payload));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      code,
      brand,
      price,
      basketQty,
      inStockQty,
      rating,
      delivery,
      const DeepCollectionEquality().hash(_payload));

  /// Create a copy of ExamplePricesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExamplePricesResponseImplCopyWith<_$ExamplePricesResponseImpl>
      get copyWith => __$$ExamplePricesResponseImplCopyWithImpl<
          _$ExamplePricesResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExamplePricesResponseImplToJson(
      this,
    );
  }
}

abstract class _ExamplePricesResponse implements ExamplePricesResponse {
  factory _ExamplePricesResponse(
          {@JsonKey(name: 'id') final String? id,
          @JsonKey(name: 'title') final String? title,
          @JsonKey(name: 'code') final String? code,
          @JsonKey(name: 'brand') final String? brand,
          @JsonKey(name: 'price') final String? price,
          @JsonKey(name: 'basketQty') final String? basketQty,
          @JsonKey(name: 'inStockQty') final String? inStockQty,
          @JsonKey(name: 'rating') final String? rating,
          @JsonKey(name: 'delivery') final String? delivery,
          @JsonKey(name: 'payload') final Map<String, String>? payload}) =
      _$ExamplePricesResponseImpl;

  factory _ExamplePricesResponse.fromJson(Map<String, dynamic> json) =
      _$ExamplePricesResponseImpl.fromJson;

  /// Идентификатор.
  @override
  @JsonKey(name: 'id')
  String? get id;

  /// Название.
  @override
  @JsonKey(name: 'title')
  String? get title;

  /// Код.
  @override
  @JsonKey(name: 'code')
  String? get code;

  /// Бренд.
  @override
  @JsonKey(name: 'brand')
  String? get brand;

  /// Цена.
  @override
  @JsonKey(name: 'price')
  String? get price;

  /// Количество в корзине.
  @override
  @JsonKey(name: 'basketQty')
  String? get basketQty;

  /// Количество в наличии.
  @override
  @JsonKey(name: 'inStockQty')
  String? get inStockQty;

  /// Рейтинг.
  @override
  @JsonKey(name: 'rating')
  String? get rating;

  /// Доставка.
  @override
  @JsonKey(name: 'delivery')
  String? get delivery;

  /// Полезная нагрузка (payload).
  @override
  @JsonKey(name: 'payload')
  Map<String, String>? get payload;

  /// Create a copy of ExamplePricesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExamplePricesResponseImplCopyWith<_$ExamplePricesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\example_prices_response.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_prices_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExamplePricesResponseImpl _$$ExamplePricesResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ExamplePricesResponseImpl(
      id: json['id'] as String?,
      title: json['title'] as String?,
      code: json['code'] as String?,
      brand: json['brand'] as String?,
      price: json['price'] as String?,
      basketQty: json['basketQty'] as String?,
      inStockQty: json['inStockQty'] as String?,
      rating: json['rating'] as String?,
      delivery: json['delivery'] as String?,
      payload: (json['payload'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$$ExamplePricesResponseImplToJson(
        _$ExamplePricesResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'code': instance.code,
      'brand': instance.brand,
      'price': instance.price,
      'basketQty': instance.basketQty,
      'inStockQty': instance.inStockQty,
      'rating': instance.rating,
      'delivery': instance.delivery,
      'payload': instance.payload,
    };

```

## lib\features\parts_catalog\models\group.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'group.freezed.dart';
part 'group.g.dart';

/// {@template group}
/// Модель данных для группы.
/// {@endtemplate}
@freezed
class Group with _$Group {
  /// {@macro group}
  factory Group({
    /// Идентификатор группы.
    @JsonKey(name: 'id') required String id,

    /// Идентификатор родительской группы (может быть null).
    @JsonKey(name: 'parentId') String? parentId,

    /// Признак наличия подгрупп.
    @JsonKey(name: 'hasSubgroups') bool? hasSubgroups,

    /// Признак наличия деталей в группе.
    @JsonKey(name: 'hasParts') bool? hasParts,

    /// Название группы.
    @JsonKey(name: 'name') required String name,

    /// Изображение группы.
    @JsonKey(name: 'img') String? img,

    /// Описание группы.
    @JsonKey(name: 'description') String? description,
  }) = _Group;

  /// Преобразует JSON в объект [Group].
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}

```

## lib\features\parts_catalog\models\group.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Group _$GroupFromJson(Map<String, dynamic> json) {
  return _Group.fromJson(json);
}

/// @nodoc
mixin _$Group {
  /// Идентификатор группы.
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  /// Идентификатор родительской группы (может быть null).
  @JsonKey(name: 'parentId')
  String? get parentId => throw _privateConstructorUsedError;

  /// Признак наличия подгрупп.
  @JsonKey(name: 'hasSubgroups')
  bool? get hasSubgroups => throw _privateConstructorUsedError;

  /// Признак наличия деталей в группе.
  @JsonKey(name: 'hasParts')
  bool? get hasParts => throw _privateConstructorUsedError;

  /// Название группы.
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// Изображение группы.
  @JsonKey(name: 'img')
  String? get img => throw _privateConstructorUsedError;

  /// Описание группы.
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this Group to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupCopyWith<Group> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupCopyWith<$Res> {
  factory $GroupCopyWith(Group value, $Res Function(Group) then) =
      _$GroupCopyWithImpl<$Res, Group>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'parentId') String? parentId,
      @JsonKey(name: 'hasSubgroups') bool? hasSubgroups,
      @JsonKey(name: 'hasParts') bool? hasParts,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'img') String? img,
      @JsonKey(name: 'description') String? description});
}

/// @nodoc
class _$GroupCopyWithImpl<$Res, $Val extends Group>
    implements $GroupCopyWith<$Res> {
  _$GroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = freezed,
    Object? hasSubgroups = freezed,
    Object? hasParts = freezed,
    Object? name = null,
    Object? img = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      hasSubgroups: freezed == hasSubgroups
          ? _value.hasSubgroups
          : hasSubgroups // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasParts: freezed == hasParts
          ? _value.hasParts
          : hasParts // ignore: cast_nullable_to_non_nullable
              as bool?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupImplCopyWith<$Res> implements $GroupCopyWith<$Res> {
  factory _$$GroupImplCopyWith(
          _$GroupImpl value, $Res Function(_$GroupImpl) then) =
      __$$GroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'parentId') String? parentId,
      @JsonKey(name: 'hasSubgroups') bool? hasSubgroups,
      @JsonKey(name: 'hasParts') bool? hasParts,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'img') String? img,
      @JsonKey(name: 'description') String? description});
}

/// @nodoc
class __$$GroupImplCopyWithImpl<$Res>
    extends _$GroupCopyWithImpl<$Res, _$GroupImpl>
    implements _$$GroupImplCopyWith<$Res> {
  __$$GroupImplCopyWithImpl(
      _$GroupImpl _value, $Res Function(_$GroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? parentId = freezed,
    Object? hasSubgroups = freezed,
    Object? hasParts = freezed,
    Object? name = null,
    Object? img = freezed,
    Object? description = freezed,
  }) {
    return _then(_$GroupImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      hasSubgroups: freezed == hasSubgroups
          ? _value.hasSubgroups
          : hasSubgroups // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasParts: freezed == hasParts
          ? _value.hasParts
          : hasParts // ignore: cast_nullable_to_non_nullable
              as bool?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupImpl implements _Group {
  _$GroupImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'parentId') this.parentId,
      @JsonKey(name: 'hasSubgroups') this.hasSubgroups,
      @JsonKey(name: 'hasParts') this.hasParts,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'img') this.img,
      @JsonKey(name: 'description') this.description});

  factory _$GroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupImplFromJson(json);

  /// Идентификатор группы.
  @override
  @JsonKey(name: 'id')
  final String id;

  /// Идентификатор родительской группы (может быть null).
  @override
  @JsonKey(name: 'parentId')
  final String? parentId;

  /// Признак наличия подгрупп.
  @override
  @JsonKey(name: 'hasSubgroups')
  final bool? hasSubgroups;

  /// Признак наличия деталей в группе.
  @override
  @JsonKey(name: 'hasParts')
  final bool? hasParts;

  /// Название группы.
  @override
  @JsonKey(name: 'name')
  final String name;

  /// Изображение группы.
  @override
  @JsonKey(name: 'img')
  final String? img;

  /// Описание группы.
  @override
  @JsonKey(name: 'description')
  final String? description;

  @override
  String toString() {
    return 'Group(id: $id, parentId: $parentId, hasSubgroups: $hasSubgroups, hasParts: $hasParts, name: $name, img: $img, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.hasSubgroups, hasSubgroups) ||
                other.hasSubgroups == hasSubgroups) &&
            (identical(other.hasParts, hasParts) ||
                other.hasParts == hasParts) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, parentId, hasSubgroups,
      hasParts, name, img, description);

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupImplCopyWith<_$GroupImpl> get copyWith =>
      __$$GroupImplCopyWithImpl<_$GroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupImplToJson(
      this,
    );
  }
}

abstract class _Group implements Group {
  factory _Group(
      {@JsonKey(name: 'id') required final String id,
      @JsonKey(name: 'parentId') final String? parentId,
      @JsonKey(name: 'hasSubgroups') final bool? hasSubgroups,
      @JsonKey(name: 'hasParts') final bool? hasParts,
      @JsonKey(name: 'name') required final String name,
      @JsonKey(name: 'img') final String? img,
      @JsonKey(name: 'description') final String? description}) = _$GroupImpl;

  factory _Group.fromJson(Map<String, dynamic> json) = _$GroupImpl.fromJson;

  /// Идентификатор группы.
  @override
  @JsonKey(name: 'id')
  String get id;

  /// Идентификатор родительской группы (может быть null).
  @override
  @JsonKey(name: 'parentId')
  String? get parentId;

  /// Признак наличия подгрупп.
  @override
  @JsonKey(name: 'hasSubgroups')
  bool? get hasSubgroups;

  /// Признак наличия деталей в группе.
  @override
  @JsonKey(name: 'hasParts')
  bool? get hasParts;

  /// Название группы.
  @override
  @JsonKey(name: 'name')
  String get name;

  /// Изображение группы.
  @override
  @JsonKey(name: 'img')
  String? get img;

  /// Описание группы.
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// Create a copy of Group
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupImplCopyWith<_$GroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\group.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupImpl _$$GroupImplFromJson(Map<String, dynamic> json) => _$GroupImpl(
      id: json['id'] as String,
      parentId: json['parentId'] as String?,
      hasSubgroups: json['hasSubgroups'] as bool?,
      hasParts: json['hasParts'] as bool?,
      name: json['name'] as String,
      img: json['img'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$GroupImplToJson(_$GroupImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'parentId': instance.parentId,
      'hasSubgroups': instance.hasSubgroups,
      'hasParts': instance.hasParts,
      'name': instance.name,
      'img': instance.img,
      'description': instance.description,
    };

```

## lib\features\parts_catalog\models\groups_tree.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'groups_tree.freezed.dart';
part 'groups_tree.g.dart';

/// {@template groups_tree}
/// Модель данных для дерева групп.
/// {@endtemplate}
@freezed
class GroupsTree with _$GroupsTree {
  /// {@macro groups_tree}
  factory GroupsTree({
    /// Идентификатор.
    @JsonKey(name: 'id') required String id,

    /// Название.
    @JsonKey(name: 'name') required String name,

    /// Идентификатор родительской группы (может быть null).
    @JsonKey(name: 'parentId') String? parentId,

    /// Список подгрупп.
    @JsonKey(name: 'subGroups') @Default([]) List<GroupsTree> subGroups,
  }) = _GroupsTree;

  /// Преобразует JSON в объект [GroupsTree].
  factory GroupsTree.fromJson(Map<String, dynamic> json) =>
      _$GroupsTreeFromJson(json);
}

```

## lib\features\parts_catalog\models\groups_tree.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'groups_tree.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GroupsTree _$GroupsTreeFromJson(Map<String, dynamic> json) {
  return _GroupsTree.fromJson(json);
}

/// @nodoc
mixin _$GroupsTree {
  /// Идентификатор.
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  /// Название.
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// Идентификатор родительской группы (может быть null).
  @JsonKey(name: 'parentId')
  String? get parentId => throw _privateConstructorUsedError;

  /// Список подгрупп.
  @JsonKey(name: 'subGroups')
  List<GroupsTree> get subGroups => throw _privateConstructorUsedError;

  /// Serializes this GroupsTree to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupsTree
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupsTreeCopyWith<GroupsTree> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupsTreeCopyWith<$Res> {
  factory $GroupsTreeCopyWith(
          GroupsTree value, $Res Function(GroupsTree) then) =
      _$GroupsTreeCopyWithImpl<$Res, GroupsTree>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'parentId') String? parentId,
      @JsonKey(name: 'subGroups') List<GroupsTree> subGroups});
}

/// @nodoc
class _$GroupsTreeCopyWithImpl<$Res, $Val extends GroupsTree>
    implements $GroupsTreeCopyWith<$Res> {
  _$GroupsTreeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupsTree
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? parentId = freezed,
    Object? subGroups = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      subGroups: null == subGroups
          ? _value.subGroups
          : subGroups // ignore: cast_nullable_to_non_nullable
              as List<GroupsTree>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupsTreeImplCopyWith<$Res>
    implements $GroupsTreeCopyWith<$Res> {
  factory _$$GroupsTreeImplCopyWith(
          _$GroupsTreeImpl value, $Res Function(_$GroupsTreeImpl) then) =
      __$$GroupsTreeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'parentId') String? parentId,
      @JsonKey(name: 'subGroups') List<GroupsTree> subGroups});
}

/// @nodoc
class __$$GroupsTreeImplCopyWithImpl<$Res>
    extends _$GroupsTreeCopyWithImpl<$Res, _$GroupsTreeImpl>
    implements _$$GroupsTreeImplCopyWith<$Res> {
  __$$GroupsTreeImplCopyWithImpl(
      _$GroupsTreeImpl _value, $Res Function(_$GroupsTreeImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupsTree
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? parentId = freezed,
    Object? subGroups = null,
  }) {
    return _then(_$GroupsTreeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      subGroups: null == subGroups
          ? _value._subGroups
          : subGroups // ignore: cast_nullable_to_non_nullable
              as List<GroupsTree>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupsTreeImpl implements _GroupsTree {
  _$GroupsTreeImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'parentId') this.parentId,
      @JsonKey(name: 'subGroups') final List<GroupsTree> subGroups = const []})
      : _subGroups = subGroups;

  factory _$GroupsTreeImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupsTreeImplFromJson(json);

  /// Идентификатор.
  @override
  @JsonKey(name: 'id')
  final String id;

  /// Название.
  @override
  @JsonKey(name: 'name')
  final String name;

  /// Идентификатор родительской группы (может быть null).
  @override
  @JsonKey(name: 'parentId')
  final String? parentId;

  /// Список подгрупп.
  final List<GroupsTree> _subGroups;

  /// Список подгрупп.
  @override
  @JsonKey(name: 'subGroups')
  List<GroupsTree> get subGroups {
    if (_subGroups is EqualUnmodifiableListView) return _subGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_subGroups);
  }

  @override
  String toString() {
    return 'GroupsTree(id: $id, name: $name, parentId: $parentId, subGroups: $subGroups)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupsTreeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            const DeepCollectionEquality()
                .equals(other._subGroups, _subGroups));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, parentId,
      const DeepCollectionEquality().hash(_subGroups));

  /// Create a copy of GroupsTree
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupsTreeImplCopyWith<_$GroupsTreeImpl> get copyWith =>
      __$$GroupsTreeImplCopyWithImpl<_$GroupsTreeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupsTreeImplToJson(
      this,
    );
  }
}

abstract class _GroupsTree implements GroupsTree {
  factory _GroupsTree(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'parentId') final String? parentId,
          @JsonKey(name: 'subGroups') final List<GroupsTree> subGroups}) =
      _$GroupsTreeImpl;

  factory _GroupsTree.fromJson(Map<String, dynamic> json) =
      _$GroupsTreeImpl.fromJson;

  /// Идентификатор.
  @override
  @JsonKey(name: 'id')
  String get id;

  /// Название.
  @override
  @JsonKey(name: 'name')
  String get name;

  /// Идентификатор родительской группы (может быть null).
  @override
  @JsonKey(name: 'parentId')
  String? get parentId;

  /// Список подгрупп.
  @override
  @JsonKey(name: 'subGroups')
  List<GroupsTree> get subGroups;

  /// Create a copy of GroupsTree
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupsTreeImplCopyWith<_$GroupsTreeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\groups_tree.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groups_tree.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupsTreeImpl _$$GroupsTreeImplFromJson(Map<String, dynamic> json) =>
    _$GroupsTreeImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parentId'] as String?,
      subGroups: (json['subGroups'] as List<dynamic>?)
              ?.map((e) => GroupsTree.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$GroupsTreeImplToJson(_$GroupsTreeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parentId': instance.parentId,
      'subGroups': instance.subGroups,
    };

```

## lib\features\parts_catalog\models\groups_tree_response.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/features/parts_catalog/models/groups_tree.dart';

part 'groups_tree_response.freezed.dart';
part 'groups_tree_response.g.dart';

/// {@template groups_tree_response}
/// Модель данных для ответа с деревом групп.
/// {@endtemplate}
@freezed
class GroupsTreeResponse with _$GroupsTreeResponse {
  /// {@macro groups_tree_response}
  factory GroupsTreeResponse({
    /// Идентификатор.
    @JsonKey(name: 'id') required String id,

    /// Название.
    @JsonKey(name: 'name') required String name,

    /// Идентификатор родительской группы (может быть null).
    @JsonKey(name: 'parentId') String? parentId,

    /// Список подгрупп.
    @JsonKey(name: 'subGroups') List<GroupsTree>? subGroups,
  }) = _GroupsTreeResponse;

  /// Преобразует JSON в объект [GroupsTreeResponse].
  factory GroupsTreeResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupsTreeResponseFromJson(json);
}

```

## lib\features\parts_catalog\models\groups_tree_response.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'groups_tree_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GroupsTreeResponse _$GroupsTreeResponseFromJson(Map<String, dynamic> json) {
  return _GroupsTreeResponse.fromJson(json);
}

/// @nodoc
mixin _$GroupsTreeResponse {
  /// Идентификатор.
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  /// Название.
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// Идентификатор родительской группы (может быть null).
  @JsonKey(name: 'parentId')
  String? get parentId => throw _privateConstructorUsedError;

  /// Список подгрупп.
  @JsonKey(name: 'subGroups')
  List<GroupsTree>? get subGroups => throw _privateConstructorUsedError;

  /// Serializes this GroupsTreeResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GroupsTreeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GroupsTreeResponseCopyWith<GroupsTreeResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GroupsTreeResponseCopyWith<$Res> {
  factory $GroupsTreeResponseCopyWith(
          GroupsTreeResponse value, $Res Function(GroupsTreeResponse) then) =
      _$GroupsTreeResponseCopyWithImpl<$Res, GroupsTreeResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'parentId') String? parentId,
      @JsonKey(name: 'subGroups') List<GroupsTree>? subGroups});
}

/// @nodoc
class _$GroupsTreeResponseCopyWithImpl<$Res, $Val extends GroupsTreeResponse>
    implements $GroupsTreeResponseCopyWith<$Res> {
  _$GroupsTreeResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GroupsTreeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? parentId = freezed,
    Object? subGroups = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      subGroups: freezed == subGroups
          ? _value.subGroups
          : subGroups // ignore: cast_nullable_to_non_nullable
              as List<GroupsTree>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GroupsTreeResponseImplCopyWith<$Res>
    implements $GroupsTreeResponseCopyWith<$Res> {
  factory _$$GroupsTreeResponseImplCopyWith(_$GroupsTreeResponseImpl value,
          $Res Function(_$GroupsTreeResponseImpl) then) =
      __$$GroupsTreeResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'parentId') String? parentId,
      @JsonKey(name: 'subGroups') List<GroupsTree>? subGroups});
}

/// @nodoc
class __$$GroupsTreeResponseImplCopyWithImpl<$Res>
    extends _$GroupsTreeResponseCopyWithImpl<$Res, _$GroupsTreeResponseImpl>
    implements _$$GroupsTreeResponseImplCopyWith<$Res> {
  __$$GroupsTreeResponseImplCopyWithImpl(_$GroupsTreeResponseImpl _value,
      $Res Function(_$GroupsTreeResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of GroupsTreeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? parentId = freezed,
    Object? subGroups = freezed,
  }) {
    return _then(_$GroupsTreeResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      parentId: freezed == parentId
          ? _value.parentId
          : parentId // ignore: cast_nullable_to_non_nullable
              as String?,
      subGroups: freezed == subGroups
          ? _value._subGroups
          : subGroups // ignore: cast_nullable_to_non_nullable
              as List<GroupsTree>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GroupsTreeResponseImpl implements _GroupsTreeResponse {
  _$GroupsTreeResponseImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'parentId') this.parentId,
      @JsonKey(name: 'subGroups') final List<GroupsTree>? subGroups})
      : _subGroups = subGroups;

  factory _$GroupsTreeResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$GroupsTreeResponseImplFromJson(json);

  /// Идентификатор.
  @override
  @JsonKey(name: 'id')
  final String id;

  /// Название.
  @override
  @JsonKey(name: 'name')
  final String name;

  /// Идентификатор родительской группы (может быть null).
  @override
  @JsonKey(name: 'parentId')
  final String? parentId;

  /// Список подгрупп.
  final List<GroupsTree>? _subGroups;

  /// Список подгрупп.
  @override
  @JsonKey(name: 'subGroups')
  List<GroupsTree>? get subGroups {
    final value = _subGroups;
    if (value == null) return null;
    if (_subGroups is EqualUnmodifiableListView) return _subGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'GroupsTreeResponse(id: $id, name: $name, parentId: $parentId, subGroups: $subGroups)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GroupsTreeResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            const DeepCollectionEquality()
                .equals(other._subGroups, _subGroups));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, parentId,
      const DeepCollectionEquality().hash(_subGroups));

  /// Create a copy of GroupsTreeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GroupsTreeResponseImplCopyWith<_$GroupsTreeResponseImpl> get copyWith =>
      __$$GroupsTreeResponseImplCopyWithImpl<_$GroupsTreeResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GroupsTreeResponseImplToJson(
      this,
    );
  }
}

abstract class _GroupsTreeResponse implements GroupsTreeResponse {
  factory _GroupsTreeResponse(
          {@JsonKey(name: 'id') required final String id,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'parentId') final String? parentId,
          @JsonKey(name: 'subGroups') final List<GroupsTree>? subGroups}) =
      _$GroupsTreeResponseImpl;

  factory _GroupsTreeResponse.fromJson(Map<String, dynamic> json) =
      _$GroupsTreeResponseImpl.fromJson;

  /// Идентификатор.
  @override
  @JsonKey(name: 'id')
  String get id;

  /// Название.
  @override
  @JsonKey(name: 'name')
  String get name;

  /// Идентификатор родительской группы (может быть null).
  @override
  @JsonKey(name: 'parentId')
  String? get parentId;

  /// Список подгрупп.
  @override
  @JsonKey(name: 'subGroups')
  List<GroupsTree>? get subGroups;

  /// Create a copy of GroupsTreeResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GroupsTreeResponseImplCopyWith<_$GroupsTreeResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\groups_tree_response.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groups_tree_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GroupsTreeResponseImpl _$$GroupsTreeResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$GroupsTreeResponseImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parentId'] as String?,
      subGroups: (json['subGroups'] as List<dynamic>?)
          ?.map((e) => GroupsTree.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$GroupsTreeResponseImplToJson(
        _$GroupsTreeResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'parentId': instance.parentId,
      'subGroups': instance.subGroups,
    };

```

## lib\features\parts_catalog\models\ip.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ip.freezed.dart';
part 'ip.g.dart';

/// {@template ip}
/// Модель данных для IP-адреса.
/// {@endtemplate}
@freezed
class Ip with _$Ip {
  /// {@macro ip}
  factory Ip({
    /// IP-адрес.
    @JsonKey(name: 'ip') String? ip,
  }) = _Ip;

  /// Преобразует JSON в объект [Ip].
  factory Ip.fromJson(Map<String, dynamic> json) => _$IpFromJson(json);
}

```

## lib\features\parts_catalog\models\ip.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ip.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Ip _$IpFromJson(Map<String, dynamic> json) {
  return _Ip.fromJson(json);
}

/// @nodoc
mixin _$Ip {
  /// IP-адрес.
  @JsonKey(name: 'ip')
  String? get ip => throw _privateConstructorUsedError;

  /// Serializes this Ip to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Ip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IpCopyWith<Ip> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IpCopyWith<$Res> {
  factory $IpCopyWith(Ip value, $Res Function(Ip) then) =
      _$IpCopyWithImpl<$Res, Ip>;
  @useResult
  $Res call({@JsonKey(name: 'ip') String? ip});
}

/// @nodoc
class _$IpCopyWithImpl<$Res, $Val extends Ip> implements $IpCopyWith<$Res> {
  _$IpCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Ip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ip = freezed,
  }) {
    return _then(_value.copyWith(
      ip: freezed == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IpImplCopyWith<$Res> implements $IpCopyWith<$Res> {
  factory _$$IpImplCopyWith(_$IpImpl value, $Res Function(_$IpImpl) then) =
      __$$IpImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@JsonKey(name: 'ip') String? ip});
}

/// @nodoc
class __$$IpImplCopyWithImpl<$Res> extends _$IpCopyWithImpl<$Res, _$IpImpl>
    implements _$$IpImplCopyWith<$Res> {
  __$$IpImplCopyWithImpl(_$IpImpl _value, $Res Function(_$IpImpl) _then)
      : super(_value, _then);

  /// Create a copy of Ip
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ip = freezed,
  }) {
    return _then(_$IpImpl(
      ip: freezed == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IpImpl implements _Ip {
  _$IpImpl({@JsonKey(name: 'ip') this.ip});

  factory _$IpImpl.fromJson(Map<String, dynamic> json) =>
      _$$IpImplFromJson(json);

  /// IP-адрес.
  @override
  @JsonKey(name: 'ip')
  final String? ip;

  @override
  String toString() {
    return 'Ip(ip: $ip)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IpImpl &&
            (identical(other.ip, ip) || other.ip == ip));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, ip);

  /// Create a copy of Ip
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IpImplCopyWith<_$IpImpl> get copyWith =>
      __$$IpImplCopyWithImpl<_$IpImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IpImplToJson(
      this,
    );
  }
}

abstract class _Ip implements Ip {
  factory _Ip({@JsonKey(name: 'ip') final String? ip}) = _$IpImpl;

  factory _Ip.fromJson(Map<String, dynamic> json) = _$IpImpl.fromJson;

  /// IP-адрес.
  @override
  @JsonKey(name: 'ip')
  String? get ip;

  /// Create a copy of Ip
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IpImplCopyWith<_$IpImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\ip.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ip.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$IpImpl _$$IpImplFromJson(Map<String, dynamic> json) => _$IpImpl(
      ip: json['ip'] as String?,
    );

Map<String, dynamic> _$$IpImplToJson(_$IpImpl instance) => <String, dynamic>{
      'ip': instance.ip,
    };

```

## lib\features\parts_catalog\models\model.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'model.freezed.dart';
part 'model.g.dart';

/// {@template model}
/// Модель данных для модели автомобиля.
/// {@endtemplate}
@freezed
class Model with _$Model {
  /// {@macro model}
  factory Model({
    /// Идентификатор модели.
    @JsonKey(name: 'id') required String id,

    /// Название модели.
    @JsonKey(name: 'name') required String name,

    /// URL изображения модели.
    @JsonKey(name: 'img') String? img,
  }) = _Model;

  /// Преобразует JSON в объект [Model].
  factory Model.fromJson(Map<String, dynamic> json) => _$ModelFromJson(json);
}

```

## lib\features\parts_catalog\models\model.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Model _$ModelFromJson(Map<String, dynamic> json) {
  return _Model.fromJson(json);
}

/// @nodoc
mixin _$Model {
  /// Идентификатор модели.
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  /// Название модели.
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// URL изображения модели.
  @JsonKey(name: 'img')
  String? get img => throw _privateConstructorUsedError;

  /// Serializes this Model to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Model
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ModelCopyWith<Model> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ModelCopyWith<$Res> {
  factory $ModelCopyWith(Model value, $Res Function(Model) then) =
      _$ModelCopyWithImpl<$Res, Model>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'img') String? img});
}

/// @nodoc
class _$ModelCopyWithImpl<$Res, $Val extends Model>
    implements $ModelCopyWith<$Res> {
  _$ModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Model
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? img = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ModelImplCopyWith<$Res> implements $ModelCopyWith<$Res> {
  factory _$$ModelImplCopyWith(
          _$ModelImpl value, $Res Function(_$ModelImpl) then) =
      __$$ModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'img') String? img});
}

/// @nodoc
class __$$ModelImplCopyWithImpl<$Res>
    extends _$ModelCopyWithImpl<$Res, _$ModelImpl>
    implements _$$ModelImplCopyWith<$Res> {
  __$$ModelImplCopyWithImpl(
      _$ModelImpl _value, $Res Function(_$ModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of Model
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? img = freezed,
  }) {
    return _then(_$ModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ModelImpl implements _Model {
  _$ModelImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'img') this.img});

  factory _$ModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ModelImplFromJson(json);

  /// Идентификатор модели.
  @override
  @JsonKey(name: 'id')
  final String id;

  /// Название модели.
  @override
  @JsonKey(name: 'name')
  final String name;

  /// URL изображения модели.
  @override
  @JsonKey(name: 'img')
  final String? img;

  @override
  String toString() {
    return 'Model(id: $id, name: $name, img: $img)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.img, img) || other.img == img));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, img);

  /// Create a copy of Model
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ModelImplCopyWith<_$ModelImpl> get copyWith =>
      __$$ModelImplCopyWithImpl<_$ModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ModelImplToJson(
      this,
    );
  }
}

abstract class _Model implements Model {
  factory _Model(
      {@JsonKey(name: 'id') required final String id,
      @JsonKey(name: 'name') required final String name,
      @JsonKey(name: 'img') final String? img}) = _$ModelImpl;

  factory _Model.fromJson(Map<String, dynamic> json) = _$ModelImpl.fromJson;

  /// Идентификатор модели.
  @override
  @JsonKey(name: 'id')
  String get id;

  /// Название модели.
  @override
  @JsonKey(name: 'name')
  String get name;

  /// URL изображения модели.
  @override
  @JsonKey(name: 'img')
  String? get img;

  /// Create a copy of Model
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ModelImplCopyWith<_$ModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\model.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ModelImpl _$$ModelImplFromJson(Map<String, dynamic> json) => _$ModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      img: json['img'] as String?,
    );

Map<String, dynamic> _$$ModelImplToJson(_$ModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'img': instance.img,
    };

```

## lib\features\parts_catalog\models\option_code.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'option_code.freezed.dart';
part 'option_code.g.dart';

/// {@template option_code}
/// Модель данных для кода опции автомобиля.
/// {@endtemplate}
@freezed
class OptionCode with _$OptionCode {
  /// {@macro option_code}
  factory OptionCode({
    /// Код опции.
    @JsonKey(name: 'code') String? code,

    /// Описание опции.
    @JsonKey(name: 'description') String? description,
  }) = _OptionCode;

  /// Преобразует JSON в объект [OptionCode].
  factory OptionCode.fromJson(Map<String, dynamic> json) =>
      _$OptionCodeFromJson(json);
}

```

## lib\features\parts_catalog\models\option_code.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'option_code.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OptionCode _$OptionCodeFromJson(Map<String, dynamic> json) {
  return _OptionCode.fromJson(json);
}

/// @nodoc
mixin _$OptionCode {
  /// Код опции.
  @JsonKey(name: 'code')
  String? get code => throw _privateConstructorUsedError;

  /// Описание опции.
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this OptionCode to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OptionCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OptionCodeCopyWith<OptionCode> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OptionCodeCopyWith<$Res> {
  factory $OptionCodeCopyWith(
          OptionCode value, $Res Function(OptionCode) then) =
      _$OptionCodeCopyWithImpl<$Res, OptionCode>;
  @useResult
  $Res call(
      {@JsonKey(name: 'code') String? code,
      @JsonKey(name: 'description') String? description});
}

/// @nodoc
class _$OptionCodeCopyWithImpl<$Res, $Val extends OptionCode>
    implements $OptionCodeCopyWith<$Res> {
  _$OptionCodeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OptionCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OptionCodeImplCopyWith<$Res>
    implements $OptionCodeCopyWith<$Res> {
  factory _$$OptionCodeImplCopyWith(
          _$OptionCodeImpl value, $Res Function(_$OptionCodeImpl) then) =
      __$$OptionCodeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'code') String? code,
      @JsonKey(name: 'description') String? description});
}

/// @nodoc
class __$$OptionCodeImplCopyWithImpl<$Res>
    extends _$OptionCodeCopyWithImpl<$Res, _$OptionCodeImpl>
    implements _$$OptionCodeImplCopyWith<$Res> {
  __$$OptionCodeImplCopyWithImpl(
      _$OptionCodeImpl _value, $Res Function(_$OptionCodeImpl) _then)
      : super(_value, _then);

  /// Create a copy of OptionCode
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? description = freezed,
  }) {
    return _then(_$OptionCodeImpl(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OptionCodeImpl implements _OptionCode {
  _$OptionCodeImpl(
      {@JsonKey(name: 'code') this.code,
      @JsonKey(name: 'description') this.description});

  factory _$OptionCodeImpl.fromJson(Map<String, dynamic> json) =>
      _$$OptionCodeImplFromJson(json);

  /// Код опции.
  @override
  @JsonKey(name: 'code')
  final String? code;

  /// Описание опции.
  @override
  @JsonKey(name: 'description')
  final String? description;

  @override
  String toString() {
    return 'OptionCode(code: $code, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OptionCodeImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, description);

  /// Create a copy of OptionCode
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OptionCodeImplCopyWith<_$OptionCodeImpl> get copyWith =>
      __$$OptionCodeImplCopyWithImpl<_$OptionCodeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OptionCodeImplToJson(
      this,
    );
  }
}

abstract class _OptionCode implements OptionCode {
  factory _OptionCode(
          {@JsonKey(name: 'code') final String? code,
          @JsonKey(name: 'description') final String? description}) =
      _$OptionCodeImpl;

  factory _OptionCode.fromJson(Map<String, dynamic> json) =
      _$OptionCodeImpl.fromJson;

  /// Код опции.
  @override
  @JsonKey(name: 'code')
  String? get code;

  /// Описание опции.
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// Create a copy of OptionCode
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OptionCodeImplCopyWith<_$OptionCodeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\option_code.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'option_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OptionCodeImpl _$$OptionCodeImplFromJson(Map<String, dynamic> json) =>
    _$OptionCodeImpl(
      code: json['code'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$OptionCodeImplToJson(_$OptionCodeImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'description': instance.description,
    };

```

## lib\features\parts_catalog\models\part.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'part.freezed.dart';
part 'part.g.dart';

/// {@template part}
/// Модель данных для детали.
/// {@endtemplate}
@freezed
class Part with _$Part {
  /// {@macro part}
  factory Part({
    /// Идентификатор детали.
    @JsonKey(name: 'id') String? id,

    /// Идентификатор названия детали (может быть null).
    @JsonKey(name: 'nameId') String? nameId,

    /// Название детали.
    @JsonKey(name: 'name') String? name,

    /// Номер детали.
    @JsonKey(name: 'number') String? number,

    /// Примечание к детали.
    @JsonKey(name: 'notice') String? notice,

    /// Описание детали.
    @JsonKey(name: 'description') String? description,

    /// Номер позиции на изображении группы.
    @JsonKey(name: 'positionNumber') String? positionNumber,

    /// URL для поиска результатов.
    @JsonKey(name: 'url') String? url,
  }) = _Part;

  /// Преобразует JSON в объект [Part].
  factory Part.fromJson(Map<String, dynamic> json) => _$PartFromJson(json);
}

```

## lib\features\parts_catalog\models\part.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'part.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Part _$PartFromJson(Map<String, dynamic> json) {
  return _Part.fromJson(json);
}

/// @nodoc
mixin _$Part {
  /// Идентификатор детали.
  @JsonKey(name: 'id')
  String? get id => throw _privateConstructorUsedError;

  /// Идентификатор названия детали (может быть null).
  @JsonKey(name: 'nameId')
  String? get nameId => throw _privateConstructorUsedError;

  /// Название детали.
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// Номер детали.
  @JsonKey(name: 'number')
  String? get number => throw _privateConstructorUsedError;

  /// Примечание к детали.
  @JsonKey(name: 'notice')
  String? get notice => throw _privateConstructorUsedError;

  /// Описание детали.
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// Номер позиции на изображении группы.
  @JsonKey(name: 'positionNumber')
  String? get positionNumber => throw _privateConstructorUsedError;

  /// URL для поиска результатов.
  @JsonKey(name: 'url')
  String? get url => throw _privateConstructorUsedError;

  /// Serializes this Part to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Part
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartCopyWith<Part> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartCopyWith<$Res> {
  factory $PartCopyWith(Part value, $Res Function(Part) then) =
      _$PartCopyWithImpl<$Res, Part>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'nameId') String? nameId,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'number') String? number,
      @JsonKey(name: 'notice') String? notice,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'positionNumber') String? positionNumber,
      @JsonKey(name: 'url') String? url});
}

/// @nodoc
class _$PartCopyWithImpl<$Res, $Val extends Part>
    implements $PartCopyWith<$Res> {
  _$PartCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Part
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? nameId = freezed,
    Object? name = freezed,
    Object? number = freezed,
    Object? notice = freezed,
    Object? description = freezed,
    Object? positionNumber = freezed,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      nameId: freezed == nameId
          ? _value.nameId
          : nameId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      notice: freezed == notice
          ? _value.notice
          : notice // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      positionNumber: freezed == positionNumber
          ? _value.positionNumber
          : positionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartImplCopyWith<$Res> implements $PartCopyWith<$Res> {
  factory _$$PartImplCopyWith(
          _$PartImpl value, $Res Function(_$PartImpl) then) =
      __$$PartImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String? id,
      @JsonKey(name: 'nameId') String? nameId,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'number') String? number,
      @JsonKey(name: 'notice') String? notice,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'positionNumber') String? positionNumber,
      @JsonKey(name: 'url') String? url});
}

/// @nodoc
class __$$PartImplCopyWithImpl<$Res>
    extends _$PartCopyWithImpl<$Res, _$PartImpl>
    implements _$$PartImplCopyWith<$Res> {
  __$$PartImplCopyWithImpl(_$PartImpl _value, $Res Function(_$PartImpl) _then)
      : super(_value, _then);

  /// Create a copy of Part
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? nameId = freezed,
    Object? name = freezed,
    Object? number = freezed,
    Object? notice = freezed,
    Object? description = freezed,
    Object? positionNumber = freezed,
    Object? url = freezed,
  }) {
    return _then(_$PartImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      nameId: freezed == nameId
          ? _value.nameId
          : nameId // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      notice: freezed == notice
          ? _value.notice
          : notice // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      positionNumber: freezed == positionNumber
          ? _value.positionNumber
          : positionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PartImpl implements _Part {
  _$PartImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'nameId') this.nameId,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'number') this.number,
      @JsonKey(name: 'notice') this.notice,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'positionNumber') this.positionNumber,
      @JsonKey(name: 'url') this.url});

  factory _$PartImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartImplFromJson(json);

  /// Идентификатор детали.
  @override
  @JsonKey(name: 'id')
  final String? id;

  /// Идентификатор названия детали (может быть null).
  @override
  @JsonKey(name: 'nameId')
  final String? nameId;

  /// Название детали.
  @override
  @JsonKey(name: 'name')
  final String? name;

  /// Номер детали.
  @override
  @JsonKey(name: 'number')
  final String? number;

  /// Примечание к детали.
  @override
  @JsonKey(name: 'notice')
  final String? notice;

  /// Описание детали.
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// Номер позиции на изображении группы.
  @override
  @JsonKey(name: 'positionNumber')
  final String? positionNumber;

  /// URL для поиска результатов.
  @override
  @JsonKey(name: 'url')
  final String? url;

  @override
  String toString() {
    return 'Part(id: $id, nameId: $nameId, name: $name, number: $number, notice: $notice, description: $description, positionNumber: $positionNumber, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.nameId, nameId) || other.nameId == nameId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.notice, notice) || other.notice == notice) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.positionNumber, positionNumber) ||
                other.positionNumber == positionNumber) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, nameId, name, number, notice,
      description, positionNumber, url);

  /// Create a copy of Part
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartImplCopyWith<_$PartImpl> get copyWith =>
      __$$PartImplCopyWithImpl<_$PartImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartImplToJson(
      this,
    );
  }
}

abstract class _Part implements Part {
  factory _Part(
      {@JsonKey(name: 'id') final String? id,
      @JsonKey(name: 'nameId') final String? nameId,
      @JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'number') final String? number,
      @JsonKey(name: 'notice') final String? notice,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'positionNumber') final String? positionNumber,
      @JsonKey(name: 'url') final String? url}) = _$PartImpl;

  factory _Part.fromJson(Map<String, dynamic> json) = _$PartImpl.fromJson;

  /// Идентификатор детали.
  @override
  @JsonKey(name: 'id')
  String? get id;

  /// Идентификатор названия детали (может быть null).
  @override
  @JsonKey(name: 'nameId')
  String? get nameId;

  /// Название детали.
  @override
  @JsonKey(name: 'name')
  String? get name;

  /// Номер детали.
  @override
  @JsonKey(name: 'number')
  String? get number;

  /// Примечание к детали.
  @override
  @JsonKey(name: 'notice')
  String? get notice;

  /// Описание детали.
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// Номер позиции на изображении группы.
  @override
  @JsonKey(name: 'positionNumber')
  String? get positionNumber;

  /// URL для поиска результатов.
  @override
  @JsonKey(name: 'url')
  String? get url;

  /// Create a copy of Part
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartImplCopyWith<_$PartImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\part.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PartImpl _$$PartImplFromJson(Map<String, dynamic> json) => _$PartImpl(
      id: json['id'] as String?,
      nameId: json['nameId'] as String?,
      name: json['name'] as String?,
      number: json['number'] as String?,
      notice: json['notice'] as String?,
      description: json['description'] as String?,
      positionNumber: json['positionNumber'] as String?,
      url: json['url'] as String?,
    );

Map<String, dynamic> _$$PartImplToJson(_$PartImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nameId': instance.nameId,
      'name': instance.name,
      'number': instance.number,
      'notice': instance.notice,
      'description': instance.description,
      'positionNumber': instance.positionNumber,
      'url': instance.url,
    };

```

## lib\features\parts_catalog\models\part_name.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'part_name.freezed.dart';
part 'part_name.g.dart';

/// {@template part_name}
/// Модель данных для названия детали.
/// {@endtemplate}
@freezed
class PartName with _$PartName {
  /// {@macro part_name}
  factory PartName({
    /// Идентификатор.
    @JsonKey(name: 'id') required String id,

    /// Название.
    @JsonKey(name: 'name') required String name,
  }) = _PartName;

  /// Преобразует JSON в объект [PartName].
  factory PartName.fromJson(Map<String, dynamic> json) =>
      _$PartNameFromJson(json);
}

```

## lib\features\parts_catalog\models\part_name.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'part_name.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PartName _$PartNameFromJson(Map<String, dynamic> json) {
  return _PartName.fromJson(json);
}

/// @nodoc
mixin _$PartName {
  /// Идентификатор.
  @JsonKey(name: 'id')
  String get id => throw _privateConstructorUsedError;

  /// Название.
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// Serializes this PartName to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PartName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartNameCopyWith<PartName> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartNameCopyWith<$Res> {
  factory $PartNameCopyWith(PartName value, $Res Function(PartName) then) =
      _$PartNameCopyWithImpl<$Res, PartName>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id, @JsonKey(name: 'name') String name});
}

/// @nodoc
class _$PartNameCopyWithImpl<$Res, $Val extends PartName>
    implements $PartNameCopyWith<$Res> {
  _$PartNameCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PartName
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartNameImplCopyWith<$Res>
    implements $PartNameCopyWith<$Res> {
  factory _$$PartNameImplCopyWith(
          _$PartNameImpl value, $Res Function(_$PartNameImpl) then) =
      __$$PartNameImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String id, @JsonKey(name: 'name') String name});
}

/// @nodoc
class __$$PartNameImplCopyWithImpl<$Res>
    extends _$PartNameCopyWithImpl<$Res, _$PartNameImpl>
    implements _$$PartNameImplCopyWith<$Res> {
  __$$PartNameImplCopyWithImpl(
      _$PartNameImpl _value, $Res Function(_$PartNameImpl) _then)
      : super(_value, _then);

  /// Create a copy of PartName
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
  }) {
    return _then(_$PartNameImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PartNameImpl implements _PartName {
  _$PartNameImpl(
      {@JsonKey(name: 'id') required this.id,
      @JsonKey(name: 'name') required this.name});

  factory _$PartNameImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartNameImplFromJson(json);

  /// Идентификатор.
  @override
  @JsonKey(name: 'id')
  final String id;

  /// Название.
  @override
  @JsonKey(name: 'name')
  final String name;

  @override
  String toString() {
    return 'PartName(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartNameImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of PartName
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartNameImplCopyWith<_$PartNameImpl> get copyWith =>
      __$$PartNameImplCopyWithImpl<_$PartNameImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartNameImplToJson(
      this,
    );
  }
}

abstract class _PartName implements PartName {
  factory _PartName(
      {@JsonKey(name: 'id') required final String id,
      @JsonKey(name: 'name') required final String name}) = _$PartNameImpl;

  factory _PartName.fromJson(Map<String, dynamic> json) =
      _$PartNameImpl.fromJson;

  /// Идентификатор.
  @override
  @JsonKey(name: 'id')
  String get id;

  /// Название.
  @override
  @JsonKey(name: 'name')
  String get name;

  /// Create a copy of PartName
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartNameImplCopyWith<_$PartNameImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\part_name.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'part_name.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PartNameImpl _$$PartNameImplFromJson(Map<String, dynamic> json) =>
    _$PartNameImpl(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$$PartNameImplToJson(_$PartNameImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

```

## lib\features\parts_catalog\models\parts.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/features/parts_catalog/models/part.dart';

part 'parts.freezed.dart';
part 'parts.g.dart';

/// {@template parts}
/// Модель данных для списка запчастей.
/// {@endtemplate}
@freezed
class Parts with _$Parts {
  /// {@macro parts}
  factory Parts({
    /// URL изображения группы запчастей.
    @JsonKey(name: 'img') String? img,

    /// Описание изображения группы запчастей.
    @JsonKey(name: 'imgDescription') String? imgDescription,

    /// Список групп запчастей.
    @JsonKey(name: 'partGroups') List<PartsGroup>? partGroups,

    /// Список позиций блоков с номерами на изображении.
    @JsonKey(name: 'positions') List<Position>? positions,
  }) = _Parts;

  /// Преобразует JSON в объект [Parts].
  factory Parts.fromJson(Map<String, dynamic> json) => _$PartsFromJson(json);
}

/// {@template parts_group}
/// Модель данных для группы запчастей.
/// {@endtemplate}
@freezed
class PartsGroup with _$PartsGroup {
  /// {@macro parts_group}
  factory PartsGroup({
    /// Название запчасти.
    @JsonKey(name: 'name') String? name,

    /// Номер группы запчастей.
    @JsonKey(name: 'number') String? number,

    /// Номер позиции группы запчастей на изображении.
    @JsonKey(name: 'positionNumber') String? positionNumber,

    /// Описание группы запчастей.
    @JsonKey(name: 'description') String? description,

    /// Список деталей в группе.
    @JsonKey(name: 'parts') List<Part>? parts,
  }) = _PartsGroup;

  /// Преобразует JSON в объект [PartsGroup].
  factory PartsGroup.fromJson(Map<String, dynamic> json) =>
      _$PartsGroupFromJson(json);
}

/// {@template position}
/// Модель данных для позиции блока с номером на изображении.
/// {@endtemplate}
@freezed
class Position with _$Position {
  /// {@macro position}
  factory Position({
    /// Номер на изображении.
    @JsonKey(name: 'number') String? number,

    /// Координаты блока с номером на изображении (X, Y, H, W).
    @JsonKey(name: 'coordinates') List<double>? coordinates,
  }) = _Position;

  /// Преобразует JSON в объект [Position].
  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);
}

```

## lib\features\parts_catalog\models\parts.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parts.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Parts _$PartsFromJson(Map<String, dynamic> json) {
  return _Parts.fromJson(json);
}

/// @nodoc
mixin _$Parts {
  /// URL изображения группы запчастей.
  @JsonKey(name: 'img')
  String? get img => throw _privateConstructorUsedError;

  /// Описание изображения группы запчастей.
  @JsonKey(name: 'imgDescription')
  String? get imgDescription => throw _privateConstructorUsedError;

  /// Список групп запчастей.
  @JsonKey(name: 'partGroups')
  List<PartsGroup>? get partGroups => throw _privateConstructorUsedError;

  /// Список позиций блоков с номерами на изображении.
  @JsonKey(name: 'positions')
  List<Position>? get positions => throw _privateConstructorUsedError;

  /// Serializes this Parts to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Parts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartsCopyWith<Parts> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartsCopyWith<$Res> {
  factory $PartsCopyWith(Parts value, $Res Function(Parts) then) =
      _$PartsCopyWithImpl<$Res, Parts>;
  @useResult
  $Res call(
      {@JsonKey(name: 'img') String? img,
      @JsonKey(name: 'imgDescription') String? imgDescription,
      @JsonKey(name: 'partGroups') List<PartsGroup>? partGroups,
      @JsonKey(name: 'positions') List<Position>? positions});
}

/// @nodoc
class _$PartsCopyWithImpl<$Res, $Val extends Parts>
    implements $PartsCopyWith<$Res> {
  _$PartsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Parts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? img = freezed,
    Object? imgDescription = freezed,
    Object? partGroups = freezed,
    Object? positions = freezed,
  }) {
    return _then(_value.copyWith(
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      imgDescription: freezed == imgDescription
          ? _value.imgDescription
          : imgDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      partGroups: freezed == partGroups
          ? _value.partGroups
          : partGroups // ignore: cast_nullable_to_non_nullable
              as List<PartsGroup>?,
      positions: freezed == positions
          ? _value.positions
          : positions // ignore: cast_nullable_to_non_nullable
              as List<Position>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartsImplCopyWith<$Res> implements $PartsCopyWith<$Res> {
  factory _$$PartsImplCopyWith(
          _$PartsImpl value, $Res Function(_$PartsImpl) then) =
      __$$PartsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'img') String? img,
      @JsonKey(name: 'imgDescription') String? imgDescription,
      @JsonKey(name: 'partGroups') List<PartsGroup>? partGroups,
      @JsonKey(name: 'positions') List<Position>? positions});
}

/// @nodoc
class __$$PartsImplCopyWithImpl<$Res>
    extends _$PartsCopyWithImpl<$Res, _$PartsImpl>
    implements _$$PartsImplCopyWith<$Res> {
  __$$PartsImplCopyWithImpl(
      _$PartsImpl _value, $Res Function(_$PartsImpl) _then)
      : super(_value, _then);

  /// Create a copy of Parts
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? img = freezed,
    Object? imgDescription = freezed,
    Object? partGroups = freezed,
    Object? positions = freezed,
  }) {
    return _then(_$PartsImpl(
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      imgDescription: freezed == imgDescription
          ? _value.imgDescription
          : imgDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      partGroups: freezed == partGroups
          ? _value._partGroups
          : partGroups // ignore: cast_nullable_to_non_nullable
              as List<PartsGroup>?,
      positions: freezed == positions
          ? _value._positions
          : positions // ignore: cast_nullable_to_non_nullable
              as List<Position>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PartsImpl implements _Parts {
  _$PartsImpl(
      {@JsonKey(name: 'img') this.img,
      @JsonKey(name: 'imgDescription') this.imgDescription,
      @JsonKey(name: 'partGroups') final List<PartsGroup>? partGroups,
      @JsonKey(name: 'positions') final List<Position>? positions})
      : _partGroups = partGroups,
        _positions = positions;

  factory _$PartsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartsImplFromJson(json);

  /// URL изображения группы запчастей.
  @override
  @JsonKey(name: 'img')
  final String? img;

  /// Описание изображения группы запчастей.
  @override
  @JsonKey(name: 'imgDescription')
  final String? imgDescription;

  /// Список групп запчастей.
  final List<PartsGroup>? _partGroups;

  /// Список групп запчастей.
  @override
  @JsonKey(name: 'partGroups')
  List<PartsGroup>? get partGroups {
    final value = _partGroups;
    if (value == null) return null;
    if (_partGroups is EqualUnmodifiableListView) return _partGroups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Список позиций блоков с номерами на изображении.
  final List<Position>? _positions;

  /// Список позиций блоков с номерами на изображении.
  @override
  @JsonKey(name: 'positions')
  List<Position>? get positions {
    final value = _positions;
    if (value == null) return null;
    if (_positions is EqualUnmodifiableListView) return _positions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Parts(img: $img, imgDescription: $imgDescription, partGroups: $partGroups, positions: $positions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartsImpl &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.imgDescription, imgDescription) ||
                other.imgDescription == imgDescription) &&
            const DeepCollectionEquality()
                .equals(other._partGroups, _partGroups) &&
            const DeepCollectionEquality()
                .equals(other._positions, _positions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      img,
      imgDescription,
      const DeepCollectionEquality().hash(_partGroups),
      const DeepCollectionEquality().hash(_positions));

  /// Create a copy of Parts
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartsImplCopyWith<_$PartsImpl> get copyWith =>
      __$$PartsImplCopyWithImpl<_$PartsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartsImplToJson(
      this,
    );
  }
}

abstract class _Parts implements Parts {
  factory _Parts(
          {@JsonKey(name: 'img') final String? img,
          @JsonKey(name: 'imgDescription') final String? imgDescription,
          @JsonKey(name: 'partGroups') final List<PartsGroup>? partGroups,
          @JsonKey(name: 'positions') final List<Position>? positions}) =
      _$PartsImpl;

  factory _Parts.fromJson(Map<String, dynamic> json) = _$PartsImpl.fromJson;

  /// URL изображения группы запчастей.
  @override
  @JsonKey(name: 'img')
  String? get img;

  /// Описание изображения группы запчастей.
  @override
  @JsonKey(name: 'imgDescription')
  String? get imgDescription;

  /// Список групп запчастей.
  @override
  @JsonKey(name: 'partGroups')
  List<PartsGroup>? get partGroups;

  /// Список позиций блоков с номерами на изображении.
  @override
  @JsonKey(name: 'positions')
  List<Position>? get positions;

  /// Create a copy of Parts
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartsImplCopyWith<_$PartsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PartsGroup _$PartsGroupFromJson(Map<String, dynamic> json) {
  return _PartsGroup.fromJson(json);
}

/// @nodoc
mixin _$PartsGroup {
  /// Название запчасти.
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// Номер группы запчастей.
  @JsonKey(name: 'number')
  String? get number => throw _privateConstructorUsedError;

  /// Номер позиции группы запчастей на изображении.
  @JsonKey(name: 'positionNumber')
  String? get positionNumber => throw _privateConstructorUsedError;

  /// Описание группы запчастей.
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// Список деталей в группе.
  @JsonKey(name: 'parts')
  List<Part>? get parts => throw _privateConstructorUsedError;

  /// Serializes this PartsGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartsGroupCopyWith<PartsGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartsGroupCopyWith<$Res> {
  factory $PartsGroupCopyWith(
          PartsGroup value, $Res Function(PartsGroup) then) =
      _$PartsGroupCopyWithImpl<$Res, PartsGroup>;
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'number') String? number,
      @JsonKey(name: 'positionNumber') String? positionNumber,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'parts') List<Part>? parts});
}

/// @nodoc
class _$PartsGroupCopyWithImpl<$Res, $Val extends PartsGroup>
    implements $PartsGroupCopyWith<$Res> {
  _$PartsGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? number = freezed,
    Object? positionNumber = freezed,
    Object? description = freezed,
    Object? parts = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      positionNumber: freezed == positionNumber
          ? _value.positionNumber
          : positionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      parts: freezed == parts
          ? _value.parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<Part>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartsGroupImplCopyWith<$Res>
    implements $PartsGroupCopyWith<$Res> {
  factory _$$PartsGroupImplCopyWith(
          _$PartsGroupImpl value, $Res Function(_$PartsGroupImpl) then) =
      __$$PartsGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'number') String? number,
      @JsonKey(name: 'positionNumber') String? positionNumber,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'parts') List<Part>? parts});
}

/// @nodoc
class __$$PartsGroupImplCopyWithImpl<$Res>
    extends _$PartsGroupCopyWithImpl<$Res, _$PartsGroupImpl>
    implements _$$PartsGroupImplCopyWith<$Res> {
  __$$PartsGroupImplCopyWithImpl(
      _$PartsGroupImpl _value, $Res Function(_$PartsGroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? number = freezed,
    Object? positionNumber = freezed,
    Object? description = freezed,
    Object? parts = freezed,
  }) {
    return _then(_$PartsGroupImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      positionNumber: freezed == positionNumber
          ? _value.positionNumber
          : positionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      parts: freezed == parts
          ? _value._parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<Part>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PartsGroupImpl implements _PartsGroup {
  _$PartsGroupImpl(
      {@JsonKey(name: 'name') this.name,
      @JsonKey(name: 'number') this.number,
      @JsonKey(name: 'positionNumber') this.positionNumber,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'parts') final List<Part>? parts})
      : _parts = parts;

  factory _$PartsGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartsGroupImplFromJson(json);

  /// Название запчасти.
  @override
  @JsonKey(name: 'name')
  final String? name;

  /// Номер группы запчастей.
  @override
  @JsonKey(name: 'number')
  final String? number;

  /// Номер позиции группы запчастей на изображении.
  @override
  @JsonKey(name: 'positionNumber')
  final String? positionNumber;

  /// Описание группы запчастей.
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// Список деталей в группе.
  final List<Part>? _parts;

  /// Список деталей в группе.
  @override
  @JsonKey(name: 'parts')
  List<Part>? get parts {
    final value = _parts;
    if (value == null) return null;
    if (_parts is EqualUnmodifiableListView) return _parts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PartsGroup(name: $name, number: $number, positionNumber: $positionNumber, description: $description, parts: $parts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartsGroupImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.positionNumber, positionNumber) ||
                other.positionNumber == positionNumber) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._parts, _parts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, number, positionNumber,
      description, const DeepCollectionEquality().hash(_parts));

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartsGroupImplCopyWith<_$PartsGroupImpl> get copyWith =>
      __$$PartsGroupImplCopyWithImpl<_$PartsGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartsGroupImplToJson(
      this,
    );
  }
}

abstract class _PartsGroup implements PartsGroup {
  factory _PartsGroup(
      {@JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'number') final String? number,
      @JsonKey(name: 'positionNumber') final String? positionNumber,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'parts') final List<Part>? parts}) = _$PartsGroupImpl;

  factory _PartsGroup.fromJson(Map<String, dynamic> json) =
      _$PartsGroupImpl.fromJson;

  /// Название запчасти.
  @override
  @JsonKey(name: 'name')
  String? get name;

  /// Номер группы запчастей.
  @override
  @JsonKey(name: 'number')
  String? get number;

  /// Номер позиции группы запчастей на изображении.
  @override
  @JsonKey(name: 'positionNumber')
  String? get positionNumber;

  /// Описание группы запчастей.
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// Список деталей в группе.
  @override
  @JsonKey(name: 'parts')
  List<Part>? get parts;

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartsGroupImplCopyWith<_$PartsGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Position _$PositionFromJson(Map<String, dynamic> json) {
  return _Position.fromJson(json);
}

/// @nodoc
mixin _$Position {
  /// Номер на изображении.
  @JsonKey(name: 'number')
  String? get number => throw _privateConstructorUsedError;

  /// Координаты блока с номером на изображении (X, Y, H, W).
  @JsonKey(name: 'coordinates')
  List<double>? get coordinates => throw _privateConstructorUsedError;

  /// Serializes this Position to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PositionCopyWith<Position> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PositionCopyWith<$Res> {
  factory $PositionCopyWith(Position value, $Res Function(Position) then) =
      _$PositionCopyWithImpl<$Res, Position>;
  @useResult
  $Res call(
      {@JsonKey(name: 'number') String? number,
      @JsonKey(name: 'coordinates') List<double>? coordinates});
}

/// @nodoc
class _$PositionCopyWithImpl<$Res, $Val extends Position>
    implements $PositionCopyWith<$Res> {
  _$PositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = freezed,
    Object? coordinates = freezed,
  }) {
    return _then(_value.copyWith(
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      coordinates: freezed == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<double>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PositionImplCopyWith<$Res>
    implements $PositionCopyWith<$Res> {
  factory _$$PositionImplCopyWith(
          _$PositionImpl value, $Res Function(_$PositionImpl) then) =
      __$$PositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'number') String? number,
      @JsonKey(name: 'coordinates') List<double>? coordinates});
}

/// @nodoc
class __$$PositionImplCopyWithImpl<$Res>
    extends _$PositionCopyWithImpl<$Res, _$PositionImpl>
    implements _$$PositionImplCopyWith<$Res> {
  __$$PositionImplCopyWithImpl(
      _$PositionImpl _value, $Res Function(_$PositionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = freezed,
    Object? coordinates = freezed,
  }) {
    return _then(_$PositionImpl(
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      coordinates: freezed == coordinates
          ? _value._coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<double>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PositionImpl implements _Position {
  _$PositionImpl(
      {@JsonKey(name: 'number') this.number,
      @JsonKey(name: 'coordinates') final List<double>? coordinates})
      : _coordinates = coordinates;

  factory _$PositionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PositionImplFromJson(json);

  /// Номер на изображении.
  @override
  @JsonKey(name: 'number')
  final String? number;

  /// Координаты блока с номером на изображении (X, Y, H, W).
  final List<double>? _coordinates;

  /// Координаты блока с номером на изображении (X, Y, H, W).
  @override
  @JsonKey(name: 'coordinates')
  List<double>? get coordinates {
    final value = _coordinates;
    if (value == null) return null;
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Position(number: $number, coordinates: $coordinates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositionImpl &&
            (identical(other.number, number) || other.number == number) &&
            const DeepCollectionEquality()
                .equals(other._coordinates, _coordinates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, number, const DeepCollectionEquality().hash(_coordinates));

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PositionImplCopyWith<_$PositionImpl> get copyWith =>
      __$$PositionImplCopyWithImpl<_$PositionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PositionImplToJson(
      this,
    );
  }
}

abstract class _Position implements Position {
  factory _Position(
          {@JsonKey(name: 'number') final String? number,
          @JsonKey(name: 'coordinates') final List<double>? coordinates}) =
      _$PositionImpl;

  factory _Position.fromJson(Map<String, dynamic> json) =
      _$PositionImpl.fromJson;

  /// Номер на изображении.
  @override
  @JsonKey(name: 'number')
  String? get number;

  /// Координаты блока с номером на изображении (X, Y, H, W).
  @override
  @JsonKey(name: 'coordinates')
  List<double>? get coordinates;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PositionImplCopyWith<_$PositionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\parts.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PartsImpl _$$PartsImplFromJson(Map<String, dynamic> json) => _$PartsImpl(
      img: json['img'] as String?,
      imgDescription: json['imgDescription'] as String?,
      partGroups: (json['partGroups'] as List<dynamic>?)
          ?.map((e) => PartsGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      positions: (json['positions'] as List<dynamic>?)
          ?.map((e) => Position.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PartsImplToJson(_$PartsImpl instance) =>
    <String, dynamic>{
      'img': instance.img,
      'imgDescription': instance.imgDescription,
      'partGroups': instance.partGroups,
      'positions': instance.positions,
    };

_$PartsGroupImpl _$$PartsGroupImplFromJson(Map<String, dynamic> json) =>
    _$PartsGroupImpl(
      name: json['name'] as String?,
      number: json['number'] as String?,
      positionNumber: json['positionNumber'] as String?,
      description: json['description'] as String?,
      parts: (json['parts'] as List<dynamic>?)
          ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PartsGroupImplToJson(_$PartsGroupImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'number': instance.number,
      'positionNumber': instance.positionNumber,
      'description': instance.description,
      'parts': instance.parts,
    };

_$PositionImpl _$$PositionImplFromJson(Map<String, dynamic> json) =>
    _$PositionImpl(
      number: json['number'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$$PositionImplToJson(_$PositionImpl instance) =>
    <String, dynamic>{
      'number': instance.number,
      'coordinates': instance.coordinates,
    };

```

## lib\features\parts_catalog\models\parts_group.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/features/parts_catalog/models/part.dart';

part 'parts_group.freezed.dart';
part 'parts_group.g.dart';

/// {@template parts_group}
/// Модель данных для группы запчастей.
/// {@endtemplate}
@freezed
class PartsGroup with _$PartsGroup {
  /// {@macro parts_group}
  factory PartsGroup({
    /// Название запчасти.
    @JsonKey(name: 'name') String? name,

    /// Номер группы запчастей.
    @JsonKey(name: 'number') String? number,

    /// Номер позиции группы запчастей на изображении.
    @JsonKey(name: 'positionNumber') String? positionNumber,

    /// Описание группы запчастей.
    @JsonKey(name: 'description') String? description,

    /// Список деталей в группе.
    @JsonKey(name: 'parts') List<Part>? parts,
  }) = _PartsGroup;

  /// Преобразует JSON в объект [PartsGroup].
  factory PartsGroup.fromJson(Map<String, dynamic> json) =>
      _$PartsGroupFromJson(json);
}

```

## lib\features\parts_catalog\models\parts_group.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parts_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PartsGroup _$PartsGroupFromJson(Map<String, dynamic> json) {
  return _PartsGroup.fromJson(json);
}

/// @nodoc
mixin _$PartsGroup {
  /// Название запчасти.
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// Номер группы запчастей.
  @JsonKey(name: 'number')
  String? get number => throw _privateConstructorUsedError;

  /// Номер позиции группы запчастей на изображении.
  @JsonKey(name: 'positionNumber')
  String? get positionNumber => throw _privateConstructorUsedError;

  /// Описание группы запчастей.
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// Список деталей в группе.
  @JsonKey(name: 'parts')
  List<Part>? get parts => throw _privateConstructorUsedError;

  /// Serializes this PartsGroup to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PartsGroupCopyWith<PartsGroup> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PartsGroupCopyWith<$Res> {
  factory $PartsGroupCopyWith(
          PartsGroup value, $Res Function(PartsGroup) then) =
      _$PartsGroupCopyWithImpl<$Res, PartsGroup>;
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'number') String? number,
      @JsonKey(name: 'positionNumber') String? positionNumber,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'parts') List<Part>? parts});
}

/// @nodoc
class _$PartsGroupCopyWithImpl<$Res, $Val extends PartsGroup>
    implements $PartsGroupCopyWith<$Res> {
  _$PartsGroupCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? number = freezed,
    Object? positionNumber = freezed,
    Object? description = freezed,
    Object? parts = freezed,
  }) {
    return _then(_value.copyWith(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      positionNumber: freezed == positionNumber
          ? _value.positionNumber
          : positionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      parts: freezed == parts
          ? _value.parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<Part>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PartsGroupImplCopyWith<$Res>
    implements $PartsGroupCopyWith<$Res> {
  factory _$$PartsGroupImplCopyWith(
          _$PartsGroupImpl value, $Res Function(_$PartsGroupImpl) then) =
      __$$PartsGroupImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'name') String? name,
      @JsonKey(name: 'number') String? number,
      @JsonKey(name: 'positionNumber') String? positionNumber,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'parts') List<Part>? parts});
}

/// @nodoc
class __$$PartsGroupImplCopyWithImpl<$Res>
    extends _$PartsGroupCopyWithImpl<$Res, _$PartsGroupImpl>
    implements _$$PartsGroupImplCopyWith<$Res> {
  __$$PartsGroupImplCopyWithImpl(
      _$PartsGroupImpl _value, $Res Function(_$PartsGroupImpl) _then)
      : super(_value, _then);

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = freezed,
    Object? number = freezed,
    Object? positionNumber = freezed,
    Object? description = freezed,
    Object? parts = freezed,
  }) {
    return _then(_$PartsGroupImpl(
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      positionNumber: freezed == positionNumber
          ? _value.positionNumber
          : positionNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      parts: freezed == parts
          ? _value._parts
          : parts // ignore: cast_nullable_to_non_nullable
              as List<Part>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PartsGroupImpl implements _PartsGroup {
  _$PartsGroupImpl(
      {@JsonKey(name: 'name') this.name,
      @JsonKey(name: 'number') this.number,
      @JsonKey(name: 'positionNumber') this.positionNumber,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'parts') final List<Part>? parts})
      : _parts = parts;

  factory _$PartsGroupImpl.fromJson(Map<String, dynamic> json) =>
      _$$PartsGroupImplFromJson(json);

  /// Название запчасти.
  @override
  @JsonKey(name: 'name')
  final String? name;

  /// Номер группы запчастей.
  @override
  @JsonKey(name: 'number')
  final String? number;

  /// Номер позиции группы запчастей на изображении.
  @override
  @JsonKey(name: 'positionNumber')
  final String? positionNumber;

  /// Описание группы запчастей.
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// Список деталей в группе.
  final List<Part>? _parts;

  /// Список деталей в группе.
  @override
  @JsonKey(name: 'parts')
  List<Part>? get parts {
    final value = _parts;
    if (value == null) return null;
    if (_parts is EqualUnmodifiableListView) return _parts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'PartsGroup(name: $name, number: $number, positionNumber: $positionNumber, description: $description, parts: $parts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PartsGroupImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.number, number) || other.number == number) &&
            (identical(other.positionNumber, positionNumber) ||
                other.positionNumber == positionNumber) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._parts, _parts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, number, positionNumber,
      description, const DeepCollectionEquality().hash(_parts));

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PartsGroupImplCopyWith<_$PartsGroupImpl> get copyWith =>
      __$$PartsGroupImplCopyWithImpl<_$PartsGroupImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PartsGroupImplToJson(
      this,
    );
  }
}

abstract class _PartsGroup implements PartsGroup {
  factory _PartsGroup(
      {@JsonKey(name: 'name') final String? name,
      @JsonKey(name: 'number') final String? number,
      @JsonKey(name: 'positionNumber') final String? positionNumber,
      @JsonKey(name: 'description') final String? description,
      @JsonKey(name: 'parts') final List<Part>? parts}) = _$PartsGroupImpl;

  factory _PartsGroup.fromJson(Map<String, dynamic> json) =
      _$PartsGroupImpl.fromJson;

  /// Название запчасти.
  @override
  @JsonKey(name: 'name')
  String? get name;

  /// Номер группы запчастей.
  @override
  @JsonKey(name: 'number')
  String? get number;

  /// Номер позиции группы запчастей на изображении.
  @override
  @JsonKey(name: 'positionNumber')
  String? get positionNumber;

  /// Описание группы запчастей.
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// Список деталей в группе.
  @override
  @JsonKey(name: 'parts')
  List<Part>? get parts;

  /// Create a copy of PartsGroup
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PartsGroupImplCopyWith<_$PartsGroupImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\parts_group.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parts_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PartsGroupImpl _$$PartsGroupImplFromJson(Map<String, dynamic> json) =>
    _$PartsGroupImpl(
      name: json['name'] as String?,
      number: json['number'] as String?,
      positionNumber: json['positionNumber'] as String?,
      description: json['description'] as String?,
      parts: (json['parts'] as List<dynamic>?)
          ?.map((e) => Part.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PartsGroupImplToJson(_$PartsGroupImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'number': instance.number,
      'positionNumber': instance.positionNumber,
      'description': instance.description,
      'parts': instance.parts,
    };

```

## lib\features\parts_catalog\models\position.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';
part 'position.g.dart';

/// {@template position}
/// Модель данных для позиции блока с номером на изображении.
/// {@endtemplate}
@freezed
class Position with _$Position {
  /// {@macro position}
  factory Position({
    /// Номер на изображении.
    @JsonKey(name: 'number') String? number,

    /// Координаты блока с номером на изображении (X, Y, H, W).
    @JsonKey(name: 'coordinates') List<double>? coordinates,
  }) = _Position;

  /// Преобразует JSON в объект [Position].
  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);
}

```

## lib\features\parts_catalog\models\position.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'position.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Position _$PositionFromJson(Map<String, dynamic> json) {
  return _Position.fromJson(json);
}

/// @nodoc
mixin _$Position {
  /// Номер на изображении.
  @JsonKey(name: 'number')
  String? get number => throw _privateConstructorUsedError;

  /// Координаты блока с номером на изображении (X, Y, H, W).
  @JsonKey(name: 'coordinates')
  List<double>? get coordinates => throw _privateConstructorUsedError;

  /// Serializes this Position to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PositionCopyWith<Position> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PositionCopyWith<$Res> {
  factory $PositionCopyWith(Position value, $Res Function(Position) then) =
      _$PositionCopyWithImpl<$Res, Position>;
  @useResult
  $Res call(
      {@JsonKey(name: 'number') String? number,
      @JsonKey(name: 'coordinates') List<double>? coordinates});
}

/// @nodoc
class _$PositionCopyWithImpl<$Res, $Val extends Position>
    implements $PositionCopyWith<$Res> {
  _$PositionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = freezed,
    Object? coordinates = freezed,
  }) {
    return _then(_value.copyWith(
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      coordinates: freezed == coordinates
          ? _value.coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<double>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PositionImplCopyWith<$Res>
    implements $PositionCopyWith<$Res> {
  factory _$$PositionImplCopyWith(
          _$PositionImpl value, $Res Function(_$PositionImpl) then) =
      __$$PositionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'number') String? number,
      @JsonKey(name: 'coordinates') List<double>? coordinates});
}

/// @nodoc
class __$$PositionImplCopyWithImpl<$Res>
    extends _$PositionCopyWithImpl<$Res, _$PositionImpl>
    implements _$$PositionImplCopyWith<$Res> {
  __$$PositionImplCopyWithImpl(
      _$PositionImpl _value, $Res Function(_$PositionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? number = freezed,
    Object? coordinates = freezed,
  }) {
    return _then(_$PositionImpl(
      number: freezed == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
              as String?,
      coordinates: freezed == coordinates
          ? _value._coordinates
          : coordinates // ignore: cast_nullable_to_non_nullable
              as List<double>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PositionImpl implements _Position {
  _$PositionImpl(
      {@JsonKey(name: 'number') this.number,
      @JsonKey(name: 'coordinates') final List<double>? coordinates})
      : _coordinates = coordinates;

  factory _$PositionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PositionImplFromJson(json);

  /// Номер на изображении.
  @override
  @JsonKey(name: 'number')
  final String? number;

  /// Координаты блока с номером на изображении (X, Y, H, W).
  final List<double>? _coordinates;

  /// Координаты блока с номером на изображении (X, Y, H, W).
  @override
  @JsonKey(name: 'coordinates')
  List<double>? get coordinates {
    final value = _coordinates;
    if (value == null) return null;
    if (_coordinates is EqualUnmodifiableListView) return _coordinates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Position(number: $number, coordinates: $coordinates)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PositionImpl &&
            (identical(other.number, number) || other.number == number) &&
            const DeepCollectionEquality()
                .equals(other._coordinates, _coordinates));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, number, const DeepCollectionEquality().hash(_coordinates));

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PositionImplCopyWith<_$PositionImpl> get copyWith =>
      __$$PositionImplCopyWithImpl<_$PositionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PositionImplToJson(
      this,
    );
  }
}

abstract class _Position implements Position {
  factory _Position(
          {@JsonKey(name: 'number') final String? number,
          @JsonKey(name: 'coordinates') final List<double>? coordinates}) =
      _$PositionImpl;

  factory _Position.fromJson(Map<String, dynamic> json) =
      _$PositionImpl.fromJson;

  /// Номер на изображении.
  @override
  @JsonKey(name: 'number')
  String? get number;

  /// Координаты блока с номером на изображении (X, Y, H, W).
  @override
  @JsonKey(name: 'coordinates')
  List<double>? get coordinates;

  /// Create a copy of Position
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PositionImplCopyWith<_$PositionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\position.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'position.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PositionImpl _$$PositionImplFromJson(Map<String, dynamic> json) =>
    _$PositionImpl(
      number: json['number'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );

Map<String, dynamic> _$$PositionImplToJson(_$PositionImpl instance) =>
    <String, dynamic>{
      'number': instance.number,
      'coordinates': instance.coordinates,
    };

```

## lib\features\parts_catalog\models\schema_model.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/features/parts_catalog/models/part_name.dart';

part 'schema_model.freezed.dart';
part 'schema_model.g.dart';

/// {@template schema_model}
/// Модель данных для схемы.
/// {@endtemplate}
@freezed
class SchemaModel with _$SchemaModel {
  /// {@macro schema_model}
  factory SchemaModel({
    /// Идентификатор группы.
    @JsonKey(name: 'groupId') required String groupId,

    /// URL изображения.
    @JsonKey(name: 'img') String? img,

    /// Название.
    @JsonKey(name: 'name') required String name,

    /// Описание.
    @JsonKey(name: 'description') String? description,

    /// Список названий деталей.
    @JsonKey(name: 'partNames') List<PartName>? partNames,
  }) = _SchemaModel;

  /// Преобразует JSON в объект [SchemaModel].
  factory SchemaModel.fromJson(Map<String, dynamic> json) =>
      _$SchemaModelFromJson(json);
}

```

## lib\features\parts_catalog\models\schema_model.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schema_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SchemaModel _$SchemaModelFromJson(Map<String, dynamic> json) {
  return _SchemaModel.fromJson(json);
}

/// @nodoc
mixin _$SchemaModel {
  /// Идентификатор группы.
  @JsonKey(name: 'groupId')
  String get groupId => throw _privateConstructorUsedError;

  /// URL изображения.
  @JsonKey(name: 'img')
  String? get img => throw _privateConstructorUsedError;

  /// Название.
  @JsonKey(name: 'name')
  String get name => throw _privateConstructorUsedError;

  /// Описание.
  @JsonKey(name: 'description')
  String? get description => throw _privateConstructorUsedError;

  /// Список названий деталей.
  @JsonKey(name: 'partNames')
  List<PartName>? get partNames => throw _privateConstructorUsedError;

  /// Serializes this SchemaModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SchemaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SchemaModelCopyWith<SchemaModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchemaModelCopyWith<$Res> {
  factory $SchemaModelCopyWith(
          SchemaModel value, $Res Function(SchemaModel) then) =
      _$SchemaModelCopyWithImpl<$Res, SchemaModel>;
  @useResult
  $Res call(
      {@JsonKey(name: 'groupId') String groupId,
      @JsonKey(name: 'img') String? img,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'partNames') List<PartName>? partNames});
}

/// @nodoc
class _$SchemaModelCopyWithImpl<$Res, $Val extends SchemaModel>
    implements $SchemaModelCopyWith<$Res> {
  _$SchemaModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SchemaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? img = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? partNames = freezed,
  }) {
    return _then(_value.copyWith(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      partNames: freezed == partNames
          ? _value.partNames
          : partNames // ignore: cast_nullable_to_non_nullable
              as List<PartName>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SchemaModelImplCopyWith<$Res>
    implements $SchemaModelCopyWith<$Res> {
  factory _$$SchemaModelImplCopyWith(
          _$SchemaModelImpl value, $Res Function(_$SchemaModelImpl) then) =
      __$$SchemaModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'groupId') String groupId,
      @JsonKey(name: 'img') String? img,
      @JsonKey(name: 'name') String name,
      @JsonKey(name: 'description') String? description,
      @JsonKey(name: 'partNames') List<PartName>? partNames});
}

/// @nodoc
class __$$SchemaModelImplCopyWithImpl<$Res>
    extends _$SchemaModelCopyWithImpl<$Res, _$SchemaModelImpl>
    implements _$$SchemaModelImplCopyWith<$Res> {
  __$$SchemaModelImplCopyWithImpl(
      _$SchemaModelImpl _value, $Res Function(_$SchemaModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SchemaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groupId = null,
    Object? img = freezed,
    Object? name = null,
    Object? description = freezed,
    Object? partNames = freezed,
  }) {
    return _then(_$SchemaModelImpl(
      groupId: null == groupId
          ? _value.groupId
          : groupId // ignore: cast_nullable_to_non_nullable
              as String,
      img: freezed == img
          ? _value.img
          : img // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      partNames: freezed == partNames
          ? _value._partNames
          : partNames // ignore: cast_nullable_to_non_nullable
              as List<PartName>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchemaModelImpl implements _SchemaModel {
  _$SchemaModelImpl(
      {@JsonKey(name: 'groupId') required this.groupId,
      @JsonKey(name: 'img') this.img,
      @JsonKey(name: 'name') required this.name,
      @JsonKey(name: 'description') this.description,
      @JsonKey(name: 'partNames') final List<PartName>? partNames})
      : _partNames = partNames;

  factory _$SchemaModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchemaModelImplFromJson(json);

  /// Идентификатор группы.
  @override
  @JsonKey(name: 'groupId')
  final String groupId;

  /// URL изображения.
  @override
  @JsonKey(name: 'img')
  final String? img;

  /// Название.
  @override
  @JsonKey(name: 'name')
  final String name;

  /// Описание.
  @override
  @JsonKey(name: 'description')
  final String? description;

  /// Список названий деталей.
  final List<PartName>? _partNames;

  /// Список названий деталей.
  @override
  @JsonKey(name: 'partNames')
  List<PartName>? get partNames {
    final value = _partNames;
    if (value == null) return null;
    if (_partNames is EqualUnmodifiableListView) return _partNames;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SchemaModel(groupId: $groupId, img: $img, name: $name, description: $description, partNames: $partNames)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchemaModelImpl &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.img, img) || other.img == img) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._partNames, _partNames));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, groupId, img, name, description,
      const DeepCollectionEquality().hash(_partNames));

  /// Create a copy of SchemaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SchemaModelImplCopyWith<_$SchemaModelImpl> get copyWith =>
      __$$SchemaModelImplCopyWithImpl<_$SchemaModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchemaModelImplToJson(
      this,
    );
  }
}

abstract class _SchemaModel implements SchemaModel {
  factory _SchemaModel(
          {@JsonKey(name: 'groupId') required final String groupId,
          @JsonKey(name: 'img') final String? img,
          @JsonKey(name: 'name') required final String name,
          @JsonKey(name: 'description') final String? description,
          @JsonKey(name: 'partNames') final List<PartName>? partNames}) =
      _$SchemaModelImpl;

  factory _SchemaModel.fromJson(Map<String, dynamic> json) =
      _$SchemaModelImpl.fromJson;

  /// Идентификатор группы.
  @override
  @JsonKey(name: 'groupId')
  String get groupId;

  /// URL изображения.
  @override
  @JsonKey(name: 'img')
  String? get img;

  /// Название.
  @override
  @JsonKey(name: 'name')
  String get name;

  /// Описание.
  @override
  @JsonKey(name: 'description')
  String? get description;

  /// Список названий деталей.
  @override
  @JsonKey(name: 'partNames')
  List<PartName>? get partNames;

  /// Create a copy of SchemaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SchemaModelImplCopyWith<_$SchemaModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\schema_model.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SchemaModelImpl _$$SchemaModelImplFromJson(Map<String, dynamic> json) =>
    _$SchemaModelImpl(
      groupId: json['groupId'] as String,
      img: json['img'] as String?,
      name: json['name'] as String,
      description: json['description'] as String?,
      partNames: (json['partNames'] as List<dynamic>?)
          ?.map((e) => PartName.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SchemaModelImplToJson(_$SchemaModelImpl instance) =>
    <String, dynamic>{
      'groupId': instance.groupId,
      'img': instance.img,
      'name': instance.name,
      'description': instance.description,
      'partNames': instance.partNames,
    };

```

## lib\features\parts_catalog\models\schemas_response.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:part_catalog/features/parts_catalog/models/group.dart';
import 'package:part_catalog/features/parts_catalog/models/schema_model.dart';

part 'schemas_response.freezed.dart';
part 'schemas_response.g.dart';

/// {@template schemas_response}
/// Модель данных для ответа со схемами.
/// {@endtemplate}
@freezed
class SchemasResponse with _$SchemasResponse {
  /// {@macro schemas_response}
  factory SchemasResponse({
    /// Группа (может быть null).
    @JsonKey(name: 'group') Group? group,

    /// Список схем.
    @JsonKey(name: 'list') List<SchemaModel>? list,
  }) = _SchemasResponse;

  /// Преобразует JSON в объект [SchemasResponse].
  factory SchemasResponse.fromJson(Map<String, dynamic> json) =>
      _$SchemasResponseFromJson(json);
}

```

## lib\features\parts_catalog\models\schemas_response.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schemas_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SchemasResponse _$SchemasResponseFromJson(Map<String, dynamic> json) {
  return _SchemasResponse.fromJson(json);
}

/// @nodoc
mixin _$SchemasResponse {
  /// Группа (может быть null).
  @JsonKey(name: 'group')
  Group? get group => throw _privateConstructorUsedError;

  /// Список схем.
  @JsonKey(name: 'list')
  List<SchemaModel>? get list => throw _privateConstructorUsedError;

  /// Serializes this SchemasResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SchemasResponseCopyWith<SchemasResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SchemasResponseCopyWith<$Res> {
  factory $SchemasResponseCopyWith(
          SchemasResponse value, $Res Function(SchemasResponse) then) =
      _$SchemasResponseCopyWithImpl<$Res, SchemasResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'group') Group? group,
      @JsonKey(name: 'list') List<SchemaModel>? list});

  $GroupCopyWith<$Res>? get group;
}

/// @nodoc
class _$SchemasResponseCopyWithImpl<$Res, $Val extends SchemasResponse>
    implements $SchemasResponseCopyWith<$Res> {
  _$SchemasResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? group = freezed,
    Object? list = freezed,
  }) {
    return _then(_value.copyWith(
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as Group?,
      list: freezed == list
          ? _value.list
          : list // ignore: cast_nullable_to_non_nullable
              as List<SchemaModel>?,
    ) as $Val);
  }

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GroupCopyWith<$Res>? get group {
    if (_value.group == null) {
      return null;
    }

    return $GroupCopyWith<$Res>(_value.group!, (value) {
      return _then(_value.copyWith(group: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SchemasResponseImplCopyWith<$Res>
    implements $SchemasResponseCopyWith<$Res> {
  factory _$$SchemasResponseImplCopyWith(_$SchemasResponseImpl value,
          $Res Function(_$SchemasResponseImpl) then) =
      __$$SchemasResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'group') Group? group,
      @JsonKey(name: 'list') List<SchemaModel>? list});

  @override
  $GroupCopyWith<$Res>? get group;
}

/// @nodoc
class __$$SchemasResponseImplCopyWithImpl<$Res>
    extends _$SchemasResponseCopyWithImpl<$Res, _$SchemasResponseImpl>
    implements _$$SchemasResponseImplCopyWith<$Res> {
  __$$SchemasResponseImplCopyWithImpl(
      _$SchemasResponseImpl _value, $Res Function(_$SchemasResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? group = freezed,
    Object? list = freezed,
  }) {
    return _then(_$SchemasResponseImpl(
      group: freezed == group
          ? _value.group
          : group // ignore: cast_nullable_to_non_nullable
              as Group?,
      list: freezed == list
          ? _value._list
          : list // ignore: cast_nullable_to_non_nullable
              as List<SchemaModel>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SchemasResponseImpl implements _SchemasResponse {
  _$SchemasResponseImpl(
      {@JsonKey(name: 'group') this.group,
      @JsonKey(name: 'list') final List<SchemaModel>? list})
      : _list = list;

  factory _$SchemasResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SchemasResponseImplFromJson(json);

  /// Группа (может быть null).
  @override
  @JsonKey(name: 'group')
  final Group? group;

  /// Список схем.
  final List<SchemaModel>? _list;

  /// Список схем.
  @override
  @JsonKey(name: 'list')
  List<SchemaModel>? get list {
    final value = _list;
    if (value == null) return null;
    if (_list is EqualUnmodifiableListView) return _list;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SchemasResponse(group: $group, list: $list)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SchemasResponseImpl &&
            (identical(other.group, group) || other.group == group) &&
            const DeepCollectionEquality().equals(other._list, _list));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, group, const DeepCollectionEquality().hash(_list));

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SchemasResponseImplCopyWith<_$SchemasResponseImpl> get copyWith =>
      __$$SchemasResponseImplCopyWithImpl<_$SchemasResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SchemasResponseImplToJson(
      this,
    );
  }
}

abstract class _SchemasResponse implements SchemasResponse {
  factory _SchemasResponse(
          {@JsonKey(name: 'group') final Group? group,
          @JsonKey(name: 'list') final List<SchemaModel>? list}) =
      _$SchemasResponseImpl;

  factory _SchemasResponse.fromJson(Map<String, dynamic> json) =
      _$SchemasResponseImpl.fromJson;

  /// Группа (может быть null).
  @override
  @JsonKey(name: 'group')
  Group? get group;

  /// Список схем.
  @override
  @JsonKey(name: 'list')
  List<SchemaModel>? get list;

  /// Create a copy of SchemasResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SchemasResponseImplCopyWith<_$SchemasResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\schemas_response.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemas_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SchemasResponseImpl _$$SchemasResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$SchemasResponseImpl(
      group: json['group'] == null
          ? null
          : Group.fromJson(json['group'] as Map<String, dynamic>),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => SchemaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$SchemasResponseImplToJson(
        _$SchemasResponseImpl instance) =>
    <String, dynamic>{
      'group': instance.group,
      'list': instance.list,
    };

```

## lib\features\parts_catalog\models\suggest.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'suggest.freezed.dart';
part 'suggest.g.dart';

/// {@template suggest}
/// Модель данных для подсказки.
/// {@endtemplate}
@freezed
class Suggest with _$Suggest {
  /// {@macro suggest}
  factory Suggest({
    /// Идентификатор поиска.
    @JsonKey(name: 'sid') String? sid,

    /// Название.
    @JsonKey(name: 'name') String? name,
  }) = _Suggest;

  /// Преобразует JSON в объект [Suggest].
  factory Suggest.fromJson(Map<String, dynamic> json) =>
      _$SuggestFromJson(json);
}

```

## lib\features\parts_catalog\models\suggest.freezed.dart
```dart
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'suggest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Suggest _$SuggestFromJson(Map<String, dynamic> json) {
  return _Suggest.fromJson(json);
}

/// @nodoc
mixin _$Suggest {
  /// Идентификатор поиска.
  @JsonKey(name: 'sid')
  String? get sid => throw _privateConstructorUsedError;

  /// Название.
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;

  /// Serializes this Suggest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Suggest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SuggestCopyWith<Suggest> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SuggestCopyWith<$Res> {
  factory $SuggestCopyWith(Suggest value, $Res Function(Suggest) then) =
      _$SuggestCopyWithImpl<$Res, Suggest>;
  @useResult
  $Res call(
      {@JsonKey(name: 'sid') String? sid, @JsonKey(name: 'name') String? name});
}

/// @nodoc
class _$SuggestCopyWithImpl<$Res, $Val extends Suggest>
    implements $SuggestCopyWith<$Res> {
  _$SuggestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Suggest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sid = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      sid: freezed == sid
          ? _value.sid
          : sid // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SuggestImplCopyWith<$Res> implements $SuggestCopyWith<$Res> {
  factory _$$SuggestImplCopyWith(
          _$SuggestImpl value, $Res Function(_$SuggestImpl) then) =
      __$$SuggestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'sid') String? sid, @JsonKey(name: 'name') String? name});
}

/// @nodoc
class __$$SuggestImplCopyWithImpl<$Res>
    extends _$SuggestCopyWithImpl<$Res, _$SuggestImpl>
    implements _$$SuggestImplCopyWith<$Res> {
  __$$SuggestImplCopyWithImpl(
      _$SuggestImpl _value, $Res Function(_$SuggestImpl) _then)
      : super(_value, _then);

  /// Create a copy of Suggest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sid = freezed,
    Object? name = freezed,
  }) {
    return _then(_$SuggestImpl(
      sid: freezed == sid
          ? _value.sid
          : sid // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SuggestImpl implements _Suggest {
  _$SuggestImpl(
      {@JsonKey(name: 'sid') this.sid, @JsonKey(name: 'name') this.name});

  factory _$SuggestImpl.fromJson(Map<String, dynamic> json) =>
      _$$SuggestImplFromJson(json);

  /// Идентификатор поиска.
  @override
  @JsonKey(name: 'sid')
  final String? sid;

  /// Название.
  @override
  @JsonKey(name: 'name')
  final String? name;

  @override
  String toString() {
    return 'Suggest(sid: $sid, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuggestImpl &&
            (identical(other.sid, sid) || other.sid == sid) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sid, name);

  /// Create a copy of Suggest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuggestImplCopyWith<_$SuggestImpl> get copyWith =>
      __$$SuggestImplCopyWithImpl<_$SuggestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SuggestImplToJson(
      this,
    );
  }
}

abstract class _Suggest implements Suggest {
  factory _Suggest(
      {@JsonKey(name: 'sid') final String? sid,
      @JsonKey(name: 'name') final String? name}) = _$SuggestImpl;

  factory _Suggest.fromJson(Map<String, dynamic> json) = _$SuggestImpl.fromJson;

  /// Идентификатор поиска.
  @override
  @JsonKey(name: 'sid')
  String? get sid;

  /// Название.
  @override
  @JsonKey(name: 'name')
  String? get name;

  /// Create a copy of Suggest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuggestImplCopyWith<_$SuggestImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

```

## lib\features\parts_catalog\models\suggest.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SuggestImpl _$$SuggestImplFromJson(Map<String, dynamic> json) =>
    _$SuggestImpl(
      sid: json['sid'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$$SuggestImplToJson(_$SuggestImpl instance) =>
    <String, dynamic>{
      'sid': instance.sid,
      'name': instance.name,
    };

```

## lib\features\parts_catalog\widgets\car_info_widget.dart
```dart
import 'package:flutter/material.dart';
import 'package:part_catalog/features/parts_catalog/api/api_client_parts_catalogs.dart'; // Import ApiClientPartsCatalogs
import 'package:part_catalog/features/parts_catalog/models/car_info.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:get_it/get_it.dart'; // Import get_it

/// {@template car_info_widget}
/// Виджет для отображения информации об автомобиле по VIN или FRAME.
/// {@endtemplate}
class CarInfoWidget extends StatefulWidget {
  /// {@macro car_info_widget}
  const CarInfoWidget({super.key, required this.vinOrFrame});

  /// VIN или FRAME автомобиля.
  final String vinOrFrame;

  @override
  State<CarInfoWidget> createState() => _CarInfoWidgetState();
}

class _CarInfoWidgetState extends State<CarInfoWidget> {
  //late ApiClientPartsCatalogs apiClient; // No need to declare here
  List<CarInfo> carInfos = [];
  String apiKey = dotenv.env['API_KEY'] ?? 'YOUR_API_KEY';
  final String language = 'en';
  final logger = Logger();
  late Future<List<CarInfo>> _carInfoFuture;

  @override
  void initState() {
    super.initState();
    _carInfoFuture = fetchCarInfo();
  }

  /// Получает информацию об автомобиле из API.
  Future<List<CarInfo>> fetchCarInfo() async {
    try {
      final apiClient = GetIt.instance<
          ApiClientPartsCatalogs>(); // Get ApiClientPartsCatalogs from get_it
      return await apiClient.getCarInfo(
          widget.vinOrFrame, null, apiKey, language);
    } catch (e) {
      logger.e('Error fetching car info: $e');
      return Future.error(e); // Пробрасываем ошибку для FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CarInfo>>(
      future: _carInfoFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          carInfos = snapshot.data!;
          if (carInfos.isEmpty) {
            return const Center(child: Text('No car info found.'));
          }
          return ListView.builder(
            itemCount: carInfos.length,
            itemBuilder: (context, index) {
              final carInfo = carInfos[index];
              return CarInfoCard(
                  carInfo:
                      carInfo); // Используем отдельный виджет для отображения информации об автомобиле
            },
          );
        } else {
          return const Center(child: Text('No car info available.'));
        }
      },
    );
  }
}

/// {@template car_info_card}
/// Виджет для отображения карточки с информацией об автомобиле.
/// {@endtemplate}
class CarInfoCard extends StatelessWidget {
  /// {@macro car_info_card}
  const CarInfoCard({super.key, required this.carInfo});

  /// Информация об автомобиле.
  final CarInfo carInfo;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${carInfo.title ?? 'N/A'}'),
            Text('Catalog ID: ${carInfo.catalogId ?? 'N/A'}'),
            Text('Brand: ${carInfo.brand ?? 'N/A'}'),
            Text('Model ID: ${carInfo.modelId ?? 'N/A'}'),
            Text('Car ID: ${carInfo.carId ?? 'N/A'}'),
            Text('VIN: ${carInfo.vin ?? 'N/A'}'),
            Text('Frame: ${carInfo.frame ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}

```

## lib\features\parts_catalog\widgets\schema_list_widget.dart
```dart
import 'package:flutter/material.dart';
import 'package:part_catalog/features/parts_catalog/api/api_client_parts_catalogs.dart'; // Import ApiClientPartsCatalogs
import 'package:part_catalog/features/parts_catalog/models/schemas_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:get_it/get_it.dart'; // Import get_it

/// {@template schema_list_widget}
/// Виджет для отображения списка схем.
/// {@endtemplate}
class SchemaListWidget extends StatefulWidget {
  /// {@macro schema_list_widget}
  const SchemaListWidget({
    super.key,
    required this.catalogId,
    required this.carId,
  });

  /// Идентификатор каталога.
  final String catalogId;

  /// Идентификатор автомобиля.
  final String carId;

  @override
  State<SchemaListWidget> createState() => _SchemaListWidgetState();
}

class _SchemaListWidgetState extends State<SchemaListWidget> {
  //late ApiClientPartsCatalogs apiClient; // Больше не нужно объявлять здесь
  SchemasResponse? schemasResponse;
  String apiKey = dotenv.env['API_KEY'] ?? 'YOUR_API_KEY';
  final String language = 'en';
  final logger = Logger();
  late Future<SchemasResponse?> _schemasFuture; // Future for schemas

  @override
  void initState() {
    super.initState();
    _schemasFuture = fetchSchemas(); // Initialize the future
  }

  /// Получает схемы из API.
  Future<SchemasResponse?> fetchSchemas() async {
    try {
      final apiClient = GetIt.instance<
          ApiClientPartsCatalogs>(); // Get ApiClientPartsCatalogs from get_it
      return await apiClient.getSchemas(
        widget.catalogId,
        widget.carId,
        null,
        null,
        null,
        null,
        null,
        apiKey,
        language,
      );
    } catch (e) {
      logger.e('Error fetching schemas: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SchemasResponse?>(
      future: _schemasFuture, // Use the initialized future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final schemas = snapshot.data?.list;
          if (schemas == null || schemas.isEmpty) {
            return const Center(child: Text('No schemas available.'));
          }
          return ListView.builder(
            itemCount: schemas.length,
            itemBuilder: (context, index) {
              final schema = schemas[index];
              return ListTile(
                title: Text(schema.name),
                subtitle: Text(schema.description ?? ''),
              );
            },
          );
        } else {
          return const Center(child: Text('No schemas available.'));
        }
      },
    );
  }
}

```

## lib\features\suppliers\models\price_offer.dart
```dart
import 'package:json_annotation/json_annotation.dart';

part 'price_offer.g.dart';

/// {@template price_offer}
/// Модель данных для представления предложения цены.
/// {@endtemplate}
@JsonSerializable()
class PriceOffer {
  /// {@macro price_offer}
  PriceOffer({
    required this.partNumber,
    required this.price,
    required this.deliveryTime,
    required this.supplierId,
  });

  /// Артикул запчасти.
  @JsonKey(name: 'partNumber')
  final String partNumber;

  /// Цена.
  @JsonKey(name: 'price')
  final double price;

  /// Срок поставки.
  @JsonKey(name: 'deliveryTime')
  final String deliveryTime;

  /// Идентификатор поставщика.
  @JsonKey(name: 'supplierId')
  final String supplierId;

  /// Преобразование JSON в объект `PriceOffer`.
  factory PriceOffer.fromJson(Map<String, dynamic> json) =>
      _$PriceOfferFromJson(json);

  /// Преобразование объекта `PriceOffer` в JSON.
  Map<String, dynamic> toJson() => _$PriceOfferToJson(this);
}

```

## lib\features\suppliers\models\price_offer.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PriceOffer _$PriceOfferFromJson(Map<String, dynamic> json) => PriceOffer(
      partNumber: json['partNumber'] as String,
      price: (json['price'] as num).toDouble(),
      deliveryTime: json['deliveryTime'] as String,
      supplierId: json['supplierId'] as String,
    );

Map<String, dynamic> _$PriceOfferToJson(PriceOffer instance) =>
    <String, dynamic>{
      'partNumber': instance.partNumber,
      'price': instance.price,
      'deliveryTime': instance.deliveryTime,
      'supplierId': instance.supplierId,
    };

```

## lib\features\suppliers\models\supplier.dart
```dart
import 'package:json_annotation/json_annotation.dart';

part 'supplier.g.dart';

/// {@template supplier}
/// Модель данных для представления поставщика.
/// {@endtemplate}
@JsonSerializable()
class Supplier {
  /// {@macro supplier}
  Supplier({
    required this.id,
    required this.name,
    required this.contactInfo,
  });

  /// Уникальный идентификатор поставщика.
  @JsonKey(name: 'id')
  final String id;

  /// Название поставщика.
  @JsonKey(name: 'name')
  final String name;

  /// Контактная информация.
  @JsonKey(name: 'contactInfo')
  final String contactInfo;

  /// Преобразование JSON в объект `Supplier`.
  factory Supplier.fromJson(Map<String, dynamic> json) =>
      _$SupplierFromJson(json);

  /// Преобразование объекта `Supplier` в JSON.
  Map<String, dynamic> toJson() => _$SupplierToJson(this);
}

```

## lib\features\suppliers\models\supplier.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Supplier _$SupplierFromJson(Map<String, dynamic> json) => Supplier(
      id: json['id'] as String,
      name: json['name'] as String,
      contactInfo: json['contactInfo'] as String,
    );

Map<String, dynamic> _$SupplierToJson(Supplier instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'contactInfo': instance.contactInfo,
    };

```

## lib\features\vehicles\models\car.dart
```dart
import 'package:json_annotation/json_annotation.dart';

part 'car.g.dart';

/// {@template car}
/// Модель данных для представления автомобиля.
/// {@endtemplate}
@JsonSerializable()
class CarModel {
  /// {@macro car}
  CarModel({
    required this.id, //test
    required this.clientId,
    required this.vin,
    required this.make,
    required this.model,
    required this.year,
    this.licensePlate,
    this.additionalInfo,
  });

  /// Уникальный идентификатор автомобиля.
  @JsonKey(name: 'id')
  final String id;

  /// Идентификатор клиента-владельца.
  @JsonKey(name: 'clientId')
  final String clientId;

  /// VIN-код.
  @JsonKey(name: 'vin')
  final String vin;

  /// Марка автомобиля.
  @JsonKey(name: 'make')
  final String make;

  /// Модель автомобиля.
  @JsonKey(name: 'model')
  final String model;

  /// Год выпуска.
  @JsonKey(name: 'year')
  final int year;

  /// Номерной знак.
  @JsonKey(name: 'licensePlate')
  final String? licensePlate;

  /// Дополнительная информация.
  @JsonKey(name: 'additionalInfo')
  final String? additionalInfo;

  /// Преобразование JSON в объект `Car`.
  factory CarModel.fromJson(Map<String, dynamic> json) =>
      _$CarModelFromJson(json);

  /// Преобразование объекта `Car` в JSON.
  Map<String, dynamic> toJson() => _$CarModelToJson(this);
}

```

## lib\features\vehicles\models\car.g.dart
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarModel _$CarModelFromJson(Map<String, dynamic> json) => CarModel(
      id: json['id'] as String,
      clientId: json['clientId'] as String,
      vin: json['vin'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      year: (json['year'] as num).toInt(),
      licensePlate: json['licensePlate'] as String?,
      additionalInfo: json['additionalInfo'] as String?,
    );

Map<String, dynamic> _$CarModelToJson(CarModel instance) => <String, dynamic>{
      'id': instance.id,
      'clientId': instance.clientId,
      'vin': instance.vin,
      'make': instance.make,
      'model': instance.model,
      'year': instance.year,
      'licensePlate': instance.licensePlate,
      'additionalInfo': instance.additionalInfo,
    };

```

## lib\features\vehicles\screens\cars_screen.dart
```dart
import 'package:flutter/material.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/clients/models/client.dart';
import 'package:part_catalog/features/vehicles/models/car.dart';
import 'package:part_catalog/features/vehicles/services/car_service.dart';
import 'package:part_catalog/features/clients/services/client_service.dart';

class CarsScreen extends StatefulWidget {
  const CarsScreen({super.key});

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  final _carService = locator<CarService>();
  final _clientService = locator<ClientService>();
  bool _isDbError = false;

  // Опционально: фильтр по клиенту
  int? _selectedClientId;

  @override
  Widget build(BuildContext context) {
    if (_isDbError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ошибка базы данных')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Ошибка доступа к базе данных'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Получаем ScaffoldMessengerState до асинхронной операции
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  try {
                    // Сбрасываем базу данных
                    final db = locator<AppDatabase>();
                    await db.resetDatabase();

                    // Обновляем экземпляры в сервис-локаторе
                    locator.unregister<AppDatabase>();
                    locator.registerSingleton<AppDatabase>(AppDatabase());

                    // Обновляем все сервисы, зависящие от БД
                    locator.unregister<ClientService>();
                    locator.unregister<CarService>();
                    locator.registerLazySingleton<ClientService>(
                        () => ClientService(locator<AppDatabase>()));
                    locator.registerLazySingleton<CarService>(
                        () => CarService(locator<AppDatabase>()));

                    setState(() {
                      _isDbError = false;
                    });

                    // Используем сохраненный scaffoldMessenger
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                          content: Text('База данных успешно сброшена')),
                    );
                  } catch (e) {
                    // Показываем сообщение об ошибке
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                          content: Text('Ошибка при сбросе базы данных: $e')),
                    );
                  }
                },
                child: const Text('Сбросить базу данных'),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Автомобили'),
        actions: [
          // Опционально: кнопка для сброса фильтра по клиенту
          if (_selectedClientId != null)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              onPressed: () => setState(() => _selectedClientId = null),
              tooltip: 'Сбросить фильтр',
            ),
        ],
      ),
      // Используем StreamBuilder для реактивного обновления списка автомобилей
      body: StreamBuilder<List<CarModel>>(
        // Выбираем источник данных в зависимости от наличия фильтра
        stream: _selectedClientId != null
            ? _carService.watchClientCars(_selectedClientId!)
            : _carService.watchCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Проверяем, связана ли ошибка с отсутствием таблицы
            if (snapshot.error.toString().contains('no such table')) {
              // Устанавливаем флаг ошибки БД, который перерисует виджет
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isDbError = true;
                });
              });
            }
            return Center(
              child: Text(
                'Ошибка загрузки данных: ${snapshot.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          final cars = snapshot.data ?? [];

          if (cars.isEmpty) {
            return const Center(
              child: Text(
                  'Список автомобилей пуст. Добавьте автомобиль, нажав на кнопку "+"'),
            );
          }

          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];

              return Dismissible(
                key: Key(car.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Удалить автомобиль?'),
                            content: Text(
                                'Вы действительно хотите удалить автомобиль ${car.make} ${car.model}?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Отмена'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Удалить'),
                              ),
                            ],
                          );
                        },
                      ) ??
                      false;
                },
                onDismissed: (direction) {
                  _carService.deleteCar(int.parse(car.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Автомобиль ${car.make} ${car.model} удален')),
                  );
                },
                child: FutureBuilder(
                  // Получаем информацию о клиенте для отображения
                  future: _clientService.getClientById(int.parse(car.clientId)),
                  builder: (context, clientSnapshot) {
                    final clientName =
                        clientSnapshot.data?.name ?? 'Загрузка...';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.directions_car,
                            color: Colors.white),
                      ),
                      title: Text('${car.make} ${car.model}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Клиент: $clientName'),
                          if (car.vin.isNotEmpty == true)
                            Text('VIN: ${car.vin}'),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _editCar(car),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCar,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addCar() async {
    final newCar = await _showCarDialog(context);
    if (newCar != null) {
      await _carService.addCar(newCar);
    }
  }

  Future<void> _editCar(CarModel car) async {
    final updatedCar = await _showCarDialog(context, car: car);
    if (updatedCar != null) {
      await _carService.updateCar(updatedCar);
    }
  }

  /// Показывает диалог для добавления/редактирования автомобиля.
  ///
  /// [car] - существующий автомобиль для редактирования, null для нового автомобиля.
  ///
  /// Возвращает новый или обновленный объект [CarModel] или null, если отменено.
  Future<CarModel?> _showCarDialog(BuildContext context,
      {CarModel? car}) async {
    // Создаём контроллеры для полей ввода с начальными значениями из автомобиля (если есть)
    final makeController = TextEditingController(text: car?.make);
    final modelController = TextEditingController(text: car?.model);
    final yearController = TextEditingController(
      text: car?.year != null && car!.year > 0 ? car.year.toString() : '',
    );
    final vinController = TextEditingController(text: car?.vin);
    final licensePlateController =
        TextEditingController(text: car?.licensePlate);
    final additionalInfoController =
        TextEditingController(text: car?.additionalInfo);

    // Выбранный клиент (владелец автомобиля)
    Client? selectedClient;
    String? selectedClientId = car?.clientId;

    // Список всех клиентов для выбора
    List<Client> clients = [];

    // Состояние валидации формы
    bool isValid =
        car != null; // для новых автомобилей изначально невалидная форма
    bool isLoading = true; // состояние загрузки списка клиентов

    // Создаём ключ для формы (для валидации)
    final formKey = GlobalKey<FormState>();

    return showDialog<CarModel>(
      context: context,
      builder: (BuildContext context) {
        // Используем StatefulBuilder для обновления состояния диалога
        return StatefulBuilder(
          builder: (context, setState) {
            // Загружаем список клиентов, если еще не загружен
            if (isLoading) {
              // Запускаем асинхронную загрузку клиентов
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                // Сохраняем ссылку на ScaffoldMessengerState до выполнения асинхронных операций
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                // Сохраняем ссылку на Navigator до вызова pop()
                final navigator = Navigator.of(context);

                try {
                  final loadedClients = await _clientService.getAllClients();

                  // Проверяем, что виджет все еще в дереве виджетов
                  if (mounted) {
                    setState(() {
                      clients = loadedClients;
                      isLoading = false;

                      // Если редактируем существующую машину, выбираем текущего владельца
                      if (selectedClientId != null) {
                        selectedClient = clients
                            .where((c) => c.id.toString() == selectedClientId)
                            .firstOrNull;
                      }

                      // Если клиент не выбран или не найден, и список не пуст, выбираем первого
                      if ((selectedClient == null) && clients.isNotEmpty) {
                        selectedClient = clients.first;
                        selectedClientId = clients.first.id.toString();
                      }
                    });
                  }
                } catch (error) {
                  // Проверяем, что виджет все еще в дереве виджетов
                  if (mounted) {
                    // Используем сохраненную ссылку вместо получения новой
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                          content: Text('Ошибка загрузки клиентов: $error')),
                    );
                    navigator.pop(); // закрываем диалог при ошибке
                  }
                }
              });
            }

            // Функция валидации формы
            void validateForm() {
              setState(() {
                isValid = formKey.currentState?.validate() ?? false;
                isValid = isValid && selectedClient != null;
              });
            }

            return AlertDialog(
              title: Text(car == null
                  ? 'Добавить автомобиль'
                  : 'Редактировать автомобиль'),
              content: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: formKey,
                      onChanged: validateForm,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Выпадающий список для выбора владельца
                            DropdownButtonFormField<Client>(
                              value: selectedClient,
                              decoration: const InputDecoration(
                                labelText: 'Владелец автомобиля',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              items: clients.map((client) {
                                return DropdownMenuItem<Client>(
                                  value: client,
                                  child: Text(client.name),
                                );
                              }).toList(),
                              onChanged: (Client? value) {
                                setState(() {
                                  selectedClient = value;
                                  selectedClientId = value?.id.toString();
                                  validateForm();
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Необходимо выбрать владельца';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Поле ввода марки автомобиля
                            TextFormField(
                              controller: makeController,
                              decoration: const InputDecoration(
                                labelText: 'Марка автомобиля',
                                prefixIcon: Icon(Icons.directions_car),
                                border: OutlineInputBorder(),
                                hintText: 'Например: Toyota',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Поле обязательно для заполнения';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                            ),

                            const SizedBox(height: 16),

                            // Поле ввода модели автомобиля
                            TextFormField(
                              controller: modelController,
                              decoration: const InputDecoration(
                                labelText: 'Модель автомобиля',
                                prefixIcon: Icon(Icons.directions_car_filled),
                                border: OutlineInputBorder(),
                                hintText: 'Например: Camry',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Поле обязательно для заполнения';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                            ),

                            const SizedBox(height: 16),

                            // Поля для года выпуска и VIN в одной строке
                            Row(
                              children: [
                                // Год выпуска
                                Expanded(
                                  child: TextFormField(
                                    controller: yearController,
                                    decoration: const InputDecoration(
                                      labelText: 'Год выпуска',
                                      prefixIcon: Icon(Icons.date_range),
                                      border: OutlineInputBorder(),
                                      hintText: 'Например: 2022',
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value != null && value.isNotEmpty) {
                                        final year = int.tryParse(value);
                                        if (year == null) {
                                          return 'Введите число';
                                        }
                                        if (year < 1900 ||
                                            year > DateTime.now().year + 1) {
                                          return 'Некорректный год';
                                        }
                                      }
                                      return null; // год необязателен
                                    },
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // VIN-код
                                Expanded(
                                  child: TextFormField(
                                    controller: vinController,
                                    decoration: const InputDecoration(
                                      labelText: 'VIN-код',
                                      prefixIcon: Icon(Icons.pin),
                                      border: OutlineInputBorder(),
                                      hintText: '17 символов',
                                    ),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    onChanged: (value) {
                                      // Преобразуем VIN к верхнему регистру
                                      final upperValue = value.toUpperCase();
                                      if (value != upperValue) {
                                        vinController.text = upperValue;
                                        vinController.selection =
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset: vinController
                                                        .text.length));
                                      }
                                    },
                                    validator: (value) {
                                      if (value != null && value.isNotEmpty) {
                                        if (value.length != 17) {
                                          return 'VIN должен содержать 17 символов';
                                        }
                                      }
                                      return null; // VIN необязателен
                                    },
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Поле для госномера
                            TextFormField(
                              controller: licensePlateController,
                              decoration: const InputDecoration(
                                labelText: 'Государственный номер',
                                prefixIcon: Icon(Icons.app_registration),
                                border: OutlineInputBorder(),
                                hintText: 'Регистрационный номер авто',
                              ),
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (value) {
                                // Преобразуем номер к верхнему регистру
                                final upperValue = value.toUpperCase();
                                if (value != upperValue) {
                                  licensePlateController.text = upperValue;
                                  licensePlateController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: licensePlateController
                                              .text.length));
                                }
                              },
                              textInputAction: TextInputAction.next,
                            ),

                            const SizedBox(height: 16),

                            // Поле ввода дополнительной информации
                            TextFormField(
                              controller: additionalInfoController,
                              decoration: const InputDecoration(
                                labelText: 'Дополнительная информация',
                                prefixIcon: Icon(Icons.info_outline),
                                hintText: 'Комплектация, особенности и т.д.',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Отмена'),
                ),
                if (!isLoading)
                  TextButton(
                    onPressed: isValid
                        ? () {
                            // Создаем объект автомобиля из введенных данных
                            final result = CarModel(
                              id: car?.id ??
                                  '0', // '0' для новых автомобилей (ID присвоит БД)
                              clientId: selectedClient!.id.toString(),
                              make: makeController.text.trim(),
                              model: modelController.text.trim(),
                              year: yearController.text.isNotEmpty
                                  ? int.parse(yearController.text.trim())
                                  : 0,
                              vin: vinController.text.trim(),
                              licensePlate: licensePlateController.text.trim(),
                              additionalInfo:
                                  additionalInfoController.text.trim(),
                            );
                            Navigator.of(context).pop(result);
                          }
                        : null, // Если форма невалидна, кнопка будет неактивна
                    child: Text(car == null ? 'Добавить' : 'Сохранить'),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

```

## lib\features\vehicles\services\car_service.dart
```dart
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/daos/cars_dao.dart';
import 'package:part_catalog/features/vehicles/models/car.dart';

/// {@template car_service}
/// Сервис для управления автомобилями.
/// Обеспечивает бизнес-логику и преобразование между моделями базы данных и бизнес-моделями.
/// {@endtemplate}
class CarService {
  /// {@macro car_service}
  CarService(this._database) {
    _carsDao = _database.carsDao;
  }

  final AppDatabase _database;
  late final CarsDao _carsDao;
  final Logger _logger = Logger();

  /// Возвращает поток списка автомобилей, который обновляется автоматически при изменении данных.
  Stream<List<CarModel>> watchCars() {
    return _carsDao.watchAllCars().map(
          (cars) => cars.map(_mapToModel).toList(),
        );
  }

  /// Возвращает поток списка автомобилей для указанного клиента.
  ///
  /// [clientId] - идентификатор клиента, автомобили которого нужно получить.
  Stream<List<CarModel>> watchClientCars(int clientId) {
    return _carsDao.watchClientCars(clientId).map(
          (cars) => cars.map(_mapToModel).toList(),
        );
  }

  /// Возвращает автомобиль по идентификатору.
  Future<CarModel?> getCarById(int id) async {
    final car = await _carsDao.getCarById(id);
    if (car == null) return null;

    return _mapToModel(car);
  }

  /// Добавляет новый автомобиль.
  ///
  /// Параметры:
  /// * [car] - данные автомобиля для добавления
  ///
  /// Возвращает идентификатор добавленного автомобиля.
  Future<int> addCar(CarModel car) {
    _logger.i('Добавление автомобиля: ${car.make} ${car.model}');

    // Преобразование бизнес-модели в companion для DAO
    final companion = _mapToCompanion(car);

    // Делегируем выполнение операции в DAO
    return _carsDao.insertCar(companion);
  }

  /// Обновляет информацию об автомобиле.
  ///
  /// [car] - обновленные данные автомобиля.
  ///
  /// Возвращает количество обновленных записей (обычно 1).
  Future<bool> updateCar(CarModel car) {
    _logger.i('Обновление автомобиля ID: ${car.id}');

    // Преобразование бизнес-модели в companion для DAO
    // с явным указанием идентификатора
    final companion = _mapToCompanion(car).copyWith(
      id: Value(int.parse(car.id)), // Добавляем ID в companion
    );

    // Делегируем выполнение операции в DAO
    return _carsDao.updateCar(companion);
  }

  /// Soft-delete автомобиля (установка deletedAt).
  ///
  /// Возвращает количество обновленных записей (обычно 1).
  Future<int> deleteCar(int id) {
    _logger.i('Удаление автомобиля с ID: $id');

    // Делегируем выполнение операции в DAO
    return _carsDao.softDeleteCar(id);
  }

  /// Получает расширенную информацию об автомобилях с данными владельцев.
  ///
  /// Пример сложной операции, использующей DAO для получения связанных данных.
  Future<List<CarWithOwnerModel>> getCarsWithOwners() async {
    final results = await _carsDao.getCarsWithOwners();

    return results
        .map((item) => CarWithOwnerModel(
              car: _mapToModel(item.car),
              ownerName: item.ownerName,
              ownerType: item.ownerType,
            ))
        .toList();
  }

  /// Преобразует запись из БД в бизнес-модель.
  CarModel _mapToModel(CarsItem car) {
    return CarModel(
      id: car.id.toString(),
      clientId: car.clientId.toString(),
      vin: car.vin ?? '',
      make: car.make,
      model: car.model,
      year: car.year ?? 0,
      licensePlate: car.licensePlate ?? '',
      additionalInfo: car.additionalInfo ?? '',
    );
  }

  /// Преобразует бизнес-модель в модель базы данных.
  CarsItemsCompanion _mapToCompanion(CarModel car) {
    return CarsItemsCompanion(
      clientId: Value(int.parse(car.clientId)),
      make: Value(car.make),
      model: Value(car.model),
      year: Value(car.year != 0 ? car.year : null),
      vin: Value(car.vin.isNotEmpty ? car.vin : null),
      licensePlate:
          Value(car.licensePlate?.isNotEmpty == true ? car.licensePlate : null),
      additionalInfo: Value(
          car.additionalInfo?.isNotEmpty == true ? car.additionalInfo : null),
    );
  }
}

/// Модель для представления автомобиля с информацией о владельце.
class CarWithOwnerModel {
  final CarModel car;
  final String ownerName;
  final String ownerType;

  CarWithOwnerModel({
    required this.car,
    required this.ownerName,
    required this.ownerType,
  });
}

```

## lib\main.dart
```dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/features/parts_catalog/api/api_client_parts_catalogs.dart';
import 'package:part_catalog/features/parts_catalog/models/catalog.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/features/parts_catalog/widgets/car_info_widget.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/clients/screens/clients_screen.dart';
import 'package:part_catalog/features/vehicles/screens/cars_screen.dart';

/// {@template main_app}
/// Главное приложение.
/// {@endtemplate}
void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация базы данных с проверкой таблиц
  final database = AppDatabase();
  await database.ensureDatabaseReady();

  // Регистрация в service_locator
  setupLocator(); // предполагаем, что это регистрирует database
  runApp(const MainApp());
}

/// {@template main_app}
/// Главный виджет приложения.
/// {@endtemplate}
class MainApp extends StatelessWidget {
  /// {@macro main_app}
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Part Catalog',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late ApiClientPartsCatalogs apiClient;
  List<Catalog> catalogs = [];
  String apiKey = dotenv.env['API_KEY'] ?? 'YOUR_API_KEY';
  final String language = 'en';
  final Logger logger = Logger();
  String vinOrFrame = '';

  @override
  void initState() {
    super.initState();
    apiClient = locator<ApiClientPartsCatalogs>();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      catalogs = await apiClient.getCatalogs(apiKey, language);
      setState(() {});
    } on DioException catch (e) {
      logger.e('Error fetching data: ${e.message}');
      if (e.response != null) {
        logger.e('Status code: ${e.response?.statusCode}');
        logger.e('Response data: ${e.response?.data}');
      } else {
        logger.e('Request failed without a response.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Part Catalog'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Part Catalog Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Clients'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClientsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Автомобили'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CarsScreen()),
                );
              },
            ),
          ],
        ),
        // Добавьте другие пункты меню здесь
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter VIN or Frame',
              ),
              onChanged: (value) {
                vinOrFrame = value;
              },
            ),
            Expanded(
              child: CarInfoWidget(vinOrFrame: vinOrFrame),
            ),
          ],
        ),
      ),
    );
  }
}

```

