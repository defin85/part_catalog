import 'package:flutter/material.dart';

import 'package:part_catalog/core/i18n/strings.g.dart';

/// Данные для карточки информации
class InfoCardData {
  final IconData icon;
  final String title;
  final int count;
  final Color color;
  final VoidCallback? onTap;
  final String? subtitle;

  const InfoCardData({
    required this.icon,
    required this.title,
    required this.count,
    required this.color,
    this.onTap,
    this.subtitle,
  });
}

/// Базовый абстрактный виджет для отображения информации о поставщике
/// Каждый поставщик должен реализовать свою версию этого виджета
abstract class BaseSupplierInfoWidget extends StatefulWidget {
  final String supplierCode;
  final Map<String, dynamic>? supplierData;

  const BaseSupplierInfoWidget({
    super.key,
    required this.supplierCode,
    this.supplierData,
  });

  @override
  BaseSupplierInfoWidgetState createState();
}

abstract class BaseSupplierInfoWidgetState<T extends BaseSupplierInfoWidget>
    extends State<T> {
  Object? _selectedItem;
  String _selectedItemType = '';

  @override
  void initState() {
    super.initState();
    _selectedItemType = 'overview';
    _selectedItem = widget.supplierData;
  }

  /// Каждый поставщик должен реализовать свой список карточек
  List<InfoCardData> buildInfoCards(Translations t);

  /// Каждый поставщик должен реализовать отображение деталей для выбранного элемента
  Widget buildDetailView(String itemType, Object? item, Translations t);

  /// Общий метод для создания карточки информации
  Widget buildCompactInfoCard(InfoCardData cardData) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: cardData.onTap,
        borderRadius: BorderRadius.circular(8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 50
                ? 2.0
                : (constraints.maxWidth < 100 ? 4.0 : 12.0);
            final verticalPadding = constraints.maxWidth < 50
                ? 2.0
                : (constraints.maxWidth < 100 ? 3.0 : 8.0);

            return Container(
              padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding, vertical: verticalPadding),
              decoration: BoxDecoration(
                border: Border.all(
                  color: cardData.color.withValues(alpha: 0.3),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // Иконка
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 80) {
                        final iconPadding =
                            constraints.maxWidth < 120 ? 3.0 : 6.0;
                        final iconSize =
                            constraints.maxWidth < 120 ? 12.0 : 16.0;
                        return Container(
                          padding: EdgeInsets.all(iconPadding),
                          decoration: BoxDecoration(
                            color: cardData.color.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(cardData.icon,
                              color: cardData.color, size: iconSize),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  // Отступ
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 80) {
                        return SizedBox(
                            width: constraints.maxWidth < 120 ? 4 : 8);
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                  // Текст
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              cardData.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        if (cardData.subtitle != null)
                          Text(
                            cardData.subtitle!,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withValues(alpha: 0.7),
                                      fontSize: 10,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        Text(
                          '${cardData.count}',
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: cardData.color,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Метод для обновления выбранного элемента
  void selectItem(String itemType, Object? item) {
    setState(() {
      _selectedItemType = itemType;
      _selectedItem = item;
    });
  }

  /// Геттеры для доступа к состоянию из наследников
  String get selectedItemType => _selectedItemType;
  Object? get selectedItem => _selectedItem;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isLargeScreen = screenWidth >= 850;

    if (isLargeScreen) {
      // Desktop layout - Master-Detail
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Master panel - карточки навигации
          SizedBox(
            width: screenWidth * 0.3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Информация ${widget.supplierCode}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  // Карточки информации
                  ...buildInfoCards(t).map((cardData) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: buildCompactInfoCard(cardData),
                      )),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Detail panel
          Expanded(
            child: SingleChildScrollView(
              child: buildDetailView(_selectedItemType, _selectedItem, t),
            ),
          ),
        ],
      );
    } else {
      // Mobile layout - стек с табами
      return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Обзор'),
                Tab(text: 'Детали'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Обзор - карточки
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        ...buildInfoCards(t).map((cardData) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: buildCompactInfoCard(cardData),
                            )),
                      ],
                    ),
                  ),
                  // Детали
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: buildDetailView(_selectedItemType, _selectedItem, t),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
