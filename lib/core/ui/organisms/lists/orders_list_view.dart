import 'package:flutter/material.dart';
import 'package:part_catalog/core/database/daos/orders_dao.dart';
import 'package:part_catalog/core/ui/themes/app_spacing.dart';
import 'package:part_catalog/core/ui/molecules/empty_state_message.dart';
import 'package:part_catalog/core/ui/organisms/lists/order_list_item.dart';

/// Список заказов с поддержкой пагинации и выбора
class OrdersListView extends StatelessWidget {
  final List<OrderHeaderData> orders;
  final OrderHeaderData? selectedOrder;
  final ValueChanged<OrderHeaderData?> onOrderSelected;
  final ScrollController scrollController;
  final bool hasReachedMax;
  final bool isEmpty;

  const OrdersListView({
    super.key,
    required this.orders,
    required this.selectedOrder,
    required this.onOrderSelected,
    required this.scrollController,
    required this.hasReachedMax,
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isEmpty) {
      return const EmptyStateMessage(
        title: 'Заказы не найдены',
        subtitle: 'Попробуйте изменить параметры поиска или создать новый заказ',
      );
    }

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: hasReachedMax ? orders.length : orders.length + 1,
      itemBuilder: (context, index) {
        if (index >= orders.length) {
          return const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final order = orders[index];
        return OrderListItem(
          order: order,
          isSelected: selectedOrder?.coreData.uuid == order.coreData.uuid,
          onTap: () => onOrderSelected(order),
        );
      },
    );
  }
}