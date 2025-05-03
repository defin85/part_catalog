import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:part_catalog/core/service_locator.dart';
// --- Обновленные импорты ---
import 'package:part_catalog/core/i18n/strings.g.dart'; // Используем slang
import 'package:part_catalog/features/core/base_item_type.dart';
import 'package:part_catalog/features/core/i_document_item_entity.dart';
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';
import 'package:part_catalog/features/documents/orders/models/order_part_model_composite.dart';
import 'package:part_catalog/features/documents/orders/models/order_service_model_composite.dart';
import 'package:part_catalog/features/documents/orders/services/order_service.dart';
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
import 'package:part_catalog/features/references/clients/services/client_service.dart';
import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';
import 'package:part_catalog/features/references/vehicles/services/car_service.dart';
import 'package:part_catalog/core/utils/logger_config.dart'; // Импорт конфигурации логгера
import 'package:collection/collection.dart';

/// Экран для создания и редактирования заказ-нарядов.
///
/// Позволяет пользователю создать новый заказ-наряд или отредактировать существующий
/// с возможностью выбора клиента, автомобиля, добавления услуг и запчастей.
class OrderFormScreen extends StatefulWidget {
  /// UUID заказ-наряда для редактирования (опционально).
  /// Если null, то создается новый заказ-наряд.
  final String? orderUuid;

  const OrderFormScreen({super.key, this.orderUuid});

  @override
  State<OrderFormScreen> createState() => _OrderFormScreenState();
}

