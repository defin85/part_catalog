import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// {@template clients_items}
/// Таблица клиентов для хранения в базе данных.
/// {@endtemplate}
class ClientsItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  TextColumn get code => text()(); // Код клиента
  TextColumn get type => text()();
  TextColumn get name => text()();
  TextColumn get contactInfo => text()();
  TextColumn get additionalInfo => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get modifiedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// Временное поле для теста генерации схемы

  List<Index> get indexes => [
        // Уникальный индекс по uuid (если не null)
        Index('clients_uuid_idx',
            'CREATE UNIQUE INDEX IF NOT EXISTS clients_uuid_idx ON clients_items(uuid) WHERE uuid IS NOT NULL'),

        // Уникальный индекс по коду клиента
        Index('clients_code_idx',
            'CREATE UNIQUE INDEX IF NOT EXISTS clients_code_idx ON clients_items(code)'),

        // Обычный индекс по имени для быстрого поиска
        Index('clients_name_idx',
            'CREATE INDEX IF NOT EXISTS clients_name_idx ON clients_items(name)'),

        // Индекс по deletedAt для быстрой фильтрации активных клиентов
        Index('clients_deleted_at_idx',
            'CREATE INDEX IF NOT EXISTS clients_deleted_at_idx ON clients_items(deleted_at)'),

        // Составной индекс по типу и deletedAt для запросов с фильтрацией
        Index('clients_type_active_idx',
            'CREATE INDEX IF NOT EXISTS clients_type_active_idx ON clients_items(type, deleted_at)'),

        // Составной индекс для полнотекстового поиска
        Index('clients_search_idx',
            'CREATE INDEX IF NOT EXISTS clients_search_idx ON clients_items(name, contact_info)'),
      ];
}
