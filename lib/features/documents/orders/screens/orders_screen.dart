import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Импорт Riverpod
// Импортируем сгенерированный файл slang
import 'package:part_catalog/core/i18n/strings.g.dart';
// Импортируем композитор и статус документа
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';
import 'package:part_catalog/features/core/document_status.dart';
// Импортируем Notifier
import 'package:part_catalog/features/documents/orders/notifiers/orders_notifier.dart';
import 'package:part_catalog/features/documents/orders/screens/order_form_screen.dart';
import 'package:part_catalog/features/documents/orders/screens/order_details_screen.dart';
import 'package:part_catalog/features/documents/orders/widgets/order_list_item.dart';

// Преобразуем в ConsumerStatefulWidget
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

// Преобразуем State в ConsumerState
class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  Timer? _debounce; // Таймер для debounce поиска
  final _searchController = TextEditingController(); // Контроллер для поиска

  @override
  void initState() {
    super.initState();
    // Слушатель для контроллера поиска с debounce
    _searchController.addListener(() {
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        // Вызываем метод Notifier'а для обновления поиска
        ref
            .read(ordersNotifierProvider.notifier)
            .setSearchQuery(_searchController.text);
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose(); // Не забываем освобождать контроллер
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    // Следим за состоянием Notifier'а
    final ordersState = ref.watch(ordersNotifierProvider);
    final notifier = ref.read(ordersNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.orders.screenTitle),
        actions: [
          // Кнопка сброса фильтра, если он активен
          if (ordersState.filterStatus != null)
            IconButton(
              icon: const Icon(Icons.filter_alt_off),
              tooltip: t.common.resetFilter,
              onPressed: () => notifier.setFilterStatus(null),
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: t.common.filter,
            onPressed: () => _showFilterDialog(
                ordersState.filterStatus), // Передаем текущий фильтр
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController, // Используем контроллер
              decoration: InputDecoration(
                hintText: t.orders.searchByNumberOrClient,
                prefixIcon: const Icon(Icons.search),
                // Добавляем кнопку очистки поиска
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: t.common.clear,
                        onPressed: () {
                          _searchController.clear();
                          // Сразу обновляем notifier, т.к. очистка - мгновенное действие
                          // notifier.setSearchQuery(null); // Вызовется через listener контроллера
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              // onChanged убран, т.к. используем listener контроллера
            ),
          ),
          // Отображение активного фильтра
          if (ordersState.filterStatus != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text(
                      '${t.common.filter}: ${ordersState.filterStatus!.displayName}'),
                  backgroundColor: ordersState.filterStatus!.color
                      .withAlpha((255 * 0.1).round()),
                  onDeleted: () => notifier
                      .setFilterStatus(null), // Вызываем метод Notifier'а
                ),
              ),
            ),
          Expanded(
            // Используем AsyncValue из ordersState
            child: ordersState.orders.when(
              data: (orders) {
                // Отображение, если ничего не найдено после фильтрации/поиска
                if (orders.isEmpty &&
                    (ordersState.searchQuery != null ||
                        ordersState.filterStatus != null)) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          t.common.noResultsFound,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        // Кнопки сброса фильтров/поиска
                        if (ordersState.filterStatus != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ActionChip(
                              avatar: const Icon(Icons.close, size: 16),
                              label: Text(
                                  '${t.common.resetFilter}: ${ordersState.filterStatus!.displayName}'),
                              onPressed: () => notifier.setFilterStatus(null),
                            ),
                          ),
                        if (ordersState.searchQuery != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ActionChip(
                              avatar: const Icon(Icons.close, size: 16),
                              label: Text(
                                  '${t.common.resetSearch}: "${ordersState.searchQuery!}"'),
                              onPressed: () => _searchController
                                  .clear(), // Очищаем контроллер
                            ),
                          ),
                      ],
                    ),
                  );
                }
                // Отображение, если вообще нет заказов (не после фильтрации)
                if (orders.isEmpty &&
                    ordersState.searchQuery == null &&
                    ordersState.filterStatus == null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.assignment_late_outlined,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          t.orders.noOrdersFound,
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // Отображение списка
                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return OrderListItem(
                      order: order,
                      onTap: () => _openOrderDetails(order),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) {
                // Логгер уже сработал в Notifier'е
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      '${t.errors.dataLoadingError}: $error',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: t.orders.add,
        onPressed: _createNewOrder,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Фильтрация и сортировка теперь выполняются в Notifier'е
  // List<OrderModelComposite> _filterOrders(List<OrderModelComposite> orders) { ... } // <--- Удалить

  // Открытие диалога фильтрации
  void _showFilterDialog(DocumentStatus? currentFilter) {
    // Принимаем текущий фильтр
    final t = context.t;
    final notifier =
        ref.read(ordersNotifierProvider.notifier); // Получаем notifier
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.orders.filterByStatus),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final status in DocumentStatus.values)
                if (status != DocumentStatus.unknown)
                  RadioListTile<DocumentStatus>(
                    title: Text(status.displayName),
                    value: status,
                    groupValue: currentFilter, // Используем переданный фильтр
                    activeColor: status.color,
                    onChanged: (value) {
                      notifier
                          .setFilterStatus(value); // Вызываем метод Notifier'а
                      Navigator.pop(context);
                    },
                  ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(t.common.resetButtonLabel),
            onPressed: () {
              notifier.setFilterStatus(null); // Вызываем метод Notifier'а
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(t.common.closeButtonLabel),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // Создание нового заказ-наряда
  void _createNewOrder() async {
    final t = context.t;
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const OrderFormScreen(), // orderUuid не передаем
      ),
    );

    if (!mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.orders.createdSuccess)),
      );
      // Список обновится автоматически благодаря подписке Notifier'а на stream
      // ref.invalidate(ordersNotifierProvider); // Можно инвалидировать, если watchOrders не используется
    }
  }

  // Открытие экрана деталей заказ-наряда
  void _openOrderDetails(OrderModelComposite order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        // OrderDetailsScreen должен быть адаптирован для приема orderUuid
        // и использования Riverpod для загрузки данных (например, через FutureProvider.family)
        builder: (context) => OrderDetailsScreen(
          orderUuid: order.coreData.uuid,
        ),
      ),
    );
  }
}
