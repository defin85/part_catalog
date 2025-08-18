import 'package:flutter/material.dart';

import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/suppliers/models/base/part_price_response.dart';

class PartPriceListItem extends StatelessWidget {
  final PartPriceModel part;
  final VoidCallback? onTap;

  const PartPriceListItem({
    super.key,
    required this.part,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final theme = Theme.of(context);

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getSupplierColor(part.supplierName),
        child: Text(
          _getSupplierInitials(part.supplierName),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
      title: Text(
        part.name.isEmpty ? part.article : part.name,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${part.article} • ${part.brand}'),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                Icons.store,
                size: 16,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(width: 4),
              Text(
                part.supplierName,
                style: TextStyle(
                  color: theme.colorScheme.outline,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.local_shipping,
                size: 16,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(width: 4),
              Text(
                t.suppliers.partsSearch.daysCount(days: part.deliveryDays),
                style: TextStyle(
                  color: theme.colorScheme.outline,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${part.price.toStringAsFixed(2)} ₽',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: _getQuantityColor(part.quantity, theme),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${part.quantity} шт',
              style: TextStyle(
                fontSize: 12,
                color: _getQuantityTextColor(part.quantity, theme),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Color _getSupplierColor(String supplierName) {
    // Генерируем цвет на основе имени поставщика
    final hash = supplierName.hashCode;
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.amber,
    ];
    return colors[hash.abs() % colors.length];
  }

  String _getSupplierInitials(String supplierName) {
    if (supplierName.isEmpty) return '?';

    final words = supplierName.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}'.toUpperCase();
    } else {
      return supplierName.length >= 2
          ? supplierName.substring(0, 2).toUpperCase()
          : supplierName[0].toUpperCase();
    }
  }

  Color _getQuantityColor(int quantity, ThemeData theme) {
    if (quantity <= 0) {
      return theme.colorScheme.errorContainer;
    } else if (quantity < 5) {
      return theme.colorScheme.secondaryContainer;
    } else {
      return theme.colorScheme.primaryContainer;
    }
  }

  Color _getQuantityTextColor(int quantity, ThemeData theme) {
    if (quantity <= 0) {
      return theme.colorScheme.onErrorContainer;
    } else if (quantity < 5) {
      return theme.colorScheme.onSecondaryContainer;
    } else {
      return theme.colorScheme.onPrimaryContainer;
    }
  }
}