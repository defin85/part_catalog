import 'package:rxdart/rxdart.dart';

import 'package:part_catalog/core/database/daos/cars_dao.dart';
import 'package:part_catalog/core/database/daos/clients_dao.dart';
import 'package:part_catalog/core/database/daos/orders_dao.dart'; // Содержит OrderHeaderData, FullOrderItemData, Tuple3
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/database_error_recovery.dart';
import 'package:part_catalog/core/utils/error_handler.dart';
import 'package:part_catalog/core/utils/log_messages.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:part_catalog/features/core/document_item_specific_data.dart';
import 'package:part_catalog/features/core/document_status.dart';
import 'package:part_catalog/features/core/i_document_item_entity.dart';
import 'package:part_catalog/features/core/item_core_data.dart';
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';
import 'package:part_catalog/features/documents/orders/models/order_part_model_composite.dart';
import 'package:part_catalog/features/documents/orders/models/order_service_model_composite.dart';

// --- Новые импорты ---
// --- Импорты @freezed моделей данных (предполагается, что они существуют) ---
// --- Остальные импорты ---

/// Сервис для работы с заказ-нарядами
///
/// Этот сервис обеспечивает бизнес-логику для операций с заказ-нарядами,
/// работает с бизнес-моделями (композиторами) и преобразует их
/// во/из `@freezed` моделей данных для взаимодействия с DAO.
class OrderService {
  final AppDatabase _database;
  final _logger = AppLoggers.orders;
  late final DatabaseErrorRecovery _errorRecovery;

  /// Получение DAO для работы с заказ-нарядами из базы данных
  OrdersDao get _ordersDao => _database.ordersDao;

  /// Получение DAO для работы с клиентами
  ClientsDao get _clientsDao => _database.clientsDao;

  /// Получение DAO для работы с автомобилями
  CarsDao get _carsDao => _database.carsDao;

  /// Создает экземпляр сервиса заказ-нарядов
  ///
  /// @param database Экземпляр базы данных для доступа к данным
  OrderService(this._database) {
    _errorRecovery = DatabaseErrorRecovery(_database);
  }

  // --- Вспомогательный метод для маппинга данных из DAO в композитор ---
  Future<OrderModelComposite> _mapDataToComposite(String uuid) async {
    // 1. Получить заголовок заказа (@freezed) из DAO
    final headerData = await _ordersDao.getOrderHeaderByUuid(uuid);
    if (headerData == null) {
      // Используем константу
      final errorMsg =
          LogMessages.orderNotFoundByUuid.replaceAll('{uuid}', uuid);
      _logger.e(errorMsg);
      throw Exception(errorMsg);
    }
    final coreData = headerData.coreData;
    final docData = headerData.docData;
    final orderData = headerData.orderData;

    // 2. Получить данные элементов заказа (@freezed) из DAO
    final itemsData =
        await _ordersDao.getOrderItems(uuid); // Используем новый метод
    final Map<BaseItemType, List<IDocumentItemEntity>> itemsMap = {};

    for (final fullItemData in itemsData) {
      // Итерируем по FullOrderItemData
      final itemCore = fullItemData.coreData;
      final itemDoc = fullItemData.docItemData;
      final itemType = fullItemData.itemType;
      IDocumentItemEntity itemEntity;

      if (itemType == BaseItemType.part && fullItemData.partData != null) {
        // Используем публичный фабричный конструктор fromData
        itemEntity = OrderPartModelComposite(
            coreData: itemCore,
            docItemData: itemDoc,
            partData: fullItemData.partData!);
      } else if (itemType == BaseItemType.service &&
          fullItemData.serviceData != null) {
        // Используем публичный фабричный конструктор fromData
        itemEntity = OrderServiceModelComposite(
            coreData: itemCore,
            docItemData: itemDoc,
            serviceData: fullItemData.serviceData!);
      } else {
        // Используем константу
        _logger.w(LogMessages.orderItemInvalidData
            .replaceAll('{itemUuid}', itemCore.uuid));
        continue;
      }
      itemsMap.putIfAbsent(itemType, () => []).add(itemEntity);
    }

    // 3. Создать композитор
    return OrderModelComposite.fromData(coreData, docData, orderData, itemsMap);
  }

