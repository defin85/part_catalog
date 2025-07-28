import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/home/screens/home_screen.dart';

// Helper to wrap widget in MaterialApp with GoRouter
Widget createHomeScreen({
  required String location,
  required Widget child,
}) {
  final router = GoRouter(
    initialLocation: location,
    routes: [
      ShellRoute(
        builder: (context, state, widget) => HomeScreen(child: widget),
        routes: [
          GoRoute(
            path: '/clients',
            builder: (context, state) => child,
          ),
          GoRoute(
            path: '/vehicles',
            builder: (context, state) => child,
          ),
          GoRoute(
            path: '/orders',
            builder: (context, state) => child,
          ),
          GoRoute(
            path: '/api-control-center',
            builder: (context, state) => child,
          ),
        ],
      ),
    ],
  );

  return TranslationProvider(
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('displays NavigationBar on small screens', (WidgetTester tester) async {
      // Arrange
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createHomeScreen(
        location: '/clients',
        child: const Text('Clients Page'),
      ));

      // Assert
      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
      expect(find.text(t.clients.screenTitle), findsWidgets); // Finds in AppBar and Nav Bar
    });

    testWidgets('displays NavigationRail on large screens', (WidgetTester tester) async {
      // Arrange
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createHomeScreen(
        location: '/orders',
        child: const Text('Orders Page'),
      ));

      // Assert
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.text(t.orders.screenTitle), findsWidgets);
    });

    testWidgets('correct navigation item is selected based on route', (WidgetTester tester) async {
      // Arrange
      tester.view.physicalSize = const Size(500, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(createHomeScreen(
        location: '/vehicles',
        child: const Text('Vehicles Page'),
      ));

      // Act
      final navigationBar = tester.widget<NavigationBar>(find.byType(NavigationBar));

      // Assert
      expect(navigationBar.selectedIndex, 1); // 0: clients, 1: vehicles
    });
  });
}
