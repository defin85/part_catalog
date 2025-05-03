import 'package:drift/drift.dart';
import 'clients_items.dart';
import 'package:uuid/uuid.dart';

/// {@template cars_items}
/// Таблица автомобилей для хранения в базе данных.
/// {@endtemplate}
class CarsItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();
  IntColumn get clientId => integer().references(ClientsItems, #id)();
  TextColumn get vin => text().nullable()();
  TextColumn get make => text()();
  TextColumn get model => text()();
  IntColumn get year => integer().nullable()();
  TextColumn get licensePlate => text().nullable()();
  TextColumn get additionalInfo => text().nullable()();
  TextColumn get code => text().withDefault(const Constant(''))();
  // Дата и время создания записи
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  // Дата и время последнего изменения записи
  DateTimeColumn get modifiedAt => dateTime().nullable()();
  // Дата и время удаления, null если запись активна
  DateTimeColumn get deletedAt => dateTime().nullable()();
  // Метод для фильтрации только активных записей
  Expression<bool> get isActive => deletedAt.isNull();

  // Определяем индексы для таблицы
  List<Index> get indexes => [
        // Индекс для улучшения производительности поиска по clientId
        Index(
          'cars_client_id_idx',
          'CREATE INDEX IF NOT EXISTS "cars_client_id_idx" ON "cars_items"("client_id")',
        ),
        // Уникальный индекс для uuid
        Index(
          'cars_uuid_unique_idx',
          'CREATE UNIQUE INDEX IF NOT EXISTS "cars_uuid_unique_idx" ON "cars_items"("uuid")',
        ),
        // Уникальный индекс для vin с частичным условием
        Index(
          'cars_vin_unique_idx',
          'CREATE UNIQUE INDEX IF NOT EXISTS "cars_vin_unique_idx" ON "cars_items"("vin") WHERE "vin" IS NOT NULL',
        ),
        // Индекс по deletedAt для быстрой фильтрации активных автомобилей
        Index(
          'cars_deleted_at_idx',
          'CREATE INDEX IF NOT EXISTS "cars_deleted_at_idx" ON "cars_items"("deleted_at")',
        ),
        // Индекс по licensePlate с частичным условием
        Index(
          'cars_license_plate_idx',
          'CREATE INDEX IF NOT EXISTS "cars_license_plate_idx" ON "cars_items"("license_plate") WHERE "license_plate" IS NOT NULL',
        ),
        // Составной индекс по марке и модели для быстрого поиска
        Index(
          'cars_make_model_idx',
          'CREATE INDEX IF NOT EXISTS "cars_make_model_idx" ON "cars_items"("make", "model")',
        ),
        // Составной индекс для полнотекстового поиска
        Index(
          'cars_search_idx',
          'CREATE INDEX IF NOT EXISTS "cars_search_idx" ON "cars_items"("make", "model", "vin", "license_plate")',
        ),
        // Индекс по коду автомобиля
        Index(
          'cars_code_idx',
          'CREATE INDEX IF NOT EXISTS "cars_code_idx" ON "cars_items"("code")',
        ),
        // Составной индекс по году выпуска и deletedAt для запросов с фильтрацией
        Index(
          'cars_year_active_idx',
          'CREATE INDEX IF NOT EXISTS "cars_year_active_idx" ON "cars_items"("year", "deleted_at")',
        ),
      ];
}
