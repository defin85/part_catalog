import 'package:drift/drift.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/items/cars_items.dart';
import 'package:part_catalog/core/database/items/clients_items.dart';

part 'cars_dao.g.dart';

/// {@template cars_dao}
/// Объект доступа к данным для работы с автомобилями.
/// {@endtemplate}
@DriftAccessor(tables: [CarsItems, ClientsItems])
class CarsDao extends DatabaseAccessor<AppDatabase> with _$CarsDaoMixin {
  /// {@macro cars_dao}
  CarsDao(super.db);

  /// Возвращает поток списка всех автомобилей.
  Stream<List<CarsItem>> watchAllCars() {
    return (select(carsItems)..where((c) => c.deletedAt.isNull())).watch();
  }

  /// Возвращает поток списка автомобилей, принадлежащих указанному клиенту.
  Stream<List<CarsItem>> watchClientCars(int clientId) {
    return (select(carsItems)
          ..where((c) => c.clientId.equals(clientId) & c.deletedAt.isNull()))
        .watch();
  }

  /// Возвращает автомобиль по его идентификатору.
  Future<CarsItem?> getCarById(int id) {
    return (select(carsItems)
          ..where((c) => c.id.equals(id) & c.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Добавляет новую запись об автомобиле.
  Future<int> insertCar(CarsItemsCompanion car) {
    return into(carsItems).insert(car);
  }

  /// Обновляет информацию об автомобиле.
  Future<bool> updateCar(CarsItemsCompanion car) {
    return update(carsItems).replace(car);
  }

  /// Мягкое удаление автомобиля.
  Future<int> softDeleteCar(int id) {
    return (update(carsItems)..where((c) => c.id.equals(id)))
        .write(CarsItemsCompanion(deletedAt: Value(DateTime.now())));
  }

  /// Возвращает список автомобилей с информацией о владельцах.
  Future<List<CarWithOwner>> getCarsWithOwners() {
    final query = select(carsItems).join([
      innerJoin(
        clientsItems,
        clientsItems.id.equalsExp(carsItems.clientId),
      )
    ]);

    return query.map((row) {
      final car = row.readTable(carsItems);
      final client = row.readTable(clientsItems);

      return CarWithOwner(
        car: car,
        ownerName: client.name,
        ownerType: client.type,
      );
    }).get();
  }
}

/// Модель для представления результатов запроса автомобиля с владельцем.
class CarWithOwner {
  final CarsItem car;
  final String ownerName;
  final String ownerType;

  CarWithOwner({
    required this.car,
    required this.ownerName,
    required this.ownerType,
  });
}
