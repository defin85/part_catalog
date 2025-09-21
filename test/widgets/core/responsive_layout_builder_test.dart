import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';
import '../../helpers/adaptive_test_helpers.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('ResponsiveLayoutBuilder Widget Tests', () {
    testWidgets('should render small layout by default', (tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          ResponsiveLayoutBuilder(
            small: (context, constraints) => const Text('Small Layout'),
            medium: (context, constraints) => const Text('Medium Layout'),
            large: (context, constraints) => const Text('Large Layout'),
          ),
        ),
      );

      expect(find.byType(ResponsiveLayoutBuilder), findsOneWidget);
      expect(find.text('Small Layout'), findsOneWidget);
    });

    testWidgets('should switch layouts based on screen size', (tester) async {
      const breakpointMedium = 600.0;
      const breakpointLarge = 900.0;

      Widget builder() => ResponsiveLayoutBuilder(
            small: (context, constraints) => const Text('Small Layout'),
            medium: (context, constraints) => const Text('Medium Layout'),
            large: (context, constraints) => const Text('Large Layout'),
            mediumBreakpoint: breakpointMedium,
            largeBreakpoint: breakpointLarge,
          );

      // Test small screen (below medium breakpoint)
      await tester.binding.setSurfaceSize(Size(breakpointMedium - 50, 600));
      await tester.pumpWidget(TestHelpers.createTestApp(builder()));
      await tester.pumpAndSettle();
      expect(find.text('Small Layout'), findsOneWidget);
      expect(find.text('Medium Layout'), findsNothing);
      expect(find.text('Large Layout'), findsNothing);

      // Test medium screen (between medium and large breakpoints)
      await tester.binding.setSurfaceSize(Size(breakpointMedium + 50, 600));
      await tester.pumpWidget(TestHelpers.createTestApp(builder()));
      await tester.pumpAndSettle();
      expect(find.text('Small Layout'), findsNothing);
      expect(find.text('Medium Layout'), findsOneWidget);
      expect(find.text('Large Layout'), findsNothing);

      // Test large screen (above large breakpoint)
      await tester.binding.setSurfaceSize(Size(breakpointLarge + 50, 600));
      await tester.pumpWidget(TestHelpers.createTestApp(builder()));
      await tester.pumpAndSettle();
      expect(find.text('Small Layout'), findsNothing);
      expect(find.text('Medium Layout'), findsNothing);
      expect(find.text('Large Layout'), findsOneWidget);
    });

    testWidgets('should fall back to small layout when medium/large are null', (tester) async {
      Widget builder() => ResponsiveLayoutBuilder(
            small: (context, constraints) => const Text('Small Only Layout'),
          );

      // Test on large screen - should still show small layout
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(TestHelpers.createTestApp(builder()));
      await tester.pumpAndSettle();
      expect(find.text('Small Only Layout'), findsOneWidget);

      // Test on medium screen - should still show small layout
      await tester.binding.setSurfaceSize(const Size(700, 600));
      await tester.pumpWidget(TestHelpers.createTestApp(builder()));
      await tester.pumpAndSettle();
      expect(find.text('Small Only Layout'), findsOneWidget);
    });

    testWidgets('should fall back to medium when large is null', (tester) async {
      Widget builder() => ResponsiveLayoutBuilder(
            small: (context, constraints) => const Text('Small Layout'),
            medium: (context, constraints) => const Text('Medium Layout'),
            // large is null
          );

      // Test on large screen - should show medium layout
      await tester.binding.setSurfaceSize(const Size(1200, 800));
      await tester.pumpWidget(TestHelpers.createTestApp(builder()));
      await tester.pumpAndSettle();
      expect(find.text('Medium Layout'), findsOneWidget);
      expect(find.text('Small Layout'), findsNothing);
    });

    group('Custom Breakpoints', () {
      testWidgets('should use custom breakpoints correctly', (tester) async {
        const customMedium = 800.0;
        const customLarge = 1200.0;

        Widget builder() => ResponsiveLayoutBuilder(
              small: (context, constraints) => const Text('Custom Small'),
              medium: (context, constraints) => const Text('Custom Medium'),
              large: (context, constraints) => const Text('Custom Large'),
              mediumBreakpoint: customMedium,
              largeBreakpoint: customLarge,
            );

        // Test just below custom medium breakpoint
        await tester.binding.setSurfaceSize(Size(customMedium - 1, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(find.text('Custom Small'), findsOneWidget);

        // Test just above custom medium breakpoint
        await tester.binding.setSurfaceSize(Size(customMedium + 1, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(find.text('Custom Medium'), findsOneWidget);

        // Test just below custom large breakpoint
        await tester.binding.setSurfaceSize(Size(customLarge - 1, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(find.text('Custom Medium'), findsOneWidget);

        // Test just above custom large breakpoint
        await tester.binding.setSurfaceSize(Size(customLarge + 1, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(find.text('Custom Large'), findsOneWidget);
      });
    });

    group('Default Breakpoints', () {
      testWidgets('should use default breakpoints when not specified', (tester) async {
        Widget builder() => ResponsiveLayoutBuilder(
              small: (context, constraints) => const Text('Default Small'),
              medium: (context, constraints) => const Text('Default Medium'),
              large: (context, constraints) => const Text('Default Large'),
            );

        // Test default medium breakpoint (600.0)
        await tester.binding.setSurfaceSize(const Size(599, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(find.text('Default Small'), findsOneWidget);

        await tester.binding.setSurfaceSize(const Size(601, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(find.text('Default Medium'), findsOneWidget);

        // Test default large breakpoint (900.0)
        await tester.binding.setSurfaceSize(const Size(899, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(find.text('Default Medium'), findsOneWidget);

        await tester.binding.setSurfaceSize(const Size(901, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(find.text('Default Large'), findsOneWidget);
      });
    });

    group('Constraints Passing', () {
      testWidgets('should pass correct constraints to builder functions', (tester) async {
        BoxConstraints? receivedConstraints;

        await tester.binding.setSurfaceSize(const Size(800, 600));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            ResponsiveLayoutBuilder(
              small: (context, constraints) {
                receivedConstraints = constraints;
                return const Text('Constraints Test');
              },
              medium: (context, constraints) {
                receivedConstraints = constraints;
                return const Text('Constraints Test');
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(receivedConstraints, isNotNull);
        expect(receivedConstraints!.maxWidth, equals(800));
        expect(receivedConstraints!.maxHeight, equals(600));
      });
    });

    group('Complex Layouts', () {
      testWidgets('should handle complex widgets in each layout', (tester) async {
        Widget builder() => ResponsiveLayoutBuilder(
              small: (context, constraints) => Column(
                children: [
                  const Text('Small Header'),
                  Expanded(
                    child: ListView(
                      children: const [
                        ListTile(title: Text('Small Item 1')),
                        ListTile(title: Text('Small Item 2')),
                      ],
                    ),
                  ),
                ],
              ),
              medium: (context, constraints) => Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.grey[200],
                      child: const Text('Medium Sidebar'),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.white,
                      child: const Text('Medium Content'),
                    ),
                  ),
                ],
              ),
              large: (context, constraints) => Row(
                children: [
                  Container(
                    width: 200,
                    color: Colors.grey[300],
                    child: const Text('Large Sidebar'),
                  ),
                  Expanded(
                    child: Column(
                      children: const [
                        Text('Large Header'),
                        Expanded(child: Text('Large Content')),
                      ],
                    ),
                  ),
                  Container(
                    width: 150,
                    color: Colors.grey[100],
                    child: const Text('Large Side Panel'),
                  ),
                ],
              ),
            );

        await AdaptiveTestHelpers.expectDifferentLayouts(
          tester,
          builder,
          smallScreenAssertions: () {
            expect(find.text('Small Header'), findsOneWidget);
            expect(find.text('Small Item 1'), findsOneWidget);
            expect(find.byType(Column), findsWidgets);
          },
          mediumScreenAssertions: () {
            expect(find.text('Medium Sidebar'), findsOneWidget);
            expect(find.text('Medium Content'), findsOneWidget);
            expect(find.byType(Row), findsWidgets);
          },
          largeScreenAssertions: () {
            expect(find.text('Large Sidebar'), findsOneWidget);
            expect(find.text('Large Header'), findsOneWidget);
            expect(find.text('Large Content'), findsOneWidget);
            expect(find.text('Large Side Panel'), findsOneWidget);
          },
        );
      });
    });

    testWidgets('should not overflow on any screen size', (tester) async {
      await AdaptiveTestHelpers.expectNoOverflowOnAllSizes(
        tester,
        () => ResponsiveLayoutBuilder(
          small: (context, constraints) => Column(
            children: List.generate(
              10,
              (index) => Text('Small Item $index'),
            ),
          ),
          medium: (context, constraints) => Row(
            children: List.generate(
              5,
              (index) => Expanded(child: Text('Medium $index')),
            ),
          ),
          large: (context, constraints) => Wrap(
            children: List.generate(
              20,
              (index) => Container(
                width: 100,
                height: 50,
                child: Text('Large $index'),
              ),
            ),
          ),
        ),
      );
    });

    group('Edge Cases', () {
      testWidgets('should handle zero breakpoints', (tester) async {
        Widget builder() => ResponsiveLayoutBuilder(
              small: (context, constraints) => const Text('Zero Breakpoint Small'),
              medium: (context, constraints) => const Text('Zero Breakpoint Medium'),
              mediumBreakpoint: 0.0,
              largeBreakpoint: 0.0,
            );

        await tester.binding.setSurfaceSize(const Size(100, 100));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();

        // Should show medium layout since width (100) >= breakpoint (0)
        expect(find.text('Zero Breakpoint Medium'), findsOneWidget);
      });

      testWidgets('should handle very large breakpoints', (tester) async {
        Widget builder() => ResponsiveLayoutBuilder(
              small: (context, constraints) => const Text('Large Breakpoint Small'),
              medium: (context, constraints) => const Text('Large Breakpoint Medium'),
              mediumBreakpoint: 10000.0,
              largeBreakpoint: 20000.0,
            );

        await tester.binding.setSurfaceSize(const Size(1920, 1080));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();

        // Should show small layout since width (1920) < breakpoint (10000)
        expect(find.text('Large Breakpoint Small'), findsOneWidget);
      });

      testWidgets('should handle equal breakpoints', (tester) async {
        Widget builder() => ResponsiveLayoutBuilder(
              small: (context, constraints) => const Text('Equal Small'),
              medium: (context, constraints) => const Text('Equal Medium'),
              large: (context, constraints) => const Text('Equal Large'),
              mediumBreakpoint: 600.0,
              largeBreakpoint: 600.0, // Same as medium
            );

        await tester.binding.setSurfaceSize(const Size(700, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();

        // Should show large layout since width >= largeBreakpoint
        expect(find.text('Equal Large'), findsOneWidget);
      });
    });

    group('Performance Tests', () {
      testWidgets('should rebuild efficiently when screen size changes', (tester) async {
        int buildCount = 0;

        Widget builder() => ResponsiveLayoutBuilder(
              small: (context, constraints) {
                buildCount++;
                return Text('Build count: $buildCount');
              },
              medium: (context, constraints) {
                buildCount++;
                return Text('Build count: $buildCount');
              },
            );

        // Initial build
        await tester.binding.setSurfaceSize(const Size(400, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(buildCount, equals(1));

        // Change to medium screen
        await tester.binding.setSurfaceSize(const Size(700, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(buildCount, equals(2));

        // Change back to small screen
        await tester.binding.setSurfaceSize(const Size(400, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(buildCount, equals(3));
      });
    });

    group('Screen Size Enum Integration', () {
      testWidgets('should work with ScreenSize enum values', (tester) async {
        ScreenSize? currentScreenSize;

        Widget builder() => ResponsiveLayoutBuilder(
              small: (context, constraints) {
                currentScreenSize = ScreenSize.small;
                return const Text('Enum Small');
              },
              medium: (context, constraints) {
                currentScreenSize = ScreenSize.medium;
                return const Text('Enum Medium');
              },
              large: (context, constraints) {
                currentScreenSize = ScreenSize.large;
                return const Text('Enum Large');
              },
            );

        // Test small
        await tester.binding.setSurfaceSize(const Size(400, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(currentScreenSize, equals(ScreenSize.small));

        // Test medium
        await tester.binding.setSurfaceSize(const Size(700, 600));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(currentScreenSize, equals(ScreenSize.medium));

        // Test large
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        await tester.pumpWidget(TestHelpers.createTestApp(builder()));
        await tester.pumpAndSettle();
        expect(currentScreenSize, equals(ScreenSize.large));
      });
    });
  });
}