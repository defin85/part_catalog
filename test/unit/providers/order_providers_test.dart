import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';
import 'package:part_catalog/features/documents/orders/providers/order_providers.dart';
import 'package:part_catalog/features/documents/orders/services/order_service.dart';

import '../../fixtures/test_data.dart';
import 'order_providers_test.mocks.dart';

@GenerateMocks([OrderService])
void main() {
  group('Order Providers Tests', () {
    late MockOrderService mockOrderService;
    late ProviderContainer container;

    final testOrder = TestData.testOrder1;
    final testOrders = [TestData.testOrder1, TestData.testOrder2];

    setUp(() {
      mockOrderService = MockOrderService();
      container = ProviderContainer(
        overrides: [
          orderServiceProvider.overrideWithValue(mockOrderService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('ordersListProvider returns a list of orders from the service', () async {
      // Arrange
      when(mockOrderService.watchOrders()).thenAnswer((_) => Stream.value(testOrders));

      // Act
      final result = await container.read(ordersListProvider.future);

      // Assert
      expect(result, testOrders);
      verify(mockOrderService.watchOrders()).called(1);
    });

    test('ordersListProvider handles errors from the service', () {
      // Arrange
      final error = Exception('Failed to fetch orders');
      when(mockOrderService.watchOrders()).thenAnswer((_) => Stream.error(error));

      // Act & Assert
      expect(
        container.read(ordersListProvider.future),
        throwsA(isA<Exception>()),
      );
    });

    test('orderDetailsStreamProvider returns a single order from the service', () async {
      // Arrange
      when(mockOrderService.watchOrderByUuid(testOrder.uuid))
          .thenAnswer((_) => Stream.value(testOrder));

      // Act
      final result = await container.read(orderDetailsStreamProvider(testOrder.uuid).future);

      // Assert
      expect(result, testOrder);
      verify(mockOrderService.watchOrderByUuid(testOrder.uuid)).called(1);
    });

    test('orderDetailsStreamProvider handles errors from the service', () {
      // Arrange
      final error = Exception('Failed to fetch order');
      when(mockOrderService.watchOrderByUuid(testOrder.uuid))
          .thenAnswer((_) => Stream.error(error));

      // Act & Assert
      expect(
        container.read(orderDetailsStreamProvider(testOrder.uuid).future),
        throwsA(isA<Exception>()),
      );
    });
  });
}