  // --- Вспомогательный метод для маппинга данных из DAO в композитор (Stream) ---
  Stream<OrderModelComposite> _mapStreamDataToComposite(String uuid) {
    final baseDataStream =
        _ordersDao.watchOrderHeaderByUuid(uuid); // Используем новый метод
    final itemsDataStream =
        _ordersDao.watchOrderItems(uuid); // Используем новый метод

    return CombineLatestStream.combine2(
      baseDataStream,
      itemsDataStream,
      (OrderHeaderData? baseData, List<FullOrderItemData> itemsData) {
        // Добавляем проверку на null для baseData
        if (baseData == null) {
          // Если заголовок null (заказ удален или не найден), возвращаем null или ошибку
          // В данном случае, чтобы CombineLatestStream продолжал работать,
          // можно либо пробросить ошибку, либо вернуть специальное значение,
          // либо фильтровать null позже. Пробросим ошибку.
          throw Exception(
              LogMessages.orderNotFoundByUuid.replaceAll('{uuid}', uuid));
        }

        final coreData = baseData.coreData;
        final docData = baseData.docData;
        final orderData = baseData.orderData;
        final Map<BaseItemType, List<IDocumentItemEntity>> itemsMap = {};

        for (final fullItemData in itemsData) {
          final itemCore = fullItemData.coreData;
          final itemDoc = fullItemData.docItemData;
          final itemType = fullItemData.itemType;
          IDocumentItemEntity itemEntity;

          if (itemType == BaseItemType.part && fullItemData.partData != null) {
            // Используем публичный фабричный конструктор fromData
            itemEntity = OrderPartModelComposite(
                coreData: itemCore,
                docItemData: itemDoc,
                partData: fullItemData.partData!);
          } else if (itemType == BaseItemType.service &&
              fullItemData.serviceData != null) {
            // Используем публичный фабричный конструктор fromData
            itemEntity = OrderServiceModelComposite(
                coreData: itemCore,
                docItemData: itemDoc,
                serviceData: fullItemData.serviceData!);
          } else {
            // Используем константу
            _logger.w(LogMessages.orderItemInvalidData
                .replaceAll('{itemUuid}', itemCore.uuid));
            continue;
          }
          itemsMap.putIfAbsent(itemType, () => []).add(itemEntity);
        }
        return OrderModelComposite.fromData(
            coreData, docData, orderData, itemsMap);
      },
    ).handleError((e, stackTrace) {
      // Логируем ошибку из потока
      // Используем константу
      _logger.e(
          LogMessages.orderStreamError
              .replaceAll('{uuid}', uuid)
              .replaceAll('{error}', e.toString()),
          error: e,
          stackTrace: stackTrace);
      // Пробрасываем ошибку дальше, чтобы внешний подписчик мог ее обработать
      throw e;
    });
  }

  /// Получает список всех активных заказ-нарядов
  Future<List<OrderModelComposite>> getOrders() async {
    return ErrorHandler.executeWithLogging(
      operation: () async {
        final orderUuids = await _ordersDao.getActiveOrderUuids();
        // Фильтруем null UUIDs, если DAO может их вернуть
        final nonNullUuids = orderUuids.whereType<String>().toList();
        if (nonNullUuids.isEmpty) return [];

        final List<Future<OrderModelComposite>> futures =
            nonNullUuids.map((uuid) => _mapDataToComposite(uuid)).toList();
        return await Future.wait(futures);
      },
      logger: _logger,
      operationName: 'getOrders',
    );
  }

