import 'package:flutter/material.dart';
import 'package:part_catalog/core/database/database.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/features/clients/models/client.dart';
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

  /// Показывает диалог для добавления/редактирования автомобиля.
  ///
  /// [car] - существующий автомобиль для редактирования, null для нового автомобиля.
  ///
  /// Возвращает новый или обновленный объект [CarModel] или null, если отменено.
  Future<CarModel?> _showCarDialog(BuildContext context,
      {CarModel? car}) async {
    // Создаём контроллеры для полей ввода с начальными значениями из автомобиля (если есть)
    final makeController = TextEditingController(text: car?.make);
    final modelController = TextEditingController(text: car?.model);
    final yearController = TextEditingController(
      text: car?.year != null && car!.year > 0 ? car.year.toString() : '',
    );
    final vinController = TextEditingController(text: car?.vin);
    final licensePlateController =
        TextEditingController(text: car?.licensePlate);
    final additionalInfoController =
        TextEditingController(text: car?.additionalInfo);

    // Выбранный клиент (владелец автомобиля)
    Client? selectedClient;
    String? selectedClientId = car?.clientId;

    // Список всех клиентов для выбора
    List<Client> clients = [];

    // Состояние валидации формы
    bool isValid =
        car != null; // для новых автомобилей изначально невалидная форма
    bool isLoading = true; // состояние загрузки списка клиентов

    // Создаём ключ для формы (для валидации)
    final formKey = GlobalKey<FormState>();

    return showDialog<CarModel>(
      context: context,
      builder: (BuildContext context) {
        // Используем StatefulBuilder для обновления состояния диалога
        return StatefulBuilder(
          builder: (context, setState) {
            // Загружаем список клиентов, если еще не загружен
            if (isLoading) {
              // Запускаем асинхронную загрузку клиентов
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                // Сохраняем ссылку на ScaffoldMessengerState до выполнения асинхронных операций
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                // Сохраняем ссылку на Navigator до вызова pop()
                final navigator = Navigator.of(context);

                try {
                  final loadedClients = await _clientService.getAllClients();

                  // Проверяем, что виджет все еще в дереве виджетов
                  if (mounted) {
                    setState(() {
                      clients = loadedClients;
                      isLoading = false;

                      // Если редактируем существующую машину, выбираем текущего владельца
                      if (selectedClientId != null) {
                        selectedClient = clients
                            .where((c) => c.id.toString() == selectedClientId)
                            .firstOrNull;
                      }

                      // Если клиент не выбран или не найден, и список не пуст, выбираем первого
                      if ((selectedClient == null) && clients.isNotEmpty) {
                        selectedClient = clients.first;
                        selectedClientId = clients.first.id.toString();
                      }
                    });
                  }
                } catch (error) {
                  // Проверяем, что виджет все еще в дереве виджетов
                  if (mounted) {
                    // Используем сохраненную ссылку вместо получения новой
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                          content: Text('Ошибка загрузки клиентов: $error')),
                    );
                    navigator.pop(); // закрываем диалог при ошибке
                  }
                }
              });
            }

            // Функция валидации формы
            void validateForm() {
              setState(() {
                isValid = formKey.currentState?.validate() ?? false;
                isValid = isValid && selectedClient != null;
              });
            }

            return AlertDialog(
              title: Text(car == null
                  ? 'Добавить автомобиль'
                  : 'Редактировать автомобиль'),
              content: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: formKey,
                      onChanged: validateForm,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Выпадающий список для выбора владельца
                            DropdownButtonFormField<Client>(
                              value: selectedClient,
                              decoration: const InputDecoration(
                                labelText: 'Владелец автомобиля',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              items: clients.map((client) {
                                return DropdownMenuItem<Client>(
                                  value: client,
                                  child: Text(client.name),
                                );
                              }).toList(),
                              onChanged: (Client? value) {
                                setState(() {
                                  selectedClient = value;
                                  selectedClientId = value?.id.toString();
                                  validateForm();
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Необходимо выбрать владельца';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Поле ввода марки автомобиля
                            TextFormField(
                              controller: makeController,
                              decoration: const InputDecoration(
                                labelText: 'Марка автомобиля',
                                prefixIcon: Icon(Icons.directions_car),
                                border: OutlineInputBorder(),
                                hintText: 'Например: Toyota',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Поле обязательно для заполнения';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                            ),

                            const SizedBox(height: 16),

                            // Поле ввода модели автомобиля
                            TextFormField(
                              controller: modelController,
                              decoration: const InputDecoration(
                                labelText: 'Модель автомобиля',
                                prefixIcon: Icon(Icons.directions_car_filled),
                                border: OutlineInputBorder(),
                                hintText: 'Например: Camry',
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Поле обязательно для заполнения';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.next,
                              textCapitalization: TextCapitalization.words,
                            ),

                            const SizedBox(height: 16),

                            // Поля для года выпуска и VIN в одной строке
                            Row(
                              children: [
                                // Год выпуска
                                Expanded(
                                  child: TextFormField(
                                    controller: yearController,
                                    decoration: const InputDecoration(
                                      labelText: 'Год выпуска',
                                      prefixIcon: Icon(Icons.date_range),
                                      border: OutlineInputBorder(),
                                      hintText: 'Например: 2022',
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value != null && value.isNotEmpty) {
                                        final year = int.tryParse(value);
                                        if (year == null) {
                                          return 'Введите число';
                                        }
                                        if (year < 1900 ||
                                            year > DateTime.now().year + 1) {
                                          return 'Некорректный год';
                                        }
                                      }
                                      return null; // год необязателен
                                    },
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),

                                const SizedBox(width: 16),

                                // VIN-код
                                Expanded(
                                  child: TextFormField(
                                    controller: vinController,
                                    decoration: const InputDecoration(
                                      labelText: 'VIN-код',
                                      prefixIcon: Icon(Icons.pin),
                                      border: OutlineInputBorder(),
                                      hintText: '17 символов',
                                    ),
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    onChanged: (value) {
                                      // Преобразуем VIN к верхнему регистру
                                      final upperValue = value.toUpperCase();
                                      if (value != upperValue) {
                                        vinController.text = upperValue;
                                        vinController.selection =
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset: vinController
                                                        .text.length));
                                      }
                                    },
                                    validator: (value) {
                                      if (value != null && value.isNotEmpty) {
                                        if (value.length != 17) {
                                          return 'VIN должен содержать 17 символов';
                                        }
                                      }
                                      return null; // VIN необязателен
                                    },
                                    textInputAction: TextInputAction.next,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Поле для госномера
                            TextFormField(
                              controller: licensePlateController,
                              decoration: const InputDecoration(
                                labelText: 'Государственный номер',
                                prefixIcon: Icon(Icons.app_registration),
                                border: OutlineInputBorder(),
                                hintText: 'Регистрационный номер авто',
                              ),
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (value) {
                                // Преобразуем номер к верхнему регистру
                                final upperValue = value.toUpperCase();
                                if (value != upperValue) {
                                  licensePlateController.text = upperValue;
                                  licensePlateController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: licensePlateController
                                              .text.length));
                                }
                              },
                              textInputAction: TextInputAction.next,
                            ),

                            const SizedBox(height: 16),

                            // Поле ввода дополнительной информации
                            TextFormField(
                              controller: additionalInfoController,
                              decoration: const InputDecoration(
                                labelText: 'Дополнительная информация',
                                prefixIcon: Icon(Icons.info_outline),
                                hintText: 'Комплектация, особенности и т.д.',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Отмена'),
                ),
                if (!isLoading)
                  TextButton(
                    onPressed: isValid
                        ? () {
                            // Создаем объект автомобиля из введенных данных
                            final result = CarModel(
                              id: car?.id ??
                                  '0', // '0' для новых автомобилей (ID присвоит БД)
                              clientId: selectedClient!.id.toString(),
                              make: makeController.text.trim(),
                              model: modelController.text.trim(),
                              year: yearController.text.isNotEmpty
                                  ? int.parse(yearController.text.trim())
                                  : 0,
                              vin: vinController.text.trim(),
                              licensePlate: licensePlateController.text.trim(),
                              additionalInfo:
                                  additionalInfoController.text.trim(),
                            );
                            Navigator.of(context).pop(result);
                          }
                        : null, // Если форма невалидна, кнопка будет неактивна
                    child: Text(car == null ? 'Добавить' : 'Сохранить'),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