class _OrderFormScreenState extends State<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _logger = AppLoggers.ordersLogger; // Используем логгер

  final _orderService = locator<OrderService>();
  final _clientService = locator<ClientService>();
  final _carService = locator<CarService>();

  // Состояние формы - используем композиторы
  ClientModelComposite? _selectedClient;
  CarModelComposite? _selectedCar;
  DateTime _scheduledDate = DateTime.now().add(const Duration(days: 1));
  // Используем Map для хранения элементов, как в OrderModelComposite
  Map<String, IDocumentItemEntity> _itemsMap = {};
  bool _isLoading = false;
  bool _isEditMode = false;
  OrderModelComposite?
      _existingOrder; // Для хранения исходного заказа в режиме редактирования

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.orderUuid != null;

    if (_isEditMode) {
      _loadExistingOrder();
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  /// Загружает существующий заказ-наряд для редактирования
  Future<void> _loadExistingOrder() async {
    setState(() => _isLoading = true);
    _logger.i('Загрузка заказа для редактирования: ${widget.orderUuid}');
    try {
      // Используем getOrderByUuid, который возвращает Future<OrderModelComposite>
      // Если заказ не найден, этот метод выбросит исключение
      final order = await _orderService.getOrderByUuid(widget.orderUuid!);

      // --- Эта проверка больше не нужна, т.к. при неуспехе будет исключение ---
      // if (order == null) { ... }

      // --- Код выполняется только если заказ успешно загружен ---
      _existingOrder = order; // Сохраняем исходный заказ
      _descriptionController.text = order.description ?? '';

      // Загрузка клиента
      // Добавляем проверку на null, так как анализатор считает clientId nullable
      if (order.clientId != null) {
        await _loadClient(order.clientId!); // Используем ! после проверки
      } else {
        // Логируем неожиданную ситуацию: clientId == null для существующего заказа
        _logger.e('clientId is null for existing order ${order.uuid}');
        // Возможно, показать ошибку пользователю или сбросить выбор клиента
        if (mounted) {
          _showErrorSnackBar(
              '${context.t.errors.dataLoadingError} (Client ID missing)');
          setState(() => _selectedClient = null);
        }
      }

      // Загрузка автомобиля
      // Добавляем проверку на null, так как анализатор считает carId nullable
      if (order.carId != null) {
        await _loadCar(order.carId!); // Используем ! после проверки
      } else {
        // Логируем неожиданную ситуацию: carId == null для существующего заказа
        _logger.e('carId is null for existing order ${order.uuid}');
        // Возможно, показать ошибку пользователю или сбросить выбор автомобиля
        if (mounted) {
          _showErrorSnackBar(
              '${context.t.errors.dataLoadingError} (Car ID missing)');
          setState(() => _selectedCar = null);
        }
      }

      // Установка даты
      if (order.docData.scheduledDate != null) {
        _scheduledDate = order.docData.scheduledDate!;
      }

      // Загрузка услуг и запчастей
      _itemsMap = Map.from(order.itemsMap); // Копируем карту элементов

      if (mounted) {
        setState(() {}); // Обновляем UI после загрузки данных
      }
    } catch (e, s) {
      // --- Обрабатываем ошибку загрузки, включая случай, когда заказ не найден ---
      _logger.e(
          'Ошибка загрузки заказ-наряда ${widget.orderUuid} или заказ не найден',
          error: e,
          stackTrace: s);
      if (mounted) {
        // Определяем, была ли ошибка "не найдено" или другая
        // Можно улучшить, если OrderService будет бросать кастомное исключение NotFoundException
        final errorMessage = e.toString().contains('не найден')
            ? context.t.orders.orderNotFound // Используем slang
            : context.t.errors.dataLoadingError; // Используем slang

        _showErrorSnackBar(errorMessage);

        // Если заказ не найден, закрываем форму
        if (errorMessage == context.t.orders.orderNotFound) {
          Navigator.pop(context);
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Загружает информацию о клиенте по UUID
  Future<void> _loadClient(String clientUuid) async {
    try {
      final client = await _clientService.getClientByUuid(clientUuid);
      if (mounted && client != null) {
        setState(() => _selectedClient = client);
      } else if (client == null) {
        _logger.w('Клиент с UUID $clientUuid не найден.');
        // Можно показать сообщение пользователю или оставить поле пустым
      }
    } catch (e, s) {
      _logger.e('Ошибка загрузки данных клиента $clientUuid',
          error: e, stackTrace: s);
      if (mounted) {
        _showErrorSnackBar(
            context.t.clients.clientLoadError); // Используем slang
      }
    }
  }

  /// Загружает информацию об автомобиле по UUID
  Future<void> _loadCar(String carUuid) async {
    try {
      final car = await _carService.getCarByUuid(carUuid);
      if (mounted && car != null) {
        setState(() => _selectedCar = car);
      } else if (car == null) {
        _logger.w('Автомобиль с UUID $carUuid не найден.');
        // Можно показать сообщение пользователю или оставить поле пустым
      }
    } catch (e, s) {
      _logger.e('Ошибка загрузки данных автомобиля $carUuid',
          error: e, stackTrace: s);
      if (mounted) {
        _showErrorSnackBar(
            context.t.vehicles.vehicleLoadError); // Используем slang
      }
    }
  }

  /// Показывает диалог выбора клиента (должен возвращать ClientModelComposite)
  Future<void> _selectClient() async {
    // Предполагаем, что диалог выбора клиента адаптирован и возвращает ClientModelComposite?
    final client = await showDialog<ClientModelComposite>(
      context: context,
      builder: (context) => _ClientSelectionDialog(), // Заглушка
    );

    if (client != null && mounted) {
      // Проверяем, изменился ли клиент
      if (_selectedClient?.uuid != client.uuid) {
        _logger.d('Выбран новый клиент: ${client.uuid}');
        setState(() {
          _selectedClient = client;
          // Сбрасываем выбранный автомобиль, если клиент изменился
          _selectedCar = null;
        });
      }
    }
  }

  /// Показывает диалог выбора автомобиля (должен возвращать CarModelComposite)
  Future<void> _selectCar() async {
    final t = context.t;
    if (_selectedClient == null) {
      _showErrorSnackBar(t.orders.selectClientFirst); // Используем slang
      return;
    }

    // Предполагаем, что диалог выбора автомобиля адаптирован и возвращает CarModelComposite?
    final car = await showDialog<CarModelComposite>(
      context: context,
      builder: (context) =>
          _CarSelectionDialog(clientUuid: _selectedClient!.uuid), // Заглушка
    );

    if (car != null && mounted) {
      if (_selectedCar?.uuid != car.uuid) {
        _logger.d('Выбран новый автомобиль: ${car.uuid}');
        setState(() => _selectedCar = car);
      }
    }
  }

  /// Показывает диалог выбора даты
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _scheduledDate,
      firstDate: DateTime.now()
          .subtract(const Duration(days: 30)), // Позволим выбирать прошлые даты
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null && mounted) {
      // Объединяем выбранную дату с текущим временем, если нужно
      final currentTime = TimeOfDay.now();
      final newDateTime = DateTime(picked.year, picked.month, picked.day,
          currentTime.hour, currentTime.minute);
      setState(() => _scheduledDate = newDateTime);
    }
  }

  /// Показывает диалог добавления/редактирования услуги (должен возвращать OrderServiceModelComposite)
  Future<void> _manageService(
      {OrderServiceModelComposite? existingService}) async {
    // Предполагаем, что диалог адаптирован
    final service = await showDialog<OrderServiceModelComposite>(
      context: context,
      builder: (context) =>
          _ServiceFormDialog(service: existingService), // Заглушка
    );

    if (service != null && mounted) {
      _logger.d('Добавлена/обновлена услуга: ${service.uuid}');
      setState(() {
        _itemsMap[service.uuid] = service; // Добавляем или обновляем в карте
      });
    }
  }

  /// Показывает диалог добавления/редактирования запчасти (должен возвращать OrderPartModelComposite)
  Future<void> _managePart({OrderPartModelComposite? existingPart}) async {
    // Предполагаем, что диалог адаптирован
    final part = await showDialog<OrderPartModelComposite>(
      context: context,
      builder: (context) => _PartFormDialog(part: existingPart), // Заглушка
    );

    if (part != null && mounted) {
      _logger.d('Добавлена/обновлена запчасть: ${part.uuid}');
      setState(() {
        _itemsMap[part.uuid] = part; // Добавляем или обновляем в карте
      });
    }
  }

  /// Удаляет элемент (услугу или запчасть) из списка
  void _removeItem(String itemUuid) {
    final t = context.t;
    final item = _itemsMap[itemUuid];
    if (item == null) return;

    _logger.d('Удаление элемента: $itemUuid');
    setState(() {
      _itemsMap.remove(itemUuid);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(item is OrderPartModelComposite
              ? t.orders.partRemovedSuccess
              : t.orders.serviceRemovedSuccess)),
    );
  }

  /// Сохраняет заказ-наряд
  Future<void> _saveOrder() async {
    final t = context.t;
    if (!_formKey.currentState!.validate()) {
      _logger.w('Форма не прошла валидацию.');
      return;
    }

    if (_selectedClient == null) {
      _showErrorSnackBar(t.orders.selectClientError); // Используем slang
      return;
    }

    if (_selectedCar == null) {
      _showErrorSnackBar(t.orders.selectVehicleError); // Используем slang
      return;
    }

    setState(() => _isLoading = true);
    _logger.i(_isEditMode
        ? 'Сохранение изменений заказа: ${widget.orderUuid}'
        : 'Создание нового заказа');

    try {
      // --- Преобразование _itemsMap ---
      final Map<BaseItemType, List<IDocumentItemEntity>> groupedItemsMap =
          _itemsMap.values.groupListsBy((item) => item.itemType);
      // --- Конец преобразования ---

      OrderModelComposite orderToSave;

      if (_isEditMode) {
        // Обновляем существующий композитор, используя методы with...
        // Важно передать обновленную карту элементов
        orderToSave = _existingOrder!
            .withClient(_selectedClient!.uuid)
            .withCar(_selectedCar!.uuid)
            .withDescription(_descriptionController.text)
            .withScheduledDate(_scheduledDate)
            .withItems(groupedItemsMap); // Передаем сгруппированную карту
      } else {
        // Создаем новый композитор через фабричный метод .create()
        orderToSave = OrderModelComposite.create(
          // Используем code и displayName из клиента/авто, если нужно, или генерируем
          code:
              'ЗН-${DateTime.now().millisecondsSinceEpoch}', // Пример генерации кода
          displayName:
              'Заказ-наряд от ${DateFormat('dd.MM.yy').format(DateTime.now())}', // Пример
          documentDate: DateTime.now(),
          clientId: _selectedClient!.uuid,
          carId: _selectedCar!.uuid,
          description: _descriptionController.text,
          scheduledDate: _scheduledDate,
          itemsMap: groupedItemsMap, // Передаем сгруппированную карту
          // Статус по умолчанию будет DocumentStatus.newDoc
        );
      }

      // Вызываем соответствующий метод сервиса
      if (_isEditMode) {
        await _orderService.updateOrder(orderToSave);
        _logger.i('Заказ ${orderToSave.uuid} успешно обновлен.');
      } else {
        await _orderService.createOrder(orderToSave);
        _logger.i('Новый заказ ${orderToSave.uuid} успешно создан.');
      }

      if (mounted) {
        // Показываем сообщение об успехе
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(_isEditMode
                  ? t.orders.updatedSuccess
                  : t.orders.createdSuccess)),
        );
        Navigator.pop(context, true); // Возвращаем true при успехе
      }
    } catch (e, s) {
      _logger.e('Ошибка сохранения заказ-наряда', error: e, stackTrace: s);
      if (mounted) {
        _showErrorSnackBar(t.errors.saveError); // Используем slang
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.t; // Получаем доступ к slang
    final dateFormat = DateFormat(
        'dd.MM.yyyy HH:mm',
        Localizations.localeOf(context)
            .toString()); // Используем локаль из slang
    final currencyFormat = NumberFormat.currency(
      locale: Localizations.localeOf(context)
          .toString(), // Используем локаль из slang
      symbol: '₽', // TODO: Сделать символ валюты настраиваемым
      decimalDigits: 2,
    );

    // Рассчитываем общую стоимость из _itemsMap
    final total = _itemsMap.values
        .fold<double>(0.0, (sum, item) => sum + (item.totalPrice ?? 0.0));

    // Разделяем элементы на услуги и запчасти для отображения
    final services =
        _itemsMap.values.whereType<OrderServiceModelComposite>().toList();
    final parts =
        _itemsMap.values.whereType<OrderPartModelComposite>().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode
            ? t.orders.editOrderTitle // Используем slang
            : t.orders.newOrderTitle), // Используем slang
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: t.common.saveButtonLabel, // Используем slang
            onPressed: _isLoading ? null : _saveOrder,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Секция выбора клиента
                    _buildSectionTitle(
                        theme, t.orders.clientInfoTitle), // Используем slang
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      // Используем displayName из композитора
                      title: Text(_selectedClient?.displayName ??
                          t.orders.selectClientHint), // Используем slang
                      leading: const Icon(Icons.person),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _selectClient,
                      // Валидация выбора клиента
                      subtitle: _selectedClient == null
                          ? Text(t.errors.fieldRequired,
                              style: TextStyle(
                                  color: theme.colorScheme.error, fontSize: 12))
                          : null,
                    ),
                    const Divider(),

                    // Секция выбора автомобиля
                    _buildSectionTitle(
                        theme, t.orders.vehicleInfoTitle), // Используем slang
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(_selectedCar != null
                          // Используем displayName и displayLicensePlate из композитора
                          ? '${_selectedCar!.displayName} (${_selectedCar!.displayLicensePlate})'
                          : t.orders.selectVehicleHint), // Используем slang
                      leading: const Icon(Icons.directions_car),
                      trailing: const Icon(Icons.chevron_right),
                      // Блокируем выбор, если не выбран клиент
                      onTap: _selectedClient != null ? _selectCar : null,
                      enabled: _selectedClient != null,
                      // Валидация выбора автомобиля
                      subtitle: _selectedCar == null
                          ? Text(t.errors.fieldRequired,
                              style: TextStyle(
                                  color: theme.colorScheme.error, fontSize: 12))
                          : null,
                    ),
                    const Divider(),

                    // Секция описания проблемы
                    _buildSectionTitle(
                        theme, t.orders.problemDescription), // Используем slang
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText:
                            t.orders.problemDescriptionHint, // Используем slang
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      // Можно добавить валидатор, если описание обязательно
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return t.errors.fieldRequired;
                      //   }
                      //   return null;
                      // },
                    ),
                    const SizedBox(height: 16),

                    // Секция запланированной даты
                    _buildSectionTitle(
                        theme, t.orders.scheduledDate), // Используем slang
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(dateFormat.format(_scheduledDate)),
                      leading: const Icon(Icons.calendar_today),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _selectDate,
                    ),
                    const Divider(),

                    // Секция услуг
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle(
                            theme, t.orders.servicesList), // Используем slang
                        TextButton.icon(
                          icon: const Icon(Icons.add),
                          label: Text(t.common.add), // Используем slang
                          onPressed: () =>
                              _manageService(), // Вызов без аргумента для добавления
                        ),
                      ],
                    ),
                    if (services.isEmpty)
                      _buildEmptyPlaceholder(
                          t.orders.noServicesAdded) // Используем slang
                    else
                      _buildServicesList(services, currencyFormat, t),
                    const Divider(),

                    // Секция запчастей
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle(
                            theme, t.orders.partsList), // Используем slang
                        TextButton.icon(
                          icon: const Icon(Icons.add),
                          label: Text(t.common.add), // Используем slang
                          onPressed: () =>
                              _managePart(), // Вызов без аргумента для добавления
                        ),
                      ],
                    ),
                    if (parts.isEmpty)
                      _buildEmptyPlaceholder(
                          t.orders.noPartsAdded) // Используем slang
                    else
                      _buildPartsList(parts, currencyFormat, t),
                    const Divider(),

                    // Итоговая сумма
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            t.orders.totalAmount, // Используем slang
                            style: theme.textTheme.headlineSmall,
                          ),
                          Text(
                            currencyFormat.format(total),
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEmptyPlaceholder(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }

  // Обновленный метод для отображения списка услуг
  Widget _buildServicesList(List<OrderServiceModelComposite> services,
      NumberFormat currencyFormat, Translations t) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service.name, // Используем name из композитора
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      tooltip: t.common.edit,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _manageService(
                          existingService:
                              service), // Передаем для редактирования
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18),
                      tooltip: t.common.remove,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: Colors.red,
                      onPressed: () =>
                          _removeItem(service.uuid), // Удаляем по UUID
                    ),
                  ],
                ),
                if (service.description != null &&
                    service.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(service.description!),
                  ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Используем duration из композитора
                      if (service.duration != null)
                        Text('${service.duration} ч.'),
                      // Используем price из композитора
                      Text(
                        currencyFormat.format(service.price ?? 0.0),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Обновленный метод для отображения списка запчастей
  Widget _buildPartsList(List<OrderPartModelComposite> parts,
      NumberFormat currencyFormat, Translations t) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: parts.length,
      itemBuilder: (context, index) {
        final part = parts[index];
        final totalPartPrice = part.totalPrice ?? 0.0;
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        part.name, // Используем name из композитора
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      tooltip: t.common.edit,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _managePart(
                          existingPart: part), // Передаем для редактирования
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18),
                      tooltip: t.common.remove,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: Colors.red,
                      onPressed: () =>
                          _removeItem(part.uuid), // Удаляем по UUID
                    ),
                  ],
                ),
                // Используем partNumber из композитора
                Text('${t.parts.partNumberLabel}: ${part.partNumber}'),
                // Используем brand из композитора
                if (part.brand != null)
                  Text('${t.parts.brandLabel}: ${part.brand}'),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Используем quantity и price из композитора
                      Text(
                          '${part.quantity ?? 1.0} ${t.parts.pcs} × ${currencyFormat.format(part.price ?? 0.0)}'),
                      Text(
                        currencyFormat.format(totalPartPrice),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- Вспомогательные диалоги (Заглушки - ТРЕБУЮТ АДАПТАЦИИ) ---
// Эти диалоги должны быть переделаны для работы с композиторами
// и возвращать соответствующие композиторы (ClientModelComposite, CarModelComposite и т.д.)

class _ClientSelectionDialog extends StatelessWidget {
  // TODO: Адаптировать для работы с ClientService и ClientModelComposite
  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return AlertDialog(
      title: Text(t.orders.selectClient),
      content: const Text('Здесь будет список клиентов (ClientModelComposite)'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.common.cancelButtonLabel),
        ),
      ],
    );
  }
}

