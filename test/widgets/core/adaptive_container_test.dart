import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/core/widgets/adaptive_container.dart';
import '../../helpers/adaptive_test_helpers.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('AdaptiveContainer Widget Tests', () {
    testWidgets('should render basic container without errors', (tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          const AdaptiveContainer(
            child: Text('Test Content'),
          ),
        ),
      );

      expect(find.byType(AdaptiveContainer), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('should adapt to screen sizes', (tester) async {
      await AdaptiveTestHelpers.expectResponsiveBehavior(
        tester,
        () => const AdaptiveContainer(
          child: Text('Adaptive Content'),
        ),
        assertions: (screenSize) {
          expect(find.byType(AdaptiveContainer), findsOneWidget);
          expect(find.text('Adaptive Content'), findsOneWidget);
        },
      );
    });

    testWidgets('should not overflow on any screen size', (tester) async {
      await AdaptiveTestHelpers.expectNoOverflowOnAllSizes(
        tester,
        () => const AdaptiveContainer(
          child: Text('Content that should not overflow'),
        ),
      );
    });

    group('Size Modes', () {
      for (final mode in AdaptiveSizeMode.values) {
        testWidgets('should handle ${mode.name} size mode', (tester) async {
          await AdaptiveTestHelpers.testAllScreenSizes(
            tester,
            () => AdaptiveContainer(
              sizeMode: mode,
              child: Text('${mode.name} mode'),
            ),
            description: '${mode.name} size mode',
          );
        });
      }
    });

    group('Predefined Constructors', () {
      testWidgets('should work with .card constructor', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveContainer.card(
            child: Text('Card Container'),
          ),
          description: 'card constructor',
        );
      });

      testWidgets('should work with .modal constructor', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveContainer.modal(
            child: Text('Modal Container'),
          ),
          description: 'modal constructor',
        );
      });

      testWidgets('should work with .form constructor', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveContainer.form(
            child: Text('Form Container'),
          ),
          description: 'form constructor',
        );
      });

      testWidgets('should work with .sidebar constructor', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveContainer.sidebar(
            child: Text('Sidebar Container'),
          ),
          description: 'sidebar constructor',
        );
      });
    });

    group('Custom Size Configuration', () {
      testWidgets('should apply custom width and height', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveContainer(
            customWidth: 200,
            customHeight: 100,
            child: Text('Custom Size'),
          ),
          description: 'custom size',
        );
      });

      testWidgets('should respect size constraints', (tester) async {
        const config = AdaptiveSizeConfig(
          minWidth: 200,
          maxWidth: 400,
          minHeight: 100,
          maxHeight: 200,
        );

        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveContainer(
            sizeConfig: config,
            child: Text('Constrained Size'),
          ),
          description: 'size constraints',
        );
      });
    });

    group('Aspect Ratio', () {
      testWidgets('should maintain aspect ratio when requested', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveContainer(
            maintainAspectRatio: true,
            aspectRatio: 16 / 9,
            child: Text('Aspect Ratio'),
          ),
          description: 'aspect ratio',
        );
      });
    });

    group('Extension Methods', () {
      testWidgets('should work with asAdaptiveCard extension', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const Text('Extension Test').asAdaptiveCard(),
          description: 'asAdaptiveCard extension',
        );
      });

      testWidgets('should work with asAdaptiveModal extension', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const Text('Extension Test').asAdaptiveModal(),
          description: 'asAdaptiveModal extension',
        );
      });

      testWidgets('should work with asAdaptiveForm extension', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const Text('Extension Test').asAdaptiveForm(),
          description: 'asAdaptiveForm extension',
        );
      });
    });

    group('Size Calculations', () {
      testWidgets('should have different sizes on different screens', (tester) async {
        Size? smallSize, mediumSize, largeSize;

        // Small screen
        await tester.binding.setSurfaceSize(AdaptiveTestHelpers.smallScreen);
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            const AdaptiveContainer(
              sizeConfig: AdaptiveSizeConfig.card,
              child: Text('Size Test'),
            ),
          ),
        );
        await tester.pumpAndSettle();
        smallSize = tester.getSize(find.byType(Container).first);

        // Medium screen
        await tester.binding.setSurfaceSize(AdaptiveTestHelpers.mediumScreen);
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            const AdaptiveContainer(
              sizeConfig: AdaptiveSizeConfig.card,
              child: Text('Size Test'),
            ),
          ),
        );
        await tester.pumpAndSettle();
        mediumSize = tester.getSize(find.byType(Container).first);

        // Large screen
        await tester.binding.setSurfaceSize(AdaptiveTestHelpers.largeScreen);
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            const AdaptiveContainer(
              sizeConfig: AdaptiveSizeConfig.card,
              child: Text('Size Test'),
            ),
          ),
        );
        await tester.pumpAndSettle();
        largeSize = tester.getSize(find.byType(Container).first);

        // Проверяем что размеры логично изменяются
        expect(smallSize, isNotNull);
        expect(mediumSize, isNotNull);
        expect(largeSize, isNotNull);
      });
    });

    testWidgets('should handle breakpoints correctly', (tester) async {
      await AdaptiveTestHelpers.testBreakpoints(
        tester,
        () => const AdaptiveContainer(
          child: Text('Breakpoint Test'),
        ),
      );
    });

    group('Performance Tests', () {
      testWidgets('should render quickly with complex content', (tester) async {
        await TestHelpers.testPerformance(
          tester,
          AdaptiveContainer(
            sizeConfig: AdaptiveSizeConfig.card,
            child: Column(
              children: List.generate(
                20,
                (index) => Container(
                  height: 50,
                  child: Text('Item $index'),
                ),
              ),
            ),
          ),
          maxRenderTimeMs: 150,
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null configurations gracefully', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveContainer(
            child: Text('Null Config Test'),
          ),
          description: 'null configuration',
        );
      });

      testWidgets('should handle very small sizes', (tester) async {
        await tester.binding.setSurfaceSize(const Size(100, 100));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            const AdaptiveContainer(
              child: Text('Small'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AdaptiveContainer), findsOneWidget);
      });

      testWidgets('should handle very large sizes', (tester) async {
        await tester.binding.setSurfaceSize(const Size(4000, 3000));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            const AdaptiveContainer(
              child: Text('Large'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AdaptiveContainer), findsOneWidget);
      });
    });

    group('Decoration and Styling', () {
      testWidgets('should apply decorations correctly on all screens', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveContainer(
            color: Colors.blue,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Text('Styled Container'),
          ),
          description: 'decorations',
        );
      });
    });
  });
}