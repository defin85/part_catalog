import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/features/documents/orders/screens/order_form_screen.dart';
import '../../helpers/test_helpers.dart';

// Исправленный тест для OrderFormScreen
void main() {
  group('OrderFormScreen Widget Tests', () {
    testWidgets('should render without errors', (tester) async {
      await tester.pumpTestApp(
        const OrderFormScreen(),
      );

      expect(find.byType(OrderFormScreen), findsOneWidget);
    });

    testWidgets('should have form widget', (tester) async {
      await tester.pumpTestApp(
        const OrderFormScreen(),
      );
      
      // Даем время виджету полностью загрузиться
      await tester.pumpAndSettle();

      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets('should have description field', (tester) async {
      await tester.pumpTestApp(
        const OrderFormScreen(),
      );
      
      await tester.pumpAndSettle();

      // Проверяем наличие текстовых полей
      expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
    });
  });
}