class _CarSelectionDialog extends StatelessWidget {
  final String clientUuid;

  const _CarSelectionDialog({required this.clientUuid});

  // TODO: Адаптировать для работы с CarService и CarModelComposite, используя clientUuid
  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return AlertDialog(
      title: Text(t.orders.selectVehicle),
      content: const Text(
          'Здесь будет список автомобилей клиента (CarModelComposite)'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.common.cancelButtonLabel),
        ),
      ],
    );
  }
}

class _ServiceFormDialog extends StatelessWidget {
  final OrderServiceModelComposite? service; // Принимает композитор

  const _ServiceFormDialog({this.service});

  // TODO: Адаптировать форму для создания/редактирования OrderServiceModelComposite
  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return AlertDialog(
      title: Text(service == null ? t.orders.addService : t.orders.editService),
      content: const Text('Здесь будет форма для OrderServiceModelComposite'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.common.cancelButtonLabel),
        ),
        TextButton(
          // TODO: Реализовать сохранение и возврат OrderServiceModelComposite
          onPressed: () =>
              Navigator.pop(context /*, созданный/обновленный service */),
          child: Text(t.common.saveButtonLabel),
        ),
      ],
    );
  }
}

class _PartFormDialog extends StatelessWidget {
  final OrderPartModelComposite? part; // Принимает композитор

  const _PartFormDialog({this.part});

  // TODO: Адаптировать форму для создания/редактирования OrderPartModelComposite
  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return AlertDialog(
      title: Text(part == null ? t.orders.addPart : t.orders.editPart),
      content: const Text('Здесь будет форма для OrderPartModelComposite'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.common.cancelButtonLabel),
        ),
        TextButton(
          // TODO: Реализовать сохранение и возврат OrderPartModelComposite
          onPressed: () =>
              Navigator.pop(context /*, созданная/обновленная part */),
          child: Text(t.common.saveButtonLabel),
        ),
      ],
    );
  }
}
