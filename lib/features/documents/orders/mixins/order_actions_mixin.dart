import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:part_catalog/core/database/daos/orders_dao.dart';
import 'package:part_catalog/features/documents/orders/screens/order_details_screen.dart';
import 'package:part_catalog/features/documents/orders/screens/order_form_screen.dart';

/// Mixin с общими действиями для работы с заказами
mixin OrderActionsMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {

  /// Создание нового заказа
  Future<void> createNewOrder({required VoidCallback onSuccess}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const OrderFormScreen(),
      ),
    );

    if (mounted && result == true) {
      onSuccess();
    }
  }

  /// Открытие деталей заказа
  void openOrderDetails(OrderHeaderData order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(
          orderUuid: order.coreData.uuid,
        ),
      ),
    );
  }

  /// Редактирование заказа
  void editOrder(OrderHeaderData order) {
    // TODO: Реализовать редактирование заказа
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Редактирование заказа ${order.coreData.uuid.substring(0, 8)}')),
    );
  }

  /// Удаление заказа
  void deleteOrder(OrderHeaderData order, {VoidCallback? onDeleted}) {
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
              onDeleted?.call();
            },
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }

  /// Копирование заказа
  void duplicateOrder(OrderHeaderData order, {VoidCallback? onDuplicated}) {
    // TODO: Реализовать копирование заказа
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Копирование заказа ${order.coreData.uuid.substring(0, 8)}')),
    );
    onDuplicated?.call();
  }
}