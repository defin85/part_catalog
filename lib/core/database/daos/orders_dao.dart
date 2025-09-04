import 'dart:async';

import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';

import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/items/cars_items.dart'; // Нужен для JOIN
import 'package:part_catalog/core/database/items/clients_items.dart'; // Нужен для JOIN
import 'package:part_catalog/core/database/items/order_parts_items.dart';
import 'package:part_catalog/core/database/items/order_services_items.dart';
import 'package:part_catalog/core/database/items/orders_items.dart';
import 'package:part_catalog/core/utils/log_messages.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:part_catalog/features/core/document_item_specific_data.dart';
import 'package:part_catalog/features/core/document_specific_data.dart';
import 'package:part_catalog/features/core/document_status.dart'; // Используем DocumentStatus
import 'package:part_catalog/features/core/entity_core_data.dart';
import 'package:part_catalog/features/core/item_core_data.dart';
import 'package:part_catalog/features/documents/orders/models/order_specific_data.dart';
import 'package:part_catalog/features/documents/orders/models/part_specific_data.dart';
import 'package:part_catalog/features/documents/orders/models/service_specific_data.dart';

// Логгер и сообщения
// Импортируем @freezed модели данных

part 'orders_dao.g.dart';

// --- Вспомогательные классы для возврата данных ---

/// Данные заголовка заказ-наряда (@freezed модели)
class OrderHeaderData {
  final EntityCoreData coreData;
  final DocumentSpecificData docData;
  final OrderSpecificData orderData;

  OrderHeaderData({
    required this.coreData,
    required this.docData,
    required this.orderData,
  });
}

/// Данные элемента заказ-наряда (запчасть или услуга) (@freezed модели)
class FullOrderItemData {
  final ItemCoreData coreData;
  final DocumentItemSpecificData docItemData;
  final BaseItemType itemType; // Добавляем тип для различения
  // Специфичные данные (одно из полей будет не null)
  final PartSpecificData? partData;
  final ServiceSpecificData? serviceData;

  FullOrderItemData({
    required this.coreData,
    required this.docItemData,
    required this.itemType,
    this.partData,
    this.serviceData,
  }) : assert(
            (partData != null &&
                    serviceData == null &&
                    itemType == BaseItemType.part) ||
                (partData == null &&
                    serviceData != null &&
                    itemType == BaseItemType.service),
            'Должны быть предоставлены данные только одного типа (Part или Service)');
}

/// Полные данные заказ-наряда с элементами (@freezed модели)
class FullOrderData {
  final OrderHeaderData headerData;
  final List<FullOrderItemData> items;

  FullOrderData({required this.headerData, required this.items});
}

/// {@template orders_dao}
/// DAO для работы с заказ-нарядами и их элементами.
/// Работает с @freezed моделями данных.
/// {@endtemplate}
@DriftAccessor(tables: [
  OrdersItems,
  OrderPartsItems,
  OrderServicesItems,
  ClientsItems, // Добавляем для JOIN
  CarsItems // Добавляем для JOIN
])
class OrdersDao extends DatabaseAccessor<AppDatabase> with _$OrdersDaoMixin {
  /// {@macro orders_dao}
  OrdersDao(super.db);

  final _logger = AppLoggers.database;

  // --- Приватные методы маппинга (из таблицы в @freezed) ---

  EntityCoreData _mapToOrderCoreData(OrdersItem item) {
    return EntityCoreData(
      uuid: item.uuid,
      code: item.number, // Используем number как code
      displayName: 'Заказ-наряд №${item.number} от ${item.date.toLocal()}',
      createdAt: item.createdAt,
      modifiedAt: item.modifiedAt,
      deletedAt: item.deletedAt,
      isDeleted: item.deletedAt != null,
    );
  }

  DocumentSpecificData _mapToOrderDocData(OrdersItem item) {
    return DocumentSpecificData(
      status: DocumentStatus.fromString(item.status),
      documentDate: item.date,
      isPosted: item.isPosted,
      postedAt: item.isPosted ? item.modifiedAt : null, // Примерная логика
    );
  }

  OrderSpecificData _mapToOrderSpecificData(OrdersItem item) {
    return OrderSpecificData(
      clientId: item.clientUuid,
      carId: item.carUuid,
      description: item.description,
      // Добавить другие поля при необходимости
    );
  }

