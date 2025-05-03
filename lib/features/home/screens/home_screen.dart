import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // Импортируем go_router
import 'package:part_catalog/core/navigation/app_routes.dart'; // Импортируем маршруты
import 'package:part_catalog/core/widgets/language_switcher.dart';
// Используем slang для локализации
import 'package:part_catalog/core/i18n/strings.g.dart';

/// Оболочка навигации (Shell) для основных разделов приложения.
/// Используется с ShellRoute в go_router.
class HomeScreen extends StatelessWidget {
  /// Дочерний виджет, предоставляемый ShellRoute (текущий экран).
  final Widget child;

  const HomeScreen({
    super.key,
    required this.child,
  });

  // Определяем элементы навигации статически или получаем из конфигурации
  // Теперь они больше связаны с маршрутами, чем с конкретными виджетами
  static final _navigationDestinations = [
    (
      route: AppRoutes.clients,
      icon: Icons.people,
      labelKey: t.clients.screenTitle
    ),
    (
      route: AppRoutes.vehicles,
      icon: Icons.directions_car,
      labelKey: t.vehicles.screenTitle
    ),
    (
      route: AppRoutes.orders,
      icon: Icons.list_alt,
      labelKey: t.orders.screenTitle
    ),
    // Добавьте другие основные разделы здесь
  ];

  @override
  Widget build(BuildContext context) {
    // Получаем текущий маршрут для определения активного индекса
    final String location = GoRouterState.of(context).uri.toString();
    final int currentIndex = _calculateSelectedIndex(location);

    return Scaffold(
      appBar: AppBar(
        // Заголовок теперь может зависеть от текущего раздела или быть общим
        title: Text(_navigationDestinations[currentIndex].labelKey),
        actions: const [
          LanguageSwitcher(),
        ],
      ),
      // Отображаем дочерний экран, предоставленный ShellRoute
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          // Используем go_router для навигации
          context.go(_navigationDestinations[index].route);
        },
        destinations: _navigationDestinations
            .map(
              (dest) => NavigationDestination(
                icon: Icon(dest.icon),
                label: dest.labelKey, // Используем ключ локализации slang
              ),
            )
            .toList(),
      ),
    );
  }

  /// Определяет индекс активного элемента навигации на основе текущего маршрута.
  int _calculateSelectedIndex(String location) {
    // Находим первый элемент, чей маршрут является началом текущего location
    final index = _navigationDestinations.indexWhere(
      (dest) => location.startsWith(dest.route),
    );
    // Если маршрут не найден (например, главная страница или ошибка), возвращаем 0
    return index < 0 ? 0 : index;
  }
}
