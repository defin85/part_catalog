import 'package:drift/drift.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/items/cars_items.dart';
import 'package:part_catalog/core/database/items/clients_items.dart';
import 'package:part_catalog/core/utils/log_messages.dart';
// Логгер
import 'package:part_catalog/core/utils/logger_config.dart';
// Импортируем @freezed модели данных
import 'package:part_catalog/features/core/entity_core_data.dart';
// Импортируем @freezed модели для клиента
import 'package:part_catalog/features/references/clients/models/client_specific_data.dart';
import 'package:part_catalog/features/references/clients/models/client_type.dart';
import 'package:part_catalog/features/references/vehicles/models/car_specific_data.dart';

part 'cars_dao.g.dart';

/// Модель для возврата полных данных автомобиля (@freezed модели)
class CarFullData {
  final EntityCoreData coreData;
  final CarSpecificData carData;

  CarFullData({required this.coreData, required this.carData});
}

/// Модель для представления автомобиля с данными владельца (@freezed модели)
class CarWithOwnerData {
  final CarFullData carFullData;
  final EntityCoreData ownerCoreData; // Используем EntityCoreData для владельца
  final ClientSpecificData ownerSpecificData; // Используем ClientSpecificData

  CarWithOwnerData({
    required this.carFullData,
    required this.ownerCoreData,
    required this.ownerSpecificData,
  });
}

/// {@template cars_dao}
/// Объект доступа к данным для работы с автомобилями.
/// Работает с @freezed моделями данных (EntityCoreData, CarSpecificData),
/// используя UUID для связывания и маппинга.
/// {@endtemplate}
@DriftAccessor(tables: [CarsItems, ClientsItems])
class CarsDao extends DatabaseAccessor<AppDatabase> with _$CarsDaoMixin {
  /// {@macro cars_dao}
  CarsDao(super.db);

  // Используем логгер из AppLoggers
  final _logger = AppLoggers.database; // Или AppLoggers.vehiclesLogger

  // --- Приватные методы маппинга (из таблицы в @freezed) ---

  /// Маппинг из CarsItem в EntityCoreData
  EntityCoreData _mapToCoreData(CarsItem item) {
    return EntityCoreData(
      uuid: item.uuid,
      code: item.code,
      displayName:
          '${item.make} ${item.model} (${item.year})', // Формируем displayName
      createdAt: item.createdAt,
      modifiedAt: item.modifiedAt,
      deletedAt: item.deletedAt,
      isDeleted: item.deletedAt != null,
    );
  }

  /// Маппинг из CarsItem и clientUuid в CarSpecificData
  CarSpecificData _mapToCarSpecificData(CarsItem item, String clientUuid) {
    return CarSpecificData(
      clientId: clientUuid, // Используем переданный UUID клиента
      vin: item.vin ?? '', // Обеспечиваем non-nullable String
      make: item.make,
      model: item.model,
      year: item.year ?? 0, // Обеспечиваем non-nullable int
      licensePlate: item.licensePlate,
      additionalInfo: item.additionalInfo,
    );
  }

  /// Маппинг из CarsItem и clientUuid в CarFullData
  CarFullData _mapToCarFullData(CarsItem item, String clientUuid) {
    return CarFullData(
      coreData: _mapToCoreData(item),
      carData: _mapToCarSpecificData(item, clientUuid),
    );
  }

  /// Вспомогательный метод для получения int ID клиента по его UUID.
  Future<int?> _getClientIntId(String clientUuid) async {
    final client = await (select(clientsItems)
          ..where((c) => c.uuid.equals(clientUuid)))
        .getSingleOrNull();
    if (client == null) {
      // Используем константу
      _logger
          .w(LogMessages.clientNotFoundByUuid.replaceAll('{uuid}', clientUuid));
    }
    return client?.id;
  }

  // --- Публичные методы DAO ---

