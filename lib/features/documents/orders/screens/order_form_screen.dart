import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Импорт Riverpod
import 'package:intl/intl.dart';
// --- Обновленные импорты ---
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/core/utils/logger_config.dart';
import 'package:part_catalog/core/widgets/app_dialog.dart';
import 'package:part_catalog/core/widgets/custom_text_form_field.dart';
import 'package:part_catalog/core/widgets/section_title.dart';
import 'package:part_catalog/core/widgets/selection_list_tile.dart';
import 'package:part_catalog/features/documents/orders/models/order_part_model_composite.dart';
import 'package:part_catalog/features/documents/orders/models/order_service_model_composite.dart';
// Импортируем Notifier и State
import 'package:part_catalog/features/documents/orders/notifiers/order_form_notifier.dart';
import 'package:part_catalog/features/documents/orders/state/order_form_state.dart';
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
import 'package:part_catalog/features/references/clients/providers/client_providers.dart';
import 'package:part_catalog/features/references/vehicles/models/car_model_composite.dart';
import 'package:part_catalog/features/references/vehicles/providers/car_providers.dart';

// Преобразуем в ConsumerStatefulWidget
class OrderFormScreen extends ConsumerStatefulWidget {
  final String? orderUuid;

  const OrderFormScreen({super.key, this.orderUuid});

  @override
  ConsumerState<OrderFormScreen> createState() => _OrderFormScreenState();
}

