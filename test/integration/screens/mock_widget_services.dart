import 'package:mockito/annotations.dart';

import 'package:part_catalog/core/database/daos/orders_dao.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/features/documents/orders/services/order_service.dart';

// Инструкция для генерации моков.
// Запустите в терминале: flutter pub run build_runner build --delete-conflicting-outputs
@GenerateMocks([
  OrderService,
  OrdersDao,
], customMocks: [
  MockSpec<AppDatabase>(
      as: #MockAppDatabase,
      unsupportedMembers: {#clientsDao, #carsDao, #supplierSettingsDao})
])
void main() {}