import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:part_catalog/core/navigation/app_routes.dart';
import 'package:part_catalog/core/widgets/language_switcher.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';

class HomeScreen extends StatelessWidget {
  final Widget child;

  const HomeScreen({
    super.key,
    required this.child,
  });

  static final _navigationDestinations = [
    (
      route: AppRoutes.clients,
      icon: Icons.people_alt_outlined,
      selectedIcon: Icons.people, // Добавляем выбранную иконку
      labelKey: t.clients.screenTitle
    ),
    (
      route: AppRoutes.vehicles,
      icon: Icons.directions_car_outlined,
      selectedIcon: Icons.directions_car, // Добавляем выбранную иконку
      labelKey: t.vehicles.screenTitle
    ),
    (
      route: AppRoutes.orders,
      icon: Icons.list_alt_outlined,
      selectedIcon: Icons.list_alt, // Добавляем выбранную иконку
      labelKey: t.orders.screenTitle
    ),
    (
      // Новый элемент навигации
      route: AppRoutes.apiControlCenter,
      icon: Icons.settings_input_component_outlined,
      selectedIcon: Icons.settings_input_component,
      labelKey: t.settings.apiControlCenter
          .screenTitle // Убедитесь, что эта строка локализации существует
    ),
    // Добавьте другие основные разделы здесь
  ];

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final int currentIndex = _calculateSelectedIndex(location);

    // Определяем ширину экрана
    final screenWidth = MediaQuery.of(context).size.width;
    // Устанавливаем точку перехода (breakpoint), например, 600 пикселей
    const double breakpoint = 600;

    // Если экран достаточно широкий, используем NavigationRail
    if (screenWidth >= breakpoint) {
      return Scaffold(
        appBar: AppBar(
          title: Text(_navigationDestinations[currentIndex].labelKey),
          actions: const [
            LanguageSwitcher(),
          ],
        ),
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: currentIndex,
              onDestinationSelected: (index) {
                context.go(_navigationDestinations[index].route);
              },
              labelType: NavigationRailLabelType.all, // Или .selected, .none
              destinations: _navigationDestinations
                  .map(
                    (dest) => NavigationRailDestination(
                      icon: Icon(dest.icon),
                      selectedIcon: Icon(
                          dest.selectedIcon), // Используем выбранную иконку
                      label: Text(dest.labelKey),
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
          title: Text(_navigationDestinations[currentIndex].labelKey),
          actions: const [
            LanguageSwitcher(),
          ],
        ),
        body: child, // Отображаем дочерний экран
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) {
            context.go(_navigationDestinations[index].route);
          },
          destinations: _navigationDestinations
              .map(
                (dest) => NavigationDestination(
                  icon: Icon(dest.icon),
                  selectedIcon:
                      Icon(dest.selectedIcon), // Используем выбранную иконку
                  label: dest.labelKey,
                ),
              )
              .toList(),
        ),
      );
    }
  }

  int _calculateSelectedIndex(String location) {
    final index = _navigationDestinations.indexWhere(
      (dest) => location.startsWith(dest.route),
    );
    return index < 0 ? 0 : index;
  }
}
