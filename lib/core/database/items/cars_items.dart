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
