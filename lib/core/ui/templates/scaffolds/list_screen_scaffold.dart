import 'package:flutter/material.dart';
import 'package:part_catalog/core/ui/themes/app_constants.dart';
import 'package:part_catalog/core/ui/molecules/search_bar.dart';
import 'package:part_catalog/core/ui/molecules/empty_state_message.dart';
import 'package:part_catalog/core/ui/molecules/loading_overlay.dart';

/// Универсальный шаблон для экранов со списками
/// Поддерживает поиск, фильтрация, пагинацию и различные состояния
class ListScreenScaffold<T> extends StatelessWidget {
  // Основные параметры экрана
  final String title;
  final PreferredSizeWidget? appBar;
  final List<Widget>? actions;

  // Поиск и фильтрация
  final SearchBarMolecule? searchBar;
  final Widget? filterPanel;
  final bool showSearch;
  final String? searchHint;
  final ValueChanged<String>? onSearch;

  // Список и данные
  final List<T> items;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final ScrollController? scrollController;
  final bool isLoading;
  final String? loadingMessage;

  // Состояния и ошибки
  final EmptyStateMessage? emptyState;
  final Widget? errorState;
  final VoidCallback? onRefresh;
  final bool showRefreshIndicator;

  // Layout и стилизация
  final ListLayoutType layoutType;
  final EdgeInsets? padding;
  final double itemSpacing;
  final int? gridCrossAxisCount;
  final double? gridChildAspectRatio;

  // Floating Action Button
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  // Bottom Navigation или Panel
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final List<Widget>? persistentFooterButtons;

  const ListScreenScaffold({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.appBar,
    this.actions,
    this.searchBar,
    this.filterPanel,
    this.showSearch = false,
    this.searchHint,
    this.onSearch,
    this.scrollController,
    this.isLoading = false,
    this.loadingMessage,
    this.emptyState,
    this.errorState,
    this.onRefresh,
    this.showRefreshIndicator = true,
    this.layoutType = ListLayoutType.list,
    this.padding,
    this.itemSpacing = 0,
    this.gridCrossAxisCount = 2,
    this.gridChildAspectRatio = 1.0,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.persistentFooterButtons,
  });

  /// Создает экран со списком и поиском
  const ListScreenScaffold.withSearch({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    required this.onSearch,
    this.searchHint = 'Поиск...',
    this.appBar,
    this.actions,
    this.filterPanel,
    this.scrollController,
    this.isLoading = false,
    this.loadingMessage,
    this.emptyState,
    this.errorState,
    this.onRefresh,
    this.showRefreshIndicator = true,
    this.layoutType = ListLayoutType.list,
    this.padding,
    this.itemSpacing = 0,
    this.gridCrossAxisCount = 2,
    this.gridChildAspectRatio = 1.0,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.persistentFooterButtons,
  })  : showSearch = true,
        searchBar = null;

  /// Создает экран с сеткой элементов
  const ListScreenScaffold.grid({
    super.key,
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.gridCrossAxisCount = 2,
    this.gridChildAspectRatio = 1.0,
    this.appBar,
    this.actions,
    this.searchBar,
    this.filterPanel,
    this.showSearch = false,
    this.searchHint,
    this.onSearch,
    this.scrollController,
    this.isLoading = false,
    this.loadingMessage,
    this.emptyState,
    this.errorState,
    this.onRefresh,
    this.showRefreshIndicator = true,
    this.padding,
    this.itemSpacing = AppSpacing.sm,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.bottomSheet,
    this.persistentFooterButtons,
  }) : layoutType = ListLayoutType.grid;

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      message: loadingMessage,
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: _buildBody(context),
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
        bottomNavigationBar: bottomNavigationBar,
        bottomSheet: bottomSheet,
        persistentFooterButtons: persistentFooterButtons,
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context) {
    if (appBar != null) return appBar;

    return AppBar(
      title: Text(title),
      actions: actions,
      centerTitle: false,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        // Поиск и фильтры
        if (_shouldShowSearchOrFilters()) ...[
          _buildSearchAndFilters(context),
          const Divider(height: 1),
        ],

        // Основной контент
        Expanded(
          child: _buildContent(context),
        ),
      ],
    );
  }

  bool _shouldShowSearchOrFilters() {
    return showSearch || searchBar != null || filterPanel != null;
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.adaptive(context)),
      child: Column(
        children: [
          // Поисковая строка
          if (showSearch || searchBar != null)
            searchBar ?? SearchBarMolecule(
              hint: searchHint ?? 'Поиск...',
              onChanged: onSearch,
            ),

          // Панель фильтров
          if (filterPanel != null) ...[
            if (showSearch || searchBar != null)
              const SizedBox(height: AppSpacing.sm),
            filterPanel!,
          ],
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    // Показываем состояние ошибки
    if (errorState != null) {
      return errorState!;
    }

    // Показываем пустое состояние
    if (items.isEmpty && !isLoading) {
      return emptyState ?? _buildDefaultEmptyState();
    }

    // Показываем список
    return _buildList(context);
  }

  Widget _buildDefaultEmptyState() {
    return const EmptyStateMessage(
      icon: Icon(Icons.list_alt, size: 64, color: Colors.grey),
      title: 'Список пуст',
      subtitle: 'Нет элементов для отображения',
    );
  }

  Widget _buildList(BuildContext context) {
    Widget listWidget;

    switch (layoutType) {
      case ListLayoutType.list:
        listWidget = _buildListView(context);
        break;
      case ListLayoutType.separated:
        listWidget = _buildSeparatedListView(context);
        break;
      case ListLayoutType.grid:
        listWidget = _buildGridView(context);
        break;
    }

    // Добавляем Pull-to-Refresh если нужно
    if (showRefreshIndicator && onRefresh != null) {
      listWidget = RefreshIndicator(
        onRefresh: () async {
          onRefresh!();
        },
        child: listWidget,
      );
    }

    return listWidget;
  }

  Widget _buildListView(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: padding ?? EdgeInsets.all(AppSpacing.adaptive(context)),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index], index);
      },
    );
  }

  Widget _buildSeparatedListView(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      padding: padding ?? EdgeInsets.all(AppSpacing.adaptive(context)),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index], index);
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: itemSpacing);
      },
    );
  }

  Widget _buildGridView(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      padding: padding ?? EdgeInsets.all(AppSpacing.adaptive(context)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getAdaptiveCrossAxisCount(context),
        childAspectRatio: gridChildAspectRatio!,
        crossAxisSpacing: itemSpacing,
        mainAxisSpacing: itemSpacing,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index], index);
      },
    );
  }

  int _getAdaptiveCrossAxisCount(BuildContext context) {
    if (AppBreakpoints.isMobile(context)) {
      return gridCrossAxisCount! > 2 ? 2 : gridCrossAxisCount!;
    } else if (AppBreakpoints.isTablet(context)) {
      return (gridCrossAxisCount! * 1.5).round();
    } else {
      return gridCrossAxisCount! * 2;
    }
  }
}

