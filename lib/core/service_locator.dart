import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:part_catalog/features/documents/orders/services/order_service.dart';
import 'package:part_catalog/features/parts_catalog/api/api_client_parts_catalogs.dart';
import 'package:part_catalog/features/references/clients/services/client_service.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/features/references/vehicles/services/car_service.dart';

final locator = GetIt.instance;

// Изменяем функцию, чтобы принимать существующий экземпляр базы данных
void setupLocator(AppDatabase database) {
  // Регистрируем Dio
  locator.registerLazySingleton(() => Dio());

  // Регистрируем ApiClientPartsCatalogs
  locator.registerLazySingleton(() => ApiClientPartsCatalogs(locator<Dio>()));

  // Регистрируем существующий экземпляр базы данных
  locator.registerSingleton<AppDatabase>(database);

  // Регистрация сервисов
  locator.registerLazySingleton<ClientService>(
      () => ClientService(locator<AppDatabase>()));
  locator.registerLazySingleton<CarService>(
      () => CarService(locator<AppDatabase>()));
  locator.registerLazySingleton<OrderService>(
      () => OrderService(locator<AppDatabase>()));
}