  /// Реактивно наблюдает за списком всех активных заказ-нарядов
  Stream<List<OrderModelComposite>> watchOrders() {
    try {
      return _ordersDao.watchActiveOrderUuids().switchMap((uuids) {
        // Фильтруем null UUIDs
        final nonNullUuids = uuids.whereType<String>().toList();
        if (nonNullUuids.isEmpty) {
          return Stream.value(<OrderModelComposite>[]);
        }
        final List<Stream<OrderModelComposite>> orderStreams = nonNullUuids
            .map((uuid) => _mapStreamDataToComposite(uuid)
                    // Добавляем обработку ошибок для каждого отдельного стрима заказа,
                    // чтобы ошибка в одном не обрушила весь CombineLatestStream
                    .handleError((e, s) {
                  // Используем константу
                  _logger.e(
                      LogMessages.orderListStreamItemError
                          .replaceAll('{uuid}', uuid),
                      error: e,
                      stackTrace: s);
                  // Возвращаем пустой стрим или стрим с ошибкой, чтобы CombineLatest продолжил работу
                  return const Stream<OrderModelComposite>.empty();
                  // или return Stream.error(e); - но это остановит CombineLatest
                }))
            .toList();
        // Используем CombineLatestStream.list для объединения потоков
        return CombineLatestStream.list<OrderModelComposite>(orderStreams).map(
            (orders) => orders
                .whereType<OrderModelComposite>()
                .toList()); // Фильтруем возможные null/ошибки
      }).handleError((e, stackTrace) {
        _logger.e(LogMessages.orderWatchError,
            error: e, stackTrace: stackTrace);
        // Возвращаем стрим с ошибкой
        return Stream.error(e);
      });
    } catch (e, stackTrace) {
      _logger.e(LogMessages.orderWatchError, error: e, stackTrace: stackTrace);
      // Возвращаем стрим с ошибкой, если исключение возникло синхронно
      return Stream.error(e);
    }
  }

  /// Реактивно наблюдает за пагинированным списком заголовков заказ-нарядов.
  Stream<List<OrderHeaderData>> watchOrderHeadersPaginated(
      {required int limit, int? offset}) {
    try {
      return _ordersDao.watchActiveOrderHeadersPaginated(
          limit: limit, offset: offset);
    } catch (e, stackTrace) {
      _logger.e('Error watching paginated order headers',
          error: e, stackTrace: stackTrace);
      return Stream.error(e);
    }
  }