/// Типы отображения списка
enum ListLayoutType {
  list,      // Обычный список
  separated, // Список с разделителями
  grid,      // Сетка
}

/// Конфигурация для создания списков
class ListScreenConfig<T> {
  final String title;
  final List<T> items;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final String? searchHint;
  final ValueChanged<String>? onSearch;
  final EmptyStateMessage? emptyState;
  final VoidCallback? onRefresh;
  final ListLayoutType layoutType;
  final Widget? floatingActionButton;

  const ListScreenConfig({
    required this.title,
    required this.items,
    required this.itemBuilder,
    this.searchHint,
    this.onSearch,
    this.emptyState,
    this.onRefresh,
    this.layoutType = ListLayoutType.list,
    this.floatingActionButton,
  });
}

/// Фабрика для создания типовых экранов списков
class ListScreenFactory {
  /// Создает экран для списка клиентов
  static Widget clients<T>({
    required List<T> clients,
    required Widget Function(BuildContext, T, int) itemBuilder,
    ValueChanged<String>? onSearch,
    VoidCallback? onAddClient,
    VoidCallback? onRefresh,
  }) {
    return ListScreenScaffold.withSearch(
      title: 'Клиенты',
      items: clients,
      itemBuilder: itemBuilder,
      searchHint: 'Поиск клиентов...',
      onSearch: onSearch,
      onRefresh: onRefresh,
      emptyState: EmptyStateConfigs.clients(
        onAddClient: onAddClient,
      ),
      floatingActionButton: onAddClient != null
          ? FloatingActionButton(
              onPressed: onAddClient,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  /// Создает экран для списка заказов
  static Widget orders<T>({
    required List<T> orders,
    required Widget Function(BuildContext, T, int) itemBuilder,
    ValueChanged<String>? onSearch,
    VoidCallback? onCreateOrder,
    VoidCallback? onRefresh,
  }) {
    return ListScreenScaffold.withSearch(
      title: 'Заказы',
      items: orders,
      itemBuilder: itemBuilder,
      searchHint: 'Поиск заказов...',
      onSearch: onSearch,
      onRefresh: onRefresh,
      layoutType: AppBreakpoints.isTablet(
        // Нужен BuildContext, используем адаптивную логику в самом виджете
        null as BuildContext? ?? WidgetsBinding.instance.rootElement!,
      ) ? ListLayoutType.grid : ListLayoutType.list,
      emptyState: EmptyStateConfigs.orders(
        onCreateOrder: onCreateOrder,
      ),
      floatingActionButton: onCreateOrder != null
          ? FloatingActionButton.extended(
              onPressed: onCreateOrder,
              icon: const Icon(Icons.add),
              label: const Text('Создать заказ'),
            )
          : null,
    );
  }

  /// Создает экран для каталога товаров
  static Widget catalog<T>({
    required List<T> products,
    required Widget Function(BuildContext, T, int) itemBuilder,
    ValueChanged<String>? onSearch,
    Widget? filterPanel,
    VoidCallback? onRefresh,
  }) {
    return ListScreenScaffold.grid(
      title: 'Каталог',
      items: products,
      itemBuilder: itemBuilder,
      searchBar: onSearch != null
          ? SearchBarMolecule(
              hint: 'Поиск товаров...',
              onChanged: onSearch,
            )
          : null,
      filterPanel: filterPanel,
      onRefresh: onRefresh,
      gridCrossAxisCount: 2,
      gridChildAspectRatio: 0.8, // Для карточек товаров
      emptyState: const EmptyStateMessage.search(
        title: 'Товары не найдены',
        subtitle: 'Попробуйте изменить критерии поиска',
      ),
    );
  }
}