  OrderHeaderData _mapToOrderHeaderData(OrdersItem item) {
    return OrderHeaderData(
      coreData: _mapToOrderCoreData(item),
      docData: _mapToOrderDocData(item),
      orderData: _mapToOrderSpecificData(item),
    );
  }

  ItemCoreData _mapToPartCoreData(OrderPartsItem item) {
    return ItemCoreData(
      uuid: item.uuid,
      name: item.name,
      itemType: BaseItemType.part,
      lineNumber: item.lineNumber,
      data: {}, // Можно добавить доп. данные при необходимости
    );
  }

  DocumentItemSpecificData _mapToPartDocItemData(OrderPartsItem item) {
    return DocumentItemSpecificData(
      price: item.price,
      quantity: item.quantity,
      isCompleted: item.isReceived, // Завершено = Получено
    );
  }

  PartSpecificData _mapToPartSpecificData(OrderPartsItem item) {
    return PartSpecificData(
      documentUuid: item.documentUuid,
      partNumber: item.partNumber,
      brand: item.brand,
      supplierName: item.supplierName,
      deliveryDays: item.deliveryDays,
      isOrdered: item.isOrdered,
      isReceived: item.isReceived,
    );
  }

  FullOrderItemData _mapToFullPartData(OrderPartsItem item) {
    return FullOrderItemData(
      coreData: _mapToPartCoreData(item),
      docItemData: _mapToPartDocItemData(item),
      itemType: BaseItemType.part,
      partData: _mapToPartSpecificData(item),
    );
  }

  ItemCoreData _mapToServiceCoreData(OrderServicesItem item) {
    return ItemCoreData(
      uuid: item.uuid,
      name: item.name,
      itemType: BaseItemType.service,
      lineNumber: item.lineNumber,
      data: {},
    );
  }

  DocumentItemSpecificData _mapToServiceDocItemData(OrderServicesItem item) {
    return DocumentItemSpecificData(
      price: item.price,
      quantity: 1.0, // Услуги обычно имеют количество 1
      isCompleted: item.isCompleted,
    );
  }

  ServiceSpecificData _mapToServiceSpecificData(OrderServicesItem item) {
    return ServiceSpecificData(
      documentUuid: item.documentUuid,
      duration: item.duration,
      performedBy: item.performedBy,
    );
  }

  FullOrderItemData _mapToFullServiceData(OrderServicesItem item) {
    return FullOrderItemData(
      coreData: _mapToServiceCoreData(item),
      docItemData: _mapToServiceDocItemData(item),
      itemType: BaseItemType.service,
      serviceData: _mapToServiceSpecificData(item),
    );
  }

  // --- Публичные методы DAO ---

  /// Возвращает поток списка заголовков активных заказ-нарядов.
  Stream<List<OrderHeaderData>> watchActiveOrderHeaders() {
    final query = select(ordersItems)..where((o) => o.deletedAt.isNull());
    return query
        .watch()
        .map((rows) => rows.map(_mapToOrderHeaderData).toList());
  }

  /// Возвращает пагинированный поток списка заголовков активных заказ-нарядов.
  Stream<List<OrderHeaderData>> watchActiveOrderHeadersPaginated(
      {required int limit, int? offset}) {
    final query = select(ordersItems)
      ..where((o) => o.deletedAt.isNull())
      ..orderBy(
          [(o) => OrderingTerm.desc(o.createdAt)]) // Сортируем по дате создания
      ..limit(limit, offset: offset);
    return query
        .watch()
        .map((rows) => rows.map(_mapToOrderHeaderData).toList());
  }

  /// Возвращает заголовок заказ-наряда по UUID.
  Future<OrderHeaderData?> getOrderHeaderByUuid(String uuid) async {
    final item = await (select(ordersItems)
          ..where((o) => o.uuid.equals(uuid) & o.deletedAt.isNull()))
        .getSingleOrNull();
    return item != null ? _mapToOrderHeaderData(item) : null;
  }

  /// Возвращает заголовки заказ-нарядов клиента по UUID клиента.
  Future<List<OrderHeaderData>> getOrderHeadersByClientUuid(
      String clientUuid) async {
    final items = await (select(ordersItems)
          ..where(
              (o) => o.clientUuid.equals(clientUuid) & o.deletedAt.isNull()))
        .get();
    return items.map(_mapToOrderHeaderData).toList();
  }

