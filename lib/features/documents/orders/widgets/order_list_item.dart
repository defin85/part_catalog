import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// --- Обновленные импорты ---
import 'package:part_catalog/core/i18n/strings.g.dart'; // Используем slang
import 'package:part_catalog/features/core/base_item_type.dart'; // Для подсчета типов
import 'package:part_catalog/features/documents/orders/models/order_model_composite.dart'; // Используем композитор
// TODO: Рассмотреть возможность получения Client/Car имен через сервис или ViewModel
// import 'package:part_catalog/features/references/clients/services/client_service.dart';
// import 'package:part_catalog/features/references/vehicles/services/car_service.dart';
// import 'package:part_catalog/core/service_locator.dart';

class OrderListItem extends StatelessWidget {
  final OrderModelComposite order; // Используем композитор
  final VoidCallback? onTap;

  const OrderListItem({
    super.key,
    required this.order,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t = context.t; // Получаем доступ к slang
    // Используем локаль из контекста для форматирования
    final currentLocale = Localizations.localeOf(context);
    final dateFormat = DateFormat('dd.MM.yyyy', currentLocale.languageCode);
    final currencyFormat = NumberFormat.currency(
      locale: currentLocale.languageCode,
      symbol: '₽', // TODO: Сделать символ валюты настраиваемым
      decimalDigits: 2,
    );

    // Расчет общей суммы и количества элементов из itemsMap
    final totalAmount = order.items
        .fold<double>(0.0, (sum, item) => sum + (item.totalPrice ?? 0.0));
    final partsCount = order.getItemsByType(BaseItemType.part).length;
    final servicesCount = order.getItemsByType(BaseItemType.service).length;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12), // Немного увеличим радиус
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Верхняя часть с номером и статусом
              Row(
                children: [
                  Expanded(
                    child: Text(
                      // Используем code из coreData
                      t.orders.orderNumberFormat(number: order.code),
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
                      // Используем color и displayName из DocumentStatus
                      color: order.status.color.withAlpha((255 * 0.15).round()),
                      borderRadius:
                          BorderRadius.circular(16), // Сделаем более округлым
                    ),
                    child: Text(
                      order.status.displayName,
                      style: TextStyle(
                        color: order.status.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12), // Увеличим отступ

              // Информация о клиенте и автомобиле (отображаем ID или плейсхолдер)
              // TODO: Загружать и отображать имена клиента/автомобиля
              _buildInfoRow(
                icon: Icons.person_outline,
                // Используем clientId из orderData
                text: order.clientId != null
                    ? '${t.clients.client}: ${order.clientId!.substring(0, 8)}...' // Показываем часть UUID
                    : t.clients.clientNotSelected, // Используем slang
                theme: theme,
                hasData: order.clientId != null,
              ),
              const SizedBox(height: 4),
              _buildInfoRow(
                icon: Icons.directions_car_outlined,
                // Используем carId из orderData
                text: order.carId != null
                    ? '${t.vehicles.vehicle}: ${order.carId!.substring(0, 8)}...' // Показываем часть UUID
                    : t.vehicles.vehicleNotSelected, // Используем slang
                theme: theme,
                hasData: order.carId != null,
              ),
              const SizedBox(height: 12), // Увеличим отступ

              // Дата создания и дата выполнения
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    // Используем documentDate из docData
                    '${t.common.createdAt}: ${dateFormat.format(order.documentDate)}', // Используем slang
                    style: theme.textTheme.bodySmall,
                  ),
                  const Spacer(), // Занимаем доступное пространство
                  // Используем scheduledDate из docData
                  if (order.docData.scheduledDate != null) ...[
                    Icon(Icons.event_outlined,
                        size: 16, color: theme.colorScheme.secondary),
                    const SizedBox(width: 4),
                    Text(
                      '${t.orders.scheduledShort}: ${dateFormat.format(order.docData.scheduledDate!)}', // Используем slang
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 16), // Увеличим отступ

              // Нижняя часть с итоговой стоимостью и счетчиками
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormat.format(totalAmount),
                    style: theme.textTheme.titleMedium?.copyWith(
                      // Сделаем крупнее
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Row(
                    children: [
                      if (partsCount > 0) ...[
                        const Icon(Icons.settings_outlined,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '$partsCount', // Показываем только число
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(width: 12),
                      ],
                      if (servicesCount > 0) ...[
                        const Icon(Icons.build_outlined,
                            size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '$servicesCount', // Показываем только число
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Вспомогательный виджет для отображения строки информации (клиент/авто)
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

  // Функция для множественного числа больше не нужна здесь,
  // т.к. отображаем только количество.
  // Локализация форм множественного числа должна быть в slang файлах, если потребуется.
}
