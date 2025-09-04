import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:part_catalog/core/providers/core_providers.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';
import 'package:part_catalog/features/documents/orders/services/order_service.dart';
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
import 'package:part_catalog/features/references/clients/providers/client_providers.dart'; // Импорт для clientServiceProvider
import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';
import 'package:part_catalog/features/references/vehicles/providers/car_providers.dart'; // Импорт для carServiceProvider

// Провайдер для OrderService (если еще не определен глобально)
// Используем существующий из service_locator
final orderServiceProvider =
    Provider<OrderService>((ref) => locator<OrderService>());

// Провайдер для отслеживания списка всех заказов
final ordersListProvider =
    StreamProvider.autoDispose<List<OrderModelComposite>>((ref) {
  final orderService = ref.watch(orderServiceProvider);
  return orderService.watchOrders();
});

// Провайдер для отслеживания одного заказа по UUID
final orderDetailsStreamProvider = StreamProvider.autoDispose
    .family<OrderModelComposite, String>((ref, orderUuid) {
  final orderService = ref.watch(orderServiceProvider);
  return orderService.watchOrderByUuid(orderUuid);
});

// Провайдер для получения клиента по UUID (если он есть)
final orderClientProvider = FutureProvider.autoDispose
    .family<ClientModelComposite?, String?>((ref, clientUuid) async {
  if (clientUuid == null) {
    return null;
  }
  // Используем существующий clientServiceProvider
  final clientService = ref.watch(clientServiceProvider);
  try {
    return await clientService.getClientByUuid(clientUuid);
  } catch (e) {
    // Логируем ошибку, но возвращаем null, чтобы не ломать UI деталей заказа
    ref
        .read(ordersLoggerProvider)
        .e('Failed to load client $clientUuid', error: e);
    return null;
  }
});

// Провайдер для получения автомобиля по UUID (если он есть)
final orderCarProvider = FutureProvider.autoDispose
    .family<CarModelComposite?, String?>((ref, carUuid) async {
  if (carUuid == null) {
    return null;
  }
  // Используем существующий carServiceProvider
  final carService = ref.watch(carServiceProvider);
  try {
    return await carService.getCarByUuid(carUuid);
  } catch (e) {
    // Логируем ошибку, но возвращаем null
    ref.read(ordersLoggerProvider).e('Failed to load car $carUuid', error: e);
    return null;
  }
});

// Добавим провайдер логгера, если его еще нет глобально
// final appLoggerProvider = Provider.family<Logger, String>((ref, name) => AppLoggers.getLogger(name));
