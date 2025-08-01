import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:uuid/uuid.dart';

import 'daos/cars_dao.dart';
// импорты DAO
import 'daos/clients_dao.dart';
import 'daos/orders_dao.dart';
import 'daos/supplier_settings_dao.dart';
import 'items/cars_items.dart';
// импорты таблиц
import 'items/clients_items.dart';
import 'items/order_parts_items.dart';
import 'items/order_services_items.dart';
import 'items/orders_items.dart';
import 'items/supplier_settings_items.dart';

part 'database.g.dart';

/// {@template app_database}
/// База данных приложения, использующая Drift ORM.
/// {@endtemplate}
@DriftDatabase(
  tables: [
    ClientsItems,
    CarsItems,
    OrdersItems,
    OrderPartsItems,
    OrderServicesItems,
    SupplierSettingsItems
  ],
  daos: [ClientsDao, CarsDao, OrdersDao, SupplierSettingsDao],
)
class AppDatabase extends _$AppDatabase {
  /// {@macro app_database}
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// Логгер для отслеживания операций с базой данных.
  final Logger _logger = Logger();

  @override
  int get schemaVersion => 13; // Новая базовая версия схемы

  /// Получает экземпляр DAO клиентов.
  @override
  ClientsDao get clientsDao => ClientsDao(this);

  /// Получает экземпляр DAO автомобилей.
  @override
  CarsDao get carsDao => CarsDao(this);

  /// Получает экземпляр DAO заказ-нарядов.
  @override
  OrdersDao get ordersDao => OrdersDao(this);

  /// Получает экземпляр DAO настройки поставщиков.
  @override
  SupplierSettingsDao get supplierSettingsDao => SupplierSettingsDao(this);

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          _logger
              .i('Создание новой базы данных, schemaVersion: $schemaVersion');
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          _logger.i('Обновление схемы с версии $from до $to');

          // Применяем миграции пошагово
          for (var version = from; version < to; version++) {
            final nextVersion = version + 1;
            _logger.i('Применение миграции для схемы версии $nextVersion');

            // Миграции со старых версий (до v12 включительно, где работал SchemaSynchronizer)
            // на новую базовую версию v13.
            // Этот блок гарантирует, что все таблицы, ожидаемые в v13, существуют.
            if (version < 12) {
              _logger.i(
                  'Миграция с v$version на v$nextVersion: проверка/создание базовых таблиц.');
              await m.createTable(clientsItems);
              await m.createTable(carsItems);
              await m.createTable(ordersItems);
              await m.createTable(orderPartsItems);
              await m.createTable(orderServicesItems);
              await m.createTable(supplierSettingsItems);
              _logger.i(
                  'Завершено: проверка/создание таблиц при миграции с v$version на v$nextVersion.');
            }

            // Миграция с версии 12 (последняя версия с кастомным синхронизатором) на 13
            if (version == 12 && nextVersion == 13) {
              _logger.i('Выполнение специфичных шагов миграции с v12 на v13.');
              // На данный момент, если SchemaSynchronizer корректно создавал все таблицы и колонки
              // для v12, и v13 не вносит новых изменений по сравнению с v12,
              // этот блок может быть пустым или содержать только проверки.
              // Для безопасности, еще раз убедимся, что все таблицы созданы,
              // на случай если createAll в onCreate не был вызван для очень старых БД.
              await m.createTable(clientsItems);
              await m.createTable(carsItems);
              await m.createTable(ordersItems);
              await m.createTable(orderPartsItems);
              await m.createTable(orderServicesItems);
              await m.createTable(supplierSettingsItems);
              _logger.i(
                  'Завершено: специфичные шаги миграции с v12 на v13 (проверка таблиц).');
            }

            // Сюда добавляются будущие миграции:
            // if (version == 13 && nextVersion == 14) {
            //   _logger.i('Миграция с v13 на v14.');
            //   // await m.addColumn(clientsItems, clientsItems.newColumnForV14);
            //   _logger.i('Завершено: Миграция с v13 на v14.');
            // }
            // if (version == 14 && nextVersion == 15) {
            //   // Миграция с v14 на v15
            // }
          }
        },
        beforeOpen: (details) async {
          _logger.i(
              'Открытие БД: wasCreated=${details.wasCreated}, hadUpgrade=${details.hadUpgrade}, versionBefore=${details.versionBefore}, versionNow=${details.versionNow}');
          if (details.wasCreated) {
            _logger.i(
                'База данных была создана с нуля. Текущая версия схемы: ${details.versionNow}');
          }
          // Включаем внешние ключи
          await customStatement('PRAGMA foreign_keys = ON');

          if (details.hadUpgrade) {
            _logger.i(
                'База данных была обновлена с версии ${details.versionBefore} до ${details.versionNow}');
          }
        },
      );

  /// Удаляет файл базы данных.
  ///
  /// Используется для отладки и сброса базы данных к начальному состоянию.
  Future<void> deleteDatabase() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    if (await file.exists()) {
      await close(); // Закрываем соединение перед удалением файла
      await file.delete();
      _logger.i('База данных была удалена');
    }
  }

  /// Создает резервную копию базы данных.
  ///
  /// Возвращает путь к созданному файлу резервной копии.
  Future<String> backupDatabase() async {
    await close(); // Закрываем соединение перед копированием
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
  Future<void> resetDatabase() async {
    try {
      _logger.i('Начинаем процесс сброса базы данных...');
      await close();

      final dbFolder = await getApplicationDocumentsDirectory();
      final dbPath = p.join(dbFolder.path, 'db.sqlite');
      final dbFile = File(dbPath);

      if (await dbFile.exists()) {
        await dbFile.delete();
        _logger.i('Старый файл базы данных удален: $dbPath');
      }
      _logger.i(
          'База данных успешно сброшена. Будет создана заново при следующем обращении.');
    } catch (e, s) {
      _logger.e('Ошибка при сбросе базы данных', error: e, stackTrace: s);
      rethrow;
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    return NativeDatabase.createInBackground(file);
  });
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return locator<AppDatabase>();
});

final supplierSettingsDaoProvider = Provider<SupplierSettingsDao>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return SupplierSettingsDao(database);
});
