import 'dart:async'; // Для Timer (debounce)
import 'package:flutter/material.dart';
import 'package:part_catalog/core/service_locator.dart';
// Импортируем сгенерированный файл slang
import 'package:part_catalog/core/i18n/strings.g.dart';
// Импортируем композитор и статус документа
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';
import 'package:part_catalog/features/core/document_status.dart'; // Используем DocumentStatus
import 'package:part_catalog/features/documents/orders/services/order_service.dart';
import 'package:part_catalog/features/documents/orders/screens/order_form_screen.dart'; // Предполагаем, что он адаптирован
import 'package:part_catalog/features/documents/orders/screens/order_details_screen.dart'; // Предполагаем, что он адаптирован
import 'package:part_catalog/features/documents/orders/widgets/order_list_item.dart'; // Предполагаем, что он адаптирован
import 'package:part_catalog/core/utils/logger_config.dart'; // Для логгирования
import 'package:part_catalog/core/utils/log_messages.dart'; // Для сообщений логгера

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _orderService = locator<OrderService>();
  final _logger = AppLoggers.ordersLogger; // Логгер для экрана
  String? _searchQuery;
  DocumentStatus? _filterStatus; // Используем DocumentStatus
  Timer? _debounce; // Таймер для debounce поиска

  @override
  void dispose() {
    _debounce?.cancel(); // Отменяем таймер при уничтожении виджета
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Получаем доступ к локализации через context.t
    final t = context.t;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.orders.screenTitle), // Используем slang
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: t.common.filter, // Используем slang
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: t.orders.searchByNumberOrClient, // Используем slang
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                // Реализация debounce
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  if (mounted) {
                    // Проверяем, что виджет еще в дереве
                    setState(() {
                      _searchQuery = value.isNotEmpty ? value : null;
                    });
                  }
                });
              },
            ),
          ),
          // Отображение активного фильтра
          if (_filterStatus != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Chip(
                  label: Text(
                      '${t.common.filter}: ${_filterStatus!.displayName}'), // Используем displayName
                  backgroundColor:
                      _filterStatus!.color.withAlpha((255 * 0.1).round()),
                  onDeleted: () {
                    setState(() {
                      _filterStatus = null;
                    });
                  },
                ),
              ),
            ),
          Expanded(
            // Используем OrderModelComposite
            child: StreamBuilder<List<OrderModelComposite>>(
              stream: _orderService
                  .watchOrders(), // Метод сервиса возвращает Stream<List<OrderModelComposite>>
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  // Логируем ошибку
                  _logger.e(LogMessages.orderWatchError,
                      error: snapshot.error, stackTrace: snapshot.stackTrace);
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '${t.errors.dataLoadingError}: ${snapshot.error}', // Используем slang
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final allOrders = snapshot.data;

                if (allOrders == null || allOrders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.assignment_late_outlined,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          t.orders.noOrdersFound, // Используем slang
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // Фильтрация и сортировка данных
                final orders = _filterOrders(allOrders);

                // Отображение, если ничего не найдено после фильтрации
                if (orders.isEmpty &&
                    (_searchQuery != null || _filterStatus != null)) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          t.common.noResultsFound, // Используем slang
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                        if (_filterStatus != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ActionChip(
                              avatar: const Icon(Icons.close, size: 16),
                              label: Text(
                                  '${t.common.resetFilter}: ${_filterStatus!.displayName}'),
                              onPressed: () =>
                                  setState(() => _filterStatus = null),
                            ),
                          ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    // OrderListItem должен быть адаптирован под OrderModelComposite
                    return OrderListItem(
                      order: order, // Передаем композитор
                      onTap: () => _openOrderDetails(order),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: t.orders.add, // Используем slang
        onPressed: _createNewOrder,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Фильтрация и сортировка заказ-нарядов (OrderModelComposite)
  List<OrderModelComposite> _filterOrders(List<OrderModelComposite> orders) {
    var filteredOrders = List<OrderModelComposite>.from(orders);

    // Применяем фильтр по статусу
    if (_filterStatus != null) {
      filteredOrders = filteredOrders
          .where((order) => order.docData.status == _filterStatus)
          .toList();
    }

    // Применяем поисковый запрос
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      final query = _searchQuery!.toLowerCase();
      filteredOrders = filteredOrders
          .where((order) =>
              order.containsSearchText(query)) // Используем метод композитора
          .toList();
    }

    // Сортируем по дате создания (сначала новые)
    filteredOrders.sort(
        (a, b) => b.docData.documentDate.compareTo(a.docData.documentDate));

    return filteredOrders;
  }

  // Открытие диалога фильтрации
  void _showFilterDialog() {
    final t = context.t;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.orders.filterByStatus), // Используем slang
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              // Используем DocumentStatus
              for (final status in DocumentStatus.values)
                // Исключаем 'unknown' из фильтра
                if (status != DocumentStatus.unknown)
                  RadioListTile<DocumentStatus>(
                    title: Text(status.displayName), // Используем displayName
                    value: status,
                    groupValue: _filterStatus,
                    activeColor: status.color, // Используем color
                    onChanged: (value) {
                      if (mounted) {
                        setState(() => _filterStatus = value);
                      }
                      Navigator.pop(context);
                    },
                  ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text(t.common.resetButtonLabel), // Используем slang
            onPressed: () {
              if (mounted) {
                setState(() => _filterStatus = null);
              }
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(t.common.closeButtonLabel), // Используем slang
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // Создание нового заказ-наряда
  void _createNewOrder() async {
    final t = context.t;
    // OrderFormScreen должен быть адаптирован для создания OrderModelComposite
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const OrderFormScreen(), // Передаем null для orderId
      ),
    );

    // Проверяем, что виджет все еще в дереве после асинхронной операции
    if (!mounted) return;

    if (result == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(t.orders.createdSuccess)), // Используем slang
      );
      // Список обновится автоматически благодаря StreamBuilder
    }
  }

  // Открытие экрана деталей заказ-наряда
  void _openOrderDetails(OrderModelComposite order) {
    // OrderDetailsScreen должен быть адаптирован под OrderModelComposite
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(
          orderUuid: order
              .coreData.uuid, // Передаем UUID с правильным именем параметра
        ),
      ),
    );
  }
}

// Добавляем геттер displayName в DocumentStatus
// (Предполагается, что этот код будет добавлен в файл document_status.dart)