  /// Возвращает поток списка всех активных автомобилей в виде CarFullData.
  Stream<List<CarFullData>> watchAllActiveCars() {
    // Используем JOIN для получения UUID клиента
    final query = select(carsItems).join([
      innerJoin(clientsItems, clientsItems.id.equalsExp(carsItems.clientId))
    ])
      ..where(carsItems.deletedAt.isNull() & clientsItems.deletedAt.isNull());

    return query.watch().map((rows) {
      return rows.map((row) {
        final carItem = row.readTable(carsItems);
        final clientItem = row.readTable(clientsItems);
        return _mapToCarFullData(
            carItem, clientItem.uuid); // Передаем UUID клиента
      }).toList();
    });
  }

  /// Возвращает поток списка активных автомобилей клиента в виде CarFullData.
  Stream<List<CarFullData>> watchActiveClientCars(String clientUuid) {
    // JOIN с ClientsItems для фильтрации по UUID клиента
    final query = select(carsItems).join([
      innerJoin(clientsItems, clientsItems.id.equalsExp(carsItems.clientId))
    ])
      ..where(
          clientsItems.uuid.equals(clientUuid) & carsItems.deletedAt.isNull());

    return query.watch().map((rows) {
      return rows.map((row) {
        final carItem = row.readTable(carsItems);
        // UUID клиента у нас уже есть из параметра clientUuid
        return _mapToCarFullData(carItem, clientUuid);
      }).toList();
    });
  }

  /// Возвращает автомобиль по его UUID в виде CarFullData.
  ///
  /// По умолчанию возвращает только активные (не удаленные) автомобили.
  /// Если [includeDeleted] установлен в true, вернет и мягко удаленный автомобиль.
  Future<CarFullData?> getCarByUuid(String carUuid,
      {bool includeDeleted = false}) async {
    // Используем JOIN для получения UUID клиента
    final query = select(carsItems).join([
      innerJoin(clientsItems, clientsItems.id.equalsExp(carsItems.clientId))
    ])
      ..where(carsItems.uuid.equals(carUuid)); // Ищем по UUID

    // Добавляем условие на deletedAt только если не нужно включать удаленные
    if (!includeDeleted) {
      query.where(carsItems.deletedAt.isNull());
    }

    final row = await query.getSingleOrNull();
    if (row == null) return null;

    final carItem = row.readTable(carsItems);
    final clientItem = row.readTable(clientsItems);
    return _mapToCarFullData(carItem, clientItem.uuid); // Передаем UUID клиента
  }

  /// Находит автомобиль по VIN (возвращает полную модель данных CarFullData).
  ///
  /// По умолчанию ищет только активные (не удаленные) автомобили.
  /// Если [includeDeleted] установлен в true, вернет и мягко удаленный автомобиль.
  Future<CarFullData?> getCarByVin(String vin,
      {bool includeDeleted = false}) async {
    _logger.d('Getting car by VIN: "$vin", includeDeleted: $includeDeleted');
    // Используем JOIN для получения UUID клиента
    final query = select(carsItems).join([
      innerJoin(clientsItems, clientsItems.id.equalsExp(carsItems.clientId))
    ])
      ..where(carsItems.vin.equals(vin)); // Ищем по VIN

    // Добавляем условие на deletedAt только если не нужно включать удаленные
    if (!includeDeleted) {
      query.where(carsItems.deletedAt.isNull());
    }

    final row = await query.getSingleOrNull();
    if (row == null) {
      _logger.w('Car with VIN "$vin" not found.');
      return null;
    }

    final carItem = row.readTable(carsItems);
    final clientItem = row.readTable(clientsItems);
    _logger.d('Found car with VIN "$vin", UUID: ${carItem.uuid}');
    return _mapToCarFullData(carItem, clientItem.uuid); // Передаем UUID клиента
  }

