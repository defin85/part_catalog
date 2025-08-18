import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

import 'package:part_catalog/core/database/daos/orders_dao.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/features/documents/orders/services/order_service.dart';

import '../mocks/mock_services.mocks.dart';

final GetIt locator = GetIt.instance;

/// Регистрирует моки сервисов и базы данных для тестов.
void setupTestLocator() {
  // Удаляем предыдущие регистрации, чтобы тесты были изолированы
  locator.reset();

  // Создаем моки
  final mockAppDatabase = MockAppDatabase();
  final mockOrdersDao = MockOrdersDao();

  // Настраиваем мок базы данных
  when(mockAppDatabase.ordersDao).thenReturn(mockOrdersDao);

  // Регистрируем моки
  locator.registerLazySingleton<AppDatabase>(() => mockAppDatabase);
  locator.registerLazySingleton<OrderService>(
      () => OrderService(locator<AppDatabase>()));
  locator.registerLazySingleton<OrdersDao>(() => mockOrdersDao);
}