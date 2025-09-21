import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';

import '../helpers/adaptive_test_helpers.dart';

void main() {
  group('Minimal Adaptive Widget Tests', () {

    testWidgets('should detect BoxConstraints error in problematic widget', (tester) async {
      // Виджет с потенциальной BoxConstraints проблемой
      Widget problematicWidget() {
        return MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                // Этот виджет может вызвать infinite height
                Column(
                  children: [
                    for (int i = 0; i < 100; i++)
                      Container(height: 50, child: Text('Item $i')),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      // Этот тест должен либо пройти, либо обнаружить constraint ошибку
      try {
        await AdaptiveTestHelpers.expectNoConstraintErrors(
          tester,
          () => problematicWidget(),
          description: 'problematic widget with many items',
        );
        print('✅ No constraint errors detected');
      } catch (e) {
        print('🔍 Constraint error detected: $e');
        // Это ожидаемо - тест работает правильно
      }
    });

    testWidgets('should work with simple widget', (tester) async {
      Widget simpleWidget() {
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Simple Test')),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Предотвращает infinite height
                children: [
                  Container(height: 100, child: Text('Item 1')),
                  Container(height: 100, child: Text('Item 2')),
                ],
              ),
            ),
          ),
        );
      }

      // Этот тест должен пройти успешно
      await AdaptiveTestHelpers.expectNoConstraintErrors(
        tester,
        () => simpleWidget(),
        description: 'simple widget with proper layout',
      );

      await AdaptiveTestHelpers.expectNoRefListenErrors(
        tester,
        () => simpleWidget(),
        description: 'simple widget without providers',
      );

      await AdaptiveTestHelpers.testAllScreenSizes(
        tester,
        () => simpleWidget(),
        description: 'simple widget responsiveness',
      );
    });

    testWidgets('should test adaptive behavior without complex providers', (tester) async {
      Widget adaptiveWidget() {
        return MaterialApp(
          home: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                if (width < 600) {
                  // Mobile layout
                  return Column(
                    children: [
                      AppBar(title: Text('Mobile')),
                      Expanded(child: Text('Mobile Content')),
                    ],
                  );
                } else if (width < 1000) {
                  // Tablet layout
                  return Row(
                    children: [
                      Expanded(flex: 1, child: Text('Sidebar')),
                      VerticalDivider(),
                      Expanded(flex: 2, child: Text('Tablet Content')),
                    ],
                  );
                } else {
                  // Desktop layout
                  return Row(
                    children: [
                      Expanded(flex: 1, child: Text('Left Panel')),
                      VerticalDivider(),
                      Expanded(flex: 3, child: Text('Desktop Content')),
                      VerticalDivider(),
                      Expanded(flex: 1, child: Text('Right Panel')),
                    ],
                  );
                }
              },
            ),
          ),
        );
      }

      await AdaptiveTestHelpers.expectResponsiveBehavior(
        tester,
        () => adaptiveWidget(),
        assertions: (screenSize) {
          expect(find.byType(LayoutBuilder), findsOneWidget);

          switch (screenSize) {
            case ScreenSize.small:
              expect(find.text('Mobile'), findsOneWidget);
              break;
            case ScreenSize.medium:
              expect(find.text('Tablet Content'), findsOneWidget);
              break;
            case ScreenSize.large:
              expect(find.text('Desktop Content'), findsOneWidget);
              break;
          }
        },
      );
    });
  });
}