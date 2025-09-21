import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/core/widgets/adaptive_card.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';
import '../../helpers/adaptive_test_helpers.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('AdaptiveCard Widget Tests', () {
    testWidgets('should render basic card without errors', (tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          const AdaptiveCard(
            child: Text('Test Content'),
          ),
        ),
      );

      expect(find.byType(AdaptiveCard), findsOneWidget);
      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('should adapt to screen sizes', (tester) async {
      await AdaptiveTestHelpers.expectResponsiveBehavior(
        tester,
        () => const AdaptiveCard(
          child: Text('Adaptive Content'),
        ),
        assertions: (screenSize) {
          expect(find.byType(AdaptiveCard), findsOneWidget);
          expect(find.text('Adaptive Content'), findsOneWidget);
        },
      );
    });

    testWidgets('should not overflow on any screen size', (tester) async {
      await AdaptiveTestHelpers.expectNoOverflowOnAllSizes(
        tester,
        () => const AdaptiveCard(
          child: Text('Long content that might cause overflow issues'),
        ),
      );
    });

    group('Card Contexts', () {
      for (final context in AdaptiveCardContext.values) {
        testWidgets('should render ${context.name} context correctly', (tester) async {
          await AdaptiveTestHelpers.testAllScreenSizes(
            tester,
            () => AdaptiveCard(
              context: context,
              child: Text('${context.name} context'),
            ),
            description: '${context.name} context',
          );
        });
      }
    });

    group('Interactive Features', () {
      testWidgets('should handle onTap on all screen sizes', (tester) async {
        bool tapped = false;

        await AdaptiveTestHelpers.expectResponsiveBehavior(
          tester,
          () => AdaptiveCard(
            onTap: () => tapped = true,
            child: const Text('Tappable Card'),
          ),
          assertions: (screenSize) {
            expect(find.byType(AdaptiveCard), findsOneWidget);
          },
        );

        // Test tap on large screen
        await tester.binding.setSurfaceSize(AdaptiveTestHelpers.largeScreen);
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdaptiveCard(
              onTap: () => tapped = true,
              child: const Text('Tappable Card'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(AdaptiveCard));
        expect(tapped, isTrue);
      });

      testWidgets('should show selection state on all screen sizes', (tester) async {
        await AdaptiveTestHelpers.expectResponsiveBehavior(
          tester,
          () => const AdaptiveCard(
            isSelectable: true,
            isSelected: true,
            child: Text('Selected Card'),
          ),
          assertions: (screenSize) {
            expect(find.byType(AdaptiveCard), findsOneWidget);
            expect(find.text('Selected Card'), findsOneWidget);
          },
        );
      });
    });

    group('Different Card Styles', () {
      testWidgets('should apply custom border radius on all screens', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveCard(
            customBorderRadius: 24.0,
            child: Text('Custom Radius'),
          ),
          description: 'custom border radius',
        );
      });

      testWidgets('should apply custom colors and elevation', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveCard(
            backgroundColor: Colors.blue,
            elevation: 8.0,
            child: Text('Custom Style'),
          ),
          description: 'custom colors and elevation',
        );
      });
    });

    group('Extension Methods', () {
      testWidgets('should work with asAdaptiveCard extension', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const Text('Extension Test').asAdaptiveCard(),
          description: 'extension method',
        );
      });
    });

    testWidgets('should handle breakpoints correctly', (tester) async {
      await AdaptiveTestHelpers.testBreakpoints(
        tester,
        () => const AdaptiveCard(
          child: Text('Breakpoint Test'),
        ),
      );
    });

    group('Performance Tests', () {
      testWidgets('should render quickly on all screen sizes', (tester) async {
        for (final size in [
          AdaptiveTestHelpers.smallScreen,
          AdaptiveTestHelpers.mediumScreen,
          AdaptiveTestHelpers.largeScreen,
        ]) {
          await TestHelpers.testPerformance(
            tester,
            AdaptiveCard(
              context: AdaptiveCardContext.primary,
              child: Column(
                children: List.generate(
                  10,
                  (index) => Text('Item $index'),
                ),
              ),
            ),
            maxRenderTimeMs: 100,
          );
        }
      });
    });

    group('Nested Cards', () {
      testWidgets('should handle nested cards correctly', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveCard(
            context: AdaptiveCardContext.primary,
            child: AdaptiveCard(
              context: AdaptiveCardContext.nested,
              child: Text('Nested Card'),
            ),
          ),
          description: 'nested cards',
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty child', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveCard(
            child: SizedBox.shrink(),
          ),
          description: 'empty child',
        );
      });

      testWidgets('should handle very long content', (tester) async {
        await AdaptiveTestHelpers.expectNoOverflowOnAllSizes(
          tester,
          () => AdaptiveCard(
            child: Text('Very long content ' * 100),
          ),
        );
      });
    });
  });
}