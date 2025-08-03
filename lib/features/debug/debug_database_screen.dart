import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/service_locator.dart';

/// Debug экран для проверки содержимого базы данных
class DebugDatabaseScreen extends ConsumerStatefulWidget {
  const DebugDatabaseScreen({super.key});

  @override
  ConsumerState<DebugDatabaseScreen> createState() => _DebugDatabaseScreenState();
}

class _DebugDatabaseScreenState extends ConsumerState<DebugDatabaseScreen> {
  String _output = 'Нажмите кнопку для проверки базы данных';
  bool _isLoading = false;

  Future<void> _checkDatabase() async {
    setState(() {
      _isLoading = true;
      _output = 'Проверяем базу данных...';
    });

    try {
      final database = locator<AppDatabase>();
      final buffer = StringBuffer();
      
      buffer.writeln('🔍 Проверка таблицы supplier_settings');
      buffer.writeln();

      // Проверяем существование таблицы
      buffer.writeln('=== Проверка существования таблицы ===');
      final tableExists = await database.customSelect(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='supplier_settings'"
      ).get();

      if (tableExists.isEmpty) {
        buffer.writeln('❌ Таблица supplier_settings не существует!');
        setState(() {
          _output = buffer.toString();
          _isLoading = false;
        });
        return;
      }

      buffer.writeln('✅ Таблица supplier_settings существует');
      buffer.writeln();

      // Структура таблицы
      buffer.writeln('📋 Структура таблицы:');
      final structure = await database.customSelect(
        'PRAGMA table_info(supplier_settings)'
      ).get();

      for (final row in structure) {
        final name = row.data['name'];
        final type = row.data['type'];
        final notNull = row.data['notnull'] == 1 ? 'NOT NULL' : 'NULL';
        final defaultValue = row.data['dflt_value'];
        buffer.writeln('  - $name: $type ($notNull)${defaultValue != null ? ' DEFAULT $defaultValue' : ''}');
      }
      buffer.writeln();

      // Содержимое таблицы
      buffer.writeln('=== Содержимое таблицы ===');
      final allSettings = await database.supplierSettingsDao.getAllSupplierSettings();

      if (allSettings.isEmpty) {
        buffer.writeln('📭 Таблица пуста');
        
        // Проверяем SharedPreferences на предмет старых данных
        // (это потребует дополнительной проверки в production коде)
        buffer.writeln();
        buffer.writeln('ℹ️ Проверьте SharedPreferences на предмет данных для миграции');
      } else {
        buffer.writeln('📊 Найдено записей: ${allSettings.length}');
        buffer.writeln();

        for (int i = 0; i < allSettings.length; i++) {
          final setting = allSettings[i];
          buffer.writeln('--- Запись ${i + 1} ---');
          buffer.writeln('  ID: ${setting.id}');
          buffer.writeln('  Supplier Code: ${setting.supplierCode}');
          buffer.writeln('  Is Enabled: ${setting.isEnabled}');
          buffer.writeln('  Has Encrypted Credentials: ${setting.encryptedCredentials != null}');
          if (setting.encryptedCredentials != null) {
            buffer.writeln('  Credentials Length: ${setting.encryptedCredentials!.length} символов');
          }
          buffer.writeln('  Last Check Status: ${setting.lastCheckStatus ?? 'Не проверялся'}');
          buffer.writeln('  Created At: ${setting.createdAt}');
          buffer.writeln('  Updated At: ${setting.updatedAt}');

          if (setting.additionalConfig != null) {
            buffer.writeln('  Additional Config Length: ${setting.additionalConfig!.length} символов');
            final config = setting.additionalConfig!;
            if (config.length > 100) {
              buffer.writeln('  Config Preview: ${config.substring(0, 100)}...');
            } else {
              buffer.writeln('  Config: $config');
            }
          }
          buffer.writeln();
        }
      }

      // Статистика всех таблиц
      buffer.writeln('=== Статистика всех таблиц ===');
      final tables = await database.customSelect(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%'"
      ).get();

      for (final tableRow in tables) {
        final tableName = tableRow.data['name'];
        final count = await database.customSelect(
          'SELECT COUNT(*) as count FROM $tableName'
        ).get();
        final recordCount = count.first.data['count'];
        buffer.writeln('  $tableName: $recordCount записей');
      }

      buffer.writeln();
      buffer.writeln('✅ Проверка завершена!');

      setState(() {
        _output = buffer.toString();
        _isLoading = false;
      });

    } catch (e, stackTrace) {
      final buffer = StringBuffer();
      buffer.writeln('❌ Ошибка при проверке базы данных:');
      buffer.writeln('   $e');
      buffer.writeln();
      buffer.writeln('Stack trace:');
      buffer.writeln('   $stackTrace');

      setState(() {
        _output = buffer.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug: База данных'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _checkDatabase,
                  icon: _isLoading 
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh),
                  label: Text(_isLoading ? 'Проверяем...' : 'Проверить БД'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _output = 'Лог очищен';
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Очистить'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  _output,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}