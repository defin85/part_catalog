import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:part_catalog/core/database/daos/orders_dao.dart';
import 'package:part_catalog/core/i18n/strings.g.dart';
import 'package:part_catalog/core/widgets/adaptive_card.dart';
import 'package:part_catalog/core/widgets/adaptive_container.dart';
import 'package:part_catalog/core/widgets/adaptive_text.dart';
import 'package:part_catalog/core/widgets/adaptive_icon.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';
import 'package:part_catalog/features/documents/orders/providers/orders_pagination_provider.dart';
import 'package:part_catalog/features/documents/orders/screens/order_details_screen.dart';
import 'package:part_catalog/features/documents/orders/screens/order_form_screen.dart';

/// Полностью адаптивный экран списка заказов
class AdaptiveOrdersScreen extends ConsumerStatefulWidget {
  const AdaptiveOrdersScreen({super.key});

  @override
  ConsumerState<AdaptiveOrdersScreen> createState() => _AdaptiveOrdersScreenState();
}

class _AdaptiveOrdersScreenState extends ConsumerState<AdaptiveOrdersScreen> {
  final _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  OrderHeaderData? _selectedOrder;
  String _statusFilter = '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      ref.read(ordersPaginationNotifierProvider.notifier).fetchNextPage();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    // TODO: Реализовать поиск заказов
  }

  void _selectOrder(OrderHeaderData? order) {
    setState(() {
      _selectedOrder = order;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;

    return ResponsiveLayoutBuilder(
      small: (context, constraints) => _buildMobileLayout(t),
      medium: (context, constraints) => _buildTabletLayout(t),
      large: (context, constraints) => _buildDesktopLayout(t),
      mediumBreakpoint: 600,
      largeBreakpoint: 1000,
    );
  }

  /// Mobile Layout - вертикальный список с поиском
  Widget _buildMobileLayout(dynamic t) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            t.orders.screenTitle.asAdaptiveHeadline(),
            'Управление заказами'.asAdaptiveCaption(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ],
        ),
        actions: [
          Icons.add.asAdaptiveActionIcon(
            onTap: () => _createNewOrder(),
            semanticLabel: t.orders.add,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Поиск и фильтры
          AdaptiveCard(
            context: AdaptiveCardContext.primary,
            child: _buildSearchAndFilters(ScreenSize.small, t),
          ),
          // Список заказов
          Expanded(
            child: _buildOrdersList(ScreenSize.small, t),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: t.orders.add,
        onPressed: _createNewOrder,
        child: Icons.add.asAdaptiveIcon(context: AdaptiveIconContext.fab),
      ),
    );
  }

  /// Tablet Layout - горизонтальный layout
  Widget _buildTabletLayout(dynamic t) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icons.list_alt.asAdaptiveNavigationIcon(),
            const SizedBox(width: 12),
            Expanded(
              child: 'Заказы'.asAdaptiveHeadline(),
            ),
          ],
        ),
        actions: [
          Icons.add.asAdaptiveActionIcon(
            onTap: () => _createNewOrder(),
            semanticLabel: t.orders.add,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Левая панель - список заказов с поиском
          Expanded(
            flex: 2,
            child: Column(
              children: [
                AdaptiveCard(
                  context: AdaptiveCardContext.list,
                  child: _buildSearchAndFilters(ScreenSize.medium, t),
                ),
                Expanded(
                  child: _buildOrdersList(ScreenSize.medium, t),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          // Правая панель - детали заказа
          Expanded(
            flex: 3,
            child: _buildOrderDetails(ScreenSize.medium, t),
          ),
        ],
      ),
    );
  }

  /// Desktop Layout - трехколоночный layout
  Widget _buildDesktopLayout(dynamic t) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icons.list_alt.asAdaptiveNavigationIcon(),
            const SizedBox(width: 16),
            'Управление заказами'.asAdaptiveHeadline(),
            const Spacer(),
            'Система заказов'.asAdaptiveBodySecondary(),
          ],
        ),
        actions: [
          Icons.analytics.asAdaptiveActionIcon(
            onTap: () => _showOrdersAnalytics(),
            semanticLabel: 'Аналитика заказов',
          ),
          const SizedBox(width: 8),
          Icons.import_export.asAdaptiveActionIcon(
            onTap: () => _showImportExportDialog(),
            semanticLabel: 'Импорт/Экспорт',
          ),
          const SizedBox(width: 8),
          Icons.add.asAdaptiveActionIcon(
            onTap: () => _createNewOrder(),
            semanticLabel: t.orders.add,
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Левая панель - поиск, фильтры и список заказов
          AdaptiveContainer.sidebar(
            child: Column(
              children: [
                _buildSearchAndFilters(ScreenSize.large, t),
                Expanded(
                  child: _buildOrdersList(ScreenSize.large, t),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          // Центральная панель - детали заказа
          Expanded(
            flex: 2,
            child: _buildOrderDetails(ScreenSize.large, t),
          ),
          const VerticalDivider(width: 1),
          // Правая панель - действия и статистика
          AdaptiveContainer(
            sizeConfig: const AdaptiveSizeConfig(
              desktopWidth: 300,
              minWidth: 250,
              maxWidth: 400,
            ),
            child: _buildActionsPanel(ScreenSize.large, t),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(ScreenSize screenSize, dynamic t) {
    return AdaptiveContainer(
      padding: EdgeInsets.all(_getSpacing(screenSize)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (screenSize == ScreenSize.large) ...[
            'Поиск и фильтры'.asAdaptiveSubheadline(),
            SizedBox(height: _getSpacing(screenSize)),
          ],

          // Поиск
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Поиск заказов',
              hintText: 'Номер заказа или клиент',
              border: const OutlineInputBorder(),
              prefixIcon: Icons.search.asAdaptiveButtonIcon(),
              suffixIcon: _searchController.text.isNotEmpty
                  ? Icons.clear.asAdaptiveButtonIcon(
                      onTap: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
            ),
            onChanged: _onSearchChanged,
          ),

          if (screenSize == ScreenSize.large) ...[
            SizedBox(height: _getSpacing(screenSize)),

            // Фильтры статуса
            'Статус заказа'.asAdaptiveBodySecondary(fontWeight: FontWeight.w600),
            SizedBox(height: _getSpacing(screenSize) * 0.5),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: 'Все'.asAdaptiveCaption(),
                  selected: _statusFilter.isEmpty,
                  onSelected: (selected) {
                    setState(() {
                      _statusFilter = '';
                    });
                  },
                ),
                FilterChip(
                  label: 'В работе'.asAdaptiveCaption(),
                  selected: _statusFilter == 'in_progress',
                  onSelected: (selected) {
                    setState(() {
                      _statusFilter = selected ? 'in_progress' : '';
                    });
                  },
                ),
                FilterChip(
                  label: 'Завершенные'.asAdaptiveCaption(),
                  selected: _statusFilter == 'completed',
                  onSelected: (selected) {
                    setState(() {
                      _statusFilter = selected ? 'completed' : '';
                    });
                  },
                ),
                FilterChip(
                  label: 'Отмененные'.asAdaptiveCaption(),
                  selected: _statusFilter == 'cancelled',
                  onSelected: (selected) {
                    setState(() {
                      _statusFilter = selected ? 'cancelled' : '';
                    });
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrdersList(ScreenSize screenSize, dynamic t) {
    final ordersAsync = ref.watch(ordersPaginationNotifierProvider);

    return ordersAsync.when(
      data: (state) => _buildOrdersListView(state, screenSize, t),
      loading: () => _buildLoadingIndicator(screenSize),
      error: (error, stack) => _buildErrorWidget(error, screenSize, t),
    );
  }

  Widget _buildOrdersListView(dynamic state, ScreenSize screenSize, dynamic t) {
    if (state.orders.isEmpty) {
      return _buildEmptyState(screenSize, t);
    }

    Widget listContent;

    if (screenSize == ScreenSize.large) {
      // Desktop: компактный список с выбором
      listContent = ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(_getSpacing(screenSize) * 0.5),
        itemCount: state.hasReachedMax ? state.orders.length : state.orders.length + 1,
        itemBuilder: (context, index) {
          if (index >= state.orders.length) {
            return AdaptiveCard(
              context: AdaptiveCardContext.list,
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          final order = state.orders[index];
          return AdaptiveCard(
            context: AdaptiveCardContext.list,
            isSelected: _selectedOrder?.coreData.uuid == order.coreData.uuid,
            onTap: () => _selectOrder(order),
            child: _buildOrderListTile(order, screenSize),
          );
        },
      );
    } else if (screenSize == ScreenSize.medium) {
      // Tablet: сетка карточек
      listContent = GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(_getSpacing(screenSize)),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 4,
          mainAxisSpacing: 12,
        ),
        itemCount: state.hasReachedMax ? state.orders.length : state.orders.length + 1,
        itemBuilder: (context, index) {
          if (index >= state.orders.length) {
            return AdaptiveCard(
              context: AdaptiveCardContext.grid,
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          final order = state.orders[index];
          return AdaptiveCard(
            context: AdaptiveCardContext.grid,
            isSelected: _selectedOrder?.coreData.uuid == order.coreData.uuid,
            onTap: () => _selectOrder(order),
            child: _buildOrderCard(order, screenSize),
          );
        },
      );
    } else {
      // Mobile: полные карточки
      listContent = ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(_getSpacing(screenSize)),
        itemCount: state.hasReachedMax ? state.orders.length : state.orders.length + 1,
        itemBuilder: (context, index) {
          if (index >= state.orders.length) {
            return AdaptiveCard(
              context: AdaptiveCardContext.primary,
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          final order = state.orders[index];
          return AdaptiveCard(
            context: AdaptiveCardContext.primary,
            onTap: () => _showOrderDetails(order),
            child: _buildOrderCard(order, screenSize),
          );
        },
      );
    }

    return listContent;
  }

  Widget _buildOrderListTile(OrderHeaderData order, ScreenSize screenSize) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getStatusColor(order),
        child: Icons.description.asAdaptiveIcon(
          context: AdaptiveIconContext.avatar,
          color: Colors.white,
        ),
      ),
      title: 'Заказ №${order.coreData.uuid.substring(0, 8)}'.asAdaptiveBody(fontWeight: FontWeight.w600),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          'Создан: ${_formatDate(order.coreData.createdAt)}'.asAdaptiveCaption(),
          _getStatusText(order).asAdaptiveCaption(color: _getStatusColor(order)),
        ],
      ),
      trailing: Icons.chevron_right.asAdaptiveIcon(
        context: AdaptiveIconContext.action,
      ),
    );
  }

  Widget _buildOrderCard(OrderHeaderData order, ScreenSize screenSize) {
    return Padding(
      padding: EdgeInsets.all(_getSpacing(screenSize)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: screenSize == ScreenSize.small ? 24 : 20,
                backgroundColor: _getStatusColor(order),
                child: Icons.description.asAdaptiveIcon(
                  context: AdaptiveIconContext.avatar,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: _getSpacing(screenSize)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    'Заказ №${order.coreData.uuid.substring(0, 8)}'.asAdaptiveBody(fontWeight: FontWeight.w600),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icons.calendar_today.asAdaptiveIcon(
                          context: AdaptiveIconContext.decorative,
                          customSize: 14,
                        ),
                        const SizedBox(width: 4),
                        _formatDate(order.coreData.createdAt).asAdaptiveCaption(),
                      ],
                    ),
                  ],
                ),
              ),
              if (screenSize != ScreenSize.small)
                Icons.more_vert.asAdaptiveActionIcon(
                  onTap: () => _showOrderActions(order),
                ),
            ],
          ),
          SizedBox(height: _getSpacing(screenSize) * 0.5),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(order).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _getStatusText(order).asAdaptiveCaption(
                  color: _getStatusColor(order),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (screenSize == ScreenSize.small)
                Icons.chevron_right.asAdaptiveIcon(
                  context: AdaptiveIconContext.action,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(ScreenSize screenSize, dynamic t) {
    if (_selectedOrder == null) {
      return _buildSelectOrderState(screenSize, t);
    }

    return AdaptiveContainer(
      padding: EdgeInsets.all(_getSpacing(screenSize)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Row(
            children: [
              'Детали заказа'.asAdaptiveSubheadline(),
              const Spacer(),
              Icons.edit.asAdaptiveActionIcon(
                onTap: () => _editOrder(_selectedOrder!),
                semanticLabel: 'Редактировать',
              ),
              const SizedBox(width: 8),
              Icons.delete.asAdaptiveActionIcon(
                onTap: () => _deleteOrder(_selectedOrder!),
                semanticLabel: 'Удалить',
                color: Theme.of(context).colorScheme.error,
              ),
            ],
          ),

          SizedBox(height: _getSpacing(screenSize)),

          // Основная информация
          AdaptiveCard(
            context: AdaptiveCardContext.nested,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                'Основная информация'.asAdaptiveBodySecondary(fontWeight: FontWeight.w600),
                SizedBox(height: _getSpacing(screenSize) * 0.5),
                _buildInfoRow('Номер', _selectedOrder!.coreData.uuid.substring(0, 8), screenSize),
                _buildInfoRow('Статус', _getStatusText(_selectedOrder!), screenSize),
                _buildInfoRow('Создан', _formatDate(_selectedOrder!.coreData.createdAt), screenSize),
                _buildInfoRow('Изменен', _selectedOrder!.coreData.modifiedAt != null ? _formatDate(_selectedOrder!.coreData.modifiedAt!) : 'Не изменялся', screenSize),
              ],
            ),
          ),

          SizedBox(height: _getSpacing(screenSize)),

          // Кнопки действий
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _openOrderDetails(_selectedOrder!),
                  icon: Icons.open_in_new.asAdaptiveButtonIcon(),
                  label: 'Открыть'.asAdaptiveBody(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _duplicateOrder(_selectedOrder!),
                  icon: Icons.copy.asAdaptiveButtonIcon(),
                  label: 'Копировать'.asAdaptiveBody(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ScreenSize screenSize) {
    return Padding(
      padding: EdgeInsets.only(bottom: _getSpacing(screenSize) * 0.25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: '$label:'.asAdaptiveCaption(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: value.isNotEmpty
                ? value.asAdaptiveCaption()
                : 'Не указано'.asAdaptiveCaption(
                    color: Theme.of(context).colorScheme.outline,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsPanel(ScreenSize screenSize, dynamic t) {
    return AdaptiveContainer(
      padding: EdgeInsets.all(_getSpacing(screenSize)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          'Быстрые действия'.asAdaptiveSubheadline(),
          SizedBox(height: _getSpacing(screenSize)),

          // Быстрые кнопки
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                onPressed: () => _createNewOrder(),
                icon: Icons.add.asAdaptiveButtonIcon(),
                label: 'Новый заказ'.asAdaptiveBody(),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _showOrdersAnalytics(),
                icon: Icons.analytics.asAdaptiveButtonIcon(),
                label: 'Аналитика'.asAdaptiveBody(),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _showImportExportDialog(),
                icon: Icons.import_export.asAdaptiveButtonIcon(),
                label: 'Импорт/Экспорт'.asAdaptiveBody(),
              ),
            ],
          ),

          const Divider(),

          'Статистика'.asAdaptiveSubheadline(),
          SizedBox(height: _getSpacing(screenSize)),

          // Статистика
          'Всего заказов: 234'.asAdaptiveCaption(),
          'В работе: 42'.asAdaptiveCaption(),
          'Завершено сегодня: 8'.asAdaptiveCaption(),
        ],
      ),
    );
  }

  Widget _buildSelectOrderState(ScreenSize screenSize, dynamic t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icons.list_alt_outlined.asAdaptiveIcon(
            context: AdaptiveIconContext.decorative,
            customSize: screenSize == ScreenSize.large ? 64 : 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _getSpacing(screenSize)),
          'Выберите заказ из списка'.asAdaptiveSubheadline(),
          SizedBox(height: _getSpacing(screenSize) * 0.5),
          'Информация о заказе появится здесь'.asAdaptiveCaption(),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(ScreenSize screenSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: _getSpacing(screenSize)),
          'Загрузка заказов...'.asAdaptiveBody(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ScreenSize screenSize, dynamic t) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icons.list_alt_outlined.asAdaptiveIcon(
            context: AdaptiveIconContext.decorative,
            customSize: screenSize == ScreenSize.large ? 64 : 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _getSpacing(screenSize)),
          'Нет заказов'.asAdaptiveSubheadline(),
          SizedBox(height: _getSpacing(screenSize) * 0.5),
          'Создайте первый заказ'.asAdaptiveCaption(),
          SizedBox(height: _getSpacing(screenSize)),
          ElevatedButton.icon(
            onPressed: () => _createNewOrder(),
            icon: Icons.add.asAdaptiveButtonIcon(),
            label: 'Создать заказ'.asAdaptiveBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(Object error, ScreenSize screenSize, dynamic t) {
    return Center(
      child: AdaptiveCard(
        context: AdaptiveCardContext.modal,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icons.error_outline.asAdaptiveIcon(
              context: AdaptiveIconContext.decorative,
              customSize: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: _getSpacing(screenSize)),
            'Ошибка загрузки'.asAdaptiveSubheadline(),
            SizedBox(height: _getSpacing(screenSize) * 0.5),
            error.toString().asAdaptiveCaption(
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: _getSpacing(screenSize)),
            ElevatedButton(
              onPressed: () => ref.refresh(ordersPaginationNotifierProvider),
              child: 'Повторить'.asAdaptiveBody(),
            ),
          ],
        ),
      ),
    );
  }

  // Вспомогательные методы
  Color _getStatusColor(OrderHeaderData order) {
    // TODO: Реализовать получение цвета статуса из данных заказа
    return Colors.blue; // Заглушка
  }

  String _getStatusText(OrderHeaderData order) {
    // TODO: Реализовать получение текста статуса из данных заказа
    return 'В работе'; // Заглушка
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  double _getSpacing(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.small:
        return 12.0;
      case ScreenSize.medium:
        return 16.0;
      case ScreenSize.large:
        return 20.0;
    }
  }

  // Действия
  void _createNewOrder() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const OrderFormScreen(),
      ),
    );

    if (mounted && result == true) {
      ref.invalidate(ordersPaginationNotifierProvider);
    }
  }

  void _openOrderDetails(OrderHeaderData order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsScreen(
          orderUuid: order.coreData.uuid,
        ),
      ),
    );
  }

  void _showOrderDetails(OrderHeaderData order) {
    // На мобильных устройствах показываем детали в новом экране
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: 'Заказ №${order.coreData.uuid.substring(0, 8)}'.asAdaptiveHeadline(),
          ),
          body: _buildOrderDetails(ScreenSize.small, context.t),
        ),
      ),
    );
  }

  void _showOrderActions(OrderHeaderData order) {
    // TODO: Реализовать меню действий для заказа
  }

  void _editOrder(OrderHeaderData order) {
    // TODO: Реализовать редактирование заказа
  }

  void _deleteOrder(OrderHeaderData order) {
    // TODO: Реализовать удаление заказа
  }

  void _duplicateOrder(OrderHeaderData order) {
    // TODO: Реализовать копирование заказа
  }

  void _showOrdersAnalytics() {
    // TODO: Реализовать аналитику заказов
  }

  void _showImportExportDialog() {
    // TODO: Реализовать импорт/экспорт заказов
  }
}