// Преобразуем State в ConsumerState
class _OrderFormScreenState extends ConsumerState<OrderFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _logger = AppLoggers.orders;

  // Notifier provider instance specific to this screen/orderUuid
  // Используем правильный тип AutoDisposeStateNotifierProvider
  late final AutoDisposeStateNotifierProvider<OrderFormNotifier, OrderFormState>
      _provider;

  @override
  void initState() {
    super.initState();
    _provider = orderFormNotifierProvider(widget.orderUuid);

    // Синхронизируем контроллер описания с состоянием Notifier'а
    // Слушаем изменения в Notifier'е, чтобы обновить контроллер, если нужно
    // (например, при загрузке существующих данных)
    ref.listenManual<OrderFormState>(_provider, (previous, next) {
      if (previous?.description != next.description) {
        // Проверяем, чтобы не вызывать setState во время build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _descriptionController.text != next.description) {
            _descriptionController.text = next.description;
          }
        });
      }
      // Показываем ошибки из Notifier'а
      if (previous?.error != next.error && next.error != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showErrorSnackBar(next.error!);
          }
        });
      }
    });

    // Обновляем состояние Notifier'а при изменении текста в контроллере
    _descriptionController.addListener(() {
      ref
          .read(_provider.notifier)
          .updateDescription(_descriptionController.text);
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  // --- Методы для выбора клиента, авто, даты и управления элементами ---
  // Теперь они вызывают методы Notifier'а

  Future<void> _selectClient() async {
    final client = await showDialog<ClientModelComposite>(
      context: context,
      builder: (context) => _ClientSelectionDialog(), // Заглушка
    );
    if (client != null && mounted) {
      ref.read(_provider.notifier).updateClient(client);
    }
  }

  Future<void> _selectCar(String clientUuid) async {
    final car = await showDialog<CarModelComposite>(
      context: context,
      builder: (context) =>
          _CarSelectionDialog(clientUuid: clientUuid), // Заглушка
    );
    if (car != null && mounted) {
      ref.read(_provider.notifier).updateCar(car);
    }
  }

  Future<void> _selectDate(DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      final currentTime = TimeOfDay.now();
      final newDateTime = DateTime(picked.year, picked.month, picked.day,
          currentTime.hour, currentTime.minute);
      ref.read(_provider.notifier).updateScheduledDate(newDateTime);
    }
  }

  Future<void> _manageService(
      {OrderServiceModelComposite? existingService}) async {
    final service = await showDialog<OrderServiceModelComposite>(
      context: context,
      builder: (context) =>
          _ServiceFormDialog(service: existingService), // Заглушка
    );
    if (service != null && mounted) {
      ref.read(_provider.notifier).addItem(service);
    }
  }

  Future<void> _managePart({OrderPartModelComposite? existingPart}) async {
    final part = await showDialog<OrderPartModelComposite>(
      context: context,
      builder: (context) => _PartFormDialog(part: existingPart), // Заглушка
    );
    if (part != null && mounted) {
      ref.read(_provider.notifier).addItem(part);
    }
  }

  void _removeItem(String itemUuid) {
    final t = context.t;
    final item = ref.read(_provider).itemsMap[itemUuid];
    if (item == null) return;

    ref.read(_provider.notifier).removeItem(itemUuid);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(item is OrderPartModelComposite
              ? t.orders.partRemovedSuccess
              : t.orders.serviceRemovedSuccess)),
    );
  }

  Future<void> _saveOrder() async {
    final t = context.t;
    if (!_formKey.currentState!.validate()) {
      _logger.w('Форма не прошла валидацию.');
      return;
    }

    final success = await ref.read(_provider.notifier).saveOrder();

    if (mounted && success) {
      final isEditMode = ref.read(_provider).isEditMode;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(isEditMode
                ? t.orders.updatedSuccess
                : t.orders.createdSuccess)),
      );
      Navigator.pop(context, true); // Возвращаем true при успехе
    }
    // Ошибки показываются через ref.listen в initState
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
    // Следим за состоянием Notifier'а
    final formState = ref.watch(_provider);

    final theme = Theme.of(context);
    final t = context.t;
    final dateFormat = DateFormat(
        'dd.MM.yyyy HH:mm', Localizations.localeOf(context).toString());
    final currencyFormat = NumberFormat.currency(
      locale: Localizations.localeOf(context).toString(),
      symbol: '₽',
      decimalDigits: 2,
    );

    final total = formState.itemsMap.values
        .fold<double>(0.0, (sum, item) => sum + (item.totalPrice ?? 0.0));
    final services = formState.itemsMap.values
        .whereType<OrderServiceModelComposite>()
        .toList();
    final parts =
        formState.itemsMap.values.whereType<OrderPartModelComposite>().toList();

    // Показываем индикатор загрузки или ошибку на весь экран
    if (formState.isLoading) {
      return Scaffold(
          appBar: AppBar(
              title: Text(formState.isEditMode
                  ? t.orders.editOrderTitle
                  : t.orders.newOrderTitle)),
          body: const Center(child: CircularProgressIndicator()));
    }
    // Показываем ошибку загрузки начальных данных
    // if (formState.error != null && formState.initialOrder == null && formState.isEditMode) {
    //   return Scaffold(
    //       appBar: AppBar(title: Text(formState.isEditMode ? t.orders.editOrderTitle : t.orders.newOrderTitle)),
    //       body: Center(child: Text('${t.errors.dataLoadingError}: ${formState.error}')));
    // }

    return Scaffold(
      appBar: AppBar(
        title: Text(formState.isEditMode
            ? t.orders.editOrderTitle
            : t.orders.newOrderTitle),
        actions: [
          // Блокируем кнопку сохранения во время сохранения
          if (formState.isSaving)
            const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 3)),
            )
          else
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: t.common.saveButtonLabel,
              onPressed: _saveOrder,
            ),
        ],
      ),
      // Не блокируем весь UI во время сохранения, только кнопку
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(title: t.orders.clientInfoTitle),
              SelectionListTile(
                title: formState.selectedClient?.displayName ?? t.orders.selectClientHint,
                icon: Icons.person,
                onTap: _selectClient,
                subtitle: formState.selectedClient == null ? t.errors.fieldRequired : null,
                subtitleColor: theme.colorScheme.error,
              ),
              const Divider(),

              SectionTitle(title: t.orders.vehicleInfoTitle),
              SelectionListTile(
                title: formState.selectedCar != null
                    ? '${formState.selectedCar!.displayName} (${formState.selectedCar!.displayLicensePlate})'
                    : t.orders.selectVehicleHint,
                icon: Icons.directions_car,
                onTap: () => _selectCar(formState.selectedClient!.uuid),
                enabled: formState.selectedClient != null,
                subtitle: formState.selectedCar == null ? t.errors.fieldRequired : null,
                subtitleColor: theme.colorScheme.error,
              ),
              const Divider(),

              // Секция описания проблемы
              SectionTitle(title: t.orders.problemDescription),
              CustomTextFormField(
                controller: _descriptionController,
                hintText: t.orders.problemDescriptionHint,
                labelText: t.orders.problemDescription,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              SectionTitle(title: t.orders.scheduledDate),
              SelectionListTile(
                title: formState.scheduledDate != null
                    ? dateFormat.format(formState.scheduledDate!)
                    : t.common.selectDate,
                icon: Icons.calendar_today,
                onTap: () => _selectDate(formState.scheduledDate ?? DateTime.now()),
              ),
              const Divider(),

              // Секция услуг
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SectionTitle(title: t.orders.servicesList),
                  TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(t.common.add),
                    onPressed: () => _manageService(),
                  ),
                ],
              ),
              if (services.isEmpty)
                _buildEmptyPlaceholder(t.orders.noServicesAdded)
              else
                _buildServicesList(services, currencyFormat, t),
              const Divider(),

              // Секция запчастей
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SectionTitle(title: t.orders.partsList),
                  TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text(t.common.add),
                    onPressed: () => _managePart(),
                  ),
                ],
              ),
              if (parts.isEmpty)
                _buildEmptyPlaceholder(t.orders.noPartsAdded)
              else
                _buildPartsList(parts, currencyFormat, t),
              const Divider(),

              // Итоговая сумма
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t.orders.totalAmount,
                        style: theme.textTheme.headlineSmall),
                    Text(
                      currencyFormat.format(total),
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
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

  // --- Методы _build... остаются почти без изменений, ---
  // --- только принимают данные из formState или напрямую ---

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
                      child: Text(service.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      tooltip: t.common.edit,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _manageService(existingService: service),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18),
                      tooltip: t.common.remove,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: Colors.red,
                      onPressed: () => _removeItem(service.uuid),
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
                      if (service.duration != null)
                        Text('${service.duration} ч.'),
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
                      child: Text(part.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 18),
                      tooltip: t.common.edit,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => _managePart(existingPart: part),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 18),
                      tooltip: t.common.remove,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: Colors.red,
                      onPressed: () => _removeItem(part.uuid),
                    ),
                  ],
                ),
                Text('${t.parts.partNumberLabel}: ${part.partNumber}'),
                if (part.brand != null)
                  Text('${t.parts.brandLabel}: ${part.brand}'),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
