import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'package:part_catalog/core/database/items/orders_items.dart';

/// Таблица для хранения запчастей, связанных с заказ-нарядами.
class OrderPartsItems extends Table {
  // Автоинкрементный числовой ID для эффективного индексирования в БД
  IntColumn get id => integer().autoIncrement()();

  // UUID для бизнес-логики и синхронизации
  TextColumn get uuid => text().clientDefault(() => const Uuid().v4())();

  // Связь с заказ-нарядом
  TextColumn get documentUuid => text().references(OrdersItems, #uuid)();

  // Номер строки в документе
  IntColumn get lineNumber => integer().withDefault(const Constant(0))();

  // Данные о запчасти
  TextColumn get partNumber => text()();
  TextColumn get name => text()();
  TextColumn get brand => text().nullable()();
  RealColumn get quantity => real().withDefault(const Constant(0.0))();
  RealColumn get price => real().withDefault(const Constant(0.0))();

  // Дополнительная информация
  TextColumn get supplierName => text().nullable()();
  IntColumn get deliveryDays => integer().nullable()();

  // Статус запчасти в заказе
  BoolColumn get isOrdered => boolean().withDefault(const Constant(false))();
  BoolColumn get isReceived => boolean().withDefault(const Constant(false))();

  // Служебные поля
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get modifiedAt => dateTime().nullable()();

  // Определяем минимально необходимые индексы для таблицы
  List<Index> get indexes => [
        // Уникальный индекс для UUID
        Index(
          'order_parts_uuid_unique_idx',
          'CREATE UNIQUE INDEX IF NOT EXISTS "order_parts_uuid_unique_idx" ON "order_parts_items"("uuid")',
        ),
        // Индекс для поиска по заказу
        Index(
          'order_parts_order_uuid_idx',
          'CREATE INDEX IF NOT EXISTS "order_parts_order_uuid_idx" ON "order_parts_items"("document_uuid")',
        ),
        // Индекс для поиска по артикулу
        Index(
          'order_parts_part_number_idx',
          'CREATE INDEX IF NOT EXISTS "order_parts_part_number_idx" ON "order_parts_items"("part_number")',
        ),
        // Индекс для сортировки по номеру строки
        Index(
          'order_parts_line_number_idx',
          'CREATE INDEX IF NOT EXISTS "order_parts_line_number_idx" ON "order_parts_items"("document_uuid", "line_number")',
        ),
      ];
}