  /// Добавляет новый автомобиль. Принимает @freezed модели.
  Future<int> insertCar(EntityCoreData core, CarSpecificData specific) async {
    // Получаем int ID клиента по его UUID для внешнего ключа
    final clientIntId = await _getClientIntId(specific.clientId);
    if (clientIntId == null) {
      throw Exception(
          'Client with UUID ${specific.clientId} not found, cannot insert car.');
    }

    final companion = CarsItemsCompanion(
      uuid: Value(core.uuid),
      clientId: Value(clientIntId), // Используем полученный int ID
      vin: Value(specific.vin),
      make: Value(specific.make),
      model: Value(specific.model),
      year: Value(specific.year),
      licensePlate: Value(specific.licensePlate),
      additionalInfo: Value(specific.additionalInfo),
      code: Value(core.code),
      createdAt: Value(core.createdAt),
      modifiedAt: Value(core.modifiedAt ?? DateTime.now()),
      deletedAt: Value(core.deletedAt),
    );
    _logger.d(LogMessages.carInserting
        .replaceAll('{uuid}', core.uuid)
        .replaceAll('{clientId}', clientIntId.toString()));
    try {
      return await into(carsItems).insert(companion);
    } catch (e, s) {
      _logger.e(LogMessages.carAddError, error: e, stackTrace: s);
      rethrow; // Перебрасываем исключение для обработки выше
    }
  }

