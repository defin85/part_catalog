import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';
import 'package:part_catalog/features/documents/orders/providers/order_providers.dart';
import 'package:part_catalog/features/documents/orders/screens/orders_screen.dart';
import 'package:part_catalog/features/documents/orders/services/order_service.dart';

import '../../fixtures/test_data.dart';
import 'orders_screen_test.mocks.dart';

@GenerateMocks([OrderService])
void main() {
  group('OrdersScreen Widget Tests', () {
    late MockOrderService mockOrderService;

    setUpAll(() async {
      // Инициализируем локаль для форматирования дат один раз для всех тестов
      await initializeDateFormatting('ru');
    });

    setUp(() {
      mockOrderService = MockOrderService();
    });

    Future<void> pumpTestApp(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            // Вот ключевое изменение: мы подменяем провайдер сервиса,
            // чтобы он возвращал наш мок. Notifier будет его использовать.
            orderServiceProvider.overrideWithValue(mockOrderService),
          ],
          child: TranslationProvider(
            child: const MaterialApp(
              home: OrdersScreen(),
            ),
          ),
        ),
      );
    }

    testWidgets('should show loading indicator initially', (tester) async {
      // Arrange
      when(mockOrderService.watchOrders())
          .thenAnswer((_) => const Stream.empty());

      // Act
      await pumpTestApp(tester);

      // Assert
      // На первом кадре будет индикатор загрузки
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should show list of orders when data is available',
        (tester) async {
      // Arrange
      final List<OrderModelComposite> orders = [TestData.testOrder1];
      when(mockOrderService.watchOrders())
          .thenAnswer((_) => Stream.value(orders));

      // Act
      await pumpTestApp(tester);
      // pump() для обработки состояния загрузки
      await tester.pump();
      // pump() для обработки поступления данных из стрима
      await tester.pump();

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text(orders.first.displayName), findsOneWidget);
    });

    testWidgets('should show empty message when there are no orders',
        (tester) async {
      // Arrange
      when(mockOrderService.watchOrders()).thenAnswer((_) => Stream.value([]));

      // Act
      await pumpTestApp(tester);
      await tester.pump();
      await tester.pump();

      // Assert
      expect(find.text('Заказы-наряды не найдены'), findsOneWidget);
    });

    testWidgets('should show error message when stream has error',
        (tester) async {
      // Arrange
      final error = Exception('Failed to load');
      when(mockOrderService.watchOrders())
          .thenAnswer((_) => Stream.error(error));

      // Act
      await pumpTestApp(tester);
      await tester.pump();
      await tester.pump();

      // Assert
      expect(find.textContaining('Ошибка загрузки данных'), findsOneWidget);
    });
  });
}