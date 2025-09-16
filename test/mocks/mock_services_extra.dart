import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:part_catalog/core/database/daos/cars_dao.dart';
import 'package:part_catalog/core/database/daos/clients_dao.dart';
import 'package:part_catalog/core/database/daos/orders_dao.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/features/documents/orders/services/order_service.dart';
import 'package:part_catalog/features/references/clients/services/client_service.dart';
import 'package:part_catalog/features/references/vehicles/services/car_service.dart';
import 'package:part_catalog/features/suppliers/services/parts_price_service.dart';
import 'package:part_catalog/features/suppliers/services/supplier_service.dart';

// Генерируем моки с помощью mockito
@GenerateNiceMocks([
  MockSpec<AppDatabase>(),
  MockSpec<ClientsDao>(),
  MockSpec<CarsDao>(),
  MockSpec<OrdersDao>(),
  MockSpec<ClientService>(),
  MockSpec<CarService>(),
  MockSpec<OrderService>(),
  MockSpec<PartsPriceService>(),
  MockSpec<SupplierService>(),
])
void main() {} // Пустая функция main для генерации

/// Расширение для создания стандартных моков
extension MockExtensions on Mock {
  /// Настраивает базовое поведение для всех моков
  void setupBaseMockBehavior() {
    // Общие настройки, если нужны
  }
}