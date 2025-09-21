import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/core/navigation/app_routes.dart';
import 'package:part_catalog/core/widgets/language_switcher.dart';
import 'package:part_catalog/core/widgets/adaptive_app_bar.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';

class HomeScreen extends ConsumerWidget {
  final Widget child;

  const HomeScreen({
    super.key,
    required this.child,
  });

  // Создаем навигационные элементы с учетом текущей локали
  static List<
          ({String route, IconData icon, IconData selectedIcon, String Function() labelKey})>
      _getNavigationDestinations() => [
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
            (
              route: AppRoutes.logs,
              icon: Icons.event_note_outlined,
              selectedIcon: Icons.event_note,
              labelKey: () => 'Журнал',
            ),
            // Добавьте другие основные разделы здесь
          ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Слушаем изменения локали для обновления меню
    ref.watch(localeProvider);

    final String location = GoRouterState.of(context).uri.toString();
    final navigationDestinations = _getNavigationDestinations();
    final int currentIndex =
        _calculateSelectedIndex(location, navigationDestinations);

    return ResponsiveLayoutBuilder(
      small: (context, constraints) => _buildMobileLayout(
        context,
        navigationDestinations,
        currentIndex,
      ),
      medium: (context, constraints) => _buildTabletLayout(
        context,
        navigationDestinations,
        currentIndex,
      ),
      large: (context, constraints) => _buildDesktopLayout(
        context,
        navigationDestinations,
        currentIndex,
      ),
      mediumBreakpoint: 600,
      largeBreakpoint: 1000,
    );
  }

  /// Mobile Layout - NavigationBar внизу
  Widget _buildMobileLayout(
    BuildContext context,
    List<({String route, IconData icon, IconData selectedIcon, String Function() labelKey})> destinations,
    int currentIndex,
  ) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: destinations[currentIndex].labelKey(),
        actions: const [LanguageSwitcher()],
      ),
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          context.go(destinations[index].route);
        },
        destinations: destinations
            .map(
              (dest) => NavigationDestination(
                icon: Icon(dest.icon),
                selectedIcon: Icon(dest.selectedIcon),
                label: dest.labelKey(),
              ),
            )
            .toList(),
      ),
    );
  }

  /// Tablet Layout - Компактный NavigationRail
  Widget _buildTabletLayout(
    BuildContext context,
    List<({String route, IconData icon, IconData selectedIcon, String Function() labelKey})> destinations,
    int currentIndex,
  ) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: destinations[currentIndex].labelKey(),
        actions: const [LanguageSwitcher()],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              context.go(destinations[index].route);
            },
            labelType: NavigationRailLabelType.selected,
            minWidth: 72,
            destinations: destinations
                .map(
                  (dest) => NavigationRailDestination(
                    icon: Icon(dest.icon),
                    selectedIcon: Icon(dest.selectedIcon),
                    label: Text(dest.labelKey()),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }

  /// Desktop Layout - Расширенный NavigationRail
  Widget _buildDesktopLayout(
    BuildContext context,
    List<({String route, IconData icon, IconData selectedIcon, String Function() labelKey})> destinations,
    int currentIndex,
  ) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Header с логотипом/названием приложения
                Container(
                  height: 72,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.build,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Part Catalog',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Навигационные элементы
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      final dest = destinations[index];
                      final isSelected = index == currentIndex;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected
                              ? Theme.of(context).colorScheme.primaryContainer
                              : Colors.transparent,
                        ),
                        child: ListTile(
                          leading: Icon(
                            isSelected ? dest.selectedIcon : dest.icon,
                            color: isSelected
                                ? Theme.of(context).colorScheme.onPrimaryContainer
                                : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          title: Text(
                            dest.labelKey(),
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimaryContainer
                                  : Theme.of(context).colorScheme.onSurface,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          onTap: () => context.go(dest.route),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Footer с настройками
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Настройки',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ),
                      const LanguageSwitcher(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Основной контент
          Expanded(
            child: Column(
              children: [
                AdaptiveAppBar(
                  title: destinations[currentIndex].labelKey(),
                  actions: const [
                    // Дополнительные действия для desktop
                  ],
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _calculateSelectedIndex(
      String location,
      List<
              ({
                String route,
                IconData icon,
                IconData selectedIcon,
                String Function() labelKey
              })>
          destinations) {
    final index = destinations.indexWhere(
      (dest) => location.startsWith(dest.route),
    );
    return index < 0 ? 0 : index;
  }
}
