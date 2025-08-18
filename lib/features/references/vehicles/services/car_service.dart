import 'package:logger/logger.dart';

import 'package:part_catalog/core/database/daos/cars_dao.dart'; // Содержит CarFullData, CarWithOwnerData
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/database_error_recovery.dart';
import 'package:part_catalog/core/utils/error_handler.dart';
import 'package:part_catalog/core/utils/log_messages.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';

// Логгер и сообщения
// Импорт композитора клиента для CarWithOwnerModel
// Импорт бизнес-модели (композитора)

/// Модель для представления автомобиля с информацией о владельце (использует композиторы).
class CarWithOwnerModel {
  final CarModelComposite car;
  final ClientModelComposite owner; // Используем композитор клиента

  CarWithOwnerModel({
    required this.car,
    required this.owner,
  });
}

/// {@template car_service}
/// Сервис для управления автомобилями.
/// Работает с бизнес-моделью [CarModelComposite] и взаимодействует
/// с DAO для получения/сохранения данных в виде @freezed моделей.
/// {@endtemplate}
class CarService {
  /// {@macro car_service}
  CarService(this._db)
      : _logger = AppLoggers.vehicles, // Используем настроенный логгер
        _errorRecovery = DatabaseErrorRecovery(_db);

  final AppDatabase _db;
  final Logger _logger;
  final DatabaseErrorRecovery _errorRecovery;

  /// Получение DAO для работы с автомобилями
  CarsDao get _carsDao => _db.carsDao;

  // --- Приватные методы маппинга ---

  /// Маппинг из CarFullData (@freezed) в CarModelComposite (бизнес-модель)
  CarModelComposite _mapDataToComposite(CarFullData data) {
    // Используем фабричный конструктор fromData композитора
    return CarModelComposite.fromData(
      data.coreData,
      data.carData,
      // parentId, isFolder, ancestorIds, itemsMap пока не поддерживаются DAO
    );
  }

  /// Маппинг из CarWithOwnerData (@freezed) в CarWithOwnerModel (модель представления)
  CarWithOwnerModel _mapWithOwnerDataToViewModel(CarWithOwnerData data) {
    final carComposite = _mapDataToComposite(data.carFullData);
    // Создаем композитор клиента из данных владельца
    final ownerComposite = ClientModelComposite.fromData(
      data.ownerCoreData,
      data.ownerSpecificData,
      // parentId, isFolder, ancestorIds, itemsMap пока не поддерживаются DAO
    );
    return CarWithOwnerModel(
      car: carComposite,
      owner: ownerComposite,
    );
  }

  // --- Публичные методы сервиса ---

  /// Возвращает поток списка активных автомобилей [CarModelComposite].
  Stream<List<CarModelComposite>> watchActiveCars() {
    _logger.i(LogMessages.carWatchActive);
    return _carsDao.watchAllActiveCars().map(
          (dataList) => dataList.map(_mapDataToComposite).toList(),
        );
  }

  /// Возвращает поток списка активных автомобилей клиента [CarModelComposite].
  ///
  /// [clientUuid] - UUID клиента, автомобили которого нужно получить.
  Stream<List<CarModelComposite>> watchActiveClientCars(String clientUuid) {
    _logger
        .i(LogMessages.carWatchActiveByClient.replaceAll('{uuid}', clientUuid));
    return _carsDao.watchActiveClientCars(clientUuid).map(
          (dataList) => dataList.map(_mapDataToComposite).toList(),
        );
  }

  /// Возвращает автомобиль [CarModelComposite] по его UUID.
  Future<CarModelComposite?> getCarByUuid(String carUuid) async {
    return _errorRecovery.executeWithRetry(
      () async {
        final carData = await _carsDao.getCarByUuid(carUuid);
        if (carData == null) {
          _logger
              .w(LogMessages.carNotFoundByUuid.replaceAll('{uuid}', carUuid));
          return null;
        }
        return _mapDataToComposite(carData);
      },
      operationName: 'getCarByUuid($carUuid)',
    );
  }

  /// Добавляет новый автомобиль.
  /// Принимает [CarModelComposite].
  /// Возвращает UUID созданного автомобиля.
  Future<String> addCar(CarModelComposite car) async {
    // UUID должен быть сгенерирован при создании композитора через .create()
    if (car.uuid.isEmpty) {
      _logger.e(LogMessages.carAddErrorMissingUuid);
      throw Exception(LogMessages.carAddErrorMissingUuid);
    }

    return _errorRecovery.executeWithRetry(
      () async {
        // Извлекаем @freezed модели из композитора
        final coreData = car.coreData;
        final carData = car.carData;

        // DAO вернет int ID, но нам нужен UUID
        await _carsDao.insertCar(coreData, carData);
        _logger.i(LogMessages.carCreated.replaceAll('{uuid}', car.uuid));
        return car.uuid;
      },
      operationName: 'addCar(${car.uuid})',
    );
  }

  /// Обновляет существующий автомобиль.
  /// Принимает [CarModelComposite] с обновленными данными.
  Future<void> updateCar(CarModelComposite car) async {
    await ErrorHandler.executeWithLogging(
      operation: () async {
        // Обновляем дату модификации перед сохранением
        final updatedCar = car.withModifiedDate(DateTime.now());

        // Извлекаем @freezed модели из обновленного композитора
        final coreData = updatedCar.coreData;
        final carData = updatedCar.carData;

        final updatedRows = await _carsDao.updateCarByUuid(coreData, carData);
        if (updatedRows == 0) {
          _logger.w(
              LogMessages.carNotFoundForUpdate.replaceAll('{uuid}', car.uuid));
          // Можно бросить исключение или просто завершить
        } else {
          _logger.d(LogMessages.carUpdated.replaceAll('{uuid}', car.uuid));
        }
      },
      logger: _logger,
      operationName: 'updateCar(${car.uuid})',
    );
  }

