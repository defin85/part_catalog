import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/core/navigation/app_routes.dart';
import 'package:part_catalog/core/widgets/language_switcher.dart';

class HomeScreen extends ConsumerWidget {
  final Widget child;

  const HomeScreen({
    super.key,
    required this.child,
  });

  // Создаем навигационные элементы с учетом текущей локали
  static List<({String route, IconData icon, IconData selectedIcon, String Function() labelKey})> _getNavigationDestinations() => [
    (
      route: AppRoutes.clients,
      icon: Icons.people_alt_outlined,
      selectedIcon: Icons.people, // Добавляем выбранную иконку
      labelKey: () => t.clients.screenTitle
    ),
    (
      route: AppRoutes.vehicles,
      icon: Icons.directions_car_outlined,
      selectedIcon: Icons.directions_car, // Добавляем выбранную иконку
      labelKey: () => t.vehicles.screenTitle
    ),
    (
      route: AppRoutes.orders,
      icon: Icons.list_alt_outlined,
      selectedIcon: Icons.list_alt, // Добавляем выбранную иконку
      labelKey: () => t.orders.screenTitle
    ),
    (
      route: AppRoutes.partsSearch,
      icon: Icons.search_outlined,
      selectedIcon: Icons.search,
      labelKey: () => t.suppliers.partsSearch.screenTitle
    ),
    (
      // Новый элемент навигации
      route: AppRoutes.apiControlCenter,
      icon: Icons.settings_input_component_outlined,
      selectedIcon: Icons.settings_input_component,
      labelKey: () => t.settings.apiControlCenter
          .screenTitle // Убедитесь, что эта строка локализации существует
    ),
    // Добавьте другие основные разделы здесь
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Слушаем изменения локали для обновления меню
    ref.watch(localeProvider);
    
    final String location = GoRouterState.of(context).uri.toString();
    final navigationDestinations = _getNavigationDestinations();
    final int currentIndex = _calculateSelectedIndex(location, navigationDestinations);

    // Определяем ширину экрана
    final screenWidth = MediaQuery.of(context).size.width;
    // Устанавливаем точку перехода (breakpoint), например, 600 пикселей
    const double breakpoint = 600;

    // Если экран достаточно широкий, используем NavigationRail
    if (screenWidth >= breakpoint) {
      return Scaffold(
        appBar: AppBar(
          title: Text(navigationDestinations[currentIndex].labelKey()),
          actions: const [
            LanguageSwitcher(),
          ],
        ),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                context.go(navigationDestinations[index].route);
              },
              labelType: NavigationRailLabelType.all, // Или .selected, .none
              destinations: navigationDestinations
                  .map(
                    (dest) => NavigationRailDestination(
                      icon: Icon(dest.icon),
                      selectedIcon: Icon(
                          dest.selectedIcon), // Используем выбранную иконку
                      label: Text(dest.labelKey()),
                    ),
                  )
                  .toList(),
            ),
            const VerticalDivider(thickness: 1, width: 1),
            // Основной контент занимает оставшееся место
            Expanded(
              child: child, // Отображаем дочерний экран
            ),
          ],
        ),
      );
    } else {
      // Иначе используем NavigationBar (для мобильных)
      return Scaffold(
        appBar: AppBar(
          title: Text(navigationDestinations[currentIndex].labelKey()),
          actions: const [
            LanguageSwitcher(),
          ],
        ),
        body: child, // Отображаем дочерний экран
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            context.go(navigationDestinations[index].route);
          },
          destinations: navigationDestinations
              .map(
                (dest) => NavigationDestination(
                  icon: Icon(dest.icon),
                  selectedIcon:
                      Icon(dest.selectedIcon), // Используем выбранную иконку
                  label: dest.labelKey(),
                ),
              )
              .toList(),
        ),
      );
    }
  }

  int _calculateSelectedIndex(String location, List<({String route, IconData icon, IconData selectedIcon, String Function() labelKey})> destinations) {
    final index = destinations.indexWhere(
      (dest) => location.startsWith(dest.route),
    );
    return index < 0 ? 0 : index;
  }
}
