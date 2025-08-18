import 'package:mockito/annotations.dart';

import 'package:part_catalog/core/database/daos/cars_dao.dart';
import 'package:part_catalog/core/database/daos/clients_dao.dart';
import 'package:part_catalog/core/database/daos/orders_dao.dart';
import 'package:part_catalog/core/database/daos/supplier_settings_dao.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/features/documents/orders/services/order_service.dart';
import 'package:part_catalog/features/references/clients/services/client_service.dart';
import 'package:part_catalog/features/references/vehicles/services/car_service.dart';
import 'package:part_catalog/features/suppliers/api/api_client_manager.dart';

// Инструкция для генерации моков.
// Запустите в терминале: flutter pub run build_runner build --delete-conflicting-outputs
@GenerateMocks([
  AppDatabase,
  OrderService,
  ClientService,
  CarService,
  ClientsDao,
  CarsDao,
  OrdersDao,
  SupplierSettingsDao,
  ApiClientManager,
])
void main() {}