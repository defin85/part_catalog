import 'package:flutter/foundation.dart';

import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/core/utils/logger_config.dart';

/// Функция для проверки содержимого таблицы supplier_settings
/// Вызывается из основного приложения
Future<void> checkSupplierSettingsTable() async {
  if (!kDebugMode) return; // Только в debug режиме

  final logger = AppLoggers.database;

  try {
    logger.i('🔍 Проверка таблицы supplier_settings');

    // Получаем экземпляр базы данных
    final database = locator<AppDatabase>();

    logger.i('\n=== Проверка существования таблицы ===');

    // Проверяем, существует ли таблица
    final tableExists = await database
        .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name='supplier_settings'")
        .get();

    if (tableExists.isEmpty) {
      logger.e('❌ Таблица supplier_settings не существует!');
      return;
    }

    logger.i('✅ Таблица supplier_settings существует');

    // Получаем структуру таблицы
    final structure = await database
        .customSelect('PRAGMA table_info(supplier_settings)')
        .get();

    logger.i('\n📋 Структура таблицы:');
    for (final row in structure) {
      final name = row.data['name'];
      final type = row.data['type'];
      final notNull = row.data['notnull'] == 1 ? 'NOT NULL' : 'NULL';
      final defaultValue = row.data['dflt_value'];
      logger.i(
          '  - $name: $type ($notNull)${defaultValue != null ? ' DEFAULT $defaultValue' : ''}');
    }

    // Проверяем содержимое таблицы
    logger.i('\n=== Содержимое таблицы ===');
    final allSettings =
        await database.supplierSettingsDao.getAllSupplierSettings();

    if (allSettings.isEmpty) {
      logger.i('📭 Таблица пуста');
    } else {
      logger.i('📊 Найдено записей: ${allSettings.length}');

      for (int i = 0; i < allSettings.length; i++) {
        final setting = allSettings[i];
        logger.i('\n--- Запись ${i + 1} ---');
        logger.i('  ID: ${setting.id}');
        logger.i('  Supplier Code: ${setting.supplierCode}');
        logger.i('  Is Enabled: ${setting.isEnabled}');
        logger.i(
            '  Has Encrypted Credentials: ${setting.encryptedCredentials != null}');
        if (setting.encryptedCredentials != null) {
          logger.i(
              '  Credentials Length: ${setting.encryptedCredentials!.length} символов');
        }
        logger.i(
            '  Last Check Status: ${setting.lastCheckStatus ?? 'Не проверялся'}');
        logger.i('  Created At: ${setting.createdAt}');
        logger.i('  Updated At: ${setting.updatedAt}');

        if (setting.additionalConfig != null) {
          logger.i(
              '  Additional Config Length: ${setting.additionalConfig!.length} символов');
          // Показываем первые 200 символов конфигурации
          final config = setting.additionalConfig!;
          if (config.length > 200) {
            logger.d('  Config Preview: ${config.substring(0, 200)}...');
          } else {
            logger.d('  Config: $config');
          }
        }
      }
    }

    // Проверяем индексы таблицы
    logger.i('\n=== Индексы таблицы ===');
    final indexes = await database
        .customSelect(
            "SELECT name, sql FROM sqlite_master WHERE type='index' AND tbl_name='supplier_settings'")
        .get();

    if (indexes.isEmpty) {
      logger.i('  Индексов не найдено');
    } else {
      for (final index in indexes) {
        logger.i('  - ${index.data['name']}: ${index.data['sql']}');
      }
    }

    // Проверяем все таблицы в базе
    logger.i('\n=== Статистика всех таблиц ===');
    final tables = await database
        .customSelect(
            "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'")
        .get();

    for (final tableRow in tables) {
      final tableName = tableRow.data['name'];
      final count = await database
          .customSelect('SELECT COUNT(*) as count FROM $tableName')
          .get();
      final recordCount = count.first.data['count'];
      logger.i('  $tableName: $recordCount записей');
    }

    logger.i('\n✅ Проверка завершена!');
  } catch (e, stackTrace) {
    logger.e('❌ Ошибка при проверке базы данных: $e',
        error: e, stackTrace: stackTrace);
  }
}
