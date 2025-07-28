import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/features/documents/orders/widgets/order_list_item.dart';
import 'package:part_catalog/core/database/daos/orders_dao.dart';
import 'package:part_catalog/features/core/entity_core_data.dart';
import 'package:part_catalog/features/core/document_specific_data.dart';
import 'package:part_catalog/features/documents/orders/models/order_specific_data.dart';
import 'package:part_catalog/features/core/document_status.dart';

// Простой тест для OrderListItem
void main() {
  group('OrderListItem Widget Tests', () {
    testWidgets('should render with basic data', (tester) async {
      // Создаем OrderHeaderData напрямую
      final orderHeader = OrderHeaderData(
        coreData: EntityCoreData(
          uuid: 'test-uuid-1',
          code: 'ORD-001',
          displayName: 'Test Order',
          createdAt: DateTime.now(),
        ),
        docData: DocumentSpecificData(
          status: DocumentStatus.newDoc,
          documentDate: DateTime.now(),
        ),
        orderData: OrderSpecificData(
          clientId: 'client-1',
          carId: 'car-1',
          description: 'Test order description',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: OrderListItem(
                orderHeader: orderHeader,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(OrderListItem), findsOneWidget);
      expect(find.textContaining('ORD-001'), findsOneWidget);
    });
  });
}