import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/mockito.dart';

import 'package:part_catalog/features/documents/orders/providers/order_providers.dart';
import 'package:part_catalog/features/references/clients/providers/client_providers.dart';
import 'package:part_catalog/features/references/vehicles/providers/car_providers.dart';

import '../fixtures/test_data.dart';
import '../mocks/mock_services.mocks.dart';

/// Helpers для настройки Provider тестов
class ProviderTestHelpers {
  /// Создает стандартные mock overrides для тестов
  static List<Override> createStandardOverrides() {
    final mockClientService = MockClientService();
    final mockCarService = MockCarService();
    final mockOrderService = MockOrderService();

    // Настраиваем mock поведение
    _setupMockClientService(mockClientService);
    _setupMockCarService(mockCarService);
    _setupMockOrderService(mockOrderService);

    return [
      clientServiceProvider.overrideWithValue(mockClientService),
      carServiceProvider.overrideWithValue(mockCarService),
      orderServiceProvider.overrideWithValue(mockOrderService),
    ];
  }

  /// Создает overrides для тестов с пустыми данными
  static List<Override> createEmptyDataOverrides() {
    final mockClientService = MockClientService();
    final mockCarService = MockCarService();
    final mockOrderService = MockOrderService();

    // Настраиваем возврат пустых списков
    when(mockClientService.getAllClients(
            includeDeleted: anyNamed('includeDeleted')))
        .thenAnswer((_) async => []);

    return [
      clientServiceProvider.overrideWithValue(mockClientService),
      carServiceProvider.overrideWithValue(mockCarService),
      orderServiceProvider.overrideWithValue(mockOrderService),
    ];
  }

  /// Создает overrides для тестов с ошибками
  static List<Override> createErrorOverrides() {
    final mockClientService = MockClientService();
    final mockCarService = MockCarService();
    final mockOrderService = MockOrderService();

    // Настраиваем возврат ошибок
    when(mockClientService.getAllClients(
            includeDeleted: anyNamed('includeDeleted')))
        .thenThrow(Exception('Test error'));

    return [
      clientServiceProvider.overrideWithValue(mockClientService),
      carServiceProvider.overrideWithValue(mockCarService),
      orderServiceProvider.overrideWithValue(mockOrderService),
    ];
  }

  static void _setupMockClientService(MockClientService mockService) {
    when(mockService.getAllClients(includeDeleted: anyNamed('includeDeleted')))
        .thenAnswer((_) async => TestData.testClients);
    when(mockService.searchClients(any)).thenAnswer((invocation) async {
      final query = invocation.positionalArguments[0] as String;
      return TestData.searchClients(query);
    });
    when(mockService.isCodeUnique(any, excludeUuid: anyNamed('excludeUuid')))
        .thenAnswer((_) async => true);
  }

  static void _setupMockCarService(MockCarService mockService) {
    // Базовая настройка mock методов для CarService
    // Методы настраиваются только если они определены в оригинальном классе
  }

  static void _setupMockOrderService(MockOrderService mockService) {
    // Базовая настройка mock методов для OrderService
    // Методы настраиваются только если они определены в оригинальном классе
  }
}