// Возможно, их тоже стоит сделать ConsumerWidget'ами для доступа к сервисам через ref

class _ClientSelectionDialog extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = context.t;
    final clientsAsync = ref.watch(clientsNotifierProvider);

    return AppDialog(
      title: Text(t.orders.selectClient),
      content: SizedBox(
        width: double.maxFinite,
        child: clientsAsync.when(
          data: (clients) {
            if (clients.isEmpty) {
              return Center(child: Text(t.clients.noClientsFound));
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: clients.length,
              itemBuilder: (context, index) {
                final client = clients[index];
                return ListTile(
                  title: Text(client.displayName),
                  subtitle: Text(client.contactInfo),
                  onTap: () => Navigator.pop(context, client),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('${t.errors.dataLoadingError}: $e')),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.common.cancelButtonLabel),
        ),
      ],
    );
  }
}

class _CarSelectionDialog extends ConsumerStatefulWidget {
  final String clientUuid;

  const _CarSelectionDialog({required this.clientUuid});

  @override
  ConsumerState<_CarSelectionDialog> createState() => _CarSelectionDialogState();
}

class _CarSelectionDialogState extends ConsumerState<_CarSelectionDialog> {
  @override
  void initState() {
    super.initState();
    // Устанавливаем фильтр при инициализации
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(carsNotifierProvider.notifier).setClientFilter(widget.clientUuid);
    });
  }

  @override
  void dispose() {
    // Сбрасываем фильтр при закрытии диалога
    Future.microtask(() => ref.read(carsNotifierProvider.notifier).setClientFilter(null));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final carsAsync = ref.watch(carsNotifierProvider);

    return AppDialog(
      title: Text(t.orders.selectVehicle),
      content: SizedBox(
        width: double.maxFinite,
        child: carsAsync.when(
          data: (cars) {
            if (cars.isEmpty) {
              return Center(child: Text(t.vehicles.noCarsFoundForClient));
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index].car; // Используем CarWithOwnerModel
                return ListTile(
                  title: Text(car.displayName),
                  subtitle: Text(car.displayLicensePlate),
                  onTap: () => Navigator.pop(context, car),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, s) => Center(child: Text('${t.errors.dataLoadingError}: $e')),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.common.cancelButtonLabel),
        ),
      ],
    );
  }
}

