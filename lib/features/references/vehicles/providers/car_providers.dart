import 'dart:async';

import 'package:logger/logger.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/providers/core_providers.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
import 'package:part_catalog/features/references/clients/providers/client_providers.dart'; // Для clientServiceProvider
import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';
import 'package:part_catalog/features/references/vehicles/services/car_service.dart'; // Содержит CarWithOwnerModel
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'car_providers.g.dart'; // Сгенерированный файл

// Провайдер для CarService
@Riverpod(keepAlive: true)
CarService carService(Ref ref) {
  final db = locator<AppDatabase>();
  return CarService(db);
}

// Провайдер для получения списка клиентов для фильтра
@riverpod
Future<List<ClientModelComposite>> clientsForFilter(Ref ref) async {
  final clientService = ref.watch(clientServiceProvider);
  return clientService.getAllClients();
}

// AsyncNotifier для управления списком автомобилей с владельцами
@riverpod
class CarsNotifier extends _$CarsNotifier {
  Logger get _logger => ref.read(vehiclesLoggerProvider);
  CarService get _carService => ref.read(carServiceProvider);

  // Фильтр по UUID клиента (оставляем приватным)
  String? _clientFilterUuid;

  // Публичный геттер для текущего фильтра
  String? get currentClientFilterUuid => _clientFilterUuid;

  @override
  FutureOr<List<CarWithOwnerModel>> build() async {
    _logger.d('CarsNotifier: Initial build loading cars...');
    // Используем watch для подписки на изменения
    // Передаем текущий фильтр в сервис (если сервис его поддерживает)
    // Или фильтруем здесь после получения всех данных
    final allCars = await _carService.getCarsWithOwners();
    return _filterCars(allCars);
  }

  // Внутренний метод для фильтрации
  List<CarWithOwnerModel> _filterCars(List<CarWithOwnerModel> allCars) {
    if (_clientFilterUuid == null) {
      return allCars;
    } else {
      return allCars
          .where((cwo) => cwo.owner.uuid == _clientFilterUuid)
          .toList();
    }
  }

  /// Устанавливает фильтр по клиенту и перезагружает данные
  Future<void> setClientFilter(String? clientUuid) async {
    _logger.d('CarsNotifier: Setting client filter to: $clientUuid');
    // Проверяем, изменился ли фильтр, чтобы избежать лишних перестроений
    if (_clientFilterUuid == clientUuid) return;

    _clientFilterUuid = clientUuid;
    // Перезагружаем данные с новым фильтром
    ref.invalidateSelf();
    // Ждем завершения перестроения (опционально, если нужно дождаться)
    await future;
  }

  /// Добавляет новый автомобиль
  Future<void> addCar(CarModelComposite car) async {
    _logger.d('CarsNotifier: Attempting to add car: ${car.vin}');
    try {
      await _carService.addCar(car);
      ref.invalidateSelf(); // Перезагружаем список
      await future; // Дожидаемся обновления
      _logger.i('CarsNotifier: Car added successfully: ${car.vin}');
    } catch (e, s) {
      _logger.e('CarsNotifier: Error adding car: ${car.vin}',
          error: e, stackTrace: s);
      rethrow; // Пробрасываем для UI
    }
  }

  /// Обновляет существующий автомобиль
  Future<void> updateCar(CarModelComposite car) async {
    _logger.d('CarsNotifier: Attempting to update car: ${car.uuid}');
    try {
      await _carService.updateCar(car);
      ref.invalidateSelf(); // Перезагружаем список
      await future; // Дожидаемся обновления
      _logger.i('CarsNotifier: Car updated successfully: ${car.uuid}');
    } catch (e, s) {
      _logger.e('CarsNotifier: Error updating car: ${car.uuid}',
          error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Мягко удаляет автомобиль
  Future<void> deleteCar(String carUuid) async {
    _logger.d('CarsNotifier: Attempting to delete car: $carUuid');
    try {
      await _carService.deleteCar(carUuid);
      ref.invalidateSelf(); // Перезагружаем список
      await future; // Дожидаемся обновления
      _logger.i('CarsNotifier: Car deleted successfully: $carUuid');
    } catch (e, s) {
      _logger.e('CarsNotifier: Error deleting car: $carUuid',
          error: e, stackTrace: s);
      rethrow;
    }
  }

  /// Восстанавливает мягко удаленный автомобиль
  Future<void> restoreCar(String carUuid) async {
    _logger.d('CarsNotifier: Attempting to restore car: $carUuid');
    try {
      await _carService.restoreCar(carUuid);
      ref.invalidateSelf(); // Перезагружаем список
      await future; // Дожидаемся обновления
      _logger.i('CarsNotifier: Car restored successfully: $carUuid');
    } catch (e, s) {
      _logger.e('CarsNotifier: Error restoring car: $carUuid',
          error: e, stackTrace: s);
      rethrow;
    }
  }

  // Метод поиска (если нужен)
  // Future<void> searchCars(String query) async { ... }
}

// Провайдер для получения одного автомобиля по UUID
@riverpod
Future<CarModelComposite?> car(Ref ref, String carUuid) async {
  final logger = ref.read(vehiclesLoggerProvider);
  logger.d('carProvider: Getting car with UUID: $carUuid');
  
  final carService = ref.watch(carServiceProvider);
  try {
    return await carService.getCarByUuid(carUuid);
  } catch (e, s) {
    logger.e('carProvider: Error getting car: $carUuid', error: e, stackTrace: s);
    return null;
  }
}

// Провайдер для проверки уникальности VIN (асинхронный)
@riverpod
Future<bool> isVinUnique(Ref ref,
    {required String vin, String? excludeUuid}) async {
  final logger = ref.read(vehiclesLoggerProvider);
  logger
      .d('isVinUniqueProvider: Checking VIN "$vin", excluding "$excludeUuid"');
  final carService = ref.watch(carServiceProvider);
  try {
    final isUnique =
        await carService.isVinUnique(vin, excludeUuid: excludeUuid);
    logger.d('isVinUniqueProvider: VIN "$vin" is unique: $isUnique');
    return isUnique;
  } catch (e, s) {
    logger.e('isVinUniqueProvider: Error checking VIN uniqueness for "$vin"',
        error: e, stackTrace: s);
    return false; // Считаем не уникальным при ошибке
  }
}
