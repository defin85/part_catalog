import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:part_catalog/core/widgets/adaptive_card.dart';
import 'package:part_catalog/core/widgets/adaptive_container.dart';
import 'package:part_catalog/core/widgets/adaptive_text.dart';
import 'package:part_catalog/core/widgets/adaptive_icon.dart';
import 'package:part_catalog/core/widgets/responsive_layout_builder.dart';
import 'package:part_catalog/features/references/clients/models/client_model_composite.dart';
import 'package:part_catalog/features/references/clients/providers/client_providers.dart';

/// Полностью адаптивный экран списка клиентов
class AdaptiveClientsScreen extends ConsumerStatefulWidget {
  const AdaptiveClientsScreen({super.key});

  @override
  ConsumerState<AdaptiveClientsScreen> createState() => _AdaptiveClientsScreenState();
}

class _AdaptiveClientsScreenState extends ConsumerState<AdaptiveClientsScreen> {
  final TextEditingController _searchController = TextEditingController();
  ClientModelComposite? _selectedClient;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // TODO: Реализовать поиск клиентов
  }

  void _selectClient(ClientModelComposite? client) {
    setState(() {
      _selectedClient = client;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayoutBuilder(
      small: (context, constraints) => _buildMobileLayout(),
      medium: (context, constraints) => _buildTabletLayout(),
      large: (context, constraints) => _buildDesktopLayout(),
      mediumBreakpoint: 600,
      largeBreakpoint: 1000,
    );
  }

  /// Mobile Layout - вертикальный список с поиском
  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            'Клиенты'.asAdaptiveHeadline(),
            'Справочник клиентов'.asAdaptiveCaption(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ],
        ),
        actions: [
          Icons.person_add.asAdaptiveActionIcon(
            onTap: () => _showAddClientDialog(),
            semanticLabel: 'Добавить клиента',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Поиск
          AdaptiveCard(
            context: AdaptiveCardContext.primary,
            child: _buildSearchBar(ScreenSize.small),
          ),
          // Список клиентов
          Expanded(
            child: _buildClientsList(ScreenSize.small),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddClientDialog(),
        child: Icons.add.asAdaptiveIcon(context: AdaptiveIconContext.fab),
      ),
    );
  }

  /// Tablet Layout - горизонтальный layout
  Widget _buildTabletLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icons.people.asAdaptiveNavigationIcon(),
            const SizedBox(width: 12),
            Expanded(
              child: 'Справочник клиентов'.asAdaptiveHeadline(),
            ),
          ],
        ),
        actions: [
          Icons.person_add.asAdaptiveActionIcon(
            onTap: () => _showAddClientDialog(),
            semanticLabel: 'Добавить клиента',
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Левая панель - список клиентов с поиском
          Expanded(
            flex: 2,
            child: Column(
              children: [
                AdaptiveCard(
                  context: AdaptiveCardContext.list,
                  child: _buildSearchBar(ScreenSize.medium),
                ),
                Expanded(
                  child: _buildClientsList(ScreenSize.medium),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          // Правая панель - детали клиента
          Expanded(
            flex: 3,
            child: _buildClientDetails(ScreenSize.medium),
          ),
        ],
      ),
    );
  }

  /// Desktop Layout - трехколоночный layout
  Widget _buildDesktopLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icons.people.asAdaptiveNavigationIcon(),
            const SizedBox(width: 16),
            'Справочник клиентов'.asAdaptiveHeadline(),
            const Spacer(),
            'Управление клиентами'.asAdaptiveBodySecondary(),
          ],
        ),
        actions: [
          Icons.import_export.asAdaptiveActionIcon(
            onTap: () => _showImportExportDialog(),
            semanticLabel: 'Импорт/Экспорт',
          ),
          const SizedBox(width: 8),
          Icons.person_add.asAdaptiveActionIcon(
            onTap: () => _showAddClientDialog(),
            semanticLabel: 'Добавить клиента',
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          // Левая панель - список клиентов с поиском и фильтрами
          _DryLayoutSafeSidebar(
            child: Column(
              children: [
                _buildSearchAndFilters(ScreenSize.large),
                Expanded(
                  child: _buildClientsList(ScreenSize.large),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          // Центральная панель - детали клиента
          Expanded(
            flex: 2,
            child: _buildClientDetails(ScreenSize.large),
          ),
          const VerticalDivider(width: 1),
          // Правая панель - действия и статистика
          AdaptiveContainer(
            sizeConfig: const AdaptiveSizeConfig(
              desktopWidth: 300,
              minWidth: 250,
              maxWidth: 400,
            ),
            child: _buildActionsPanel(ScreenSize.large),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ScreenSize screenSize) {
    return Padding(
      padding: EdgeInsets.all(_getSpacing(screenSize)),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'Поиск клиентов',
          hintText: 'Введите имя, телефон или email',
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
    );
  }

  Widget _buildSearchAndFilters(ScreenSize screenSize) {
    return AdaptiveContainer(
      padding: EdgeInsets.all(_getSpacing(screenSize)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          'Поиск и фильтры'.asAdaptiveSubheadline(),
          SizedBox(height: _getSpacing(screenSize)),

          // Поиск
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Поиск',
              border: const OutlineInputBorder(),
              prefixIcon: Icons.search.asAdaptiveButtonIcon(),
            ),
            onChanged: _onSearchChanged,
          ),

          SizedBox(height: _getSpacing(screenSize)),

          // Фильтры
          'Фильтры'.asAdaptiveBodySecondary(fontWeight: FontWeight.w600),
          SizedBox(height: _getSpacing(screenSize) * 0.5),

          Column(
            children: [
              _buildFilterChip('Активные', true, () {}),
              const SizedBox(height: 4),
              _buildFilterChip('Физ. лица', false, () {}),
              const SizedBox(height: 4),
              _buildFilterChip('Юр. лица', false, () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildClientsList(ScreenSize screenSize) {
    final clientsAsync = ref.watch(clientsNotifierProvider);

    return clientsAsync.when(
      data: (clients) => _buildClientsListView(clients, screenSize),
      loading: () => _buildLoadingIndicator(screenSize),
      error: (error, stack) => _buildErrorWidget(error, screenSize),
    );
  }

  Widget _buildClientsListView(List<ClientModelComposite> clients, ScreenSize screenSize) {
    if (clients.isEmpty) {
      return _buildEmptyState(screenSize);
    }

    if (screenSize == ScreenSize.large) {
      // Desktop: компактный список
      return ListView.builder(
        padding: EdgeInsets.all(_getSpacing(screenSize) * 0.5),
        itemCount: clients.length,
        itemBuilder: (context, index) => AdaptiveCard(
          context: AdaptiveCardContext.list,
          isSelected: _selectedClient?.uuid == clients[index].uuid,
          onTap: () => _selectClient(clients[index]),
          child: _buildClientListTile(clients[index], screenSize),
        ),
      );
    } else if (screenSize == ScreenSize.medium) {
      // Tablet: средние карточки
      return ListView.builder(
        padding: EdgeInsets.all(_getSpacing(screenSize)),
        itemCount: clients.length,
        itemBuilder: (context, index) => AdaptiveCard(
          context: AdaptiveCardContext.list,
          isSelected: _selectedClient?.uuid == clients[index].uuid,
          onTap: () => _selectClient(clients[index]),
          child: _buildClientCard(clients[index], screenSize),
        ),
      );
    } else {
      // Mobile: полные карточки
      return ListView.builder(
        padding: EdgeInsets.all(_getSpacing(screenSize)),
        itemCount: clients.length,
        itemBuilder: (context, index) => AdaptiveCard(
          context: AdaptiveCardContext.primary,
          onTap: () => _showClientDetails(clients[index]),
          child: _buildClientCard(clients[index], screenSize),
        ),
      );
    }
  }

  Widget _buildClientListTile(ClientModelComposite client, ScreenSize screenSize) {
    return ListTile(
      leading: CircleAvatar(
        child: client.displayName.isNotEmpty
            ? client.displayName[0].toUpperCase().asAdaptiveBody(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              )
            : Icons.person.asAdaptiveIcon(
                context: AdaptiveIconContext.avatar,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
      ),
      title: client.displayName.asAdaptiveBody(fontWeight: FontWeight.w600),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (client.clientData.contactInfo.isNotEmpty) client.clientData.contactInfo.asAdaptiveCaption(),
          // Дополнительная информация также из contactInfo
        ],
      ),
      trailing: Icons.chevron_right.asAdaptiveIcon(
        context: AdaptiveIconContext.action,
      ),
    );
  }

  Widget _buildClientCard(ClientModelComposite client, ScreenSize screenSize) {
    return Padding(
      padding: EdgeInsets.all(_getSpacing(screenSize)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: screenSize == ScreenSize.small ? 24 : 20,
                child: client.displayName.isNotEmpty
                    ? client.displayName[0].toUpperCase().asAdaptiveBody(
                        color: Theme.of(context).colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                      )
                    : Icons.person.asAdaptiveIcon(
                        context: AdaptiveIconContext.avatar,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
              ),
              SizedBox(width: _getSpacing(screenSize)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    client.displayName.asAdaptiveBody(fontWeight: FontWeight.w600),
                    if (client.clientData.contactInfo.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icons.phone.asAdaptiveIcon(
                            context: AdaptiveIconContext.decorative,
                            customSize: 14,
                          ),
                          const SizedBox(width: 4),
                          client.clientData.contactInfo.asAdaptiveCaption(),
                        ],
                      ),
                    ],
                    // Email теперь включен в contactInfo
                  ],
                ),
              ),
              if (screenSize != ScreenSize.small)
                Icons.more_vert.asAdaptiveActionIcon(
                  onTap: () => _showClientActions(client),
                ),
            ],
          ),
          if (screenSize == ScreenSize.small) ...[
            SizedBox(height: _getSpacing(screenSize) * 0.5),
            Row(
              children: [
                if (client.clientData.additionalInfo != null && client.clientData.additionalInfo!.isNotEmpty) ...[
                  Icons.location_on.asAdaptiveIcon(
                    context: AdaptiveIconContext.decorative,
                    customSize: 14,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: client.clientData.additionalInfo!.asAdaptiveCaption(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildClientDetails(ScreenSize screenSize) {
    if (_selectedClient == null) {
      return _buildSelectClientState(screenSize);
    }

    return AdaptiveContainer(
      padding: EdgeInsets.all(_getSpacing(screenSize)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок
          Row(
            children: [
              'Информация о клиенте'.asAdaptiveSubheadline(),
              const Spacer(),
              Icons.edit.asAdaptiveActionIcon(
                onTap: () => _editClient(_selectedClient!),
                semanticLabel: 'Редактировать',
              ),
              const SizedBox(width: 8),
              Icons.delete.asAdaptiveActionIcon(
                onTap: () => _deleteClient(_selectedClient!),
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
                _buildInfoRow('Имя', _selectedClient!.displayName, screenSize),
                _buildInfoRow('Контакты', _selectedClient!.clientData.contactInfo, screenSize),
                // Email включен в контактную информацию
                if (_selectedClient!.clientData.additionalInfo != null && _selectedClient!.clientData.additionalInfo!.isNotEmpty)
                  _buildInfoRow('Доп. информация', _selectedClient!.clientData.additionalInfo!, screenSize),
              ],
            ),
          ),

          SizedBox(height: _getSpacing(screenSize)),

          // Дополнительная информация
          AdaptiveCard(
            context: AdaptiveCardContext.nested,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                'Дополнительная информация'.asAdaptiveBodySecondary(fontWeight: FontWeight.w600),
                SizedBox(height: _getSpacing(screenSize) * 0.5),
                _buildInfoRow('Создан', _selectedClient!.createdAt.toString(), screenSize),
                _buildInfoRow('Изменен', _selectedClient!.modifiedAt.toString(), screenSize),
              ],
            ),
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

  Widget _buildActionsPanel(ScreenSize screenSize) {
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
                onPressed: () => _showAddClientDialog(),
                icon: Icons.person_add.asAdaptiveButtonIcon(),
                label: 'Добавить клиента'.asAdaptiveBody(),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _showImportExportDialog(),
                icon: Icons.import_export.asAdaptiveButtonIcon(),
                label: 'Импорт/Экспорт'.asAdaptiveBody(),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => _showStatistics(),
                icon: Icons.analytics.asAdaptiveButtonIcon(),
                label: 'Статистика'.asAdaptiveBody(),
              ),
            ],
          ),

          const Divider(),

          'Статистика'.asAdaptiveSubheadline(),
          SizedBox(height: _getSpacing(screenSize)),

          // Статистика
          'Всего клиентов: 156'.asAdaptiveCaption(),
          'Активных: 142'.asAdaptiveCaption(),
          'Добавлено сегодня: 3'.asAdaptiveCaption(),
        ],
      ),
    );
  }

  Widget _buildSelectClientState(ScreenSize screenSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icons.person_outline.asAdaptiveIcon(
            context: AdaptiveIconContext.decorative,
            customSize: screenSize == ScreenSize.large ? 64 : 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _getSpacing(screenSize)),
          'Выберите клиента из списка'.asAdaptiveSubheadline(),
          SizedBox(height: _getSpacing(screenSize) * 0.5),
          'Информация о клиенте появится здесь'.asAdaptiveCaption(),
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
          'Загрузка клиентов...'.asAdaptiveBody(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ScreenSize screenSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icons.people_outline.asAdaptiveIcon(
            context: AdaptiveIconContext.decorative,
            customSize: screenSize == ScreenSize.large ? 64 : 48,
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _getSpacing(screenSize)),
          'Нет клиентов'.asAdaptiveSubheadline(),
          SizedBox(height: _getSpacing(screenSize) * 0.5),
          'Добавьте первого клиента'.asAdaptiveCaption(),
          SizedBox(height: _getSpacing(screenSize)),
          ElevatedButton.icon(
            onPressed: () => _showAddClientDialog(),
            icon: Icons.person_add.asAdaptiveButtonIcon(),
            label: 'Добавить клиента'.asAdaptiveBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(Object error, ScreenSize screenSize) {
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
              onPressed: () => ref.refresh(clientsNotifierProvider),
              child: 'Повторить'.asAdaptiveBody(),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddClientDialog() {
    // TODO: Реализовать диалог добавления клиента
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: 'Добавить клиента'.asAdaptiveSubheadline(),
        content: 'Форма добавления клиента будет здесь'.asAdaptiveBody(),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: 'Отмена'.asAdaptiveBody(),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: 'Добавить'.asAdaptiveBody(),
          ),
        ],
      ),
    );
  }

  void _showClientDetails(ClientModelComposite client) {
    // На мобильных устройствах показываем детали в новом экране
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: client.displayName.asAdaptiveHeadline(),
          ),
          body: _buildClientDetails(ScreenSize.small),
        ),
      ),
    );
  }

  void _showClientActions(ClientModelComposite client) {
    // TODO: Реализовать меню действий для клиента
  }

  void _editClient(ClientModelComposite client) {
    // TODO: Реализовать редактирование клиента
  }

  void _deleteClient(ClientModelComposite client) {
    // TODO: Реализовать удаление клиента
  }

  void _showImportExportDialog() {
    // TODO: Реализовать импорт/экспорт
  }

  void _showStatistics() {
    // TODO: Реализовать статистику
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).colorScheme.primary : null,
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onSurface,
            fontSize: 12,
          ),
        ),
      ),
    );
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
}

/// Безопасная альтернатива AdaptiveContainer.sidebar с защитой от dry layout ошибок
class _DryLayoutSafeSidebar extends StatelessWidget {
  final Widget child;

  const _DryLayoutSafeSidebar({required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360, // Фиксированная ширина как у AdaptiveContainer.sidebar
      child: child,
    );
  }
}