import 'package:flutter/material.dart';
import 'package:part_catalog/core/utils/s.dart';
import 'package:part_catalog/core/widgets/language_switcher.dart';
import 'package:part_catalog/features/clients/screens/clients_screen.dart';
import 'package:part_catalog/features/vehicles/screens/cars_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final _screens = [
    const ClientsScreen(),
    const CarsScreen(),
    // Другие экраны
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).appTitle),
        actions: const [
          LanguageSwitcher(),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: S.of(context).clientsScreenTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.directions_car),
            label: S.of(context).carsScreenTitle,
          ),
          // Другие пункты меню
        ],
      ),
    );
  }
}
