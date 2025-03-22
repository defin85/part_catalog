import 'package:flutter/material.dart';
import 'package:part_catalog/core/utils/s.dart';
import 'package:part_catalog/core/widgets/language_switcher.dart';
import 'package:part_catalog/features/clients/screens/clients_screen.dart';
import 'package:part_catalog/features/home/models/navigation_item.dart';
import 'package:part_catalog/features/vehicles/screens/cars_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Объединяем экраны и данные для навигации в единую структуру
  late final List<NavigationItem> _navigationItems = [
    NavigationItem(
      screen: const ClientsScreen(),
      icon: Icons.people,
      titleGetter: (context) => S.of(context)?.clientsScreenTitle ?? 'Clients',
    ),
    NavigationItem(
      screen: const CarsScreen(),
      icon: Icons.directions_car,
      titleGetter: (context) => S.of(context)?.carsScreenTitle ?? 'Cars',
    ),
    // Добавление других экранов потребует изменений только здесь
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context)?.appTitle ?? 'Part Catalog'),
        actions: const [
          LanguageSwitcher(),
        ],
      ),
      body: _navigationItems[_selectedIndex].screen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: _navigationItems
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.titleGetter(context),
              ),
            )
            .toList(),
      ),
    );
  }
}
