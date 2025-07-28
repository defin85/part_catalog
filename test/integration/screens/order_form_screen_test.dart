import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/documents/orders/notifiers/order_form_notifier.dart';
import 'package:part_catalog/features/documents/orders/screens/order_form_screen.dart';
import 'package:part_catalog/features/documents/orders/state/order_form_state.dart';

import '../../fixtures/test_data.dart';
import 'order_form_screen_test.mocks.dart';

// 1. Аннотация для генерации моков
@GenerateMocks([OrderFormNotifier])
void main() {
  // 2. Поздняя инициализация мока
  late MockOrderFormNotifier mockNotifier;

  setUp(() {
    // 3. Инициализация мока перед каждым тестом
    mockNotifier = MockOrderFormNotifier();
  });

  // Helper для создания тестового виджета
  Widget createWidgetUnderTest({String? orderUuid}) {
    return ProviderScope(
      overrides: [
        // 4. Подмена реального провайдера на мок
        orderFormNotifierProvider(orderUuid).overrideWith((ref) => mockNotifier),
      ],
      child: TranslationProvider(
        child: MaterialApp(
          home: OrderFormScreen(orderUuid: orderUuid),
        ),
      ),
    );
  }

  group('OrderFormScreen Widget Tests', () {
    testWidgets('shows loading indicator when state is loading', (tester) async {
      // Arrange
      const state = OrderFormState(isLoading: true);
      when(mockNotifier.state).thenReturn(state); // Устанавливаем начальное состояние
      when(mockNotifier.stream).thenAnswer((_) => Stream.value(state)); // Эмулируем стрим

      // Act
      await tester.pumpWidget(createWidgetUnderTest());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays form fields in create mode', (tester) async {
      // Arrange
      final state = OrderFormState(
        isLoading: false,
        isEditMode: false,
        initialOrder: null,
      );
      when(mockNotifier.state).thenReturn(state);
      when(mockNotifier.stream).thenAnswer((_) => Stream.value(state));

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Ждем завершения всех анимаций

      // Assert
      expect(find.text(t.orders.newOrderTitle), findsOneWidget);
      expect(find.text(t.orders.selectClientHint), findsOneWidget);
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('displays populated form fields in edit mode', (tester) async {
      // Arrange
      final testOrder = TestData.testOrder1;
      final state = OrderFormState(
        isLoading: false,
        isEditMode: true,
        initialOrder: testOrder,
        selectedClient: TestData.testClientPhysical,
        description: testOrder.description ?? '',
      );
      when(mockNotifier.state).thenReturn(state);
      when(mockNotifier.stream).thenAnswer((_) => Stream.value(state));

      // Act
      await tester.pumpWidget(createWidgetUnderTest(orderUuid: testOrder.uuid));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text(t.orders.editOrderTitle), findsOneWidget);
      expect(find.text(TestData.testClientPhysical.displayName), findsOneWidget);
      expect(find.text(testOrder.description!), findsOneWidget);
    });

    testWidgets('calls saveOrder on notifier when save button is tapped', (tester) async {
      // Arrange
      final state = OrderFormState(isLoading: false, isEditMode: false);
      when(mockNotifier.state).thenReturn(state);
      when(mockNotifier.stream).thenAnswer((_) => Stream.value(state));
      // Мокируем saveOrder, чтобы он возвращал успешный результат
      when(mockNotifier.saveOrder()).thenAnswer((_) async => true);

      // Act
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.save));
      await tester.pump(); // Ждем обработки нажатия

      // Assert
      verify(mockNotifier.saveOrder()).called(1);
    });
  });
}