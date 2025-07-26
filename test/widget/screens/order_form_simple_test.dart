import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/documents/orders/screens/order_form_screen.dart';

void main() {
  group('OrderFormScreen Simple Tests', () {
    testWidgets('renders without crashing in create mode', (tester) async {
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: TranslationProvider(
            child: MaterialApp(
              home: OrderFormScreen(orderUuid: null),
            ),
          ),
        ),
      );

      // Allow time for any async operations
      await tester.pump();

      // Assert - no crashes occurred
      expect(find.byType(OrderFormScreen), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('shows correct title in create mode', (tester) async {
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: TranslationProvider(
            child: MaterialApp(
              home: OrderFormScreen(orderUuid: null),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(Duration(seconds: 2));

      // Assert
      expect(find.text(t.orders.newOrderTitle), findsOneWidget);
    });

    testWidgets('contains essential form elements', (tester) async {
      // Act
      await tester.pumpWidget(
        ProviderScope(
          child: TranslationProvider(
            child: MaterialApp(
              home: OrderFormScreen(orderUuid: null),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle(Duration(seconds: 2));

      // Assert - check for key form components
      expect(find.byType(TextFormField), findsAtLeastNWidgets(1));
      // Check for any kind of button (save functionality)
      final buttons = find.byType(ElevatedButton)
          .evaluate()
          .length + 
          find.byType(FloatingActionButton)
          .evaluate()
          .length +
          find.byType(IconButton)
          .evaluate()
          .length;
      expect(buttons, greaterThan(0));
    });
  });
}