  /// Удаляет автомобиль (мягкое удаление).
  Future<void> deleteCar(String carUuid) async {
    await ErrorHandler.executeWithLogging(
      operation: () async {
        // Можно сначала получить автомобиль, чтобы убедиться, что он существует
        final car = await getCarByUuid(carUuid);
        if (car == null) {
          _logger.w(
              LogMessages.carNotFoundForDelete.replaceAll('{uuid}', carUuid));
          return; // Автомобиль не найден или уже удален
        }
        if (car.isDeleted) {
          _logger
              .w(LogMessages.carAlreadyDeleted.replaceAll('{uuid}', carUuid));
          return; // Уже удален
        }
        // Помечаем как удаленный и обновляем
        final deletedCar = car.markAsDeleted();
        await updateCar(deletedCar); // Используем общий метод обновления
        _logger.i(LogMessages.carDeleted.replaceAll('{uuid}', carUuid));
      },
      logger: _logger,
      operationName: 'deleteCar($carUuid)',
    );
  }

  /// Восстанавливает удалённый автомобиль.
  Future<void> restoreCar(String carUuid) async {
    await ErrorHandler.executeWithLogging(
      operation: () async {
        // Получаем автомобиль, включая удаленные
        final carData =
            await _carsDao.getCarByUuid(carUuid, includeDeleted: true);
        if (carData == null) {
          _logger.w(
              LogMessages.carNotFoundForRestore.replaceAll('{uuid}', carUuid));
          return;
        }
        final car = _mapDataToComposite(carData);

        if (!car.isDeleted) {
          _logger.w(LogMessages.carRestoreAttemptOnNonDeleted
              .replaceAll('{uuid}', carUuid));
          return; // Не удален
        }

        // Восстанавливаем и обновляем
        // Используем DAO напрямую для восстановления, чтобы не вызывать updateCar,
        // который снова обновит modifiedAt и может вызвать лишние срабатывания потоков.
        final restoredRows = await _carsDao.restoreCarByUuid(carUuid);
        if (restoredRows > 0) {
          _logger.i(LogMessages.carRestored.replaceAll('{uuid}', carUuid));
        } else {
          _logger.w(
              LogMessages.carNotFoundForRestore.replaceAll('{uuid}', carUuid));
        }
      },
      logger: _logger,
      operationName: 'restoreCar($carUuid)',
    );
  }

  /// Проверяет уникальность VIN-кода.
  ///
  /// [vin] - VIN-код для проверки.
  /// [excludeUuid] - UUID автомобиля, который нужно исключить из проверки (при редактировании).
  Future<bool> isVinUnique(String vin, {String? excludeUuid}) async {
    return ErrorHandler.executeWithLogging(
      operation: () async {
        final existingCar = await _carsDao.getCarByVin(vin);
        if (existingCar == null) {
          _logger.d('VIN "$vin" is unique (no car found).');
          return true; // VIN не найден, значит уникален
        }
        // Если VIN найден, проверяем, не принадлежит ли он автомобилю, который мы редактируем
        if (excludeUuid != null && existingCar.coreData.uuid == excludeUuid) {
          _logger.d(
              'VIN "$vin" belongs to the car being edited ($excludeUuid), considering unique.');
          return true; // Найденный VIN принадлежит редактируемому авто, считаем уникальным для других
        }
        _logger.w(
            'VIN "$vin" is not unique (found car ${existingCar.coreData.uuid}).');
        return false; // VIN найден и не принадлежит редактируемому авто
      },
      logger: _logger,
      operationName: 'isVinUnique($vin)',
      defaultValue: false, // В случае ошибки лучше считать VIN не уникальным
      rethrowError: false,
    );
  }

  /// Получает список автомобилей [CarWithOwnerModel] с информацией о владельцах.
  Future<List<CarWithOwnerModel>> getCarsWithOwners() async {
    return ErrorHandler.executeWithLogging(
      operation: () async {
        final results = await _carsDao.getCarsWithOwners();
        return results.map(_mapWithOwnerDataToViewModel).toList();
      },
      logger: _logger,
      operationName: 'getCarsWithOwners',
    );
  }

  /// Возвращает поток списка автомобилей [CarWithOwnerModel] с информацией о владельцах.
  Stream<List<CarWithOwnerModel>> watchCarsWithOwners() {
    _logger
        .i(LogMessages.carWatchWithOwners); // Добавим сообщение в LogMessages
    try {
      return _carsDao.watchCarsWithOwners().map(
            (dataList) => dataList.map(_mapWithOwnerDataToViewModel).toList(),
          );
    } catch (e, s) {
      // Логгирование здесь может быть избыточным, т.к. StreamBuilder обработает ошибку
      _logger.e(LogMessages.carWatchWithOwnersError,
          error: e, stackTrace: s); // Добавим сообщение в LogMessages
      // Перебрасываем ошибку, чтобы StreamBuilder мог ее поймать
      return Stream.error(e, s);
    }
  }
}