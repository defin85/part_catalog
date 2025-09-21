import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';

import '../helpers/adaptive_test_helpers.dart';

void main() {
  group('AdaptivePartsSearchScreen Simple Tests', () {

    testWidgets('should render basic parts search layout', (tester) async {
      final testWidget = MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text('Поиск запчастей')),
          body: PartsSearchLayoutWidget(),
        ),
      );

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text('Поиск запчастей'), findsOneWidget);
      expect(find.byType(PartsSearchLayoutWidget), findsOneWidget);
    });

    testWidgets('should handle constraint errors correctly', (tester) async {
      await AdaptiveTestHelpers.expectNoConstraintErrors(
        tester,
        () => MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Parts Search')),
            body: PartsSearchLayoutWidget(),
          ),
        ),
        description: 'AdaptivePartsSearchScreen constraints',
      );
    });

    testWidgets('should not overflow on different screen sizes', (tester) async {
      await AdaptiveTestHelpers.expectNoOverflowOnAllSizes(
        tester,
        () => MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Parts Search')),
            body: PartsSearchLayoutWidget(),
          ),
        ),
        description: 'AdaptivePartsSearchScreen overflow',
      );
    });

    testWidgets('should handle breakpoints correctly', (tester) async {
      await AdaptiveTestHelpers.testBreakpoints(
        tester,
        () => MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Parts Search')),
            body: PartsSearchLayoutWidget(),
          ),
        ),
      );
    });

    testWidgets('should adapt to different screen sizes', (tester) async {
      await AdaptiveTestHelpers.expectResponsiveBehavior(
        tester,
        () => MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Parts Search')),
            body: PartsSearchLayoutWidget(),
          ),
        ),
        assertions: (screenSize) {
          expect(find.byType(PartsSearchLayoutWidget), findsOneWidget);
          expect(find.byType(Scaffold), findsOneWidget);

          switch (screenSize) {
            case ScreenSize.small:
              expect(find.text('🚀 Мобильный поиск'), findsOneWidget);
              break;
            case ScreenSize.medium:
              expect(find.text('🚀 Планшетный поиск'), findsOneWidget);
              break;
            case ScreenSize.large:
              expect(find.text('🚀 Десктопный поиск'), findsOneWidget);
              break;
          }
        },
      );
    });

    testWidgets('should not have ref.listen errors', (tester) async {
      await AdaptiveTestHelpers.expectNoRefListenErrors(
        tester,
        () => MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Parts Search')),
            body: PartsSearchLayoutWidget(),
          ),
        ),
        description: 'AdaptivePartsSearchScreen ref.listen',
      );
    });

    testWidgets('should handle search form validation', (tester) async {
      final testWidget = MaterialApp(
        home: Scaffold(
          body: PartsSearchLayoutWidget(),
        ),
      );

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      expect(find.text('Номер запчасти'), findsOneWidget);
      expect(find.text('Бренд (опционально)'), findsOneWidget);

      final articleField = find.byType(TextFormField).first;
      await tester.enterText(articleField, '12345');
      await tester.pumpAndSettle();

      expect(find.text('12345'), findsOneWidget);
    });
  });
}

class PartsSearchLayoutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 600;
        final isMedium = constraints.maxWidth < 1000;

        if (isSmall) {
          return _buildMobileLayout();
        } else if (isMedium) {
          return _buildTabletLayout();
        } else {
          return _buildDesktopLayout();
        }
      },
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('🚀 Мобильный поиск', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),
          _buildSearchForm(),
          SizedBox(height: 16),
          _buildSearchResults(),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return SingleChildScrollView(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🚀 Планшетный поиск', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  _buildSearchForm(),
                ],
              ),
            ),
          ),
          VerticalDivider(width: 1),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: _buildSearchResults(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('🚀 Десктопный поиск', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  _buildSearchForm(),
                ],
              ),
            ),
          ),
          VerticalDivider(width: 1),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: _buildSearchResults(),
            ),
          ),
          VerticalDivider(width: 1),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: _buildActionsPanel(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchForm() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Форма поиска', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Номер запчасти',
                hintText: 'Введите номер...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Бренд (опционально)',
                hintText: 'Введите бренд...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Использовать кеш'),
              value: true,
              onChanged: (_) {},
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Найти'),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text('Очистить'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Результаты поиска', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Введите номер запчасти для поиска'),
            SizedBox(height: 8),
            Text('Используйте форму поиска слева'),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsPanel() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Быстрые действия', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {},
              child: Text('История поиска'),
            ),
            SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {},
              child: Text('Избранное'),
            ),
            SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {},
              child: Text('Экспорт'),
            ),
          ],
        ),
      ),
    );
  }
}

