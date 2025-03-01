import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/daos/cars_dao.dart';
import 'package:part_catalog/features/vehicles/models/car.dart';

/// {@template car_service}
/// Сервис для управления автомобилями.
/// Обеспечивает бизнес-логику и преобразование между моделями базы данных и бизнес-моделями.
/// {@endtemplate}
class CarService {
  /// {@macro car_service}
  CarService(this._database) {
    _carsDao = _database.carsDao;
  }

  final AppDatabase _database;
  late final CarsDao _carsDao;
  final Logger _logger = Logger();

  /// Возвращает поток списка автомобилей, который обновляется автоматически при изменении данных.
  Stream<List<CarModel>> watchCars() {
    return _carsDao.watchAllCars().map(
          (cars) => cars.map(_mapToModel).toList(),
        );
  }

  /// Возвращает поток списка автомобилей для указанного клиента.
  ///
  /// [clientId] - идентификатор клиента, автомобили которого нужно получить.
  Stream<List<CarModel>> watchClientCars(int clientId) {
    return _carsDao.watchClientCars(clientId).map(
          (cars) => cars.map(_mapToModel).toList(),
        );
  }

  /// Возвращает автомобиль по идентификатору.
  Future<CarModel?> getCarById(int id) async {
    final car = await _carsDao.getCarById(id);
    if (car == null) return null;

    return _mapToModel(car);
  }

  /// Добавляет новый автомобиль.
  ///
  /// Параметры:
  /// * [car] - данные автомобиля для добавления
  ///
  /// Возвращает идентификатор добавленного автомобиля.
  Future<int> addCar(CarModel car) {
    _logger.i('Добавление автомобиля: ${car.make} ${car.model}');

    // Преобразование бизнес-модели в companion для DAO
    final companion = _mapToCompanion(car);

    // Делегируем выполнение операции в DAO
    return _carsDao.insertCar(companion);
  }

  /// Обновляет информацию об автомобиле.
  ///
  /// [car] - обновленные данные автомобиля.
  ///
  /// Возвращает количество обновленных записей (обычно 1).
  Future<bool> updateCar(CarModel car) {
    _logger.i('Обновление автомобиля ID: ${car.id}');

    // Преобразование бизнес-модели в companion для DAO
    // с явным указанием идентификатора
    final companion = _mapToCompanion(car).copyWith(
      id: Value(int.parse(car.id)), // Добавляем ID в companion
    );

    // Делегируем выполнение операции в DAO
    return _carsDao.updateCar(companion);
  }

  /// Soft-delete автомобиля (установка deletedAt).
  ///
  /// Возвращает количество обновленных записей (обычно 1).
  Future<int> deleteCar(int id) {
    _logger.i('Удаление автомобиля с ID: $id');

    // Делегируем выполнение операции в DAO
    return _carsDao.softDeleteCar(id);
  }

  /// Получает расширенную информацию об автомобилях с данными владельцев.
  ///
  /// Пример сложной операции, использующей DAO для получения связанных данных.
  Future<List<CarWithOwnerModel>> getCarsWithOwners() async {
    final results = await _carsDao.getCarsWithOwners();

    return results
        .map((item) => CarWithOwnerModel(
              car: _mapToModel(item.car),
              ownerName: item.ownerName,
              ownerType: item.ownerType,
            ))
        .toList();
  }

  /// Преобразует запись из БД в бизнес-модель.
  CarModel _mapToModel(CarsItem car) {
    return CarModel(
      id: car.id.toString(),
      clientId: car.clientId.toString(),
      vin: car.vin ?? '',
      make: car.make,
      model: car.model,
      year: car.year ?? 0,
      licensePlate: car.licensePlate ?? '',
      additionalInfo: car.additionalInfo ?? '',
    );
  }

  /// Преобразует бизнес-модель в модель базы данных.
  CarsItemsCompanion _mapToCompanion(CarModel car) {
    return CarsItemsCompanion(
      clientId: Value(int.parse(car.clientId)),
      make: Value(car.make),
      model: Value(car.model),
      year: Value(car.year != 0 ? car.year : null),
      vin: Value(car.vin.isNotEmpty ? car.vin : null),
      licensePlate:
          Value(car.licensePlate?.isNotEmpty == true ? car.licensePlate : null),
      additionalInfo: Value(
          car.additionalInfo?.isNotEmpty == true ? car.additionalInfo : null),
    );
  }
}

/// Модель для представления автомобиля с информацией о владельце.
class CarWithOwnerModel {
  final CarModel car;
  final String ownerName;
  final String ownerType;

  CarWithOwnerModel({
    required this.car,
    required this.ownerName,
    required this.ownerType,
  });
}
