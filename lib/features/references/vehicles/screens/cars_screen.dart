import 'dart:async'; // Для Timer и Future

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:part_catalog/core/database/database.dart'; // Для сброса БД (оставим пока)
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/core/providers/core_providers.dart';
import 'package:part_catalog/core/service_locator.dart';
import 'package:part_catalog/core/utils/log_messages.dart';
import 'package:part_catalog/features/core/entity_core_data.dart';
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
import 'package:part_catalog/features/references/clients/providers/client_providers.dart';
// --- Обновленные импорты ---
import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';
import 'package:part_catalog/features/references/vehicles/models/car_specific_data.dart';
// --- Импорт провайдеров ---
import 'package:part_catalog/features/references/vehicles/providers/car_providers.dart';
import 'package:part_catalog/features/references/vehicles/services/car_service.dart'; // Содержит CarWithOwnerModel
import 'package:uuid/uuid.dart'; // Для clientServiceProvider и appLoggerProvider

// Преобразуем в ConsumerStatefulWidget
class CarsScreen extends ConsumerStatefulWidget {
  const CarsScreen({super.key});

  @override
  ConsumerState<CarsScreen> createState() => _CarsScreenState();
}

// Преобразуем State в ConsumerState
class _CarsScreenState extends ConsumerState<CarsScreen> {
  // Удаляем прямые зависимости, будем использовать ref
  // final _carService = locator<CarService>();
  // final _clientService = locator<ClientService>();
  late final Logger _logger; // Инициализируем в initState
  // bool _isDbError = false; // Управляется через AsyncValue

  // Фильтр по UUID клиента (теперь управляется через Notifier)
  // String? _selectedClientUuid;

  // Состояние для выбранного автомобиля (композитор) в десктоп режиме
  CarModelComposite? _selectedCar;

  @override
  void initState() {
    super.initState();
    _logger = ref.read(vehiclesLoggerProvider); // Инициализация логгера
  }

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
    // Получаем текущий фильтр из Notifier'а (если нужно отображать его где-то)
    // final currentFilterUuid = ref.watch(carsNotifierProvider.select((state) => state.value?.clientFilterUuid)); // Пример, если бы фильтр был в состоянии

    // Получаем состояние списка автомобилей
    final carsAsyncValue = ref.watch(carsNotifierProvider);

    // Обработка ошибки БД перенесена в .when()

    final isDesktop = _isDesktop(context);
    final isLargeScreen = _isLargeScreen(context);

    // Получаем текущий UUID фильтра для UI
    // Мы не можем напрямую получить _clientFilterUuid из Notifier'а,
    // поэтому будем хранить его локально в State для UI целей (Dropdown, иконка фильтра)
    // или передавать его как параметр в build/провайдеры, если это возможно.
    // Проще всего - читать его из Notifier'а при необходимости действий.
    // Для отображения текущего значения в Dropdown/иконке - храним локально.
    // Но лучше, если Notifier будет предоставлять это значение.
    // Пока оставим локальное управление для UI фильтра.

    // Получаем текущий UUID фильтра для UI через публичный геттер Notifier'а
    String? currentClientFilterUuid =
        ref.watch(carsNotifierProvider.notifier).currentClientFilterUuid;

