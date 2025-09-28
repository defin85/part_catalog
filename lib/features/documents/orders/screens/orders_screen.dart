import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:part_catalog/core/database/daos/orders_dao.dart';
import 'package:part_catalog/core/ui/index.dart';
import 'package:part_catalog/core/ui/organisms/filters/order_filters_panel.dart';
import 'package:part_catalog/core/ui/organisms/lists/orders_list_view.dart';
import 'package:part_catalog/features/documents/orders/mixins/order_actions_mixin.dart';
import 'package:part_catalog/features/documents/orders/providers/orders_pagination_provider.dart';

/// Экран заказов с использованием новых UI компонентов
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> with OrderActionsMixin {
  final _scrollController = ScrollController();
  OrderHeaderData? _selectedOrder;
  String _searchQuery = '';
  String _statusFilter = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      ref.read(ordersPaginationNotifierProvider.notifier).fetchNextPage();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _selectOrder(OrderHeaderData? order) {
    setState(() {
      _selectedOrder = order;
    });
  }

  List<OrderHeaderData> _filterOrders(List<OrderHeaderData> orders) {
    var filtered = orders;

    // Поиск по тексту
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((order) {
        return order.coreData.uuid.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // Фильтр по статусу
    if (_statusFilter.isNotEmpty) {
      filtered = filtered.where((order) {
        return order.docData.status.name == _statusFilter;
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final ordersAsync = ref.watch(ordersPaginationNotifierProvider);

    return MasterDetailScaffold(
      title: 'Заказы',
      masterPanel: ordersAsync.when(
        data: (state) => _buildMasterPanel(state),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              const Text('Ошибка загрузки'),
              const SizedBox(height: 8),
              Text(error.toString()),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(ordersPaginationNotifierProvider),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
      detailPanel: _selectedOrder != null ? OrderDetailPanel(
        order: _selectedOrder!,
        onEdit: () => editOrder(_selectedOrder!),
        onDelete: () => deleteOrder(_selectedOrder!),
        onOpen: () => openOrderDetails(_selectedOrder!),
        onDuplicate: () => duplicateOrder(_selectedOrder!),
      ) : null,
      showDetailPanel: _selectedOrder != null,
      onCloseDetail: () => _selectOrder(null),
      // FAB для создания нового заказа
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => createNewOrder(
          onSuccess: () => ref.invalidate(ordersPaginationNotifierProvider),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Создать заказ'),
      ),
    );
  }

  Widget _buildMasterPanel(dynamic state) {
    final filteredOrders = _filterOrders(state.orders);

    return Column(
      children: [
        // Поиск и фильтры
        OrderFiltersPanel(
          searchQuery: _searchQuery,
          statusFilter: _statusFilter,
          onSearchChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          onStatusFilterChanged: (value) {
            setState(() {
              _statusFilter = value;
            });
          },
        ),
        const Divider(height: 1),
        // Список заказов
        Expanded(
          child: OrdersListView(
            orders: filteredOrders,
            selectedOrder: _selectedOrder,
            onOrderSelected: _selectOrder,
            scrollController: _scrollController,
            hasReachedMax: state.hasReachedMax,
            isEmpty: filteredOrders.isEmpty,
          ),
        ),
      ],
    );
  }

}