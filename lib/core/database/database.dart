import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:drift/native.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'dart:io';
import 'package:logger/logger.dart';

import 'client_entity.dart';
import 'car_entity.dart';

part 'database.g.dart';

/// {@template app_database}
/// База данных приложения, использующая Drift ORM.
/// {@endtemplate}
@DriftDatabase(tables: [Clients, Cars])
class AppDatabase extends _$AppDatabase {
  /// {@macro app_database}
  AppDatabase() : super(_openConnection());

  /// Логгер для отслеживания операций с базой данных.
  final Logger _logger = Logger();

  @override
  int get schemaVersion => 2; // Увеличиваем версию схемы

  // Определите стратегию миграции
  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          // Создаём все таблицы при первом запуске
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Ручные миграции для важных изменений
          if (from == 1) {
            // Миграция с версии 1 на 2 - создаём таблицу cars
            await m.createTable(cars);
          }
        },
        beforeOpen: (details) async {
          if (details.wasCreated) {
            // База данных только что создана
            _logger.i('База данных была создана с нуля');
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
      await file.delete();
      // Перезагрузите соединение
      close();
      _logger.i('База данных была удалена');
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