  /// Получает заказ-наряд по UUID
  ///
  /// @param uuid UUID заказ-наряда
  /// @return Бизнес-модель заказ-наряда
  Future<OrderModelComposite> getOrderByUuid(String uuid) async {
    try {
      return await _mapDataToComposite(uuid);
    } catch (e, stackTrace) {
      _logger.e(LogMessages.orderByUuidGetError.replaceAll('{uuid}', uuid),
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Реактивно наблюдает за заказ-нарядом по UUID
  ///
  /// @param uuid UUID заказ-наряда
  /// @return Поток с обновлениями бизнес-модели заказ-наряда
  Stream<OrderModelComposite> watchOrderByUuid(String uuid) {
    try {
      return _mapStreamDataToComposite(uuid).handleError((e, stackTrace) {
        // Логируем и пробрасываем ошибку
        _logger.e(LogMessages.orderByUuidWatchError.replaceAll('{uuid}', uuid),
            error: e, stackTrace: stackTrace);
        throw e;
      });
    } catch (e, stackTrace) {
      _logger.e(LogMessages.orderByUuidWatchError.replaceAll('{uuid}', uuid),
          error: e, stackTrace: stackTrace);
      // Возвращаем стрим с ошибкой, если исключение синхронное
      return Stream.error(e);
    }
  }

  /// Сохраняет (создает или обновляет) заказ-наряд
  ///
  /// @param order Бизнес-модель заказ-наряда для сохранения
  Future<void> _saveOrder(OrderModelComposite order) async {
    try {
      // Извлекаем @freezed модели из композитора
      final coreData = order.coreData;
      final docData = order.docData;
      final orderData = order.orderData;
      // Используем расширение для получения Tuple3
      final itemsData = order.itemsMap.values
          .expand((list) => list)
          .map((item) => item.getAllData())
          .toList();

      // Вызываем новый метод DAO
      await _ordersDao.saveFullOrderData(
          coreData, docData, orderData, itemsData);
    } catch (e, stackTrace) {
      // Используем константу
      _logger.e(LogMessages.orderSaveError.replaceAll('{uuid}', order.uuid),
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Создает новый заказ-наряд
  ///
  /// @param order Бизнес-модель заказ-наряда для создания
  /// @return UUID созданного заказ-наряда
  Future<String> createOrder(OrderModelComposite order) async {
    try {
      // Можно добавить проверку, что UUID еще не существует в БД, если нужно
      await _saveOrder(order);
      // Используем константу
      _logger.i(LogMessages.orderCreated.replaceAll('{uuid}', order.uuid));
      return order.uuid;
    } catch (e, stackTrace) {
      _logger.e(LogMessages.orderCreateError, error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Создает новый заказ-наряд с базовыми параметрами
  ///
  /// @param clientUuid UUID клиента
  /// @param carUuid UUID автомобиля
  /// @param description Описание работ или проблемы
  /// @param scheduledDate Планируемая дата выполнения
  /// @return OrderModelComposite Созданная бизнес-модель заказ-наряда
  Future<OrderModelComposite> createNewOrder({
    required String clientUuid,
    required String carUuid,
    String? description,
    DateTime? scheduledDate,
  }) async {
    return _errorRecovery.executeWithRetry(
      () async {
        // Получаем базовые данные клиента
        final clientCoreData = await _clientsDao
            .getClientCoreData(clientUuid); // Используем новый метод

        if (clientCoreData == null) {
          final errorMsg =
              LogMessages.clientNotFoundByUuid.replaceAll('{uuid}', clientUuid);
          _logger.e(errorMsg);
          throw Exception(errorMsg);
        }

        // Получаем базовые данные автомобиля
        final carCoreData =
            await _carsDao.getCarCoreData(carUuid); // Используем новый метод

        if (carCoreData == null) {
          final errorMsg =
              LogMessages.carNotFoundByUuid.replaceAll('{uuid}', carUuid);
          _logger.e(errorMsg);
          throw Exception(errorMsg);
        }

        // Создаем бизнес-модель (композитор)
        final orderModel = OrderModelComposite.create(
          // Используем фабричный конструктор композитора
          code: '', // Генерировать или получать из настроек/DAO
          displayName:
              'Заказ-наряд от ${DateTime.now().toLocal().toString().substring(0, 10)}', // Пример
          documentDate: DateTime.now(),
          clientId: clientUuid,
          carId: carUuid,
          description: description,
          scheduledDate: scheduledDate, // Передаем в конструктор
          // clientName и carInfo больше не нужны как параметры
        );

        // Сохраняем в базу данных
        await _saveOrder(orderModel);
        // Используем константу
        _logger
            .i(LogMessages.orderCreated.replaceAll('{uuid}', orderModel.uuid));
        return orderModel;
      },
      operationName: 'createNewOrder(client: $clientUuid, car: $carUuid)',
    );
  }

  /// Обновляет существующий заказ-наряд
  ///
  /// @param order Бизнес-модель заказ-наряда с обновленными данными
  Future<void> updateOrder(OrderModelComposite order) async {
    try {
      // Обновляем modifiedAt перед сохранением (предполагаем, что метод есть)
      final updatedOrder = order.copyWith(
        coreData: order.coreData.copyWith(modifiedAt: DateTime.now()),
      );
      await _saveOrder(updatedOrder);
      // Используем константу
      _logger.d(LogMessages.orderUpdated.replaceAll('{uuid}', order.uuid));
    } catch (e, stackTrace) {
      _logger.e(LogMessages.orderUpdateError.replaceAll('{uuid}', order.uuid),
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Изменяет статус заказ-наряда
  ///
  /// @param orderUuid UUID заказ-наряда
  /// @param newStatus Новый статус
  Future<void> changeOrderStatus(
      String orderUuid, DocumentStatus newStatus) async {
    await ErrorHandler.executeWithLogging(
      operation: () async {
        final order = await getOrderByUuid(orderUuid);
        // Используем метод `with...` композитора для иммутабельного обновления
        // Предполагаем, что метод withStatus существует
        final updatedOrder = order.copyWith(
          docData: order.docData.copyWith(status: newStatus),
          coreData: order.coreData.copyWith(modifiedAt: DateTime.now()),
        );
        await updateOrder(updatedOrder);
        // Используем константу
        _logger.i(LogMessages.orderStatusUpdated
            .replaceAll('{uuid}', orderUuid)
            .replaceAll('{status}', newStatus.name));
      },
      logger: _logger,
      operationName: 'changeOrderStatus($orderUuid, ${newStatus.name})',
    );
  }

  /// Добавляет элемент (услугу или запчасть) к заказ-наряду
  ///
  /// @param orderUuid UUID заказ-наряда
  /// @param item Бизнес-модель элемента для добавления
  Future<void> addItemToOrder(
      String orderUuid, IDocumentItemEntity item) async {
    try {
      final order = await getOrderByUuid(orderUuid);
      // Предполагаем, что метод withAddedItem существует
      final updatedOrder = order.withAddedItem(item);
      await updateOrder(updatedOrder);
      // Используем константу
      _logger.d(LogMessages.orderItemAdded
          .replaceAll('{itemUuid}', item.uuid)
          .replaceAll('{orderUuid}', orderUuid));
    } catch (e, stackTrace) {
      // Используем константу
      _logger.e(
          LogMessages.orderAddItemError
              .replaceAll('{itemUuid}', item.uuid)
              .replaceAll('{orderUuid}', orderUuid),
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Обновляет элемент (услугу или запчасть) в заказ-наряде
  ///
  /// @param orderUuid UUID заказ-наряда
  /// @param item Обновленная бизнес-модель элемента
  Future<void> updateOrderItem(
      String orderUuid, IDocumentItemEntity item) async {
    try {
      final order = await getOrderByUuid(orderUuid);
      // Предполагаем, что метод withUpdatedItem существует
      final updatedOrder = order.withUpdatedItem(item);
      await updateOrder(updatedOrder);
      // Используем константу
      _logger.d(LogMessages.orderItemUpdated
          .replaceAll('{itemUuid}', item.uuid)
          .replaceAll('{orderUuid}', orderUuid));
    } catch (e, stackTrace) {
      // Используем константу
      _logger.e(
          LogMessages.orderUpdateItemError
              .replaceAll('{itemUuid}', item.uuid)
              .replaceAll('{orderUuid}', orderUuid),
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Удаляет элемент (услугу или запчасть) из заказ-наряда
  ///
  /// @param itemUuid UUID элемента
  /// @param orderUuid UUID заказ-наряда
  Future<void> removeItemFromOrder(String itemUuid, String orderUuid) async {
    try {
      final order = await getOrderByUuid(orderUuid);
      // Предполагаем, что метод withRemovedItem существует
      final updatedOrder = order.withRemovedItem(itemUuid);
      await updateOrder(updatedOrder);
      // Используем константу
      _logger.i(LogMessages.orderItemRemoved
          .replaceAll('{itemUuid}', itemUuid)
          .replaceAll('{orderUuid}', orderUuid));
    } catch (e, stackTrace) {
      // Используем константу
      _logger.e(
          LogMessages.orderRemoveItemError
              .replaceAll('{itemUuid}', itemUuid)
              .replaceAll('{orderUuid}', orderUuid),
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Выполняет мягкое удаление заказ-наряда
  ///
  /// @param orderUuid UUID заказ-наряда
  Future<void> deleteOrder(String orderUuid) async {
    try {
      final order = await getOrderByUuid(orderUuid);
      // Предполагаем, что метод markAsDeleted существует
      final deletedOrder = order.copyWith(
        coreData: order.coreData.copyWith(
          isDeleted: true,
          deletedAt: DateTime.now(),
          modifiedAt: DateTime.now(),
        ),
      );
      await updateOrder(deletedOrder);
      // Используем константу
      _logger.i(LogMessages.orderDeleted.replaceAll('{uuid}', orderUuid));
    } catch (e, stackTrace) {
      _logger.e(LogMessages.orderDeleteError.replaceAll('{uuid}', orderUuid),
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Восстанавливает удаленный заказ-наряд
  ///
  /// @param orderUuid UUID заказ-наряда
  Future<void> restoreOrder(String orderUuid) async {
    try {
      // Важно: _mapDataToComposite использует getOrderHeaderByUuid, который
      // по умолчанию НЕ возвращает удаленные. Нужно либо изменить DAO,
      // либо предположить, что updateOrder/saveFullOrderData корректно
      // обработает установку deletedAt = null.
      // Пока предполагаем, что updateOrder сработает.
      // Получаем текущие данные (даже если они помечены как удаленные в coreData)
      // Возможно, потребуется метод в DAO для получения удаленных.
      // final order = await _getPotentiallyDeletedOrder(orderUuid); // Гипотетический метод
      final order = await getOrderByUuid(orderUuid); // Попробуем так

      if (order.deletedAt == null) {
        // Используем константу
        _logger.w(LogMessages.orderRestoreAttemptOnNonDeleted
            .replaceAll('{uuid}', orderUuid));
        return;
      }
      // Предполагаем, что метод restore существует
      final restoredOrder = order.copyWith(
        coreData: order.coreData.copyWith(
          isDeleted: false,
          deletedAt: null,
          modifiedAt: DateTime.now(),
        ),
      );
      await updateOrder(restoredOrder);
      // Используем константу
      _logger.i(LogMessages.orderRestored.replaceAll('{uuid}', orderUuid));
    } catch (e, stackTrace) {
      _logger.e(LogMessages.orderRestoreError.replaceAll('{uuid}', orderUuid),
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Создает новую услугу и добавляет её в заказ-наряд
  Future<OrderServiceModelComposite> createAndAddService({
    required String orderUuid,
    required String name,
    String? description,
    required double price,
    double? duration,
    String? performedBy,
  }) async {
    try {
      // Создаем бизнес-модель услуги
      final serviceModel = OrderServiceModelComposite.create(
        documentUuid: orderUuid,
        name: name,
        description: description,
        price: price,
        duration: duration,
        performedBy: performedBy,
        // isCompleted: false, // Значение по умолчанию в ServiceSpecificData
      );
      await addItemToOrder(orderUuid, serviceModel);
      // Используем константу
      _logger.d(LogMessages.orderServiceCreatedAdd
          .replaceAll('{itemUuid}', serviceModel.uuid)
          .replaceAll('{orderUuid}', orderUuid));
      return serviceModel;
    } catch (e, stackTrace) {
      _logger.e(
          LogMessages.orderServiceCreateAddError
              .replaceAll('{orderUuid}', orderUuid),
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Создает новую запчасть и добавляет её в заказ-наряд
  Future<OrderPartModelComposite> createAndAddPart({
    required String orderUuid,
    required String partNumber,
    required String name,
    required double price,
    String? brand,
    double quantity = 1,
    String? supplierName,
    int? deliveryDays,
  }) async {
    try {
      // Создаем бизнес-модель запчасти
      final partModel = OrderPartModelComposite.create(
        documentUuid: orderUuid,
        partNumber: partNumber,
        name: name,
        brand: brand,
        price: price,
        quantity: quantity,
        supplierName: supplierName,
        deliveryDays: deliveryDays,
      );
      await addItemToOrder(orderUuid, partModel);
      // Используем константу
      _logger.d(LogMessages.orderPartCreatedAdd
          .replaceAll('{itemUuid}', partModel.uuid)
          .replaceAll('{orderUuid}', orderUuid));
      return partModel;
    } catch (e, stackTrace) {
      _logger.e(
          LogMessages.orderPartCreateAddError
              .replaceAll('{orderUuid}', orderUuid),
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает заказ-наряды по UUID клиента
  Future<List<OrderModelComposite>> getOrdersByClientUuid(
      String clientUuid) async {
    try {
      final orderUuids = await _ordersDao.getOrderUuidsByClientUuid(clientUuid);
      final nonNullUuids = orderUuids.whereType<String>().toList();
      if (nonNullUuids.isEmpty) return [];
      final List<Future<OrderModelComposite>> futures =
          nonNullUuids.map((uuid) => _mapDataToComposite(uuid)).toList();
      return await Future.wait(futures);
    } catch (e, stackTrace) {
      _logger.e(
          LogMessages.orderGetByClientError
              .replaceAll('{clientId}', clientUuid),
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает заказ-наряды по UUID автомобиля
  Future<List<OrderModelComposite>> getOrdersByCarUuid(String carUuid) async {
    try {
      final orderUuids = await _ordersDao.getOrderUuidsByCarUuid(carUuid);
      final nonNullUuids = orderUuids.whereType<String>().toList();
      if (nonNullUuids.isEmpty) return [];
      final List<Future<OrderModelComposite>> futures =
          nonNullUuids.map((uuid) => _mapDataToComposite(uuid)).toList();
      return await Future.wait(futures);
    } catch (e, stackTrace) {
      _logger.e(LogMessages.orderGetByCarError.replaceAll('{carId}', carUuid),
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Получает заказ-наряды по статусу
  Future<List<OrderModelComposite>> getOrdersByStatus(
      DocumentStatus status) async {
    try {
      final orderUuids = await _ordersDao.getOrderUuidsByStatus(status);
      final nonNullUuids = orderUuids.whereType<String>().toList();
      if (nonNullUuids.isEmpty) return [];
      final List<Future<OrderModelComposite>> futures =
          nonNullUuids.map((uuid) => _mapDataToComposite(uuid)).toList();
      return await Future.wait(futures);
    } catch (e, stackTrace) {
      _logger.e(
          LogMessages.orderGetByStatusError.replaceAll('{status}', status.name),
          error: e,
          stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Выполняет поиск заказ-нарядов по строке запроса
  Future<List<OrderModelComposite>> searchOrders(String query) async {
    try {
      final orderUuids = await _ordersDao.searchOrderUuids(query);
      final nonNullUuids = orderUuids.whereType<String>().toList();
      if (nonNullUuids.isEmpty) return [];
      final List<Future<OrderModelComposite>> futures =
          nonNullUuids.map((uuid) => _mapDataToComposite(uuid)).toList();
      return await Future.wait(futures);
    } catch (e, stackTrace) {
      _logger.e(LogMessages.orderSearchError.replaceAll('{query}', query),
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  // --- Методы `provesti` и `otmenit` ---

  /// Проводит заказ-наряд
  Future<void> provesti(String orderUuid) async {
    try {
      final order = await getOrderByUuid(orderUuid);

      // Проверка статуса и флага проведения
      // TODO: Уточнить логику статуса для проведения. Возможно, нужен статус 'Completed' или 'ReadyForPosting'?
      // if (order.status != DocumentStatus.completed) { // Пример
      //   throw Exception(
      //       'Невозможно провести заказ-наряд. Требуется статус "Completed". Текущий статус: ${order.status.name}');
      // }
      if (!order.canPost) {
        // Используем константу
        _logger.w(LogMessages.orderPostAttemptOnPosted
            .replaceAll('{uuid}', orderUuid));
        return;
      }

      // ... логика создания движений в регистрах (если есть) ...

      // Обновляем флаг isPosted в композиторе (предполагаем, что метод есть)
      final updatedOrder = order.copyWith(
        docData:
            order.docData.copyWith(isPosted: true, postedAt: DateTime.now()),
        coreData: order.coreData.copyWith(modifiedAt: DateTime.now()),
      );

      await updateOrder(updatedOrder);
      // Используем константу
      _logger.i(LogMessages.orderPosted.replaceAll('{uuid}', orderUuid));
    } catch (e, stackTrace) {
      _logger.e(LogMessages.orderProvestiError.replaceAll('{uuid}', orderUuid),
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Отменяет проведение заказ-наряда
  Future<void> otmenit(String orderUuid) async {
    try {
      final order = await getOrderByUuid(orderUuid);

      if (!order.canUnpost) {
        // Используем константу
        _logger.w(LogMessages.orderUnpostAttemptOnUnposted
            .replaceAll('{uuid}', orderUuid));
        return; // Или бросить исключение
      }

      // ... логика удаления движений в регистрах (если есть) ...

      // Обновляем флаг isPosted (предполагаем, что метод есть)
      final updatedOrder = order.copyWith(
        docData: order.docData.copyWith(isPosted: false, postedAt: null),
        coreData: order.coreData.copyWith(modifiedAt: DateTime.now()),
      );

      await updateOrder(updatedOrder);
      // Используем константу
      _logger.i(LogMessages.orderUnposted.replaceAll('{uuid}', orderUuid));
    } catch (e, stackTrace) {
      _logger.e(LogMessages.orderOtmenitError.replaceAll('{uuid}', orderUuid),
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
}

// --- Вспомогательные расширения или методы для IDocumentItemEntity ---
// Убедитесь, что это расширение доступно или перенесите его сюда
extension DocumentItemEntityData on IDocumentItemEntity {
  Tuple3<ItemCoreData, DocumentItemSpecificData, dynamic> getAllData() {
    if (this is OrderPartModelComposite) {
      final part = this as OrderPartModelComposite;
      return Tuple3(part.coreData, part.docItemData, part.partData);
    } else if (this is OrderServiceModelComposite) {
      final service = this as OrderServiceModelComposite;
      return Tuple3(service.coreData, service.docItemData, service.serviceData);
    }
    throw Exception('Неизвестный тип IDocumentItemEntity: $runtimeType');
  }
}

// Убедитесь, что класс Tuple3 определен или импортирован
// class Tuple3<T1, T2, T3> { ... }