  /// Обновляет информацию об автомобиле по UUID. Принимает @freezed модели.
  Future<int> updateCarByUuid(
      EntityCoreData core, CarSpecificData specific) async {
    // Получаем int ID клиента по его UUID для внешнего ключа
    final clientIntId = await _getClientIntId(specific.clientId);
    if (clientIntId == null) {
      // Решаем, что делать: выбросить ошибку или обновить без изменения клиента?
      // Пока выбросим ошибку, т.к. смена владельца должна быть явной операцией.
      throw Exception(
          'Client with UUID ${specific.clientId} not found, cannot update car owner.');
      // Альтернатива: обновить только данные машины, не трогая clientId
      /*
      final currentCar = await (select(carsItems)..where((c) => c.uuid.equals(core.uuid))).getSingleOrNull();
      if (currentCar == null) return 0; // Машина не найдена
      clientIntId = currentCar.clientId; // Оставляем старого владельца
      */
    }

    final companion = CarsItemsCompanion(
      // id не указываем, обновление по where
      clientId: Value(clientIntId), // Используем полученный int ID
      vin: Value(specific.vin),
      make: Value(specific.make),
      model: Value(specific.model),
      year: Value(specific.year),
      licensePlate: Value(specific.licensePlate),
      additionalInfo: Value(specific.additionalInfo),
      code: Value(core.code),
      // createdAt не обновляем
      modifiedAt: Value(DateTime.now()), // Всегда обновляем modifiedAt
      deletedAt: Value(core.deletedAt), // Позволяем обновить/сбросить deletedAt
    );
    _logger.d(LogMessages.carUpdating.replaceAll('{uuid}', core.uuid));
    try {
      return await (update(carsItems)..where((c) => c.uuid.equals(core.uuid)))
          .write(companion);
    } catch (e, s) {
      _logger.e(LogMessages.carUpdateError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Мягкое удаление автомобиля по UUID.
  Future<int> softDeleteCarByUuid(String carUuid) {
    _logger.i(LogMessages.carSoftDeleting.replaceAll('{uuid}', carUuid));
    try {
      return (update(carsItems)..where((c) => c.uuid.equals(carUuid)))
          .write(CarsItemsCompanion(
        deletedAt: Value(DateTime.now()),
        modifiedAt: Value(DateTime.now()),
      ));
    } catch (e, s) {
      _logger.e(LogMessages.carDeleteError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Восстановление мягко удаленного автомобиля по UUID.
  Future<int> restoreCarByUuid(String carUuid) {
    _logger.i(LogMessages.carRestoring.replaceAll('{uuid}', carUuid));
    try {
      return (update(carsItems)..where((c) => c.uuid.equals(carUuid)))
          .write(const CarsItemsCompanion(
        deletedAt: Value(null),
        modifiedAt: Value.absent(),
      ));
    } catch (e, s) {
      _logger.e(LogMessages.carRestoreError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Возвращает список автомобилей с информацией о владельцах в виде CarWithOwnerData.
  Future<List<CarWithOwnerData>> getCarsWithOwners() async {
    final query = select(carsItems).join([
      innerJoin(
        clientsItems,
        clientsItems.id.equalsExp(carsItems.clientId),
      )
    ])
      ..where(carsItems.deletedAt.isNull() &
          clientsItems.deletedAt
              .isNull()); // Убедимся, что клиент тоже не удален

    final rows = await query.get();

    return rows.map((row) {
      final carItem = row.readTable(carsItems);
      final clientItem = row.readTable(clientsItems);

      // Маппим данные автомобиля, используя UUID клиента из JOIN
      final carFullData = _mapToCarFullData(carItem, clientItem.uuid);

      // Маппим данные владельца
      final ownerCoreData = EntityCoreData(
        uuid: clientItem.uuid,
        code: clientItem.code,
        displayName: clientItem.name,
        createdAt: clientItem.createdAt,
        modifiedAt: clientItem.modifiedAt,
        deletedAt: clientItem.deletedAt,
        isDeleted: clientItem.deletedAt != null,
      );
      // Предполагаем, что ClientSpecificData имеет конструктор fromJson или поля доступны
      // Здесь создаем вручную для примера
      final ownerSpecificData = ClientSpecificData(
        type: ClientType.values.firstWhere((e) => e.name == clientItem.type,
            orElse: () => ClientType.other), // Преобразуем строку в enum
        contactInfo: clientItem.contactInfo,
        additionalInfo: clientItem.additionalInfo,
      );

      return CarWithOwnerData(
        carFullData: carFullData,
        ownerCoreData: ownerCoreData,
        ownerSpecificData: ownerSpecificData,
      );
    }).toList();
  }

  /// Возвращает поток списка автомобилей с информацией о владельцах в виде CarWithOwnerData.
  Stream<List<CarWithOwnerData>> watchCarsWithOwners() {
    final query = select(carsItems).join([
      innerJoin(
        clientsItems,
        clientsItems.id.equalsExp(carsItems.clientId),
      )
    ])
      ..where(carsItems.deletedAt.isNull() &
          clientsItems.deletedAt
              .isNull()); // Убедимся, что клиент тоже не удален

    return query.watch().map((rows) {
      // Используем .watch()
      return rows.map((row) {
        final carItem = row.readTable(carsItems);
        final clientItem = row.readTable(clientsItems);

        // Маппим данные автомобиля, используя UUID клиента из JOIN
        final carFullData = _mapToCarFullData(carItem, clientItem.uuid);

        // Маппим данные владельца
        final ownerCoreData = EntityCoreData(
          uuid: clientItem.uuid,
          code: clientItem.code,
          displayName: clientItem.name,
          createdAt: clientItem.createdAt,
          modifiedAt: clientItem.modifiedAt,
          deletedAt: clientItem.deletedAt,
          isDeleted: clientItem.deletedAt != null,
        );
        // Предполагаем, что ClientSpecificData имеет конструктор fromJson или поля доступны
        // Здесь создаем вручную для примера
        final ownerSpecificData = ClientSpecificData(
          type: ClientType.values.firstWhere((e) => e.name == clientItem.type,
              orElse: () => ClientType.other), // Преобразуем строку в enum
          contactInfo: clientItem.contactInfo,
          additionalInfo: clientItem.additionalInfo,
        );

        return CarWithOwnerData(
          carFullData: carFullData,
          ownerCoreData: ownerCoreData,
          ownerSpecificData: ownerSpecificData,
        );
      }).toList();
    });
  }

  /// Возвращает базовые данные автомобиля по UUID.
  Future<EntityCoreData?> getCarCoreData(String uuid) async {
    final item = await (select(carsItems)..where((c) => c.uuid.equals(uuid)))
        .getSingleOrNull();
    if (item == null) return null;
    // Маппинг в EntityCoreData
    return EntityCoreData(
      uuid: item.uuid,
      code: item.vin ??
          item.licensePlate ??
          '', // Используем VIN или госномер как code
      displayName: '${item.make} ${item.model} (${item.year})',
      createdAt: item.createdAt,
      modifiedAt: item.modifiedAt,
      deletedAt: item.deletedAt,
      isDeleted: item.deletedAt != null,
    );
  }
}
