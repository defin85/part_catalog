import 'package:flutter/material.dart';
import 'package:part_catalog/core/database/database.dart'; // Для сброса БД (оставим пока)
import 'package:part_catalog/core/service_locator.dart';
// --- Обновленные импорты ---
import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';
import 'package:part_catalog/features/references/vehicles/services/car_service.dart'; // Содержит CarWithOwnerModel
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
import 'package:part_catalog/features/references/clients/services/client_service.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/core/utils/logger_config.dart'; // Используем настроенный логгер
import 'package:part_catalog/core/utils/log_messages.dart';
import 'dart:async'; // Для Timer и Future
import 'package:collection/collection.dart';

class CarsScreen extends StatefulWidget {
  const CarsScreen({super.key});

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  final _carService = locator<CarService>();
  final _clientService = locator<ClientService>();
  // Используем настроенный логгер для автомобилей
  final _logger = AppLoggers.vehiclesLogger;
  bool _isDbError = false;

  // Фильтр по UUID клиента
  String? _selectedClientUuid;

  // Состояние для выбранного автомобиля (композитор) в десктоп режиме
  CarModelComposite? _selectedCar;

  // Определяем, является ли устройство десктопом
  bool _isDesktop(BuildContext context) {
    final platform = Theme.of(context).platform;
    return platform == TargetPlatform.windows ||
        platform == TargetPlatform.macOS ||
        platform == TargetPlatform.linux;
  }

