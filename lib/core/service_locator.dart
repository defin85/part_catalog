import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:part_catalog/features/parts_catalog/api/api_client_parts_catalogs.dart';
import 'package:part_catalog/features/clients/services/client_service.dart'; // Import ClientService
import 'package:part_catalog/core/database/database.dart'; // Import AppDatabase
import 'package:part_catalog/features/vehicles/services/car_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  // Регистрируем Dio
  locator.registerLazySingleton(() => Dio());

  // Регистрируем ApiClientPartsCatalogs
  locator.registerLazySingleton(() => ApiClientPartsCatalogs(locator<Dio>()));

  // Регистрация базы данных как синглтона
  locator.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // Регистрация сервисов
  locator.registerLazySingleton<ClientService>(
      () => ClientService(locator<AppDatabase>()));
  locator.registerLazySingleton<CarService>(
      () => CarService(locator<AppDatabase>()));
}