class _ServiceFormDialog extends ConsumerStatefulWidget {
  final OrderServiceModelComposite? service;

  const _ServiceFormDialog({this.service});

  @override
  ConsumerState<_ServiceFormDialog> createState() => _ServiceFormDialogState();
}

class _ServiceFormDialogState extends ConsumerState<_ServiceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.service?.name ?? '');
    _descriptionController = TextEditingController(text: widget.service?.description ?? '');
    _priceController = TextEditingController(text: widget.service?.price?.toString() ?? '');
    _durationController = TextEditingController(text: widget.service?.duration?.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final description = _descriptionController.text;
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final duration = double.tryParse(_durationController.text);

      final result = widget.service == null
          ? OrderServiceModelComposite.create(
              documentUuid: '', // UUID будет присвоен в Notifier
              name: name,
              description: description,
              price: price,
              duration: duration,
            )
          : widget.service!.copyWith(
              coreData: widget.service!.coreData.copyWith(name: name),
              docItemData: widget.service!.docItemData.copyWith(
                price: price,
              ),
              serviceData: widget.service!.serviceData.copyWith(
                description: description,
                duration: duration,
              ),
            );
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return AppDialog(
      title: Text(widget.service == null ? t.orders.addService : t.orders.editService),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: t.common.name),
                validator: (value) => (value?.isEmpty ?? true) ? t.errors.fieldRequired : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: t.common.description),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: t.common.price),
                keyboardType: TextInputType.number,
                validator: (value) => (double.tryParse(value ?? '') == null) ? t.errors.invalidNumber : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(labelText: t.orders.durationHours),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.common.cancelButtonLabel),
        ),
        TextButton(
          onPressed: _save,
          child: Text(t.common.saveButtonLabel),
        ),
      ],
    );
  }
}

class _PartFormDialog extends ConsumerStatefulWidget {
  final OrderPartModelComposite? part;

  const _PartFormDialog({this.part});

  @override
  ConsumerState<_PartFormDialog> createState() => _PartFormDialogState();
}

class _PartFormDialogState extends ConsumerState<_PartFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _partNumberController;
  late final TextEditingController _brandController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.part?.name ?? '');
    _partNumberController = TextEditingController(text: widget.part?.partNumber ?? '');
    _brandController = TextEditingController(text: widget.part?.brand ?? '');
    _priceController = TextEditingController(text: widget.part?.price?.toString() ?? '');
    _quantityController = TextEditingController(text: widget.part?.quantity?.toString() ?? '1');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _partNumberController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final partNumber = _partNumberController.text;
      final brand = _brandController.text;
      final price = double.tryParse(_priceController.text) ?? 0.0;
      final quantity = double.tryParse(_quantityController.text) ?? 1.0;

      final result = widget.part == null
          ? OrderPartModelComposite.create(
              documentUuid: '', // UUID будет присвоен в Notifier
              name: name,
              partNumber: partNumber,
              brand: brand,
              price: price,
              quantity: quantity,
            )
          : widget.part!.copyWith(
              coreData: widget.part!.coreData.copyWith(name: name),
              docItemData: widget.part!.docItemData.copyWith(
                price: price,
                quantity: quantity,
              ),
              partData: widget.part!.partData.copyWith(
                partNumber: partNumber,
                brand: brand,
              ),
            );
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return AppDialog(
      title: Text(widget.part == null ? t.orders.addPart : t.orders.editPart),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: t.common.name),
                validator: (value) => (value?.isEmpty ?? true) ? t.errors.fieldRequired : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _partNumberController,
                decoration: InputDecoration(labelText: t.parts.partNumberLabel),
                validator: (value) => (value?.isEmpty ?? true) ? t.errors.fieldRequired : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _brandController,
                decoration: InputDecoration(labelText: t.parts.brandLabel),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: t.common.price),
                keyboardType: TextInputType.number,
                validator: (value) => (double.tryParse(value ?? '') == null) ? t.errors.invalidNumber : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: t.common.quantity),
                keyboardType: TextInputType.number,
                validator: (value) => (double.tryParse(value ?? '') == null) ? t.errors.invalidNumber : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(t.common.cancelButtonLabel),
        ),
        TextButton(
          onPressed: _save,
          child: Text(t.common.saveButtonLabel),
        ),
      ],
    );
  }
}
