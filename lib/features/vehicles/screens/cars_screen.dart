import 'package:flutter/material.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/vehicles/services/car_service.dart';
import 'package:part_catalog/core/database/database.dart'; // Добавьте этот импорт

class CarsScreen extends StatefulWidget {
  const CarsScreen({super.key});

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  final _carService = locator<CarService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Автомобили'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Показать диалог добавления автомобиля
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Car>>(
        future: _carService.getCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет данных'));
          }

          final cars = snapshot.data!;
          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return ListTile(
                title: Text('${car.make} ${car.model}'),
                subtitle:
                    Text('Год: ${car.year}, VIN: ${car.vin ?? "Не указан"}'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Показать диалог редактирования
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
