import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:drift/native.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'dart:io';
import 'package:logger/logger.dart';
import 'schema_synchronizer.dart';
import 'package:uuid/uuid.dart';

// импорты таблиц
import 'items/clients_items.dart';
import 'items/cars_items.dart';
import 'items/app_info_items.dart';
import 'items/orders_items.dart';
import 'items/order_parts_items.dart';
import 'items/order_services_items.dart';

// импорты DAO
import 'daos/clients_dao.dart';
import 'daos/cars_dao.dart';
import 'daos/orders_dao.dart';

part 'database.g.dart';

/// {@template app_database}
/// База данных приложения, использующая Drift ORM.
/// {@endtemplate}
@DriftDatabase(
  tables: [
    ClientsItems,
    CarsItems,
    AppInfoItems,
    OrdersItems,
    OrderPartsItems,
    OrderServicesItems
  ],
  daos: [ClientsDao, CarsDao, OrdersDao],
) // Обновлены имена таблиц
class AppDatabase extends _$AppDatabase {
  /// {@macro app_database}
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// Логгер для отслеживания операций с базой данных.
  final Logger _logger = Logger();

  @override
  int get schemaVersion => 10; // Увеличиваем версию из-за изменения схемы

  /// Получает экземпляр DAO клиентов.
  @override
  ClientsDao get clientsDao => ClientsDao(this);

  /// Получает экземпляр DAO автомобилей.
  @override
  CarsDao get carsDao => CarsDao(this);

  /// Получает экземпляр DAO заказ-нарядов.
  @override
  OrdersDao get ordersDao => OrdersDao(this);

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
