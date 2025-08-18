import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:part_catalog/core/database/items/orders_items.dart';

/// Таблица для хранения услуг, связанных с заказ-нарядами.
class OrderServicesItems extends Table {
  // Автоинкрементный числовой ID для эффективного индексирования в БД
  IntColumn get id => integer().autoIncrement()();

  // UUID для бизнес-логики и синхронизации
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();

  // Связь с заказ-нарядом
  TextColumn get documentUuid => text().references(OrdersItems, #uuid)();

  // Номер строки в документе
  IntColumn get lineNumber => integer().withDefault(const Constant(0))();

  // Данные об услуге
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  RealColumn get price => real().withDefault(const Constant(0.0))();

  // Продолжительность работы в часах
  RealColumn get duration => real().nullable()();

  // Информация об исполнителе
  TextColumn get performedBy => text().nullable()();

  // Статус услуги
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  // Служебные поля
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime().nullable()();

  // Определяем минимально необходимые индексы для таблицы
  List<Index> get indexes => [
        // Уникальный индекс для UUID
        Index(
          'order_services_uuid_unique_idx',
          'CREATE UNIQUE INDEX IF NOT EXISTS "order_services_uuid_unique_idx" ON "order_services_items"("uuid")',
        ),
        // Индекс для поиска по заказу
        Index(
          'order_services_order_uuid_idx',
          'CREATE INDEX IF NOT EXISTS "order_services_order_uuid_idx" ON "order_services_items"("document_uuid")',
        ),
        // Индекс для поиска по статусу завершения
        Index(
          'order_services_is_completed_idx',
          'CREATE INDEX IF NOT EXISTS "order_services_is_completed_idx" ON "order_services_items"("is_completed")',
        ),
        // Индекс для сортировки по номеру строки
        Index(
          'order_services_line_number_idx',
          'CREATE INDEX IF NOT EXISTS "order_services_line_number_idx" ON "order_services_items"("document_uuid", "line_number")',
        ),
      ];
}