  /// Реактивно наблюдает за заголовком заказ-наряда по UUID.
  Stream<OrderHeaderData?> watchOrderHeaderByUuid(String uuid) {
    return (select(ordersItems)
          ..where((o) => o.uuid.equals(uuid) & o.deletedAt.isNull()))
        .watchSingleOrNull()
        .map((item) => item != null ? _mapToOrderHeaderData(item) : null);
  }

  /// Возвращает заголовки заказ-нарядов автомобиля по UUID автомобиля.
  Future<List<OrderHeaderData>> getOrderHeadersByCarUuid(String carUuid) async {
    final items = await (select(ordersItems)
          ..where((o) => o.carUuid.equals(carUuid) & o.deletedAt.isNull()))
        .get();
    return items.map(_mapToOrderHeaderData).toList();
  }

  /// Возвращает заголовки заказ-нарядов по статусу.
  Future<List<OrderHeaderData>> getOrderHeadersByStatus(
      DocumentStatus status) async {
    final items = await (select(ordersItems)
          ..where((o) => o.status.equals(status.name) & o.deletedAt.isNull()))
        .get();
    return items.map(_mapToOrderHeaderData).toList();
  }

  /// Добавляет новый заказ-наряд. Принимает @freezed модели.
  Future<int> insertOrder(EntityCoreData core, DocumentSpecificData doc,
      OrderSpecificData order) async {
    // Добавляем проверку на null для обязательных внешних ключей
    if (order.clientId == null) {
      final errorMsg = 'clientId не может быть null при добавлении заказа.';
      _logger.e(errorMsg);
      throw ArgumentError(errorMsg);
    }
    if (order.carId == null) {
      final errorMsg = 'carId не может быть null при добавлении заказа.';
      _logger.e(errorMsg);
      throw ArgumentError(errorMsg);
    }
    final companion = OrdersItemsCompanion(
      uuid: Value(core.uuid),
      clientUuid: Value(order.clientId!),
      carUuid: Value(order.carId!),
      number: Value(core.code), // Используем code как number
      date: Value(doc.documentDate),
      scheduledDate: Value(doc.scheduledDate),
      completedAt: Value(doc.completedAt),
      status: Value(doc.status.name),
      description: Value(order.description ?? ''),
      totalAmount: Value(doc.totalAmount ?? 0.0),
      isPosted: Value(doc.isPosted),
      createdAt: Value(core.createdAt),
      modifiedAt: Value(core.modifiedAt ?? core.createdAt),
      deletedAt: Value(core.deletedAt),
    );
    _logger.d(LogMessages.orderInserting.replaceAll('{uuid}', core.uuid));
    try {
      return await into(ordersItems).insert(companion);
    } catch (e, s) {
      _logger.e(LogMessages.orderAddError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Обновляет существующий заказ-наряд. Принимает @freezed модели.
  Future<int> updateOrder(EntityCoreData core, DocumentSpecificData doc,
      OrderSpecificData order) async {
    // Добавляем проверку на null для обязательных внешних ключей
    if (order.clientId == null) {
      final errorMsg = 'clientId не может быть null при обновлении заказа.';
      _logger.e(errorMsg);
      throw ArgumentError(errorMsg);
    }
    if (order.carId == null) {
      final errorMsg = 'carId не может быть null при обновлении заказа.';
      _logger.e(errorMsg);
      throw ArgumentError(errorMsg);
    }
    final companion = OrdersItemsCompanion(
      // uuid и createdAt не обновляем
      clientUuid: Value(order.clientId!),
      carUuid: Value(order.carId!),
      number: Value(core.code),
      date: Value(doc.documentDate),
      scheduledDate: Value(doc.scheduledDate),
      completedAt: Value(doc.completedAt),
      status: Value(doc.status.name),
      description: Value(order.description ?? ''),
      totalAmount: Value(doc.totalAmount ?? 0.0),
      isPosted: Value(doc.isPosted),
      modifiedAt: Value(DateTime.now()), // Всегда обновляем modifiedAt
      deletedAt: Value(core.deletedAt), // Позволяем обновить/сбросить deletedAt
    );
    _logger.d(LogMessages.orderUpdating.replaceAll('{uuid}', core.uuid));
    try {
      return await (update(ordersItems)..where((o) => o.uuid.equals(core.uuid)))
          .write(companion);
    } catch (e, s) {
      _logger.e(LogMessages.orderUpdateError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Обновляет статус заказ-наряда.
  Future<int> updateOrderStatus(String uuid, DocumentStatus status) {
    _logger.i(LogMessages.orderStatusUpdating
        .replaceAll('{uuid}', uuid)
        .replaceAll('{status}', status.name));
    try {
      return (update(ordersItems)..where((o) => o.uuid.equals(uuid)))
          .write(OrdersItemsCompanion(
        status: Value(status.name),
        modifiedAt: Value(DateTime.now()),
      ));
    } catch (e, s) {
      _logger.e(LogMessages.orderStatusUpdateError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Мягкое удаление заказ-наряда по UUID.
  Future<int> softDeleteOrder(String uuid) {
    _logger.i(LogMessages.orderSoftDeleting.replaceAll('{uuid}', uuid));
    try {
      return (update(ordersItems)..where((o) => o.uuid.equals(uuid)))
          .write(OrdersItemsCompanion(
        deletedAt: Value(DateTime.now()),
        modifiedAt: Value(DateTime.now()),
      ));
    } catch (e, s) {
      _logger.e(LogMessages.orderDeleteError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Восстановление удаленного заказ-наряда по UUID.
  Future<int> restoreOrder(String uuid) {
    _logger.i(LogMessages.orderRestoring.replaceAll('{uuid}', uuid));
    try {
      return (update(ordersItems)..where((o) => o.uuid.equals(uuid)))
          .write(OrdersItemsCompanion(
        deletedAt: const Value(null),
        modifiedAt:
            Value(DateTime.now()), // Обновляем modifiedAt при восстановлении
      ));
    } catch (e, s) {
      _logger.e(LogMessages.orderRestoreError, error: e, stackTrace: s);
      rethrow;
    }
  }

  // --- Методы для получения UUID заказов ---

  /// Возвращает список UUID активных заказ-нарядов.
  Future<List<String?>> getActiveOrderUuids() async {
    final query = selectOnly(ordersItems)
      ..where(ordersItems.deletedAt.isNull())
      ..addColumns([ordersItems.uuid]);
    final result = await query.get();
    return result.map((row) => row.read(ordersItems.uuid)).toList();
  }

  /// Реактивно наблюдает за списком UUID активных заказ-нарядов.
  Stream<List<String?>> watchActiveOrderUuids() {
    final query = selectOnly(ordersItems)
      ..where(ordersItems.deletedAt.isNull())
      ..addColumns([ordersItems.uuid]);
    return query
        .watch()
        .map((rows) => rows.map((row) => row.read(ordersItems.uuid)).toList());
  }

  /// Возвращает список UUID заказ-нарядов клиента.
  Future<List<String?>> getOrderUuidsByClientUuid(String clientUuid) async {
    final query = selectOnly(ordersItems)
      ..where(ordersItems.clientUuid.equals(clientUuid) &
          ordersItems.deletedAt.isNull())
      ..addColumns([ordersItems.uuid]);
    final result = await query.get();
    return result.map((row) => row.read(ordersItems.uuid)).toList();
  }

  /// Возвращает список UUID заказ-нарядов автомобиля.
  Future<List<String?>> getOrderUuidsByCarUuid(String carUuid) async {
    final query = selectOnly(ordersItems)
      ..where(
          ordersItems.carUuid.equals(carUuid) & ordersItems.deletedAt.isNull())
      ..addColumns([ordersItems.uuid]);
    final result = await query.get();
    return result.map((row) => row.read(ordersItems.uuid)).toList();
  }

  /// Возвращает список UUID заказ-нарядов по статусу.
  Future<List<String?>> getOrderUuidsByStatus(DocumentStatus status) async {
    final query = selectOnly(ordersItems)
      ..where(ordersItems.status.equals(status.name) &
          ordersItems.deletedAt.isNull())
      ..addColumns([ordersItems.uuid]);
    final result = await query.get();
    return result.map((row) => row.read(ordersItems.uuid)).toList();
  }

  /// Возвращает список UUID заказ-нарядов по строке поиска.
  Future<List<String?>> searchOrderUuids(String query) async {
    if (query.isEmpty) return [];
    final lowerQuery = '%${query.toLowerCase()}%';
    final queryBuilder = selectOnly(ordersItems)
      ..where((ordersItems.number.lower().like(lowerQuery) |
              ordersItems.description.lower().like(lowerQuery)) &
          ordersItems.deletedAt.isNull())
      ..addColumns([ordersItems.uuid]);
    final result = await queryBuilder.get();
    return result.map((row) => row.read(ordersItems.uuid)).toList();
  }

  // --- Методы для работы с элементами заказ-наряда ---

  /// Возвращает поток списка элементов (запчастей и услуг) для заказ-наряда,
  /// отсортированный по номеру строки.
  Stream<List<FullOrderItemData>> watchOrderItems(String orderUuid) {
    final partsStream = (select(orderPartsItems)
          ..where((p) => p.documentUuid.equals(orderUuid)))
        .watch()
        .map((parts) => parts.map(_mapToFullPartData).toList());

    final servicesStream = (select(orderServicesItems)
          ..where((s) => s.documentUuid.equals(orderUuid)))
        .watch()
        .map((services) => services.map(_mapToFullServiceData).toList());

    // Объединяем потоки запчастей и услуг, используя ZipStream
    return ZipStream([partsStream, servicesStream], (data) {
      final List<FullOrderItemData> parts = data[0];
      final List<FullOrderItemData> services = data[1];
      final combined = [...parts, ...services];
      // Сортируем объединенный список по номеру строки
      combined.sort(
          (a, b) => a.coreData.lineNumber.compareTo(b.coreData.lineNumber));
      return combined;
    });
  }

  /// Возвращает список элементов (запчастей и услуг) для заказ-наряда.
  Future<List<FullOrderItemData>> getOrderItems(String orderUuid) async {
    final parts = await (select(orderPartsItems)
          ..where((p) => p.documentUuid.equals(orderUuid)))
        .get();
    final services = await (select(orderServicesItems)
          ..where((s) => s.documentUuid.equals(orderUuid)))
        .get();

    final combined = [
      ...parts.map(_mapToFullPartData),
      ...services.map(_mapToFullServiceData),
    ];
    combined
        .sort((a, b) => a.coreData.lineNumber.compareTo(b.coreData.lineNumber));
    return combined;
  }

  /// Добавляет новую запчасть в заказ-наряд.
  Future<int> insertOrderPart(ItemCoreData core,
      DocumentItemSpecificData docItem, PartSpecificData part) async {
    final companion = OrderPartsItemsCompanion(
      uuid: Value(core.uuid),
      documentUuid: Value(part.documentUuid),
      lineNumber: Value(core.lineNumber), // Сохраняем номер строки
      partNumber: Value(part.partNumber),
      name: Value(core.name),
      brand: Value(part.brand),
      quantity: Value(docItem.quantity ?? 0.0),
      price: Value(docItem.price ?? 0.0),
      supplierName: Value(part.supplierName),
      deliveryDays: Value(part.deliveryDays),
      isOrdered: Value(part.isOrdered),
      isReceived: Value(part.isReceived),
      createdAt: Value(DateTime.now()),
    );
    _logger.d(LogMessages.orderItemInserting
        .replaceAll('{itemUuid}', core.uuid)
        .replaceAll('{orderUuid}', part.documentUuid));
    try {
      return await into(orderPartsItems).insert(companion);
    } catch (e, s) {
      _logger.e(LogMessages.orderItemAddError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Обновляет существующую запчасть заказ-наряда.
  Future<int> updateOrderPart(ItemCoreData core,
      DocumentItemSpecificData docItem, PartSpecificData part) async {
    final companion = OrderPartsItemsCompanion(
      // uuid, documentUuid, createdAt не обновляем
      lineNumber: Value(core.lineNumber), // Обновляем номер строки
      partNumber: Value(part.partNumber),
      name: Value(core.name),
      brand: Value(part.brand),
      quantity: Value(docItem.quantity ?? 0.0),
      price: Value(docItem.price ?? 0.0),
      supplierName: Value(part.supplierName),
      deliveryDays: Value(part.deliveryDays),
      isOrdered: Value(part.isOrdered),
      isReceived: Value(part.isReceived),
      modifiedAt: Value(DateTime.now()),
    );
    _logger.d(LogMessages.orderItemUpdating
        .replaceAll('{itemUuid}', core.uuid)
        .replaceAll('{orderUuid}', part.documentUuid));
    try {
      return await (update(orderPartsItems)
            ..where((p) => p.uuid.equals(core.uuid)))
          .write(companion);
    } catch (e, s) {
      _logger.e(LogMessages.orderItemUpdateError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Удаляет запчасть из заказ-наряда по UUID.
  Future<int> deleteOrderPart(String itemUuid) {
    // Не логируем orderUuid здесь, т.к. он не передается
    _logger.i(LogMessages.orderItemDeleting.replaceAll('{itemUuid}', itemUuid));
    try {
      return (delete(orderPartsItems)..where((p) => p.uuid.equals(itemUuid)))
          .go();
    } catch (e, s) {
      _logger.e(LogMessages.orderItemDeleteError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Добавляет новую услугу в заказ-наряд.
  Future<int> insertOrderService(ItemCoreData core,
      DocumentItemSpecificData docItem, ServiceSpecificData service) async {
    final companion = OrderServicesItemsCompanion(
      uuid: Value(core.uuid),
      documentUuid: Value(service.documentUuid),
      lineNumber: Value(core.lineNumber), // Сохраняем номер строки
      name: Value(core.name),
      description: const Value(null),
      price: Value(docItem.price ?? 0.0),
      duration: Value(service.duration),
      performedBy: Value(service.performedBy),
      isCompleted: Value(docItem.isCompleted),
      createdAt: Value(DateTime.now()),
    );
    _logger.d(LogMessages.orderItemInserting
        .replaceAll('{itemUuid}', core.uuid)
        .replaceAll('{orderUuid}', service.documentUuid));
    try {
      return await into(orderServicesItems).insert(companion);
    } catch (e, s) {
      _logger.e(LogMessages.orderItemAddError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Обновляет существующую услугу заказ-наряда.
  Future<int> updateOrderService(ItemCoreData core,
      DocumentItemSpecificData docItem, ServiceSpecificData service) async {
    final companion = OrderServicesItemsCompanion(
      // uuid, documentUuid, createdAt не обновляем
      lineNumber: Value(core.lineNumber), // Обновляем номер строки
      name: Value(core.name),
      description: const Value(null),
      price: Value(docItem.price ?? 0.0),
      duration: Value(service.duration),
      performedBy: Value(service.performedBy),
      isCompleted: Value(docItem.isCompleted),
      modifiedAt: Value(DateTime.now()),
    );
    _logger.d(LogMessages.orderItemUpdating
        .replaceAll('{itemUuid}', core.uuid)
        .replaceAll('{orderUuid}', service.documentUuid));
    try {
      return await (update(orderServicesItems)
            ..where((s) => s.uuid.equals(core.uuid)))
          .write(companion);
    } catch (e, s) {
      _logger.e(LogMessages.orderItemUpdateError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Удаляет услугу из заказ-наряда по UUID.
  Future<int> deleteOrderService(String itemUuid) {
    _logger.i(LogMessages.orderItemDeleting.replaceAll('{itemUuid}', itemUuid));
    try {
      return (delete(orderServicesItems)..where((s) => s.uuid.equals(itemUuid)))
          .go();
    } catch (e, s) {
      _logger.e(LogMessages.orderItemDeleteError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Возвращает поток полных данных заказ-наряда (заголовок + элементы).
  Stream<FullOrderData?> watchFullOrderData(String orderUuid) {
    final headerStream = (select(ordersItems)
          ..where((o) => o.uuid.equals(orderUuid) & o.deletedAt.isNull()))
        .watchSingleOrNull() // Используем watchSingleOrNull для обработки удаления
        .map((item) => item != null ? _mapToOrderHeaderData(item) : null);

    final itemsStream = watchOrderItems(orderUuid);

    // Объединяем поток заголовка и поток элементов, используя ZipStream
    return ZipStream([headerStream, itemsStream], (data) {
      // data[0] - это OrderHeaderData? (из headerStream)
      // data[1] - это List<FullOrderItemData> (из itemsStream)
      final OrderHeaderData? header =
          data[0] as OrderHeaderData?; // Приводим тип
      final List<FullOrderItemData> items =
          data[1] as List<FullOrderItemData>; // Приводим тип

      if (header == null) {
        return null; // Заказ-наряд не найден или удален
      }

      return FullOrderData(headerData: header, items: items);
    });
  }

  /// Поиск заголовков заказ-нарядов по строке (номер, описание).
  Future<List<OrderHeaderData>> searchOrderHeaders(String query) async {
    if (query.isEmpty) return [];
    final lowerQuery = '%${query.toLowerCase()}%';

    // TODO: Добавить поиск по имени клиента/автомобиля через JOIN?
    final items = await (select(ordersItems)
          ..where((o) =>
              (o.number.lower().like(lowerQuery) |
                  o.description.lower().like(lowerQuery)) & // Добавили lower()
              o.deletedAt.isNull()))
        .get();
    return items.map(_mapToOrderHeaderData).toList();
  }

  // --- Метод для сохранения полных данных заказа (в транзакции) ---

  /// Сохраняет полные данные заказ-наряда (заголовок и элементы) в транзакции.
  /// Если заказ новый, он будет вставлен. Если существующий - обновлен.
  /// Элементы синхронизируются: существующие обновляются, новые добавляются, отсутствующие удаляются.
  Future<void> saveFullOrderData(
    EntityCoreData coreData,
    DocumentSpecificData docData,
    OrderSpecificData orderData,
    List<Tuple3<ItemCoreData, DocumentItemSpecificData, dynamic>> itemsData,
  ) async {
    _logger.d('Сохранение полных данных заказа ${coreData.uuid}');
    try {
      await transaction(() async {
        // 1. Проверяем, существует ли заказ
        final existingOrder = await (select(ordersItems)
              ..where((o) => o.uuid.equals(coreData.uuid)))
            .getSingleOrNull();

        // 2. Сохраняем заголовок (insert или update)
        if (existingOrder == null) {
          await insertOrder(coreData, docData, orderData);
        } else {
          // Убедимся, что передаем правильные данные для обновления
          // coreData может содержать старые createdAt, которые не нужно обновлять
          // docData и orderData содержат актуальные данные
          await updateOrder(coreData, docData, orderData);
        }

        // 3. Получаем текущие UUID элементов из БД
        final currentDbPartUuids = await (selectOnly(orderPartsItems)
              ..where(orderPartsItems.documentUuid.equals(coreData.uuid))
              ..addColumns([orderPartsItems.uuid]))
            .get()
            .then((rows) =>
                rows.map((r) => r.read(orderPartsItems.uuid)).toSet());

        final currentDbServiceUuids = await (selectOnly(orderServicesItems)
              ..where(orderServicesItems.documentUuid.equals(coreData.uuid))
              ..addColumns([orderServicesItems.uuid]))
            .get()
            .then((rows) =>
                rows.map((r) => r.read(orderServicesItems.uuid)).toSet());

        // 4. Обрабатываем переданные элементы
        final Set<String> incomingPartUuids = {};
        final Set<String> incomingServiceUuids = {};

        for (final itemTuple in itemsData) {
          final itemCore = itemTuple.item1;
          final itemDoc = itemTuple.item2;
          final itemSpecific = itemTuple.item3;

          if (itemSpecific is PartSpecificData) {
            incomingPartUuids.add(itemCore.uuid);
            if (currentDbPartUuids.contains(itemCore.uuid)) {
              await updateOrderPart(itemCore, itemDoc, itemSpecific);
            } else {
              await insertOrderPart(itemCore, itemDoc, itemSpecific);
            }
          } else if (itemSpecific is ServiceSpecificData) {
            incomingServiceUuids.add(itemCore.uuid);
            if (currentDbServiceUuids.contains(itemCore.uuid)) {
              await updateOrderService(itemCore, itemDoc, itemSpecific);
            } else {
              await insertOrderService(itemCore, itemDoc, itemSpecific);
            }
          }
        }

        // 5. Удаляем элементы, которых нет во входящем списке
        final partsToDelete = currentDbPartUuids.difference(incomingPartUuids);
        // Фильтруем null значения перед итерацией с помощью whereType<String>()
        for (final uuid in partsToDelete.whereType<String>()) {
          // Теперь uuid гарантированно имеет тип String
          await deleteOrderPart(uuid);
        }

        final servicesToDelete =
            currentDbServiceUuids.difference(incomingServiceUuids);
        // Фильтруем null значения перед итерацией с помощью whereType<String>()
        for (final uuid in servicesToDelete.whereType<String>()) {
          // Теперь uuid гарантированно имеет тип String
          await deleteOrderService(uuid); // Строка 750
        }
      });
    } catch (e, s) {
      _logger.e('Ошибка транзакции сохранения заказа ${coreData.uuid}',
          error: e, stackTrace: s);
      rethrow;
    }
  }
}

// Пример кортежа (можно использовать пакет tuple или свой класс)
// Убедитесь, что этот класс или аналогичный импортирован/определен
// там, где он используется (в DAO и Service)
class Tuple3<T1, T2, T3> {
  final T1 item1;
  final T2 item2;
  final T3 item3;
  Tuple3(this.item1, this.item2, this.item3);
}
