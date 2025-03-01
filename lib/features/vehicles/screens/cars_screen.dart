import 'package:flutter/material.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/vehicles/models/car.dart';
import 'package:part_catalog/features/vehicles/services/car_service.dart';
import 'package:part_catalog/features/clients/services/client_service.dart';

class CarsScreen extends StatefulWidget {
  const CarsScreen({super.key});

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  final _carService = locator<CarService>();
  final _clientService = locator<ClientService>();
  bool _isDbError = false;

  // Опционально: фильтр по клиенту
  int? _selectedClientId;

  @override
  Widget build(BuildContext context) {
    if (_isDbError) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ошибка базы данных')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Ошибка доступа к базе данных'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Получаем ScaffoldMessengerState до асинхронной операции
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  try {
                    // Сбрасываем базу данных
                    final db = locator<AppDatabase>();
                    await db.resetDatabase();

                    // Обновляем экземпляры в сервис-локаторе
                    locator.unregister<AppDatabase>();
                    locator.registerSingleton<AppDatabase>(AppDatabase());

                    // Обновляем все сервисы, зависящие от БД
                    locator.unregister<ClientService>();
                    locator.unregister<CarService>();
                    locator.registerLazySingleton<ClientService>(
                        () => ClientService(locator<AppDatabase>()));
                    locator.registerLazySingleton<CarService>(
                        () => CarService(locator<AppDatabase>()));

                    setState(() {
                      _isDbError = false;
                    });

                    // Используем сохраненный scaffoldMessenger
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                          content: Text('База данных успешно сброшена')),
                    );
                  } catch (e) {
                    // Показываем сообщение об ошибке
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                          content: Text('Ошибка при сбросе базы данных: $e')),
                    );
                  }
                },
                child: const Text('Сбросить базу данных'),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Автомобили'),
        actions: [
          // Опционально: кнопка для сброса фильтра по клиенту
          if (_selectedClientId != null)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              onPressed: () => setState(() => _selectedClientId = null),
              tooltip: 'Сбросить фильтр',
            ),
        ],
      ),
      // Используем StreamBuilder для реактивного обновления списка автомобилей
      body: StreamBuilder<List<CarModel>>(
        // Выбираем источник данных в зависимости от наличия фильтра
        stream: _selectedClientId != null
            ? _carService.watchClientCars(_selectedClientId!)
            : _carService.watchCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Проверяем, связана ли ошибка с отсутствием таблицы
            if (snapshot.error.toString().contains('no such table')) {
              // Устанавливаем флаг ошибки БД, который перерисует виджет
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _isDbError = true;
                });
              });
            }
            return Center(
              child: Text(
                'Ошибка загрузки данных: ${snapshot.error}',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          final cars = snapshot.data ?? [];

          if (cars.isEmpty) {
            return const Center(
              child: Text(
                  'Список автомобилей пуст. Добавьте автомобиль, нажав на кнопку "+"'),
            );
          }

          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];

              return Dismissible(
                key: Key(car.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Удалить автомобиль?'),
                            content: Text(
                                'Вы действительно хотите удалить автомобиль ${car.make} ${car.model}?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Отмена'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Удалить'),
                              ),
                            ],
                          );
                        },
                      ) ??
                      false;
                },
                onDismissed: (direction) {
                  _carService.deleteCar(int.parse(car.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Автомобиль ${car.make} ${car.model} удален')),
                  );
                },
                child: FutureBuilder(
                  // Получаем информацию о клиенте для отображения
                  future: _clientService.getClientById(int.parse(car.clientId)),
                  builder: (context, clientSnapshot) {
                    final clientName =
                        clientSnapshot.data?.name ?? 'Загрузка...';

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: const Icon(Icons.directions_car,
                            color: Colors.white),
                      ),
                      title: Text('${car.make} ${car.model}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Клиент: $clientName'),
                          if (car.vin.isNotEmpty == true)
                            Text('VIN: ${car.vin}'),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _editCar(car),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addCar,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _addCar() async {
    final newCar = await _showCarDialog(context);
    if (newCar != null) {
      await _carService.addCar(newCar);
    }
  }

  Future<void> _editCar(CarModel car) async {
    final updatedCar = await _showCarDialog(context, car: car);
    if (updatedCar != null) {
      await _carService.updateCar(updatedCar);
    }
  }

  Future<CarModel?> _showCarDialog(BuildContext context,
      {CarModel? car}) async {
    // Реализация диалога добавления/редактирования автомобиля
    // ...
    return null;
  }
}
