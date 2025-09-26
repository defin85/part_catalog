import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:part_catalog/core/database/daos/orders_dao.dart';
import 'package:part_catalog/core/ui/index.dart';
import 'package:part_catalog/features/documents/orders/providers/orders_pagination_provider.dart';
import 'package:part_catalog/features/documents/orders/screens/order_details_screen.dart';
import 'package:part_catalog/features/documents/orders/screens/order_form_screen.dart';

/// Рефакторенный экран заказов с использованием новых UI компонентов
class RefactoredOrdersScreen extends ConsumerStatefulWidget {
  const RefactoredOrdersScreen({super.key});

  @override
  ConsumerState<RefactoredOrdersScreen> createState() => _RefactoredOrdersScreenState();
}

class _RefactoredOrdersScreenState extends ConsumerState<RefactoredOrdersScreen> {
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
      // TODO: Реализовать фильтрацию по статусу
      filtered = filtered; // Заглушка
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
        onEdit: () => _editOrder(_selectedOrder!),
        onDelete: () => _deleteOrder(_selectedOrder!),
        onOpen: () => _openOrderDetails(_selectedOrder!),
        onDuplicate: () => _duplicateOrder(_selectedOrder!),
      ) : null,
      showDetailPanel: _selectedOrder != null,
      onCloseDetail: () => _selectOrder(null),
      // FAB для создания нового заказа
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewOrder,
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
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            children: [
              // Поиск
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Поиск заказов по номеру',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.md),
              // Фильтры статуса
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: const Text('Все'),
                    selected: _statusFilter.isEmpty,
                    onSelected: (selected) {
                      setState(() {
                        _statusFilter = '';
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('В работе'),
                    selected: _statusFilter == 'in_progress',
                    onSelected: (selected) {
                      setState(() {
                        _statusFilter = selected ? 'in_progress' : '';
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('Завершенные'),
                    selected: _statusFilter == 'completed',
                    onSelected: (selected) {
                      setState(() {
                        _statusFilter = selected ? 'completed' : '';
                      });
                    },
                  ),
                  FilterChip(
                    label: const Text('Отмененные'),
                    selected: _statusFilter == 'cancelled',
                    onSelected: (selected) {
                      setState(() {
                        _statusFilter = selected ? 'cancelled' : '';
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Список заказов
        Expanded(
          child: filteredOrders.isEmpty
              ? const EmptyStateMessage(
                  title: 'Заказы не найдены',
                  subtitle: 'Попробуйте изменить параметры поиска или создать новый заказ',
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  itemCount: state.hasReachedMax ? filteredOrders.length : filteredOrders.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= filteredOrders.length) {
                      return const Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final order = filteredOrders[index];
                    return OrderListItem(
                      order: order,
                      isSelected: _selectedOrder?.coreData.uuid == order.coreData.uuid,
                      onTap: () => _selectOrder(order),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // Действия
  void _createNewOrder() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const OrderFormScreen(),
      ),
    );

    if (mounted && result == true) {
      ref.invalidate(ordersPaginationNotifierProvider);
    }
  }

  void _openOrderDetails(OrderHeaderData order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(
          orderUuid: order.coreData.uuid,
        ),
      ),
    );
  }

  void _editOrder(OrderHeaderData order) {
    // TODO: Реализовать редактирование заказа
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Редактирование заказа ${order.coreData.uuid.substring(0, 8)}')),
    );
  }

  void _deleteOrder(OrderHeaderData order) {
    // TODO: Реализовать удаление заказа
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Подтверждение'),
        content: Text('Удалить заказ №${order.coreData.uuid.substring(0, 8)}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Удалить заказ
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Заказ удален')),
              );
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  void _duplicateOrder(OrderHeaderData order) {
    // TODO: Реализовать копирование заказа
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Копирование заказа ${order.coreData.uuid.substring(0, 8)}')),
    );
  }
}