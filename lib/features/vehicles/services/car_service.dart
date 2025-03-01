import 'package:drift/drift.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/features/vehicles/models/car.dart';

/// {@template car_service}
/// Сервис для управления автомобилями в базе данных.
///
/// Предоставляет методы для выполнения CRUD-операций с автомобилями.
/// {@endtemplate}
class CarService {
  /// {@macro car_service}
  CarService(this._database);

  /// База данных приложения.
  final AppDatabase _database;

  /// Возвращает список всех автомобилей.
  ///
  /// Возвращает список автомобилей из таблицы [Cars] базы данных.
  Future<List<Car>> getCars() async {
    return await _database.select(_database.cars).get();
  }

  /// Возвращает список всех автомобилей как бизнес-модели.
  ///
  /// Преобразует записи из таблицы [Cars] в объекты [CarModel].
  Future<List<CarModel>> getCarsAsModels() async {
    final dbCars = await _database.select(_database.cars).get();
    return dbCars.map(carToModel).toList();
  }

  /// Возвращает автомобили клиента.
  ///
  /// [clientId] - идентификатор клиента, автомобили которого нужно получить.
  Future<List<Car>> getClientCars(int clientId) async {
    return (_database.select(_database.cars)
          ..where((c) => c.clientId.equals(clientId)))
        .get();
  }

  /// Добавляет новый автомобиль.
  ///
  /// Параметры:
  /// * [clientId] - идентификатор клиента-владельца автомобиля.
  /// * [make] - марка автомобиля.
  /// * [model] - модель автомобиля.
  /// * [year] - год выпуска автомобиля (опционально).
  /// * [vin] - VIN-код автомобиля (опционально).
  /// * [licensePlate] - номерной знак автомобиля (опционально).
  /// * [additionalInfo] - дополнительная информация об автомобиле (опционально).
  ///
  /// Возвращает идентификатор добавленного автомобиля.
  Future<int> addCar({
    required int clientId,
    required String make,
    required String model,
    int? year,
    String? vin,
    String? licensePlate,
    String? additionalInfo,
  }) {
    return _database.into(_database.cars).insert(
          CarsCompanion.insert(
            clientId: clientId,
            make: make,
            model: model,
            year: Value(year),
            vin: Value(vin),
            licensePlate: Value(licensePlate),
            additionalInfo: Value(additionalInfo),
          ),
        );
  }

  /// Обновляет информацию об автомобиле.
  ///
  /// Параметры:
  /// * [id] - идентификатор автомобиля для обновления.
  /// * [clientId] - новый идентификатор клиента-владельца (опционально).
  /// * [make] - новая марка автомобиля (опционально).
  /// * [model] - новая модель автомобиля (опционально).
  /// * [year] - новый год выпуска (опционально).
  /// * [vin] - новый VIN-код (опционально).
  /// * [licensePlate] - новый номерной знак (опционально).
  /// * [additionalInfo] - новая дополнительная информация (опционально).
  ///
  /// Возвращает true, если обновление успешно выполнено.
  Future<bool> updateCar({
    required int id,
    int? clientId,
    String? make,
    String? model,
    int? year,
    String? vin,
    String? licensePlate,
    String? additionalInfo,
  }) {
    return _database.update(_database.cars).replace(
          CarsCompanion(
            id: Value(id),
            clientId: clientId != null ? Value(clientId) : const Value.absent(),
            make: make != null ? Value(make) : const Value.absent(),
            model: model != null ? Value(model) : const Value.absent(),
            year: year != null ? Value(year) : const Value.absent(),
            vin: vin != null ? Value(vin) : const Value.absent(),
            licensePlate: licensePlate != null
                ? Value(licensePlate)
                : const Value.absent(),
            additionalInfo: additionalInfo != null
                ? Value(additionalInfo)
                : const Value.absent(),
          ),
        );
  }

  /// Удаляет автомобиль из базы данных.
  ///
  /// [id] - идентификатор автомобиля для удаления.
  ///
  /// Возвращает количество удаленных записей (обычно 1).
  Future<int> deleteCar(int id) {
    return (_database.delete(_database.cars)..where((c) => c.id.equals(id)))
        .go();
  }

  /// Преобразует запись из БД в бизнес-модель.
  ///
  /// [car] - автомобиль из базы данных.
  ///
  /// Возвращает объект [CarModel], представляющий автомобиль.
  CarModel carToModel(Car car) {
    return CarModel(
      id: car.id.toString(),
      clientId: car.clientId.toString(),
      vin: car.vin ?? '',
      make: car.make,
      model: car.model,
      year: car.year ?? 0,
      licensePlate: car.licensePlate,
      additionalInfo: car.additionalInfo,
    );
  }
}
