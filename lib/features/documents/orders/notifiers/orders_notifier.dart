import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:part_catalog/core/database/database.dart'; // Для OrderService
import 'package:part_catalog/core/extensions/composite_extensions.dart';
import 'package:part_catalog/core/providers/core_providers.dart'; // Для appLoggerProvider
import 'package:part_catalog/core/service_locator.dart'; // Для OrderService
import 'package:part_catalog/core/utils/log_messages.dart';
import 'package:part_catalog/features/core/document_status.dart';
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';
import 'package:part_catalog/features/documents/orders/services/order_service.dart';

part 'orders_notifier.g.dart';

// Провайдер для OrderService (если еще не определен глобально)
// Если он уже есть в service_locator или другом файле провайдеров, этот можно удалить
@Riverpod(keepAlive: true)
OrderService orderService(Ref ref) {
  // Предполагаем, что AppDatabase доступна через другой провайдер или locator
  //final db =
  //    ref.watch(appDatabaseProvider); // Пример, если есть appDatabaseProvider
  final db = locator<AppDatabase>(); // Или через locator
  return OrderService(db);
}

// Состояние для Notifier'а, включающее фильтры
class OrdersState {
  final AsyncValue<List<OrderModelComposite>> orders;
  final String? searchQuery;
  final DocumentStatus? filterStatus;

  OrdersState({
    this.orders = const AsyncValue.loading(),
    this.searchQuery,
    this.filterStatus,
  });

  OrdersState copyWith({
    AsyncValue<List<OrderModelComposite>>? orders,
    String? searchQuery,
    DocumentStatus? filterStatus,
    // Используем nullable для возможности сброса фильтра/поиска
    bool resetSearchQuery = false,
    bool resetFilterStatus = false,
  }) {
    return OrdersState(
      orders: orders ?? this.orders,
      searchQuery: resetSearchQuery ? null : (searchQuery ?? this.searchQuery),
      filterStatus:
          resetFilterStatus ? null : (filterStatus ?? this.filterStatus),
    );
  }
}

// Notifier для управления списком заказов
@riverpod
class OrdersNotifier extends _$OrdersNotifier {
  StreamSubscription? _ordersSubscription;
  List<OrderModelComposite> _allOrders = []; // Кэш всех заказов

  @override
  OrdersState build() {
    _logger.d('OrdersNotifier: Initial build...');
    // Отписываемся от предыдущей подписки, если она есть
    _ordersSubscription?.cancel();

    // Подписываемся на поток заказов из сервиса
    final stream = ref.watch(orderServiceProvider).watchOrders();
    _ordersSubscription = stream.listen(
      (orders) {
        _logger
            .d('OrdersNotifier: Received ${orders.length} orders from stream.');
        _allOrders = orders; // Обновляем кэш
        _applyFiltersAndSearch(); // Применяем фильтры к новым данным
      },
      onError: (error, stackTrace) {
        _logger.e(LogMessages.orderWatchError,
            error: error, stackTrace: stackTrace);
        state = state.copyWith(orders: AsyncValue.error(error, stackTrace));
      },
    );

    // Управление отменой подписки при уничтожении Notifier'а
    ref.onDispose(() {
      _logger.d('OrdersNotifier: Disposing...');
      _ordersSubscription?.cancel();
    });

    // Начальное состояние - загрузка
    return OrdersState();
  }

  // Метод для применения фильтров и поиска к текущему кэшу _allOrders
  void _applyFiltersAndSearch() {
    var filtered = List<OrderModelComposite>.from(_allOrders);

    // Применяем extension методы для фильтрации
    // Сначала фильтруем только активные (не удаленные)
    filtered = filtered.activeOnly;

    // Фильтр по статусу с использованием extension метода
    if (state.filterStatus != null) {
      filtered = filtered.withStatus(state.filterStatus!.name);
    }

    // Поиск с использованием extension метода
    if (state.searchQuery != null && state.searchQuery!.isNotEmpty) {
      filtered = filtered.search(state.searchQuery!);
    }

    // Сортировка по дате документа с использованием extension метода
    filtered = filtered.sortByDocumentDate(descending: true);

    _logger
        .d('OrdersNotifier: Applied filters. Result count: ${filtered.length}');
    // Обновляем только часть 'orders' в состоянии
    state = state.copyWith(orders: AsyncValue.data(filtered));
  }

  void setFilterStatus(DocumentStatus? status) {
    _logger.d('OrdersNotifier: Setting filter status to $status');
    // Обновляем состояние фильтра и переприменяем фильтры
    state =
        state.copyWith(filterStatus: status, resetFilterStatus: status == null);
    _applyFiltersAndSearch();
  }

  void setSearchQuery(String? query) {
    final effectiveQuery = (query?.isNotEmpty ?? false) ? query : null;
    _logger.d('OrdersNotifier: Setting search query to "$effectiveQuery"');
    // Обновляем состояние поиска и переприменяем фильтры
    state = state.copyWith(
        searchQuery: effectiveQuery, resetSearchQuery: effectiveQuery == null);
    _applyFiltersAndSearch();
  }

  // Логгер получаем через ref
  Logger get _logger => ref.read(ordersLoggerProvider);
}