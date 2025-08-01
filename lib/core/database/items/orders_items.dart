import 'package:drift/drift.dart';
import 'package:part_catalog/core/database/items/cars_items.dart';
import 'package:part_catalog/core/database/items/clients_items.dart';
import 'package:uuid/uuid.dart';

class OrdersItems extends Table {
  // Автоинкрементный числовой ID для эффективного индексирования в БД
  IntColumn get id => integer().autoIncrement()();

  // UUID для бизнес-логики и синхронизации
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();

  // Переименовано в соответствии с OrderModel
  TextColumn get clientUuid => text().references(ClientsItems, #uuid)();
  TextColumn get carUuid => text().references(CarsItems, #uuid)();

  // Номер заказ-наряда (соответствует code в OrderModel)
  TextColumn get number => text()();

  // Дата заказ-наряда
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get scheduledDate => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();

  // Статус заказ-наряда, хранится как строка (имя enum)
  TextColumn get status => text()(); // Значения из OrderStatus.name

  TextColumn get description => text().nullable()();
  RealColumn get totalAmount => real().withDefault(const Constant(0.0))();

  // Добавленные поля из OrderModel
  BoolColumn get isPosted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();

  // Метод для фильтрации только активных записей
  Expression<bool> get isActive => deletedAt.isNull();

  // Определяем минимально необходимые индексы для таблицы
  List<Index> get indexes => [
        // Уникальный индекс для UUID
        Index(
          'orders_uuid_unique_idx',
          'CREATE UNIQUE INDEX IF NOT EXISTS "orders_uuid_unique_idx" ON "orders_items"("uuid")',
        ),
        // Индекс для поиска по clientUuid
        Index(
          'orders_client_uuid_idx',
          'CREATE INDEX IF NOT EXISTS "orders_client_uuid_idx" ON "orders_items"("client_uuid")',
        ),
        // Индекс для поиска по carUuid
        Index(
          'orders_car_uuid_idx',
          'CREATE INDEX IF NOT EXISTS "orders_car_uuid_idx" ON "orders_items"("car_uuid")',
        ),
        // Уникальный индекс для номера заказа
        Index(
          'orders_number_unique_idx',
          'CREATE UNIQUE INDEX IF NOT EXISTS "orders_number_unique_idx" ON "orders_items"("number")',
        ),
        // Индекс по статусу для быстрого поиска по состоянию заказа
        Index(
          'orders_status_idx',
          'CREATE INDEX IF NOT EXISTS "orders_status_idx" ON "orders_items"("status")',
        ),
        // Индекс по полю deleted_at для быстрой фильтрации активных заказов
        Index(
          'orders_deleted_at_idx',
          'CREATE INDEX IF NOT EXISTS "orders_deleted_at_idx" ON "orders_items"("deleted_at")',
        ),
      ];
}
