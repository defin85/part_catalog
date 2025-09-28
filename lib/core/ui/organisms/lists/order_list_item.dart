import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_spacing.dart';

import 'package:part_catalog/core/database/daos/orders_dao.dart';
import 'package:part_catalog/core/ui/atoms/typography/index.dart';
import 'package:part_catalog/core/ui/molecules/status_indicator.dart';

/// Компонент для отображения заказа в списке
class OrderListItem extends StatelessWidget {
  final OrderHeaderData order;
  final VoidCallback? onTap;
  final bool isSelected;
  final Widget? trailing;

  const OrderListItem({
    super.key,
    required this.order,
    this.onTap,
    this.isSelected = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: isSelected ? 2 : 0,
      color: isSelected ? colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: _getStatusColor(context),
                child: Icon(
                  Icons.description,
                  color: colorScheme.onPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BodyText(
                      'Заказ №${order.coreData.uuid.substring(0, 8)}',
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Caption(
                          _formatDate(order.coreData.createdAt),
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    StatusIndicator(
                      text: _getOrderStatus(),
                      status: _getOrderStatusType(),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: AppSpacing.sm),
                trailing!,
              ] else ...[
                Icon(
                  Icons.chevron_right,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getOrderStatus() {
    // TODO: Реализовать получение статуса из данных заказа
    return 'В работе';
  }

  StatusType _getOrderStatusType() {
    // TODO: Реализовать получение статуса из данных заказа
    return StatusType.info;
  }

  Color _getStatusColor(BuildContext context) {
    // TODO: Реализовать получение цвета статуса
    return Theme.of(context).colorScheme.primary;
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}