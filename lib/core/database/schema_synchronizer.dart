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