    if (isDesktop && isLargeScreen) {
      // --- Десктопный макет (Row) ---
      return Scaffold(
        appBar: AppBar(
          title: Text(t.vehicles.screenTitle),
          actions: [
            // Кнопка сброса фильтра
            if (currentClientFilterUuid != null)
              IconButton(
                icon: const Icon(Icons.filter_alt_off),
                onPressed: () {
                  ref.read(carsNotifierProvider.notifier).setClientFilter(null);
                  setState(() => _selectedCar = null); // Сброс деталей
                },
                tooltip: t.core.filterOff,
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
                  _buildClientFilter(
                      currentClientFilterUuid), // Передаем текущий фильтр
                  const Divider(),
                  // Список автомобилей
                  Expanded(
                    child: _buildCarsList(
                      carsAsyncValue: carsAsyncValue, // Передаем AsyncValue
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
            // Кнопка фильтра
            IconButton(
              icon: Icon(currentClientFilterUuid == null
                  ? Icons.filter_alt_outlined
                  : Icons.filter_alt),
              onPressed: () => _showClientFilterDialog(
                  currentClientFilterUuid), // Передаем текущий фильтр
              tooltip: t.core.filter,
            ),
          ],
        ),
        // Список автомобилей
        body: _buildCarsList(
          carsAsyncValue: carsAsyncValue, // Передаем AsyncValue
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
  Widget _buildClientFilter(String? currentFilterUuid) {
    final t = Translations.of(context);
    // Используем ref.watch для получения списка клиентов
    final clientsAsyncValue = ref.watch(clientsForFilterProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: clientsAsyncValue.when(
        data: (clients) {
          final items = [
            DropdownMenuItem<String?>(
              value: null,
              child: Text(t.core.all),
            ),
            ...clients.map((client) => DropdownMenuItem<String?>(
                  value: client.uuid,
                  child: Text(client.displayName),
                )),
          ];

          return DropdownButtonFormField<String?>(
            value: currentFilterUuid, // Используем переданное значение
            decoration: InputDecoration(
              labelText: t.clients.client,
              border: const OutlineInputBorder(),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: items,
            onChanged: (value) {
              // Вызываем метод Notifier'а для установки фильтра
              ref.read(carsNotifierProvider.notifier).setClientFilter(value);
              setState(() {
                _selectedCar =
                    null; // Сбрасываем выбор машины при смене фильтра
              });
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) {
          _logger.e("Error loading clients for filter",
              error: error, stackTrace: stack);
          // Можно показать сообщение об ошибке или пустой Dropdown
          return DropdownButtonFormField<String?>(
            decoration: InputDecoration(
              labelText: t.clients.client,
              border: const OutlineInputBorder(),
              errorText: t.core.errorLoadingData(error: ''),
            ),
            items: const [],
            onChanged: null,
          );
        },
      ),
    );
  }

  // --- Диалог фильтра по клиентам (для мобильных) ---
  Future<void> _showClientFilterDialog(String? currentFilterUuid) async {
    final t = Translations.of(context);
    // Получаем список клиентов через ref.read (однократно)
    final clientsAsyncValue = await ref.read(clientsForFilterProvider.future);
    // Обработка ошибки загрузки клиентов (если нужна)
    // if (clientsAsyncValue is AsyncError) { ... }

    final clients = clientsAsyncValue; // Предполагаем успешную загрузку

    if (!mounted) return;

    final String? result = await showDialog<String?>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(t.core.filterByClient),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(t.core.all),
                leading: Radio<String?>(
                  value: null,
                  groupValue:
                      currentFilterUuid, // Используем переданное значение
                  onChanged: (value) => Navigator.of(dialogContext).pop(value),
                ),
                onTap: () => Navigator.of(dialogContext).pop(null),
              ),
              ...clients.map((client) => ListTile(
                    title: Text(client.displayName),
                    leading: Radio<String?>(
                      value: client.uuid,
                      groupValue:
                          currentFilterUuid, // Используем переданное значение
                      onChanged: (value) =>
                          Navigator.of(dialogContext).pop(value),
                    ),
                    onTap: () => Navigator.of(dialogContext).pop(client.uuid),
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(
                currentFilterUuid), // Возвращаем текущее значение при отмене
            child: Text(t.vehicles.cancel),
          ),
        ],
      ),
    );

    // Применяем выбранный фильтр, если он изменился
    if (result != currentFilterUuid) {
      ref.read(carsNotifierProvider.notifier).setClientFilter(result);
      setState(() {
        _selectedCar = null; // Сбрасываем выбор машины
      });
    }
  }

  // --- Виджет для отображения списка автомобилей ---
  Widget _buildCarsList({
    required AsyncValue<List<CarWithOwnerModel>>
        carsAsyncValue, // Принимаем AsyncValue
    required Function(CarModelComposite) onCarSelected,
    String? selectedCarUuid,
  }) {
    final t = Translations.of(context);
    final isDesktop = _isDesktop(context);

    // Используем .when для обработки состояний AsyncValue
    return carsAsyncValue.when(
      data: (cars) {
        // Фильтрация больше не нужна здесь, она в Notifier'е
        if (cars.isEmpty) {
          // Получаем текущий фильтр для текста
          final currentFilter =
              ref.read(carsNotifierProvider.notifier).currentClientFilterUuid;
          return Center(
            child: Text(currentFilter == null
                ? t.vehicles.emptyList
                : t.vehicles.noCarsAvailable),
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
              ],
              rows: cars.map((carWithOwner) {
                final car = carWithOwner.car;
                final owner = carWithOwner.owner;
                final isSelected = car.uuid == selectedCarUuid;

                return DataRow(
                  selected: isSelected,
                  onSelectChanged: (selected) {
                    if (selected ?? false) {
                      onCarSelected(car);
                    }
                  },
                  cells: [
                    DataCell(Text(car.make)),
                    DataCell(Text(car.model)),
                    DataCell(Text(owner.displayName)),
                    DataCell(Text(car.displayLicensePlate)),
                  ],
                );
              }).toList(),
            ),
          );
        } else {
          // --- ListView для мобильных ---
          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final carWithOwner = cars[index];
              final car = carWithOwner.car;
              final owner = carWithOwner.owner;

              return Dismissible(
                key: Key(car.uuid),
                background: Container(
                  color: Theme.of(context)
                      .colorScheme
                      .error, // Цвет фона ошибки из темы
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.delete,
                    color: Theme.of(context)
                        .colorScheme
                        .onError, // Цвет иконки на фоне ошибки
                  ),
                ),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) => _confirmDelete(car),
                onDismissed: (direction) =>
                    _deleteCar(car), // Вызываем новый метод
                child: Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text('${car.make} ${car.model} (${car.year})'),
                    subtitle: Text(
                        '${t.vehicles.owner}: ${owner.displayName}\n${t.vehicles.vin}: ${car.vin}'),
                    isThreeLine: true,
                    trailing: Text(car.displayLicensePlate),
                    onTap: () => onCarSelected(car),
                  ),
                ),
              );
            },
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        // Обработка ошибки БД
        if (error.toString().contains('no such table')) {
          _logger.e('${LogMessages.dbTableMissingError}: $error',
              error: error, stackTrace: stackTrace);
          // Показываем UI для сброса БД
          return _buildDbErrorUI(t); // Выносим в отдельный метод
        }
        _logger.e(LogMessages.dataLoadingError,
            error: error, stackTrace: stackTrace);
        return Center(
          child: Text(
            t.core.errorLoadingData(error: error.toString()),
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        );
      },
    );
  }

  // --- UI для ошибки БД ---
  Widget _buildDbErrorUI(Translations t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(t.vehicles.databaseError),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              try {
                // Логика сброса БД
                final db = locator<AppDatabase>();
                await db.resetDatabase();
                // Пересоздаем зависимости
                locator.unregister<AppDatabase>();
                locator.registerSingleton<AppDatabase>(AppDatabase());
                // Инвалидируем провайдеры Riverpod
                ref.invalidate(carServiceProvider);
                ref.invalidate(
                    clientServiceProvider); // Если CarService от него зависит
                ref.invalidate(carsNotifierProvider);
                ref.invalidate(clientsForFilterProvider);
                // Не нужно делать setState, Riverpod обновит UI
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text(t.vehicles.resetDatabaseSuccess)),
                  );
                }
              } catch (e, s) {
                _logger.e(LogMessages.databaseResetError,
                    error: e, stackTrace: s);
                if (mounted) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                        content: Text(
                            '${LogMessages.databaseResetError}: ${e.toString()}')),
                  );
                }
              }
            },
            child: Text(t.vehicles.resetDatabase),
          )
        ],
      ),
    );
  }

  // --- Виджет для отображения детальной информации об автомобиле ---
  Widget _buildCarDetails(CarModelComposite car) {
    final t = Translations.of(context);
    // Получаем клиента через ref.watch или FutureProvider
    final clientAsyncValue = ref.watch(
        clientProvider(car.clientId)); // Предполагаем наличие clientProvider

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                car.displayName,
                style: Theme.of(context).textTheme.headlineSmall,
                overflow: TextOverflow.ellipsis,
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
                    // Сохраняем context-зависимые значения ДО await
                    final bool isDesktop = _isDesktop(context);
                    final bool isLarge = _isLargeScreen(context);

                    // Асинхронный вызов
                    final confirmed = await _confirmDelete(car);

                    // Проверяем mounted ПОСЛЕ await
                    if (confirmed && mounted) {
                      _deleteCar(car); // Вызываем метод удаления
                      // Сбрасываем детали в десктопном режиме, используя сохраненные значения
                      if (isDesktop && isLarge) {
                        setState(() => _selectedCar = null);
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        const Divider(),
        // Используем .when для отображения клиента
        clientAsyncValue.when(
            data: (client) => ListTile(
                  title: Text(t.vehicles.owner),
                  subtitle:
                      Text(client?.displayName ?? t.clients.clientNotFound),
                  leading: const Icon(Icons.person),
                ),
            loading: () => ListTile(
                  title: Text(t.vehicles.owner),
                  subtitle: Text(t.common.loading),
                  leading: const Icon(Icons.person),
                ),
            error: (e, s) {
              _logger.e('Error loading client details for car ${car.uuid}',
                  error: e, stackTrace: s);
              return ListTile(
                title: Text(t.vehicles.owner),
                subtitle: Text(t.core.errorLoadingData(
                    error: e.toString())), // Показываем ошибку
                leading:
                    const Icon(Icons.error, color: Colors.red), // Иконка ошибки
              );
            }),
        ListTile(
          title: Text(t.vehicles.vin),
          subtitle: Text(car.vin),
          leading: const Icon(Icons.confirmation_number),
        ),
        ListTile(
          title: Text(t.vehicles.licensePlate),
          subtitle: Text(car.displayLicensePlate),
          leading: const Icon(Icons.badge),
        ),
        ListTile(
          title: Text(t.vehicles.year),
          subtitle: Text(car.year.toString()),
          leading: const Icon(Icons.calendar_today),
        ),
        // Используем collection if
        if (car.additionalInfo?.isNotEmpty ??
            false) // Проверка на null и пустоту
          ListTile(
            title: Text(t.vehicles.additionalInfo),
            subtitle:
                Text(car.additionalInfo!), // Безопасно из-за проверки выше
            leading: const Icon(Icons.info_outline),
            isThreeLine: true,
          ), // Или ничего не отображаем, если null или пусто
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(t.vehicles.carHistory,
              style: Theme.of(context).textTheme.titleMedium),
        ),
        Expanded(
          child: Center(
            child: Text(t.vehicles.orderHistoryComingSoon),
          ),
          // TODO: ... интеграция с заказ-нарядами ...
        ),
      ],
    );
  }

  // --- Метод для подтверждения удаления автомобиля ---
  Future<bool> _confirmDelete(CarModelComposite car) async {
    // Получаем BuildContext, так как метод вызывается из build-контекста
    final currentContext = context;
    final t = Translations.of(currentContext); // Используем currentContext

    // Показываем диалог подтверждения
    final confirmed = await showDialog<bool>(
      context: currentContext, // Передаем context
      builder: (BuildContext dialogContext) {
        // Передаем builder
        return AlertDialog(
          title: Text(t.vehicles.deleteConfirmTitle),
          content: Text(t.vehicles.deleteConfirmMessage(
            make: car.make,
            model: car.model,
            vin: car.vin,
          )), // Используем ключ confirmDeleteMessage
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false), // Отмена
              child: Text(t.vehicles.cancel),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              onPressed: () =>
                  Navigator.of(dialogContext).pop(true), // Подтверждение
              child: Text(t.common.delete),
            ),
          ],
        );
      },
    );
    // Возвращаем результат (true, если подтверждено, false или null, если отменено)
    return confirmed ?? false;
  }

  // --- Метод удаления (вызывается из onDismissed и _buildCarDetails) ---
  Future<void> _deleteCar(CarModelComposite car) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final t = Translations.of(context);
    final carUuid = car.uuid; // Сохраняем для Snackbar
    final carName = '${car.make} ${car.model}';

    try {
      // Вызываем метод Notifier'а
      await ref.read(carsNotifierProvider.notifier).deleteCar(carUuid);

      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(t.vehicles.deleted(make: car.make, model: car.model)),
            action: SnackBarAction(
              label: t.common.undo,
              onPressed: () =>
                  _restoreCar(carUuid, carName), // Передаем UUID и имя
            ),
          ),
        );
      }
    } catch (e, s) {
      _logger.e(LogMessages.carDeleteError.replaceAll('{uuid}', carUuid),
          error: e, stackTrace: s);
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(t.vehicles.deleteError(error: e.toString()))),
        );
      }
    }
  }

  // --- Метод восстановления ---
  Future<void> _restoreCar(String carUuid, String carName) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final t = Translations.of(context);
    try {
      await ref.read(carsNotifierProvider.notifier).restoreCar(carUuid);
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
              content: Text(
                  t.vehicles.restored(name: carName))), // Нужен ключ restored
        );
      }
    } catch (e, s) {
      _logger.e(LogMessages.carRestoreError.replaceAll('{uuid}', carUuid),
          error: e, stackTrace: s);
      if (mounted) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(t.vehicles.restoreError(error: e.toString()))),
        );
      }
    }
  }

  // --- Методы добавления/редактирования ---
  Future<void> _addCar() async {
    final t = Translations.of(context);
    // Передаем ref в диалог
    final newCarComposite = await _showCarDialog(context, ref: ref);
    if (newCarComposite != null && mounted) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        // Вызываем метод Notifier'а
        await ref.read(carsNotifierProvider.notifier).addCar(newCarComposite);
        if (mounted) {
          scaffoldMessenger.showSnackBar(SnackBar(
              content: Text(t.vehicles.added(
                  name: newCarComposite.displayName)))); // Нужен ключ added
        }
      } catch (e, stackTrace) {
        _logger.e(LogMessages.carAddError, error: e, stackTrace: stackTrace);
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text(t.vehicles.addError(error: e.toString()))),
          );
        }
      }
    }
  }

  Future<void> _editCar(CarModelComposite car) async {
    final t = Translations.of(context);
    // Передаем ref и текущий композитор в диалог
    final updatedCarComposite =
        await _showCarDialog(context, car: car, ref: ref);
    if (updatedCarComposite != null && mounted) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        // Вызываем метод Notifier'а
        await ref
            .read(carsNotifierProvider.notifier)
            .updateCar(updatedCarComposite);
        // Обновляем выбранный автомобиль в десктопном режиме
        if (_selectedCar != null &&
            _selectedCar!.uuid == updatedCarComposite.uuid) {
          setState(() => _selectedCar = updatedCarComposite);
        }
        if (mounted) {
          scaffoldMessenger.showSnackBar(SnackBar(
              content: Text(t.vehicles.updated(
                  name:
                      updatedCarComposite.displayName)))); // Нужен ключ updated
        }
      } catch (e, stackTrace) {
        _logger.e(LogMessages.carUpdateError.replaceAll('{uuid}', car.uuid),
            error: e, stackTrace: stackTrace);
        if (mounted) {
          scaffoldMessenger.showSnackBar(
            SnackBar(
                content: Text(t.vehicles.updateError(error: e.toString()))),
          );
        }
      }
    }
  }

  // --- Диалог добавления/редактирования автомобиля ---
  // Добавляем required WidgetRef ref
  Future<CarModelComposite?> _showCarDialog(BuildContext context,
      {CarModelComposite? car, required WidgetRef ref}) async {
    final t = Translations.of(context);
    final bool isEditing = car != null;

    // Контроллеры
    final makeController = TextEditingController(text: car?.make ?? '');
    final modelController =
        TextEditingController(text: car?.model ?? ''); // Добавлено
    final yearController =
        TextEditingController(text: car?.year.toString() ?? ''); // Добавлено
    final vinController = TextEditingController(text: car?.vin ?? '');
    final licensePlateController =
        TextEditingController(text: car?.licensePlate ?? ''); // Добавлено
    final additionalInfoController =
        TextEditingController(text: car?.additionalInfo ?? ''); // Добавлено

    // Состояние диалога
    ClientModelComposite? selectedClient;
    String? selectedClientUuid = car?.clientId;
    List<ClientModelComposite> clients = [];
    bool isLoading = true;
    String? vinError;
    bool vinCheckLoading = false; // Для индикатора проверки VIN

    final formKey = GlobalKey<FormState>();
    Timer? vinDebounce; // Дебаунс для проверки VIN

    // Функция для валидации VIN на уникальность (асинхронная)
    // Используем isVinUniqueProvider
    Future<void> validateVinUniqueness(String vin) async {
      if (vin.length != 17) {
        setState(() {
          // setState из StatefulBuilder
          vinError = t.vehicles.vinRequirement;
          vinCheckLoading = false;
        });
        return;
      }

      setState(() {
        // setState из StatefulBuilder
        vinCheckLoading = true;
        vinError = null; // Сбрасываем предыдущую ошибку
      });

      try {
        // Используем ref для доступа к провайдеру
        final isUnique = await ref.read(isVinUniqueProvider(
          vin: vin,
          excludeUuid: car?.uuid,
        ).future);

        // Проверяем mounted перед setStateDialog (хотя он внутри StatefulBuilder)
        if (mounted) {
          setState(() {
            // setState из StatefulBuilder
            vinError = isUnique ? null : t.vehicles.vinNotUnique;
            vinCheckLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            // setState из StatefulBuilder
            vinError = t.vehicles.vinCheckError; // Ключ для ошибки проверки
            vinCheckLoading = false;
          });
        }
        _logger.e('Error checking VIN uniqueness', error: e);
      }
    }

    // Инициализация: загрузка клиентов и начальная валидация VIN
    Future<void> initializeDialog(StateSetter setStateDialog) async {
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      try {
        // Получаем клиентов через ref
        clients = await ref.read(clientsForFilterProvider.future);
        if (selectedClientUuid != null) {
          selectedClient =
              clients.firstWhereOrNull((c) => c.uuid == selectedClientUuid);
        }
        if (isEditing && vinController.text.isNotEmpty) {
          // Вызываем валидацию через локальную функцию, которая использует setStateDialog
          await validateVinUniqueness(vinController.text);
        }
      } catch (error, stackTrace) {
        _logger.e(LogMessages.dataLoadingError,
            error: error, stackTrace: stackTrace);
        if (mounted) {
          navigator.pop();
          scaffoldMessenger.showSnackBar(
            SnackBar(
                content:
                    Text(t.core.errorLoadingData(error: error.toString()))),
          );
        }
      } finally {
        // Используем setStateDialog для обновления состояния диалога
        if (mounted) {
          // Проверка mounted для _CarsScreenState
          setStateDialog(() {
            isLoading = false;
          });
        }
      }
    }

    // Очистка debounce таймера при закрытии диалога
    void disposeDialog() {
      vinDebounce?.cancel();
    }

    return showDialog<CarModelComposite>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Переименовали setState в setStateDialog для ясности
            // Вызываем инициализацию один раз
            if (isLoading) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Передаем setState диалога в initializeDialog
                initializeDialog(setState);
              });
            }

            // Определяем, валидна ли форма
            bool isFormValid = (formKey.currentState?.validate() ?? false) &&
                selectedClient != null &&
                vinError == null &&
                !vinCheckLoading; // Проверяем и загрузку VIN

            return PopScope(
              // Используем PopScope для очистки таймера
              canPop: !isLoading, // Нельзя закрыть во время загрузки
              onPopInvokedWithResult: (bool didPop, dynamic result) {
                if (didPop) {
                  disposeDialog();
                }
              },
              child: AlertDialog(
                title: Text(isEditing ? t.vehicles.edit : t.vehicles.add),
                content: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        child: Form(
                          key: formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              // --- Выбор клиента ---
                              DropdownButtonFormField<ClientModelComposite>(
                                value: selectedClient,
                                decoration: InputDecoration(
                                  labelText: t.clients.client,
                                  border: const OutlineInputBorder(),
                                ),
                                items: clients.map((client) {
                                  return DropdownMenuItem<ClientModelComposite>(
                                    value: client,
                                    child: Text(client.displayName),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    // Используем setState диалога
                                    selectedClient = value;
                                    selectedClientUuid = value?.uuid;
                                  });
                                },
                                validator: (value) => value == null
                                    ? t.clients.clientRequired
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
                                    (value == null || value.isEmpty)
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
                                    (value == null || value.isEmpty)
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
                                  errorText: vinError,
                                  // Индикатор загрузки для VIN
                                  suffixIcon: vinCheckLoading
                                      ? const Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2.0)),
                                        )
                                      : (vinError != null
                                          ? const Icon(Icons.error,
                                              color: Colors.red)
                                          : null),
                                ),
                                maxLength: 17,
                                textCapitalization:
                                    TextCapitalization.characters,
                                onChanged: (value) {
                                  // Дебаунс для проверки VIN
                                  vinDebounce?.cancel();
                                  vinDebounce =
                                      Timer(const Duration(milliseconds: 400),
                                          () async {
                                    // Вызываем валидацию через локальную функцию
                                    await validateVinUniqueness(value);
                                    // Обновляем состояние кнопки после проверки
                                    setState(
                                        () {}); // Используем setState диалога
                                  });
                                  // Обновляем состояние кнопки сразу
                                  setState(
                                      () {}); // Используем setState диалога
                                },
                                validator: (value) {
                                  // Валидатор для VIN (длина)
                                  if (value == null || value.isEmpty) {
                                    return t.vehicles.requiredField;
                                  }
                                  if (value.length != 17) {
                                    return t.vehicles.vinRequirement;
                                  }
                                  // Ошибка уникальности обрабатывается через vinError
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              // --- Гос. номер ---
                              TextFormField(
                                controller:
                                    licensePlateController, // Теперь определен
                                decoration: InputDecoration(
                                  labelText: t.vehicles.licensePlate,
                                  hintText: t.vehicles.licensePlateHint,
                                  border: const OutlineInputBorder(),
                                ),
                                // TODO: Валидатор для гос. номера (опционально)
                              ),
                              const SizedBox(height: 16),
                              // --- Доп. информация ---
                              TextFormField(
                                controller:
                                    additionalInfoController, // Теперь определен
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
                    onPressed: () {
                      disposeDialog(); // Очищаем таймер при отмене
                      Navigator.of(context).pop(null);
                    },
                    child: Text(t.vehicles.cancel),
                  ),
                  ElevatedButton(
                    onPressed: isFormValid
                        ? () {
                            // Создаем или обновляем композитор
                            final now = DateTime.now();
                            final EntityCoreData
                                coreData; // Объявляем переменную
                            if (isEditing) {
                              coreData = car.coreData.copyWith(
                                modifiedAt: now, // Используем modifiedAt
                                // displayName можно обновить здесь или в композиторе, если нужно
                              );
                            } else {
                              // Используем стандартный конструктор EntityCoreData
                              coreData = EntityCoreData(
                                uuid:
                                    const Uuid().v4(), // Генерируем UUID здесь
                                code: vinController
                                    .text, // Используем VIN как код по умолчанию
                                displayName:
                                    '${makeController.text} ${modelController.text}',
                                createdAt: now,
                                modifiedAt: now, // Устанавливаем modifiedAt
                                isDeleted: false,
                                deletedAt: null,
                              );
                            }

                            final carSpecificData = CarSpecificData(
                              clientId: selectedClient!
                                  .uuid, // selectedClient не может быть null из-за isFormValid
                              make: makeController.text,
                              model: modelController.text,
                              year: int.parse(yearController
                                  .text), // Безопасно из-за валидатора
                              vin: vinController.text,
                              licensePlate: licensePlateController.text,
                              additionalInfo: additionalInfoController.text,
                            );

                            // Передаем coreData и carSpecificData позиционно
                            final resultCar = CarModelComposite.fromData(
                              coreData,
                              carSpecificData,
                            );

                            disposeDialog(); // Очищаем таймер при сохранении
                            Navigator.of(context).pop(resultCar);
                          }
                        : null, // Кнопка неактивна, если форма невалидна
                    child: Text(t.vehicles.save),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
