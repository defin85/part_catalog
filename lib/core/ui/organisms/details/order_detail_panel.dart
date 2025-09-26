import 'package:flutter/material.dart';

import 'package:part_catalog/core/database/daos/orders_dao.dart';
import 'package:part_catalog/core/ui/atoms/typography/index.dart';
import 'package:part_catalog/core/ui/molecules/empty_state_message.dart';
import 'package:part_catalog/core/ui/organisms/cards/info_card.dart';
import 'package:part_catalog/core/ui/organisms/forms/form_actions_bar.dart';
import 'package:part_catalog/core/ui/themes/app_spacing.dart';

/// Панель деталей заказа для MasterDetail интерфейса
class OrderDetailPanel extends StatelessWidget {
  final OrderHeaderData? order;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onOpen;
  final VoidCallback? onDuplicate;

  const OrderDetailPanel({
    super.key,
    this.order,
    this.onEdit,
    this.onDelete,
    this.onOpen,
    this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    if (order == null) {
      return const EmptyStateMessage(
        icon: Icon(Icons.list_alt_outlined),
        title: 'Выберите заказ',
        subtitle: 'Выберите заказ из списка для просмотра деталей',
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: _buildContent(context),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Heading(
                'Заказ №${order!.coreData.uuid.substring(0, 8)}',
                level: HeadingLevel.h2,
              ),
              const SizedBox(height: AppSpacing.xs),
              Caption(
                'Создан ${_formatDate(order!.coreData.createdAt)}',
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.edit),
          tooltip: 'Редактировать',
        ),
        IconButton(
          onPressed: onDelete,
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.error,
          ),
          tooltip: 'Удалить',
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          InfoCard(
            title: 'Основная информация',
            items: [
              InfoCardItem(
                label: 'Номер',
                value: order!.coreData.uuid.substring(0, 8),
              ),
              InfoCardItem(
                label: 'Статус',
                value: _getOrderStatus(),
              ),
              InfoCardItem(
                label: 'Создан',
                value: _formatDate(order!.coreData.createdAt),
              ),
              InfoCardItem(
                label: 'Изменен',
                value: order!.coreData.modifiedAt != null
                    ? _formatDate(order!.coreData.modifiedAt!)
                    : 'Не изменялся',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          InfoCard(
            title: 'Статистика',
            items: [
              InfoCardItem(
                label: 'Позиций',
                value: '0', // TODO: Подсчет позиций
              ),
              InfoCardItem(
                label: 'Сумма',
                value: '0 ₽', // TODO: Подсчет суммы
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return FormActionsBar(
      actions: [
        FormAction.primary(
          label: 'Открыть полностью',
          onPressed: onOpen,
          icon: Icons.open_in_new,
        ),
        FormAction.secondary(
          label: 'Копировать',
          onPressed: onDuplicate,
          icon: Icons.copy,
        ),
      ],
    );
  }

  String _getOrderStatus() {
    // TODO: Реализовать получение статуса из данных заказа
    return 'В работе';
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}

