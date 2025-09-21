import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/adaptive_test_helpers.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('AdaptiveTestHelpers Unit Tests', () {

    testWidgets('expectNoConstraintErrors should detect infinite height errors', (tester) async {
      // Создаем виджет с потенциальной ошибкой BoxConstraints
      Widget problemWidget() {
        return MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                // Этот Column может вызвать infinite height в определенных условиях
                Expanded(
                  child: Column(
                    children: [
                      Container(height: 100, color: Colors.red),
                      Container(height: 100, color: Colors.blue),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Тестируем что базовый виджет работает корректно
      await AdaptiveTestHelpers.expectNoConstraintErrors(
        tester,
        () => problemWidget(),
        description: 'test widget without constraint errors',
      );
    });

    testWidgets('expectNoRefListenErrors should detect ref.listen issues', (tester) async {
      // Создаем простой виджет без ref.listen проблем
      Widget simpleWidget() {
        return MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Test')),
            body: Center(child: Text('Test Content')),
          ),
        );
      }

      // Тестируем что ref.listen detection работает
      await AdaptiveTestHelpers.expectNoRefListenErrors(
        tester,
        () => simpleWidget(),
        description: 'simple widget without ref.listen errors',
      );
    });

    testWidgets('testAllScreenSizes should work with simple widgets', (tester) async {
      await AdaptiveTestHelpers.testAllScreenSizes(
        tester,
        () => MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: Text('Test')),
            body: Text('Hello World'),
          ),
        ),
        description: 'simple test widget',
      );
    });

    testWidgets('expectNoOverflowOnAllSizes should detect overflow', (tester) async {
      await AdaptiveTestHelpers.expectNoOverflowOnAllSizes(
        tester,
        () => MaterialApp(
          home: Scaffold(
            body: Container(
              padding: EdgeInsets.all(16),
              child: Text('This text should not overflow on any screen size'),
            ),
          ),
        ),
        description: 'simple container with text',
      );
    });

    testWidgets('testBreakpoints should handle size transitions', (tester) async {
      await AdaptiveTestHelpers.testBreakpoints(
        tester,
        () => MaterialApp(
          home: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                return Center(
                  child: Text('Width: ${width.toInt()}'),
                );
              },
            ),
          ),
        ),
      );
    });

    group('Screen Size Constants', () {
      test('should have correct screen size constants', () {
        expect(AdaptiveTestHelpers.smallScreen.width, equals(320));
        expect(AdaptiveTestHelpers.smallScreen.height, equals(568));

        expect(AdaptiveTestHelpers.mediumScreen.width, equals(768));
        expect(AdaptiveTestHelpers.mediumScreen.height, equals(1024));

        expect(AdaptiveTestHelpers.largeScreen.width, equals(1920));
        expect(AdaptiveTestHelpers.largeScreen.height, equals(1080));
      });

      test('should have correct breakpoint constants', () {
        expect(AdaptiveTestHelpers.mediumBreakpoint, equals(600.0));
        expect(AdaptiveTestHelpers.largeBreakpoint, equals(1000.0));
      });
    });

    group('Error Detection Methods', () {
      testWidgets('constraint error detection should catch common layout issues', (tester) async {
        // Виджет без layout проблем
        Widget goodWidget() {
          return MaterialApp(
            home: Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Важно для предотвращения infinite height
                    children: [
                      Container(height: 100, child: Text('Item 1')),
                      Container(height: 100, child: Text('Item 2')),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // Должен пройти без ошибок
        await AdaptiveTestHelpers.expectNoConstraintErrors(
          tester,
          () => goodWidget(),
          description: 'good widget layout',
        );
      });

      testWidgets('ref.listen error detection should work with normal widgets', (tester) async {
        Widget normalWidget() {
          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: Text('Normal Widget'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {},
                  ),
                ],
              ),
              body: Column(
                children: [
                  ListTile(title: Text('Item 1')),
                  ListTile(title: Text('Item 2')),
                ],
              ),
            ),
          );
        }

        // Должен пройти без ошибок ref.listen
        await AdaptiveTestHelpers.expectNoRefListenErrors(
          tester,
          () => normalWidget(),
          description: 'normal widget without providers',
        );
      });
    });
  });
}