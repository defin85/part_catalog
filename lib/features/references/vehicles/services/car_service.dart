import 'package:logger/logger.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/daos/cars_dao.dart'; // Содержит CarFullData, CarWithOwnerData
// Импорт бизнес-модели (композитора)
import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';
// Логгер и сообщения
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/core/utils/log_messages.dart';
// Импорт композитора клиента для CarWithOwnerModel
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';

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
      : _logger = AppLoggers.vehicles; // Используем настроенный логгер

  final AppDatabase _db;
  final Logger _logger;

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
    _logger.i(LogMessages.carGetByUuid.replaceAll('{uuid}', carUuid));
    final carData = await _carsDao.getCarByUuid(carUuid);
    if (carData == null) {
      _logger.w(LogMessages.carNotFoundByUuid.replaceAll('{uuid}', carUuid));
      return null;
    }
    return _mapDataToComposite(carData);
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

    // Извлекаем @freezed модели из композитора
    final coreData = car.coreData;
    final carData = car.carData;

    try {
      // DAO вернет int ID, но нам нужен UUID
      await _carsDao.insertCar(coreData, carData);
      _logger.i(LogMessages.carCreated.replaceAll('{uuid}', car.uuid));
      return car.uuid;
    } catch (e, s) {
      _logger.e(LogMessages.carAddError, error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Обновляет существующий автомобиль.
  /// Принимает [CarModelComposite] с обновленными данными.
  Future<void> updateCar(CarModelComposite car) async {
    // Обновляем дату модификации перед сохранением
    final updatedCar = car.withModifiedDate(DateTime.now());

    // Извлекаем @freezed модели из обновленного композитора
    final coreData = updatedCar.coreData;
    final carData = updatedCar.carData;

    _logger.i(LogMessages.carUpdating.replaceAll('{uuid}', car.uuid));
    try {
      final updatedRows = await _carsDao.updateCarByUuid(coreData, carData);
      if (updatedRows == 0) {
        _logger
            .w(LogMessages.carNotFoundForUpdate.replaceAll('{uuid}', car.uuid));
        // Можно бросить исключение или просто завершить
      } else {
        _logger.d(LogMessages.carUpdated.replaceAll('{uuid}', car.uuid));
      }
    } catch (e, s) {
      _logger.e(LogMessages.carUpdateError.replaceAll('{uuid}', car.uuid),
          error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Удаляет автомобиль (мягкое удаление).
  Future<void> deleteCar(String carUuid) async {
    _logger.i(LogMessages.carDeleting.replaceAll('{uuid}', carUuid));
    try {
      // Можно сначала получить автомобиль, чтобы убедиться, что он существует
      final car = await getCarByUuid(carUuid);
      if (car == null) {
        _logger
            .w(LogMessages.carNotFoundForDelete.replaceAll('{uuid}', carUuid));
        return; // Автомобиль не найден или уже удален
      }
      if (car.isDeleted) {
        _logger.w(LogMessages.carAlreadyDeleted.replaceAll('{uuid}', carUuid));
        return; // Уже удален
      }
      // Помечаем как удаленный и обновляем
      final deletedCar = car.markAsDeleted();
      await updateCar(deletedCar); // Используем общий метод обновления
      _logger.i(LogMessages.carDeleted.replaceAll('{uuid}', carUuid));
    } catch (e, s) {
      _logger.e(LogMessages.carDeleteError.replaceAll('{uuid}', carUuid),
          error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Восстанавливает удалённый автомобиль.
  Future<void> restoreCar(String carUuid) async {
    _logger.i(LogMessages.carRestoring.replaceAll('{uuid}', carUuid));
    try {
      // Получаем автомобиль, включая удаленные
      final carData =
          await _carsDao.getCarByUuid(carUuid, includeDeleted: true);
      if (carData == null) {
        _logger
            .w(LogMessages.carNotFoundForRestore.replaceAll('{uuid}', carUuid));
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
      // final restoredCar = car.restore(); // Композитор больше не нужен для DAO
      // await updateCar(restoredCar); // Используем общий метод обновления - НЕ НАДО
      final restoredRows = await _carsDao.restoreCarByUuid(carUuid);
      if (restoredRows > 0) {
        _logger.i(LogMessages.carRestored.replaceAll('{uuid}', carUuid));
      } else {
        _logger
            .w(LogMessages.carNotFoundForRestore.replaceAll('{uuid}', carUuid));
      }
    } catch (e, s) {
      _logger.e(LogMessages.carRestoreError.replaceAll('{uuid}', carUuid),
          error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Проверяет уникальность VIN-кода.
  ///
  /// [vin] - VIN-код для проверки.
  /// [excludeUuid] - UUID автомобиля, который нужно исключить из проверки (при редактировании).
  Future<bool> isVinUnique(String vin, {String? excludeUuid}) async {
    _logger.d('Checking VIN uniqueness for "$vin", excluding $excludeUuid');
    try {
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
    } catch (e, s) {
      _logger.e('Error checking VIN uniqueness for "$vin"',
          error: e, stackTrace: s);
      // В случае ошибки лучше считать VIN не уникальным, чтобы предотвратить дублирование
      return false;
    }
  }

  /// Получает список автомобилей [CarWithOwnerModel] с информацией о владельцах.
  Future<List<CarWithOwnerModel>> getCarsWithOwners() async {
    _logger.i(LogMessages.carGetWithOwners);
    try {
      final results = await _carsDao.getCarsWithOwners();
      return results.map(_mapWithOwnerDataToViewModel).toList();
    } catch (e, s) {
      _logger.e(LogMessages.carGetWithOwnersError, error: e, stackTrace: s);
      rethrow;
    }
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
