import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/core/navigation/app_routes.dart';
import 'package:part_catalog/core/ui/index.dart';

/// Главный экран с использованием новых UI компонентов
class HomeScreen extends ConsumerWidget {
  final Widget child;

  const HomeScreen({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String location = GoRouterState.of(context).uri.toString();
    final destinations = _getNavigationDestinations();
    final int currentIndex = _calculateSelectedIndex(location, destinations);

    return AdaptiveNavigationScaffold(
      currentIndex: currentIndex,
      destinations: destinations,
      onDestinationSelected: (index) => context.go(destinations[index].route),
      body: child,
    );
  }

  static List<AppNavigationDestination> _getNavigationDestinations() => [
        AppNavigationDestination(
          route: AppRoutes.clients,
          icon: Icons.people_alt_outlined,
          selectedIcon: Icons.people,
          label: () => t.clients.screenTitle,
        ),
        AppNavigationDestination(
          route: AppRoutes.vehicles,
          icon: Icons.directions_car_outlined,
          selectedIcon: Icons.directions_car,
          label: () => t.vehicles.screenTitle,
        ),
        AppNavigationDestination(
          route: AppRoutes.orders,
          icon: Icons.list_alt_outlined,
          selectedIcon: Icons.list_alt,
          label: () => t.orders.screenTitle,
        ),
        AppNavigationDestination(
          route: AppRoutes.partsSearch,
          icon: Icons.search_outlined,
          selectedIcon: Icons.search,
          label: () => t.suppliers.partsSearch.screenTitle,
        ),
        AppNavigationDestination(
          route: AppRoutes.apiControlCenter,
          icon: Icons.settings_input_component_outlined,
          selectedIcon: Icons.settings_input_component,
          label: () => 'API Центр',
        ),
        AppNavigationDestination(
          route: AppRoutes.logs,
          icon: Icons.event_note_outlined,
          selectedIcon: Icons.event_note,
          label: () => 'Журнал',
        ),
      ];

  int _calculateSelectedIndex(String location, List<AppNavigationDestination> destinations) {
    for (int i = 0; i < destinations.length; i++) {
      if (location.startsWith(destinations[i].route)) {
        return i;
      }
    }
    return 0;
  }
}