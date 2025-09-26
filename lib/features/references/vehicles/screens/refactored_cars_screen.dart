import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/core/ui/index.dart';
import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';
import 'package:part_catalog/features/references/vehicles/providers/car_providers.dart';
import 'package:part_catalog/features/references/vehicles/services/car_service.dart';

/// Рефакторенный экран автомобилей с использованием новых UI компонентов
class RefactoredCarsScreen extends ConsumerStatefulWidget {
  const RefactoredCarsScreen({super.key});

  @override
  ConsumerState<RefactoredCarsScreen> createState() => _RefactoredCarsScreenState();
}

class _RefactoredCarsScreenState extends ConsumerState<RefactoredCarsScreen> {
  CarModelComposite? _selectedCar;
  String _searchQuery = '';
  String? _clientFilter;

  void _selectCar(CarModelComposite? car) {
    setState(() {
      _selectedCar = car;
    });
  }

  List<CarWithOwnerModel> _filterCars(List<CarWithOwnerModel> cars) {
    var filtered = cars;

    // Поиск по тексту
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((carWithOwner) {
        final car = carWithOwner.car;
        final owner = carWithOwner.owner;
        final searchText = _searchQuery.toLowerCase();
        return car.make.toLowerCase().contains(searchText) ||
               car.model.toLowerCase().contains(searchText) ||
               car.vin.toLowerCase().contains(searchText) ||
               car.licensePlate?.toLowerCase().contains(searchText) == true ||
               owner.displayName.toLowerCase().contains(searchText);
      }).toList();
    }

    // Фильтр по клиенту
    if (_clientFilter != null) {
      filtered = filtered.where((carWithOwner) {
        return carWithOwner.car.clientId == _clientFilter;
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final carsAsync = ref.watch(carsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.vehicles.screenTitle),
      ),
      body: Column(
        children: [
          // Поиск
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Поиск по марке, модели, VIN, номеру или владельцу',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Основное содержимое
          Expanded(
            child: carsAsync.when(
        data: (cars) => _buildCarsList(cars),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              const Text('Ошибка загрузки'),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(carsNotifierProvider),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCar,
        icon: const Icon(Icons.add),
        label: Text(t.vehicles.add),
      ),
    );
  }

  Widget _buildCarsList(List<CarWithOwnerModel> cars) {
    final filteredCars = _filterCars(cars);

    if (filteredCars.isEmpty) {
      String message;
      if (_searchQuery.isNotEmpty || _clientFilter != null) {
        message = 'Автомобили не найдены. Попробуйте изменить параметры поиска.';
      } else {
        message = 'Нет автомобилей. Добавьте первый автомобиль.';
      }

      return EmptyStateMessage(
        iconData: Icons.directions_car_outlined,
        title: 'Автомобили не найдены',
        subtitle: message,
        action: FloatingActionButton.extended(
          onPressed: _addCar,
          icon: const Icon(Icons.add),
          label: const Text('Добавить автомобиль'),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: filteredCars.length,
      itemBuilder: (context, index) {
        final carWithOwner = filteredCars[index];
        final car = carWithOwner.car;
        final owner = carWithOwner.owner;

        return CarListItem(
          car: car,
          ownerName: owner.displayName,
          isSelected: _selectedCar?.uuid == car.uuid,
          onTap: () => _selectCar(car),
        );
      },
    );
  }


  // Действия
  void _addCar() {
    // TODO: Реализовать добавление автомобиля
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Добавление автомобиля')),
    );
  }

}