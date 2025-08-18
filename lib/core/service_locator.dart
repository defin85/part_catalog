import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import 'package:part_catalog/core/config/global_api_settings_service.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/database/database_error_recovery.dart';
import 'package:part_catalog/core/utils/error_logger.dart';
import 'package:part_catalog/features/documents/orders/services/order_service.dart';
import 'package:part_catalog/features/documents/orders/services/pdf_service.dart';
import 'package:part_catalog/features/parts_catalog/api/api_client_parts_catalogs.dart';
import 'package:part_catalog/features/references/clients/services/client_service.dart';
import 'package:part_catalog/features/references/vehicles/services/car_service.dart';
import 'package:part_catalog/features/suppliers/api/api_client_manager.dart';
import 'package:part_catalog/features/suppliers/services/suppliers_service.dart';

final locator = GetIt.instance;

// Изменяем функцию, чтобы принимать существующий экземпляр базы данных
void setupLocator(AppDatabase database) {
  // Регистрируем Dio
  locator.registerLazySingleton(() {
    final dio = Dio();
    // Логирование отключено для чистоты лога
    // При необходимости раскомментируйте следующие строки:
    // dio.interceptors.add(LogInterceptor(
    //   request: true,
    //   requestHeader: true,
    //   requestBody: true,
    //   responseHeader: true,
    //   responseBody: true,
    //   error: true,
    // ));
    return dio;
  });

  // Регистрируем ApiClientPartsCatalogs
  locator.registerLazySingleton(() => ApiClientPartsCatalogs(locator<Dio>()));

  // Регистрируем существующий экземпляр базы данных
  locator.registerSingleton<AppDatabase>(database);

  // Регистрация сервисов, которые зависят от AppDatabase
  locator.registerLazySingleton<ClientService>(
      () => ClientService(locator<AppDatabase>()));
  locator.registerLazySingleton<CarService>(
      () => CarService(locator<AppDatabase>()));
  locator.registerLazySingleton<OrderService>(
      () => OrderService(locator<AppDatabase>()));
  locator.registerLazySingleton(() => PdfService());

  // Регистрация ApiClientManager и SuppliersService
  locator.registerLazySingleton<ApiClientManager>(() => ApiClientManager());
  locator.registerLazySingleton<SuppliersService>(
      () => SuppliersService(locator<ApiClientManager>()));

  // Регистрация GlobalApiSettingsService
  locator.registerLazySingleton<GlobalApiSettingsService>(
      () => GlobalApiSettingsService());

  // Утилиты
  locator.registerLazySingleton(() => Logger());
  locator.registerLazySingleton(() => ErrorLogger());

  // Система восстановления БД
  locator.registerLazySingleton<DatabaseErrorRecovery>(
      () => DatabaseErrorRecovery(locator<AppDatabase>()));

  // Регистрация SupplierSettingsDao (если он не получается напрямую из AppDatabase.supplierSettingsDao)
  // Обычно DAO доступны через экземпляр AppDatabase, например: locator<AppDatabase>().supplierSettingsDao
  // Если вы хотите зарегистрировать DAO отдельно:
  // locator.registerLazySingleton<SupplierSettingsDao>(
  //   () => locator<AppDatabase>().supplierSettingsDao,
  // );
  // Однако, это может быть избыточным, если DAO всегда доступны через AppDatabase.
}