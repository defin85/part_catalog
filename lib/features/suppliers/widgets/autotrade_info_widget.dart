import 'package:flutter/material.dart';

import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/features/suppliers/widgets/base_supplier_info_widget.dart';

/// Виджет информации для поставщика Autotrade
class AutotradeInfoWidget extends BaseSupplierInfoWidget {
  final Map<String, dynamic>? autotradeData;

  const AutotradeInfoWidget({
    super.key,
    this.autotradeData,
  }) : super(
          supplierCode: 'autotrade',
          supplierData: autotradeData,
        );

  @override
  BaseSupplierInfoWidgetState createState() => _AutotradeInfoWidgetState();
}

class _AutotradeInfoWidgetState
    extends BaseSupplierInfoWidgetState<AutotradeInfoWidget> {
  @override
  List<InfoCardData> buildInfoCards(Translations t) {
    final cards = <InfoCardData>[];

    // API статистика
    cards.add(InfoCardData(
      icon: Icons.api,
      title: 'API статистика',
      count: 1,
      color: Colors.blue,
      subtitle: 'Информация об API',
      onTap: () => selectItem('api_stats', widget.autotradeData),
    ));

    // Каталог запчастей
    cards.add(InfoCardData(
      icon: Icons.build,
      title: 'Каталог запчастей',
      count: widget.autotradeData?['partsCount'] ?? 0,
      color: Colors.green,
      subtitle: 'Доступные запчасти',
      onTap: () => selectItem('parts_catalog', widget.autotradeData?['parts']),
    ));

    // Производители
    cards.add(InfoCardData(
      icon: Icons.factory,
      title: 'Производители',
      count: widget.autotradeData?['manufacturersCount'] ?? 0,
      color: Colors.orange,
      subtitle: 'Доступные бренды',
      onTap: () =>
          selectItem('manufacturers', widget.autotradeData?['manufacturers']),
    ));

    // Настройки подключения
    cards.add(InfoCardData(
      icon: Icons.settings,
      title: 'Настройки',
      count: 1,
      color: Colors.purple,
      subtitle: 'Параметры API',
      onTap: () => selectItem('settings', widget.autotradeData?['settings']),
    ));

    return cards;
  }

  @override
  Widget buildDetailView(String itemType, Object? item, Translations t) {
    switch (itemType) {
      case 'overview':
        return _buildOverview(t);
      case 'api_stats':
        return _buildApiStats(t);
      case 'parts_catalog':
        return _buildPartsCatalog(item, t);
      case 'manufacturers':
        return _buildManufacturers(item, t);
      case 'settings':
        return _buildSettings(item, t);
      default:
        return const Center(child: Text('Выберите элемент для просмотра'));
    }
  }

  Widget _buildOverview(Translations t) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.store, size: 32, color: Colors.blue),
                const SizedBox(width: 12),
                Text(
                  'Autotrade API',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Поставщик автозапчастей с широким ассортиментом.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Специализация: каталог запчастей, поиск по VIN, кроссы.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('API версия', '2.0'),
            _buildInfoRow('Формат данных', 'JSON'),
            _buildInfoRow('Аутентификация', 'API Key'),
            _buildInfoRow('Лимит запросов', '1000/день'),
          ],
        ),
      ),
    );
  }

  Widget _buildApiStats(Translations t) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, size: 32, color: Colors.blue),
                const SizedBox(width: 12),
                Text(
                  'API статистика',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildStatCard('Запросов сегодня', '142', Colors.blue),
            const SizedBox(height: 8),
            _buildStatCard('Успешных ответов', '139', Colors.green),
            const SizedBox(height: 8),
            _buildStatCard('Ошибок', '3', Colors.red),
            const SizedBox(height: 8),
            _buildStatCard('Среднее время ответа', '1.2s', Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildPartsCatalog(Object? parts, Translations t) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.build, size: 32, color: Colors.green),
                const SizedBox(width: 12),
                Text(
                  'Каталог запчастей',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (parts is List) ...[
              Text('Найдено запчастей: ${parts.length}'),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: parts.take(5).length,
                itemBuilder: (context, index) {
                  final part = parts[index];
                  return ListTile(
                    leading: const Icon(Icons.build),
                    title: Text(part.toString()),
                    subtitle: Text('Артикул: ${index + 1000}'),
                  );
                },
              ),
            ] else ...[
              const Text('Каталог запчастей недоступен'),
              const SizedBox(height: 8),
              Text(
                'Для просмотра каталога необходимо загрузить данные через API.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildManufacturers(Object? manufacturers, Translations t) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.factory, size: 32, color: Colors.orange),
                const SizedBox(width: 12),
                Text(
                  'Производители',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (manufacturers is List) ...[
              Text('Доступно производителей: ${manufacturers.length}'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: manufacturers.take(10).map<Widget>((manufacturer) {
                  return Chip(
                    label: Text(manufacturer.toString()),
                    backgroundColor: Colors.orange.withValues(alpha: 0.1),
                  );
                }).toList(),
              ),
            ] else ...[
              // Примеры производителей
              const Text('Популярные производители:'),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Bosch',
                  'Mann',
                  'Mahle',
                  'Febi',
                  'Lemforder',
                  'SKF',
                  'Gates',
                  'Continental',
                  'Sachs',
                  'Bilstein'
                ].map((brand) {
                  return Chip(
                    label: Text(brand),
                    backgroundColor: Colors.orange.withValues(alpha: 0.1),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSettings(Object? settings, Translations t) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.settings, size: 32, color: Colors.purple),
                const SizedBox(width: 12),
                Text(
                  'Настройки API',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Base URL', 'https://api2.autotrade.su'),
            _buildInfoRow('Версия API', 'v2'),
            _buildInfoRow('Формат ответа', 'JSON'),
            _buildInfoRow('Кодировка', 'UTF-8'),
            _buildInfoRow('Таймаут', '30 секунд'),
            _buildInfoRow('Повторные попытки', '3'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Особенности API:',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('• Поддержка поиска по артикулу'),
                  const Text('• Поиск аналогов и кроссов'),
                  const Text('• Информация о наличии и ценах'),
                  const Text('• Возможность заказа через API'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.analytics, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(title),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}