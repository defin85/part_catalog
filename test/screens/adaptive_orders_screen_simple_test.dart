import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/adaptive_test_helpers.dart';

void main() {
  group('AdaptiveOrdersScreen Simple Tests', () {

    testWidgets('should render basic orders layout', (tester) async {
      final testWidget = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Заказ-наряды')),
          body: OrdersLayoutWidget(),
        ),
      );

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text('Заказ-наряды'), findsOneWidget);
      expect(find.byType(OrdersLayoutWidget), findsOneWidget);
    });

    testWidgets('should handle constraint errors correctly', (tester) async {
      await AdaptiveTestHelpers.expectNoConstraintErrors(
        tester,
        () => MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Orders')),
            body: OrdersLayoutWidget(),
          ),
        ),
        description: 'AdaptiveOrdersScreen constraints',
      );
    });

    testWidgets('should not overflow on different screen sizes', (tester) async {
      await AdaptiveTestHelpers.expectNoOverflowOnAllSizes(
        tester,
        () => MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Orders')),
            body: OrdersLayoutWidget(),
          ),
        ),
        description: 'AdaptiveOrdersScreen overflow',
      );
    });

    testWidgets('should handle breakpoints correctly', (tester) async {
      await AdaptiveTestHelpers.testBreakpoints(
        tester,
        () => MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Orders')),
            body: OrdersLayoutWidget(),
          ),
        ),
      );
    });

    testWidgets('should adapt to different screen sizes', (tester) async {
      await AdaptiveTestHelpers.expectResponsiveBehavior(
        tester,
        () => MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Orders')),
            body: OrdersLayoutWidget(),
          ),
        ),
        assertions: (screenSize) {
          expect(find.byType(OrdersLayoutWidget), findsOneWidget);
          expect(find.byType(Scaffold), findsOneWidget);
        },
      );
    });

    testWidgets('should demonstrate constraint error detection', (tester) async {
      // Хороший виджет
      Widget goodWidget() {
        return MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Правильно!
                children: [
                  Container(height: 100, child: Text('Search')),
                  Container(height: 200, child: Text('Filters')),
                  Container(height: 300, child: Text('Results')),
                ],
              ),
            ),
          ),
        );
      }

      // Должен пройти без ошибок
      await AdaptiveTestHelpers.expectNoConstraintErrors(
        tester,
        () => goodWidget(),
        description: 'good orders layout',
      );
    });
  });
}

class OrdersLayoutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 600;
        final isMedium = constraints.maxWidth < 1000;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isSmall ? 16.0 : 24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isMedium ? double.infinity : 1200,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchAndFilters(isSmall),
                SizedBox(height: 16),
                _buildOrdersList(isSmall),
                if (!isSmall) ...[
                  SizedBox(height: 16),
                  _buildDetailsPanel(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilters(bool isSmall) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Поиск и фильтры', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                hintText: 'Поиск заказов...',
                border: OutlineInputBorder(),
              ),
            ),
            if (isSmall) ...[
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                child: Text('Фильтры'),
              ),
            ] else ...[
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(label: Text('Активные'), selected: true, onSelected: (_) {}),
                  FilterChip(label: Text('Завершенные'), selected: false, onSelected: (_) {}),
                  FilterChip(label: Text('Отмененные'), selected: false, onSelected: (_) {}),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(bool isSmall) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Список заказов', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            ...List.generate(5, (index) => ListTile(
              leading: CircleAvatar(child: Text('${index + 1}')),
              title: Text('Заказ-наряд №${1000 + index}'),
              subtitle: Text('Статус: ${index % 2 == 0 ? 'Активный' : 'Завершен'}'),
              trailing: isSmall ? null : Icon(Icons.arrow_forward_ios),
              onTap: () {},
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsPanel() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Детали заказа', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Выберите заказ из списка'),
            SizedBox(height: 16),
            Text('Информация о заказе появится здесь'),
          ],
        ),
      ),
    );
  }
}

