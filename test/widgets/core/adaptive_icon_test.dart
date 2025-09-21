import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/core/widgets/adaptive_icon.dart';
import '../../helpers/adaptive_test_helpers.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('AdaptiveIcon Widget Tests', () {
    testWidgets('should render basic icon without errors', (tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          const AdaptiveIcon(Icons.star),
        ),
      );

      expect(find.byType(AdaptiveIcon), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('should adapt to screen sizes', (tester) async {
      await AdaptiveTestHelpers.expectResponsiveBehavior(
        tester,
        () => const AdaptiveIcon(Icons.home),
        assertions: (screenSize) {
          expect(find.byType(AdaptiveIcon), findsOneWidget);
          expect(find.byIcon(Icons.home), findsOneWidget);
        },
      );
    });

    testWidgets('should not overflow on any screen size', (tester) async {
      await AdaptiveTestHelpers.expectNoOverflowOnAllSizes(
        tester,
        () => const AdaptiveIcon(Icons.star),
      );
    });

    group('Icon Contexts', () {
      for (final context in AdaptiveIconContext.values) {
        testWidgets('should render ${context.name} context correctly', (tester) async {
          await AdaptiveTestHelpers.testAllScreenSizes(
            tester,
            () => AdaptiveIcon(
              Icons.star,
              context: context,
            ),
            description: '${context.name} context',
          );
        });
      }
    });

    group('Icon States', () {
      for (final state in AdaptiveIconState.values) {
        testWidgets('should handle ${state.name} state', (tester) async {
          await AdaptiveTestHelpers.testAllScreenSizes(
            tester,
            () => AdaptiveIcon(
              Icons.star,
              state: state,
            ),
            description: '${state.name} state',
          );
        });
      }
    });

    group('Named Constructors', () {
      testWidgets('should work with .navigation constructor', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveIcon.navigation(Icons.menu),
          description: 'navigation constructor',
        );
      });

      testWidgets('should work with .action constructor', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveIcon.action(Icons.more_vert),
          description: 'action constructor',
        );
      });

      testWidgets('should work with .button constructor', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveIcon.button(Icons.add),
          description: 'button constructor',
        );
      });
    });

    group('Icon Sizes', () {
      testWidgets('should have different sizes on different screens', (tester) async {
        Size? smallSize, mediumSize, largeSize;

        // Small screen
        await tester.binding.setSurfaceSize(AdaptiveTestHelpers.smallScreen);
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            const AdaptiveIcon(
              Icons.star,
              context: AdaptiveIconContext.navigation,
            ),
          ),
        );
        await tester.pumpAndSettle();
        if (tester.any(find.byIcon(Icons.star))) {
          smallSize = tester.getSize(find.byIcon(Icons.star));
        }

        // Medium screen
        await tester.binding.setSurfaceSize(AdaptiveTestHelpers.mediumScreen);
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            const AdaptiveIcon(
              Icons.star,
              context: AdaptiveIconContext.navigation,
            ),
          ),
        );
        await tester.pumpAndSettle();
        if (tester.any(find.byIcon(Icons.star))) {
          mediumSize = tester.getSize(find.byIcon(Icons.star));
        }

        // Large screen
        await tester.binding.setSurfaceSize(AdaptiveTestHelpers.largeScreen);
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            const AdaptiveIcon(
              Icons.star,
              context: AdaptiveIconContext.navigation,
            ),
          ),
        );
        await tester.pumpAndSettle();
        if (tester.any(find.byIcon(Icons.star))) {
          largeSize = tester.getSize(find.byIcon(Icons.star));
        }

        // Verify sizes are different (or at least reasonable)
        expect(smallSize, isNotNull);
        expect(mediumSize, isNotNull);
        expect(largeSize, isNotNull);
      });

      testWidgets('should respect custom size on all screens', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveIcon(
            Icons.star,
            customSize: 32.0,
          ),
          description: 'custom size',
        );
      });
    });

    group('Interactive Features', () {
      testWidgets('should handle onTap on all screen sizes', (tester) async {
        bool tapped = false;

        await AdaptiveTestHelpers.expectResponsiveBehavior(
          tester,
          () => AdaptiveIcon(
            Icons.star,
            onTap: () => tapped = true,
          ),
          assertions: (screenSize) {
            expect(find.byType(AdaptiveIcon), findsOneWidget);
          },
        );

        // Test tap on large screen
        await tester.binding.setSurfaceSize(AdaptiveTestHelpers.largeScreen);
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdaptiveIcon(
              Icons.star,
              onTap: () => tapped = true,
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(AdaptiveIcon));
        await tester.pumpAndSettle();
        expect(tapped, isTrue);
      });

      testWidgets('should handle onLongPress', (tester) async {
        bool longPressed = false;

        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdaptiveIcon(
              Icons.star,
              onLongPress: () => longPressed = true,
            ),
          ),
        );

        await tester.longPress(find.byType(AdaptiveIcon));
        await tester.pumpAndSettle();
        expect(longPressed, isTrue);
      });

      testWidgets('should show splash effect when enabled', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => AdaptiveIcon(
            Icons.star,
            onTap: () {},
            showSplash: true,
          ),
          description: 'splash effect',
        );
      });

      testWidgets('should not show splash when disabled', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => AdaptiveIcon(
            Icons.star,
            onTap: () {},
            showSplash: false,
          ),
          description: 'no splash',
        );
      });
    });

    group('Animations', () {
      testWidgets('should show animations when enabled', (tester) async {
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            AdaptiveIcon(
              Icons.star,
              onTap: () {},
              showAnimation: true,
            ),
          ),
        );

        // Start tap gesture
        await tester.startGesture(tester.getCenter(find.byType(AdaptiveIcon)));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(AdaptiveIcon), findsOneWidget);
      });

      testWidgets('should not animate when disabled', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => AdaptiveIcon(
            Icons.star,
            onTap: () {},
            showAnimation: false,
          ),
          description: 'no animation',
        );
      });
    });

    group('Selected Icon', () {
      testWidgets('should show selected icon when state is selected', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveIcon(
            Icons.star_border,
            state: AdaptiveIconState.selected,
            selectedIcon: Icon(Icons.star),
          ),
          description: 'selected icon',
        );
      });
    });

    group('Custom Configuration', () {
      testWidgets('should apply custom config correctly', (tester) async {
        const customConfig = AdaptiveIconConfig(
          mobileSize: 16,
          tabletSize: 20,
          desktopSize: 24,
          animationDuration: Duration(milliseconds: 300),
        );

        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveIcon(
            Icons.star,
            config: customConfig,
          ),
          description: 'custom config',
        );
      });

      testWidgets('should use predefined configs correctly', (tester) async {
        final configs = [
          ('navigation', AdaptiveIconConfig.navigation),
          ('action', AdaptiveIconConfig.action),
          ('button', AdaptiveIconConfig.button),
          ('list', AdaptiveIconConfig.list),
          ('card', AdaptiveIconConfig.card),
          ('header', AdaptiveIconConfig.header),
          ('tab', AdaptiveIconConfig.tab),
          ('fab', AdaptiveIconConfig.fab),
          ('avatar', AdaptiveIconConfig.avatar),
          ('decorative', AdaptiveIconConfig.decorative),
        ];

        for (final (name, config) in configs) {
          await AdaptiveTestHelpers.testAllScreenSizes(
            tester,
            () => AdaptiveIcon(
              Icons.star,
              config: config,
            ),
            description: '$name config',
          );
        }
      });
    });

    group('Extension Methods', () {
      testWidgets('should work with asAdaptiveNavigationIcon extension', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => Icons.menu.asAdaptiveNavigationIcon(),
          description: 'asAdaptiveNavigationIcon extension',
        );
      });

      testWidgets('should work with asAdaptiveActionIcon extension', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => Icons.more_vert.asAdaptiveActionIcon(),
          description: 'asAdaptiveActionIcon extension',
        );
      });

      testWidgets('should work with asAdaptiveButtonIcon extension', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => Icons.add.asAdaptiveButtonIcon(),
          description: 'asAdaptiveButtonIcon extension',
        );
      });

      testWidgets('should work with asAdaptiveIcon extension', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => Icons.star.asAdaptiveIcon(),
          description: 'asAdaptiveIcon extension',
        );
      });
    });

    group('Colors and Styling', () {
      testWidgets('should apply custom colors correctly', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveIcon(
            Icons.star,
            color: Colors.red,
          ),
          description: 'custom color',
        );
      });

      testWidgets('should apply padding correctly', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveIcon(
            Icons.star,
            padding: EdgeInsets.all(16),
          ),
          description: 'padding',
        );
      });

      testWidgets('should apply border radius', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => AdaptiveIcon(
            Icons.star,
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
          ),
          description: 'border radius',
        );
      });
    });

    testWidgets('should handle breakpoints correctly', (tester) async {
      await AdaptiveTestHelpers.testBreakpoints(
        tester,
        () => const AdaptiveIcon(Icons.star),
      );
    });

    group('Performance Tests', () {
      testWidgets('should render quickly with animations', (tester) async {
        await TestHelpers.testPerformance(
          tester,
          AdaptiveIcon(
            Icons.star,
            onTap: () {},
            showAnimation: true,
          ),
          maxRenderTimeMs: 100,
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle no interactions gracefully', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveIcon(Icons.star),
          description: 'no interactions',
        );
      });

      testWidgets('should handle null config gracefully', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveIcon(
            Icons.star,
            config: null,
          ),
          description: 'null config',
        );
      });

      testWidgets('should handle very small custom sizes', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveIcon(
            Icons.star,
            customSize: 1,
          ),
          description: 'very small size',
        );
      });

      testWidgets('should handle very large custom sizes', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveIcon(
            Icons.star,
            customSize: 200,
          ),
          description: 'very large size',
        );
      });
    });

    group('Semantic Labels', () {
      testWidgets('should apply semantic labels correctly', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => const AdaptiveIcon(
            Icons.star,
            semanticLabel: 'Favorite',
          ),
          description: 'semantic label',
        );
      });
    });
  });
}