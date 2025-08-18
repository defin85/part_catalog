import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:part_catalog/core/database/daos/orders_dao.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/references/clients/providers/client_providers.dart';
import 'package:part_catalog/features/references/vehicles/providers/car_providers.dart';

class OrderListItem extends ConsumerWidget {
  final OrderHeaderData orderHeader;
  final VoidCallback? onTap;

  const OrderListItem({
    super.key,
    required this.orderHeader,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final t = context.t;
    final currentLocale = Localizations.localeOf(context);
    final dateFormat = DateFormat('dd.MM.yyyy', currentLocale.languageCode);
    final currencyFormat = NumberFormat.currency(
      locale: currentLocale.languageCode,
      symbol: '₽',
      decimalDigits: 2,
    );

    final clientAsync =
        ref.watch(clientProvider(orderHeader.orderData.clientId!));
    final carAsync = ref.watch(carProvider(orderHeader.orderData.carId!));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      t.orders
                          .orderNumberFormat(number: orderHeader.coreData.code),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: orderHeader.docData.status.color
                          .withAlpha((255 * 0.15).round()),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      orderHeader.docData.status.displayName,
                      style: TextStyle(
                        color: orderHeader.docData.status.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              clientAsync.when(
                data: (client) => _buildInfoRow(
                  icon: Icons.person_outline,
                  text: client?.displayName ?? t.clients.clientNotFound,
                  theme: theme,
                  hasData: client != null,
                ),
                loading: () => _buildInfoRow(
                    icon: Icons.person_outline,
                    text: t.orders.loadingClient,
                    theme: theme),
                error: (e, s) => _buildInfoRow(
                    icon: Icons.person_outline,
                    text: t.errors.dataLoadingError,
                    theme: theme,
                    hasData: false),
              ),
              const SizedBox(height: 4),
              carAsync.when(
                data: (car) => _buildInfoRow(
                  icon: Icons.directions_car_outlined,
                  text: car?.displayName ?? t.vehicles.vehicleNotFound,
                  theme: theme,
                  hasData: car != null,
                ),
                loading: () => _buildInfoRow(
                    icon: Icons.directions_car_outlined,
                    text: t.orders.loadingVehicle,
                    theme: theme),
                error: (e, s) => _buildInfoRow(
                    icon: Icons.directions_car_outlined,
                    text: t.errors.dataLoadingError,
                    theme: theme,
                    hasData: false),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    '${t.common.createdAt}: ${dateFormat.format(orderHeader.docData.documentDate)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormat
                        .format(orderHeader.docData.totalAmount ?? 0.0),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
    required ThemeData theme,
    bool hasData = true,
  }) {
    return Row(
      children: [
        Icon(icon,
            size: 16,
            color: hasData ? Colors.grey.shade700 : Colors.grey.shade400),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: hasData ? null : Colors.grey.shade600,
              fontStyle: hasData ? FontStyle.normal : FontStyle.italic,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}