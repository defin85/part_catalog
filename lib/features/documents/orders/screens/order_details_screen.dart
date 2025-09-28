import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:part_catalog/core/ui/index.dart';
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart';
import 'package:part_catalog/features/documents/orders/providers/order_providers.dart';

/// Экран деталей заказа с использованием новых UI компонентов
class OrderDetailsScreen extends ConsumerWidget {
  final String orderUuid;

  const OrderDetailsScreen({
    super.key,
    required this.orderUuid,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailsStreamProvider(orderUuid));

    return FormScreenScaffold(
      title: 'Детали заказа',
      isLoading: false,
      additionalActions: [
        FormAction(
          text: 'Редактировать',
          icon: const Icon(Icons.edit),
          onPressed: () => _editOrder(context),
        ),
        FormAction(
          text: 'Печать',
          icon: const Icon(Icons.print),
          onPressed: () => _printOrder(context),
        ),
      ],
      children: [
        orderAsync.when(
          loading: () => const LoadingOverlay(
            isLoading: true,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => EmptyStateMessage(
            icon: const Icon(Icons.error_outline),
            title: 'Ошибка загрузки',
            subtitle: error.toString(),
            action: ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Назад'),
            ),
          ),
          data: (order) => order != null
              ? _buildOrderDetails(context, order)
              : EmptyStateMessage(
                  icon: const Icon(Icons.receipt_long_outlined),
                  title: 'Заказ не найден',
                  subtitle: 'Заказ с указанным ID не существует',
                  action: ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Назад'),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildOrderDetails(BuildContext context, OrderModelComposite order) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Основная информация
          FormSection(
            title: 'Основная информация',
            children: [
              InfoCard(
                title: 'Номер заказа',
                subtitle: order.coreData.uuid.substring(0, 8),
              ),
              InfoCard(
                title: 'Статус',
                subtitle: order.docData.status.name,
              ),
              InfoCard(
                title: 'Клиент',
                subtitle: order.orderData.clientId ?? 'Не указан',
              ),
              InfoCard(
                title: 'Автомобиль',
                subtitle: order.orderData.carId ?? 'Не указан',
              ),
            ],
          ),

          const SizedBox(height: 16.0),

          // Даты
          FormSection(
            title: 'Даты',
            children: [
              InfoCard(
                title: 'Создан',
                subtitle: _formatDate(order.coreData.createdAt),
              ),
              if (order.coreData.modifiedAt != null)
                InfoCard(
                  title: 'Изменен',
                  subtitle: _formatDate(order.coreData.modifiedAt!),
                ),
            ],
          ),

          const SizedBox(height: 16.0),

          // Описание
          if (order.orderData.description?.isNotEmpty == true)
            FormSection(
              title: 'Описание',
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(order.orderData.description!),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  void _editOrder(BuildContext context) {
    // TODO: Implement order editing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Редактирование заказа')),
    );
  }

  void _printOrder(BuildContext context) {
    // TODO: Implement order printing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Печать заказа')),
    );
  }
}