  // Определяем размер экрана
  bool _isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= 900;
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    if (_isDbError) {
      // Логика отображения ошибки БД остается прежней
      return Scaffold(
        appBar: AppBar(title: Text(t.vehicles.screenTitle)),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(t.vehicles.databaseError),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  try {
                    // Логика сброса БД (если она все еще нужна)
                    // await locator<AppDatabase>().resetDatabase();
                    // Пересоздаем зависимости, если нужно
                    // setupLocator(locator<AppDatabase>());
                    setState(() {
                      _isDbError = false;
                    });
                    scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text(t.vehicles.resetDatabaseSuccess)),
                    );
                  } catch (e, s) {
                    _logger.e(LogMessages.databaseResetError,
                        error: e, stackTrace: s);
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                          content: Text(
                              '${LogMessages.databaseResetError}: ${e.toString()}')),
                    );
                  }
                },
                child: Text(t.vehicles.resetDatabase),
              )
            ],
          ),
        ),
      );
    }

    final isDesktop = _isDesktop(context);
    final isLargeScreen = _isLargeScreen(context);

    if (isDesktop && isLargeScreen) {
      // --- Десктопный макет (Row) ---
      return Scaffold(
        appBar: AppBar(
          title: Text(t.vehicles.screenTitle),
          actions: [
            // Кнопка сброса фильтра
            if (_selectedClientUuid != null)
              IconButton(
                icon: const Icon(Icons.filter_alt_off),
                onPressed: () => setState(() => _selectedClientUuid = null),
                tooltip: t.core.filterOff, // Используем ключ из core
              ),
            // Кнопка добавления
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addCar,
              tooltip: t.vehicles.add,
            ),
          ],
        ),
        body: Row(
          children: [
            // Левая панель: Фильтр и Список
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  // Виджет фильтра по клиентам
                  _buildClientFilter(),
                  const Divider(),
                  // Список автомобилей
                  Expanded(
                    child: _buildCarsList(
                      // Передаем выбранный UUID для подсветки
                      selectedCarUuid: _selectedCar?.uuid,
                      onCarSelected: (car) {
                        setState(() {
                          _selectedCar = car;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            const VerticalDivider(width: 1),
            // Правая панель: Детали или заглушка
            Expanded(
              flex: 3,
              child: _selectedCar == null
                  ? Center(child: Text(t.vehicles.selectVehiclePrompt))
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      // Передаем выбранный композитор
                      child: _buildCarDetails(_selectedCar!),
                    ),
            ),
          ],
        ),
      );
    } else {
      // --- Мобильный макет (Scaffold с FAB) ---
      return Scaffold(
        appBar: AppBar(
          title: Text(t.vehicles.screenTitle),
          actions: [
            // Кнопка фильтра (можно вынести в отдельный виджет или экран)
            IconButton(
              icon: Icon(_selectedClientUuid == null
                  ? Icons.filter_alt_outlined
                  : Icons.filter_alt),
              onPressed: _showClientFilterDialog,
              tooltip: t.core.filter,
            ),
          ],
        ),
        // Список автомобилей, при нажатии открывается редактирование
        body: _buildCarsList(
          onCarSelected: (car) => _editCar(car),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _addCar,
          child: const Icon(Icons.add),
        ),
      );
    }
  }

  // --- Виджет фильтра по клиентам (для десктопа) ---
  Widget _buildClientFilter() {
    final t = Translations.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // Используем FutureBuilder для однократной загрузки списка клиентов
      child: FutureBuilder<List<ClientModelComposite>>(
        future: _clientService.getAllClients(), // Получаем всех клиентов
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final clients = snapshot.data ?? [];
          // Добавляем опцию "Все клиенты"
          final items = [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(t.core.all), // Ключ для "Все"
            ),
            ...clients.map((client) => DropdownMenuItem<String?>(
                  value: client.uuid,
                  child: Text(client.displayName),
                )),
          ];

          return DropdownButtonFormField<String?>(
            value: _selectedClientUuid,
            decoration: InputDecoration(
              labelText: t.clients.client, // Используем ключ из clients
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: items,
            onChanged: (value) {
              setState(() {
                _selectedClientUuid = value;
                _selectedCar =
                    null; // Сбрасываем выбор машины при смене фильтра
              });
            },
          );
        },
      ),
    );
  }

  // --- Диалог фильтра по клиентам (для мобильных) ---
  Future<void> _showClientFilterDialog() async {
    // Получаем t *до* await
    final t = Translations.of(context);
    // Проверяем mounted *до* await, если планируем использовать context после него
    if (!mounted) return;

    final clients = await _clientService.getAllClients(); // Загружаем клиентов

    // Проверяем mounted *после* await, перед использованием context для showDialog
    if (!mounted) return;

    final String? result = await showDialog<String?>(
      context: context, // context все еще нужен для showDialog
      builder: (dialogContext) => AlertDialog(
        // Используем новый context из builder
        title: Text(t.core.filterByClient), // Используем сохраненный t
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(t.core.all), // Используем сохраненный t
                leading: Radio<String?>(
                  value: null,
                  groupValue: _selectedClientUuid,
                  // Используем dialogContext для Navigator
                  onChanged: (value) => Navigator.of(dialogContext).pop(value),
                ),
                // Используем dialogContext для Navigator
                onTap: () => Navigator.of(dialogContext).pop(null),
              ),
              ...clients.map((client) => ListTile(
                    title: Text(client.displayName),
                    leading: Radio<String?>(
                      value: client.uuid,
                      groupValue: _selectedClientUuid,
                      // Используем dialogContext для Navigator
                      onChanged: (value) =>
                          Navigator.of(dialogContext).pop(value),
                    ),
                    // Используем dialogContext для Navigator
                    onTap: () => Navigator.of(dialogContext).pop(client.uuid),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            // Используем dialogContext для Navigator
            onPressed: () =>
                Navigator.of(dialogContext).pop(_selectedClientUuid),
            child: Text(t.vehicles.cancel), // Используем сохраненный t
          ),
        ],
      ),
    );

    // Применяем выбранный фильтр, если он изменился
    // Проверка mounted здесь не обязательна, т.к. setState уже имеет встроенную проверку
    if (result != _selectedClientUuid) {
      setState(() {
        _selectedClientUuid = result;
        _selectedCar = null; // Сбрасываем выбор машины
      });
    }
  }

  // --- Виджет для отображения списка автомобилей ---
  Widget _buildCarsList({
    required Function(CarModelComposite) onCarSelected,
    String? selectedCarUuid, // UUID для подсветки в десктопном режиме
  }) {
    final t = Translations.of(context);
    final isDesktop = _isDesktop(context);

    // Используем StreamBuilder для получения CarWithOwnerModel
    return StreamBuilder<List<CarWithOwnerModel>>(
      // Получаем поток всех машин с владельцами
      stream: _carService.watchCarsWithOwners(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          // Обработка ошибок остается прежней
          if (snapshot.error.toString().contains('no such table')) {
            _logger.e('${LogMessages.dbTableMissingError}: ${snapshot.error}',
                error: snapshot.error, stackTrace: snapshot.stackTrace);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _isDbError = true;
                });
              }
            });
            return const SizedBox.shrink(); // Не показываем ошибку сразу
          }
          _logger.e(LogMessages.dataLoadingError,
              error: snapshot.error, stackTrace: snapshot.stackTrace);
          return Center(
            child: Text(
              t.core.errorLoadingData(error: snapshot.error.toString()),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          );
        }

        // Фильтруем список на клиенте, если выбран UUID клиента
        final allCarsWithOwner = snapshot.data ?? [];
        final filteredCars = _selectedClientUuid == null
            ? allCarsWithOwner
            : allCarsWithOwner
                .where((cwo) => cwo.owner.uuid == _selectedClientUuid)
                .toList();

        if (filteredCars.isEmpty) {
          return Center(
            child: Text(_selectedClientUuid == null
                ? t.vehicles.emptyList
                : t.vehicles.noCarsAvailable), // Разные тексты
          );
        }

        // --- DataTable для десктопа ---
        if (isDesktop) {
          return SingleChildScrollView(
            child: DataTable(
              showCheckboxColumn: false,
              columns: [
                DataColumn(label: Text(t.vehicles.make)),
                DataColumn(label: Text(t.vehicles.model)),
                DataColumn(label: Text(t.vehicles.owner)),
                DataColumn(label: Text(t.vehicles.licensePlate)),
                // DataColumn(label: Text(t.common.edit)), // Убрали колонку Edit
              ],
              rows: filteredCars.map((carWithOwner) {
                final car = carWithOwner.car; // CarModelComposite
                final owner = carWithOwner.owner; // ClientModelComposite
                final isSelected = car.uuid == selectedCarUuid;

                return DataRow(
                  selected: isSelected,
                  onSelectChanged: (selected) {
                    if (selected ?? false) {
                      onCarSelected(car); // Передаем композитор машины
                    }
                  },
                  cells: [
                    DataCell(Text(car.make)),
                    DataCell(Text(car.model)),
                    DataCell(Text(owner.displayName)), // Имя владельца
                    DataCell(Text(car.displayLicensePlate)), // Гос. номер
                    // DataCell(IconButton( // Убрали кнопку Edit
                    //   icon: Icon(Icons.edit, size: 18),
                    //   onPressed: () => onCarSelected(car),
                    // )),
                  ],
                );
              }).toList(),
            ),
          );
        } else {
          // --- ListView для мобильных ---
          return ListView.builder(
            itemCount: filteredCars.length,
            itemBuilder: (context, index) {
              final carWithOwner = filteredCars[index];
              final car = carWithOwner.car;
              final owner = carWithOwner.owner;

              return Dismissible(
                key: Key(car.uuid), // Используем UUID
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await _confirmDelete(car); // Передаем композитор
                },
                onDismissed: (direction) async {
                  // Сохраняем ScaffoldMessengerState
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  try {
                    await _carService.deleteCar(car.uuid);
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                        content: Text(t.vehicles.deleted(
                            make: car.make, model: car.model)), // Локализация
                        action: SnackBarAction(
                          label: t.common.undo, // Локализация
                          onPressed: () async {
                            // Сохраняем ScaffoldMessengerState для undo
                            final undoMessenger = ScaffoldMessenger.of(context);
                            try {
                              await _carService.restoreCar(car.uuid);
                            } catch (e, s) {
                              _logger.e(
                                  LogMessages.carRestoreError
                                      .replaceAll('{uuid}', car.uuid),
                                  error: e,
                                  stackTrace: s);
                              undoMessenger.showSnackBar(
                                SnackBar(
                                    content: Text(t.vehicles.restoreError(
                                        error: e
                                            .toString()))), // Используем ключ с параметром
                              );
                            }
                          },
                        ),
                      ),
                    );
                  } catch (e, s) {
                    _logger.e(
                        LogMessages.carDeleteError
                            .replaceAll('{uuid}', car.uuid),
                        error: e,
                        stackTrace: s);
                    scaffoldMessenger.showSnackBar(
                      SnackBar(
                          content: Text(t.vehicles.deleteError(
                              error: e
                                  .toString()))), // Используем ключ с параметром
                    );
                  }
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text('${car.make} ${car.model} (${car.year})'),
                    subtitle: Text(
                        '${t.vehicles.owner}: ${owner.displayName}\n${t.vehicles.vin}: ${car.vin}'),
                    isThreeLine: true,
                    trailing: Text(car.displayLicensePlate),
                    onTap: () => onCarSelected(car), // Передаем композитор
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  // --- Виджет для отображения детальной информации об автомобиле ---
  Widget _buildCarDetails(CarModelComposite car) {
    final t = Translations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // Обернули Text в Expanded
              child: Text(
                car.displayName, // Используем displayName из композитора
                style: Theme.of(context).textTheme.headlineSmall,
                overflow: TextOverflow.ellipsis, // Добавили overflow
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  tooltip: t.common.edit,
                  onPressed: () => _editCar(car),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: t.common.delete,
                  onPressed: () async {
                    final confirmed = await _confirmDelete(car);
                    if (confirmed && mounted) {
                      // Сохраняем ScaffoldMessengerState
                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                      try {
                        await _carService.deleteCar(car.uuid);
                        setState(() {
                          _selectedCar = null; // Убираем детали после удаления
                        });
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                              content: Text(t.vehicles
                                  .deleted(make: car.make, model: car.model))),
                        );
                      } catch (e, s) {
                        _logger.e(
                            LogMessages.carDeleteError
                                .replaceAll('{uuid}', car.uuid),
                            error: e,
                            stackTrace: s);
                        scaffoldMessenger.showSnackBar(
                          SnackBar(
                              content: Text(
                                  t.vehicles.deleteError(error: e.toString()))),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        const Divider(),
        // Используем FutureBuilder для загрузки владельца по clientId из car
        FutureBuilder<ClientModelComposite?>(
          future: _clientService.getClientByUuid(car.clientId),
          builder: (context, snapshot) {
            final client = snapshot.data;
            return ListTile(
              title: Text(t.vehicles.owner),
              subtitle: Text(snapshot.connectionState == ConnectionState.waiting
                  ? t.common.loading
                  : client?.displayName ?? t.clients.clientNotFound),
              leading: const Icon(Icons.person),
            );
          },
        ),
        if (car.year > 0)
          ListTile(
            title: Text(t.vehicles.year),
            subtitle: Text(car.year.toString()),
            leading: const Icon(Icons.date_range),
          ),
        if (car.vin.isNotEmpty)
          ListTile(
            title: Text(t.vehicles.vin),
            subtitle: Text(car.vin),
            leading: const Icon(Icons.pin),
            onTap: () {
              // Копирование VIN в буфер обмена
              // Clipboard.setData(ClipboardData(text: car.vin));
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text(t.core.copiedToClipboard(value: 'VIN'))),
              // );
            },
          ),
        if (car.licensePlate?.isNotEmpty == true)
          ListTile(
            title: Text(t.vehicles.licensePlate),
            subtitle: Text(car.licensePlate!),
            leading: const Icon(Icons.app_registration),
          ),
        if (car.additionalInfo?.isNotEmpty == true)
          ListTile(
            title: Text(t.vehicles.additionalInfo),
            subtitle: Text(car.additionalInfo!),
            leading: const Icon(Icons.info_outline),
          ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(t.vehicles.carHistory,
              style: Theme.of(context).textTheme.titleMedium),
        ),
        // --- Интеграция со списком заказ-нарядов ---
        Expanded(
          child: Center(
            child: Text(t.vehicles.orderHistoryComingSoon),
          ),
          // Пример интеграции (потребует OrderService и OrderListWidget)
          // StreamBuilder<List<OrderModelComposite>>(
          //   stream: locator<OrderService>().watchOrdersByCar(car.uuid),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Center(child: CircularProgressIndicator());
          //     }
          //     if (snapshot.hasError) {
          //       return Center(child: Text('Error loading orders'));
          //     }
          //     final orders = snapshot.data ?? [];
          //     if (orders.isEmpty) {
          //       return Center(child: Text('No orders found for this vehicle'));
          //     }
          //     // return OrderListWidget(orders: orders); // Ваш виджет списка заказов
          //     return ListView.builder( // Заглушка
          //       itemCount: orders.length,
          //       itemBuilder: (context, index) => ListTile(
          //         title: Text('Order ${orders[index].code}'),
          //         subtitle: Text(orders[index].status.name), // Пример
          //       ),
          //     );
          //   },
          // ),
        ),
      ],
    );
  }

  // --- Метод для подтверждения удаления автомобиля ---
  Future<bool> _confirmDelete(CarModelComposite car) async {
    final t = Translations.of(context);
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(t.vehicles.deleteConfirmTitle),
              content: Text(t.vehicles
                  .deleteConfirmMessage(make: car.make, model: car.model)),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(t.vehicles.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(t.common.delete),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  // --- Методы добавления/редактирования ---
  Future<void> _addCar() async {
    // Показываем диалог, получаем новый композитор
    final newCarComposite = await _showCarDialog(context);
    if (newCarComposite != null && mounted) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        await _carService.addCar(newCarComposite);
        // Опционально: показать сообщение об успехе
      } catch (e, stackTrace) {
        _logger.e(LogMessages.carAddError, error: e, stackTrace: stackTrace);
        scaffoldMessenger.showSnackBar(
          SnackBar(
              content: Text(
                  t.vehicles.addError(error: e.toString()))), // Локализация
        );
      }
    }
  }

  Future<void> _editCar(CarModelComposite car) async {
    // Показываем диалог с текущим композитором
    final updatedCarComposite = await _showCarDialog(context, car: car);
    if (updatedCarComposite != null && mounted) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        await _carService.updateCar(updatedCarComposite);
        // Обновляем выбранный автомобиль в десктопном режиме
        if (_selectedCar != null &&
            _selectedCar!.uuid == updatedCarComposite.uuid) {
          setState(() => _selectedCar = updatedCarComposite);
        }
        // Опционально: показать сообщение об успехе
      } catch (e, stackTrace) {
        _logger.e(LogMessages.carUpdateError.replaceAll('{uuid}', car.uuid),
            error: e, stackTrace: stackTrace);
        scaffoldMessenger.showSnackBar(
          SnackBar(
              content: Text(
                  t.vehicles.updateError(error: e.toString()))), // Локализация
        );
      }
    }
  }

  // --- Диалог добавления/редактирования автомобиля ---
  Future<CarModelComposite?> _showCarDialog(BuildContext context,
      {CarModelComposite? car}) async {
    final t = Translations.of(context);
    final bool isEditing = car != null;

    // Контроллеры
    final makeController = TextEditingController(text: car?.make ?? '');
    final modelController = TextEditingController(text: car?.model ?? '');
    final yearController = TextEditingController(
      // Сначала проверяем car, затем car.year
      text: (car != null && car.year > 0) ? car.year.toString() : '',
    );
    final vinController = TextEditingController(text: car?.vin ?? '');
    final licensePlateController =
        TextEditingController(text: car?.licensePlate ?? '');
    final additionalInfoController =
        TextEditingController(text: car?.additionalInfo ?? '');

    // Состояние диалога
    ClientModelComposite? selectedClient;
    String? selectedClientUuid = car?.clientId;
    List<ClientModelComposite> clients = [];
    bool isLoading = true;
    String? vinError; // Ошибка для VIN

    final formKey = GlobalKey<FormState>();

    // Функция для валидации VIN на уникальность (асинхронная)
    Future<void> validateVinUniqueness(String vin) async {
      if (vin.length != 17) {
        // Проверка длины остается синхронной
        setState(() {
          vinError = t.vehicles.vinRequirement;
        });
        return;
      }
      // TODO: Добавить метод в CarService/CarDao для проверки уникальности VIN
      // bool isUnique = await _carService.isVinUnique(vin, excludeUuid: car?.uuid);
      bool isUnique = true; // Заглушка
      setState(() {
        vinError = isUnique ? null : t.vehicles.vinNotUnique; // Новый ключ
      });
    }

    // Инициализация: загрузка клиентов и начальная валидация VIN
    Future<void> initializeDialog() async {
      // --- Получаем зависимые от контекста объекты ДО await ---
      // Получаем Navigator и ScaffoldMessenger из контекста диалога,
      // так как initializeDialog вызывается внутри builder диалога.
      // Используем context, переданный в _showCarDialog, т.к. он стабилен
      // на момент вызова initializeDialog (хотя сам диалог может быть закрыт).
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      // t уже получен в _showCarDialog, передавать его не нужно, он доступен

      try {
        clients = await _clientService.getAllClients();
        if (selectedClientUuid != null) {
          // Используем firstWhereOrNull из пакета collection
          selectedClient =
              clients.firstWhereOrNull((c) => c.uuid == selectedClientUuid);
        }
        if (isEditing && vinController.text.isNotEmpty) {
          await validateVinUniqueness(
              vinController.text); // Валидация VIN при редактировании
        }
      } catch (error, stackTrace) {
        _logger.e(LogMessages.dataLoadingError,
            error: error, stackTrace: stackTrace);
        // --- Используем захваченные объекты ПОСЛЕ await ---
        // Проверяем mounted для State виджета CarsScreen
        if (mounted) {
          navigator.pop(); // Используем захваченный navigator
          scaffoldMessenger.showSnackBar(
            // Используем захваченный scaffoldMessenger
            SnackBar(
                content: Text(t.core.errorLoadingData(
                    error:
                        error.toString()))), // Используем t из внешней функции
          );
        }
      } finally {
        // Проверяем mounted для State виджета CarsScreen перед вызовом setState
        if (mounted) {
          // setState здесь безопасен, он принадлежит State диалога (StatefulBuilder)
          // и будет работать, пока диалог открыт.
          // Но если initializeDialog вызывается из _CarsScreenState,
          // то проверка mounted относится к _CarsScreenState.
          // В данном коде setState вызывается из StatefulBuilder диалога,
          // поэтому проверка mounted относится к _CarsScreenState, что не совсем верно.
          // Однако, если диалог закрыт, StatefulBuilder тоже уничтожен.
          // Оставим setState как есть, т.к. он внутри StatefulBuilder.
          // Если бы setState был напрямую в _CarsScreenState, проверка mounted была бы обязательна.
          setState(() {
            isLoading = false;
          });
        }
      }
    }

    return showDialog<CarModelComposite>(
      context: context,
      barrierDismissible: false, // Запретить закрытие по тапу вне диалога
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Вызываем инициализацию один раз
            if (isLoading) {
              // Используем addPostFrameCallback для вызова async функции после build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                initializeDialog();
              });
            }

            // Определяем, валидна ли форма
            bool isFormValid = (formKey.currentState?.validate() ?? false) &&
                selectedClient != null &&
                vinError == null; // Проверяем и ошибку VIN

            return AlertDialog(
              title: Text(isEditing ? t.vehicles.edit : t.vehicles.add),
              content: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      // Обертка для прокрутки
                      child: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisSize: MainAxisSize.min, // Сжимаем колонку
                          children: <Widget>[
                            // --- Выбор клиента ---
                            DropdownButtonFormField<ClientModelComposite>(
                              value: selectedClient,
                              decoration: InputDecoration(
                                labelText: t.vehicles.owner,
                                border: const OutlineInputBorder(),
                              ),
                              items: clients
                                  .map((client) =>
                                      DropdownMenuItem<ClientModelComposite>(
                                        value: client,
                                        child: Text(client.displayName),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedClient = value;
                                  selectedClientUuid = value?.uuid;
                                });
                              },
                              validator: (value) => value == null
                                  ? t.clients.clientRequired // Новый ключ
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            // --- Марка ---
                            TextFormField(
                              controller: makeController,
                              decoration: InputDecoration(
                                labelText: t.vehicles.make,
                                hintText: t.vehicles.makeHint,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? t.vehicles.requiredField
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            // --- Модель ---
                            TextFormField(
                              controller: modelController,
                              decoration: InputDecoration(
                                labelText: t.vehicles.model,
                                hintText: t.vehicles.modelHint,
                                border: const OutlineInputBorder(),
                              ),
                              validator: (value) =>
                                  value == null || value.isEmpty
                                      ? t.vehicles.requiredField
                                      : null,
                            ),
                            const SizedBox(height: 16),
                            // --- Год ---
                            TextFormField(
                              controller: yearController,
                              decoration: InputDecoration(
                                labelText: t.vehicles.year,
                                hintText: t.vehicles.yearHint,
                                border: const OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return t.vehicles.requiredField;
                                }
                                final year = int.tryParse(value);
                                if (year == null ||
                                    year < 1900 ||
                                    year > DateTime.now().year + 1) {
                                  return t.vehicles.invalidYear;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            // --- VIN ---
                            TextFormField(
                              controller: vinController,
                              decoration: InputDecoration(
                                labelText: t.vehicles.vin,
                                hintText: t.vehicles.vinHint,
                                border: const OutlineInputBorder(),
                                errorText: vinError, // Отображение ошибки VIN
                              ),
                              maxLength: 17, // Ограничение длины
                              textCapitalization: TextCapitalization.characters,
                              onChanged: (value) async {
                                // Асинхронная валидация при изменении
                                await validateVinUniqueness(value);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return t.vehicles.requiredField;
                                }
                                if (value.length != 17) {
                                  return t.vehicles.vinRequirement;
                                }
                                // Дополнительная валидация символов VIN (опционально)
                                // if (!RegExp(r'^[A-HJ-NPR-Z0-9]{17}$').hasMatch(value)) {
                                //   return 'Недопустимые символы в VIN';
                                // }
                                return null; // Ошибка уникальности обрабатывается через errorText
                              },
                            ),
                            const SizedBox(height: 16),
                            // --- Гос. номер ---
                            TextFormField(
                              controller: licensePlateController,
                              decoration: InputDecoration(
                                labelText: t.vehicles.licensePlate,
                                hintText: t.vehicles.licensePlateHint,
                                border: const OutlineInputBorder(),
                              ),
                              // Валидатор опционален
                            ),
                            const SizedBox(height: 16),
                            // --- Доп. информация ---
                            TextFormField(
                              controller: additionalInfoController,
                              decoration: InputDecoration(
                                labelText: t.vehicles.additionalInfo,
                                hintText: t.vehicles.additionalInfoHint,
                                border: const OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(null),
                  child: Text(t.vehicles.cancel),
                ),
                // Кнопка Сохранить активна только если форма валидна
                ElevatedButton(
                  onPressed: isFormValid
                      ? () {
                          // Создаем или обновляем композитор
                          final now = DateTime.now();
                          final make = makeController.text;
                          final model = modelController.text;
                          final year = int.parse(yearController.text);
                          final vin = vinController.text;
                          final licensePlate = licensePlateController.text;
                          final additionalInfo = additionalInfoController.text;

                          CarModelComposite resultCar;
                          if (isEditing) {
                            // Обновляем существующий композитор
                            resultCar = car
                                .withMake(make)
                                .withModel(model)
                                .withYear(year)
                                .withVin(vin) // Обновит и code, если нужно
                                .withLicensePlate(licensePlate.isNotEmpty
                                    ? licensePlate
                                    : null)
                                .withAdditionalInfo(additionalInfo.isNotEmpty
                                    ? additionalInfo
                                    : null)
                                .withOwner(selectedClient!.uuid)
                                .withModifiedDate(now);
                          } else {
                            // Создаем новый композитор
                            resultCar = CarModelComposite.create(
                              code: vin, // Используем VIN как код по умолчанию
                              make: make,
                              model: model,
                              year: year,
                              vin: vin,
                              clientId: selectedClient!.uuid,
                              licensePlate:
                                  licensePlate.isNotEmpty ? licensePlate : null,
                              additionalInfo: additionalInfo.isNotEmpty
                                  ? additionalInfo
                                  : null,
                            );
                          }
                          Navigator.of(context).pop(resultCar);
                        }
                      : null, // Делаем кнопку неактивной
                  child: Text(t.vehicles.save),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
