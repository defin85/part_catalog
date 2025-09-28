import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:part_catalog/core/widgets/adaptive_app_bar.dart';
import 'package:part_catalog/core/widgets/language_switcher.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';

/// Модель назначения навигации
class AppNavigationDestination {
  final String route;
  final IconData icon;
  final IconData selectedIcon;
  final String Function() label;

  const AppNavigationDestination({
    required this.route,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// Адаптивный scaffold с навигацией
/// Автоматически переключается между NavigationBar (мобильный) и NavigationRail (планшет/десктоп)
class AdaptiveNavigationScaffold extends ConsumerWidget {
  final int currentIndex;
  final List<AppNavigationDestination> destinations;
  final ValueChanged<int> onDestinationSelected;
  final Widget body;

  const AdaptiveNavigationScaffold({
    super.key,
    required this.currentIndex,
    required this.destinations,
    required this.onDestinationSelected,
    required this.body,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return ResponsiveLayoutBuilder(
      small: (context, constraints) => _buildMobileLayout(context),
      medium: (context, constraints) => _buildTabletLayout(context),
      large: (context, constraints) => _buildDesktopLayout(context),
      mediumBreakpoint: 600,
      largeBreakpoint: 1000,
    );
  }

  /// Mobile Layout - NavigationBar внизу
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: destinations[currentIndex].label(),
        actions: const [LanguageSwitcher()],
      ),
      body: body,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations
            .map(
              (dest) => NavigationDestination(
                icon: Icon(dest.icon),
                selectedIcon: Icon(dest.selectedIcon),
                label: dest.label(),
              ),
            )
            .toList(),
      ),
    );
  }

  /// Tablet Layout - Компактный NavigationRail
  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: destinations[currentIndex].label(),
        actions: const [LanguageSwitcher()],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.selected,
            minWidth: 72,
            destinations: destinations
                .map(
                  (dest) => NavigationRailDestination(
                    icon: Icon(dest.icon),
                    selectedIcon: Icon(dest.selectedIcon),
                    label: Text(dest.label()),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }

  /// Desktop Layout - Расширенный NavigationRail
  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        title: destinations[currentIndex].label(),
        actions: const [LanguageSwitcher()],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: currentIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            minWidth: 200,
            destinations: destinations
                .map(
                  (dest) => NavigationRailDestination(
                    icon: Icon(dest.icon),
                    selectedIcon: Icon(dest.selectedIcon),
                    label: Text(dest.label()),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}