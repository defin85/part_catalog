import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/database/daos/orders_dao.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/documents/orders/providers/orders_pagination_provider.dart';
import 'package:part_catalog/features/documents/orders/screens/order_details_screen.dart';
import 'package:part_catalog/features/documents/orders/screens/order_form_screen.dart';
import 'package:part_catalog/features/documents/orders/widgets/order_list_item.dart';

// Преобразуем в ConsumerStatefulWidget
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

// Преобразуем State в ConsumerState
class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  final _scrollController = ScrollController();

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

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final ordersState = ref.watch(ordersPaginationNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.orders.screenTitle),
        // TODO: Адаптировать фильтрацию и поиск для пагинации
      ),
      body: ordersState.when(
        data: (state) {
          if (state.orders.isEmpty) {
            return Center(
              child: Text(
                t.orders.noOrdersFound,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }
          return ListView.builder(
            controller: _scrollController,
            itemCount: state.hasReachedMax ? state.orders.length : state.orders.length + 1,
            itemBuilder: (context, index) {
              if (index >= state.orders.length) {
                return const Center(child: CircularProgressIndicator());
              }
              final orderHeader = state.orders[index];
              return OrderListItem(
                orderHeader: orderHeader,
                onTap: () => _openOrderDetails(orderHeader),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            '${t.errors.dataLoadingError}: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: t.orders.add,
        onPressed: _createNewOrder,
        child: const Icon(Icons.add),
      ),
    );
  }

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

  void _openOrderDetails(OrderHeaderData orderHeader) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(
          orderUuid: orderHeader.coreData.uuid,
        ),
      ),
    );
  }
}
