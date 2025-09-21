import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:part_catalog/core/widgets/adaptive_app_bar.dart';
import '../../helpers/adaptive_test_helpers.dart';
import '../../helpers/test_helpers.dart';

void main() {
  group('AdaptiveAppBar Widget Tests', () {
    testWidgets('should render basic app bar without errors', (tester) async {
      await tester.pumpWidget(
        TestHelpers.createTestApp(
          Scaffold(
            appBar: const AdaptiveAppBar(
              title: 'Test Title',
            ),
            body: const Text('Body'),
          ),
        ),
      );

      expect(find.byType(AdaptiveAppBar), findsOneWidget);
      expect(find.text('Test Title'), findsOneWidget);
    });

    testWidgets('should adapt to screen sizes with different layouts', (tester) async {
      await AdaptiveTestHelpers.expectDifferentLayouts(
        tester,
        () => Scaffold(
          appBar: const AdaptiveAppBar(
            title: 'Adaptive Title',
            actions: [
              Icon(Icons.search),
              Icon(Icons.more_vert),
            ],
          ),
          body: const Text('Body'),
        ),
        smallScreenAssertions: () {
          // Mobile: Standard AppBar
          expect(find.byType(AppBar), findsOneWidget);
          expect(find.text('Adaptive Title'), findsOneWidget);
        },
        mediumScreenAssertions: () {
          // Tablet: Enhanced AppBar
          expect(find.byType(AppBar), findsOneWidget);
          expect(find.text('Adaptive Title'), findsOneWidget);
        },
        largeScreenAssertions: () {
          // Desktop: Custom Container layout
          expect(find.byType(Container), findsWidgets);
          expect(find.text('Adaptive Title'), findsOneWidget);
        },
      );
    });

    testWidgets('should not overflow on any screen size', (tester) async {
      await AdaptiveTestHelpers.expectNoOverflowOnAllSizes(
        tester,
        () => Scaffold(
          appBar: const AdaptiveAppBar(
            title: 'Very Long Title That Might Cause Overflow Issues',
            actions: [
              Icon(Icons.search),
              Icon(Icons.favorite),
              Icon(Icons.share),
              Icon(Icons.more_vert),
            ],
          ),
          body: const Text('Body'),
        ),
      );
    });

    group('Different Screen Layouts', () {
      testWidgets('should show mobile layout on small screens', (tester) async {
        await tester.binding.setSurfaceSize(AdaptiveTestHelpers.smallScreen);
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            Scaffold(
              appBar: const AdaptiveAppBar(
                title: 'Mobile Title',
                actions: [Icon(Icons.search)],
              ),
              body: const Text('Body'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should be standard AppBar
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Mobile Title'), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
      });

      testWidgets('should show tablet layout on medium screens', (tester) async {
        await tester.binding.setSurfaceSize(AdaptiveTestHelpers.mediumScreen);
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            Scaffold(
              appBar: const AdaptiveAppBar(
                title: 'Tablet Title',
                actions: [Icon(Icons.search)],
              ),
              body: const Text('Body'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should be enhanced AppBar with larger text
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.text('Tablet Title'), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
      });

      testWidgets('should show desktop layout on large screens', (tester) async {
        await tester.binding.setSurfaceSize(AdaptiveTestHelpers.largeScreen);
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            Scaffold(
              appBar: const AdaptiveAppBar(
                title: 'Desktop Title',
                actions: [Icon(Icons.search)],
              ),
              body: const Text('Body'),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Should be custom Container layout
        expect(find.text('Desktop Title'), findsOneWidget);
        expect(find.byIcon(Icons.search), findsOneWidget);
      });
    });

    group('AppBar Features', () {
      testWidgets('should handle leading widget on all screens', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => Scaffold(
            appBar: const AdaptiveAppBar(
              title: 'Title with Leading',
              leading: Icon(Icons.menu),
            ),
            body: const Text('Body'),
          ),
          description: 'leading widget',
        );
      });

      testWidgets('should handle actions on all screens', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => Scaffold(
            appBar: const AdaptiveAppBar(
              title: 'Title with Actions',
              actions: [
                Icon(Icons.search),
                Icon(Icons.favorite),
                Icon(Icons.more_vert),
              ],
            ),
            body: const Text('Body'),
          ),
          description: 'actions',
        );
      });

      testWidgets('should handle bottom widget on all screens', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => Scaffold(
            appBar: const AdaptiveAppBar(
              title: 'Title with Bottom',
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Tab 1'),
                  Tab(text: 'Tab 2'),
                ],
              ),
            ),
            body: const Text('Body'),
          ),
          description: 'bottom widget',
        );
      });

      testWidgets('should handle center title on all screens', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => Scaffold(
            appBar: const AdaptiveAppBar(
              title: 'Centered Title',
              centerTitle: true,
            ),
            body: const Text('Body'),
          ),
          description: 'center title',
        );
      });
    });

    group('Styling Options', () {
      testWidgets('should apply custom background color', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => Scaffold(
            appBar: const AdaptiveAppBar(
              title: 'Colored AppBar',
              backgroundColor: Colors.blue,
            ),
            body: const Text('Body'),
          ),
          description: 'custom background color',
        );
      });

      testWidgets('should apply custom elevation', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => Scaffold(
            appBar: const AdaptiveAppBar(
              title: 'Elevated AppBar',
              elevation: 8.0,
            ),
            body: const Text('Body'),
          ),
          description: 'custom elevation',
        );
      });

      testWidgets('should handle automaticallyImplyLeading', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => Scaffold(
            appBar: const AdaptiveAppBar(
              title: 'No Auto Leading',
              automaticallyImplyLeading: false,
            ),
            body: const Text('Body'),
          ),
          description: 'automaticallyImplyLeading false',
        );
      });
    });

    group('Preferred Size', () {
      testWidgets('should have correct preferred size', (tester) async {
        const appBar = AdaptiveAppBar(title: 'Size Test');

        expect(appBar.preferredSize.height, equals(72.0));
      });

      testWidgets('should adjust preferred size with bottom widget', (tester) async {
        const bottom = TabBar(
          tabs: [Tab(text: 'Tab 1'), Tab(text: 'Tab 2')],
        );
        const appBar = AdaptiveAppBar(
          title: 'Size Test with Bottom',
          bottom: bottom,
        );

        expect(
          appBar.preferredSize.height,
          equals(72.0 + bottom.preferredSize.height),
        );
      });
    });

    group('AdaptiveAppBarHeight Utility', () {
      testWidgets('should return correct heights for different screen sizes', (tester) async {
        // Small screen
        await tester.binding.setSurfaceSize(const Size(400, 600));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            Builder(
              builder: (context) {
                final height = AdaptiveAppBarHeight.getHeight(context);
                expect(height, equals(56.0)); // Mobile height
                return const SizedBox();
              },
            ),
          ),
        );

        // Medium screen
        await tester.binding.setSurfaceSize(const Size(700, 800));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            Builder(
              builder: (context) {
                final height = AdaptiveAppBarHeight.getHeight(context);
                expect(height, equals(64.0)); // Tablet height
                return const SizedBox();
              },
            ),
          ),
        );

        // Large screen
        await tester.binding.setSurfaceSize(const Size(1200, 800));
        await tester.pumpWidget(
          TestHelpers.createTestApp(
            Builder(
              builder: (context) {
                final height = AdaptiveAppBarHeight.getHeight(context);
                expect(height, equals(72.0)); // Desktop height
                return const SizedBox();
              },
            ),
          ),
        );
      });
    });

    testWidgets('should handle breakpoints correctly', (tester) async {
      await AdaptiveTestHelpers.testBreakpoints(
        tester,
        () => Scaffold(
          appBar: const AdaptiveAppBar(title: 'Breakpoint Test'),
          body: const Text('Body'),
        ),
      );
    });

    group('Performance Tests', () {
      testWidgets('should render quickly with many actions', (tester) async {
        await TestHelpers.testPerformance(
          tester,
          Scaffold(
            appBar: AdaptiveAppBar(
              title: 'Performance Test',
              actions: List.generate(
                10,
                (index) => Icon(Icons.star),
              ),
            ),
            body: const Text('Body'),
          ),
          maxRenderTimeMs: 150,
        );
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty title', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => Scaffold(
            appBar: const AdaptiveAppBar(title: ''),
            body: const Text('Body'),
          ),
          description: 'empty title',
        );
      });

      testWidgets('should handle very long title', (tester) async {
        await AdaptiveTestHelpers.expectNoOverflowOnAllSizes(
          tester,
          () => Scaffold(
            appBar: AdaptiveAppBar(
              title: 'Very Long Title ' * 10,
            ),
            body: const Text('Body'),
          ),
        );
      });

      testWidgets('should handle no actions', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => Scaffold(
            appBar: const AdaptiveAppBar(
              title: 'No Actions',
              actions: [],
            ),
            body: const Text('Body'),
          ),
          description: 'no actions',
        );
      });

      testWidgets('should handle many actions', (tester) async {
        await AdaptiveTestHelpers.expectNoOverflowOnAllSizes(
          tester,
          () => Scaffold(
            appBar: AdaptiveAppBar(
              title: 'Many Actions',
              actions: List.generate(
                15,
                (index) => Icon(Icons.star),
              ),
            ),
            body: const Text('Body'),
          ),
        );
      });
    });

    group('Theme Integration', () {
      testWidgets('should respect theme colors', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => Theme(
            data: ThemeData(
              primarySwatch: Colors.purple,
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
            ),
            child: Scaffold(
              appBar: const AdaptiveAppBar(title: 'Themed AppBar'),
              body: const Text('Body'),
            ),
          ),
          description: 'theme integration',
        );
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible on all screen sizes', (tester) async {
        await AdaptiveTestHelpers.testAllScreenSizes(
          tester,
          () => Scaffold(
            appBar: const AdaptiveAppBar(
              title: 'Accessible AppBar',
              actions: [
                Icon(Icons.search, semanticLabel: 'Search'),
                Icon(Icons.menu, semanticLabel: 'Menu'),
              ],
            ),
            body: const Text('Body'),
          ),
          description: 'accessibility',
        );
      });
    });
  });
}