import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:part_catalog/core/ui/themes/app_constants.dart';
import 'package:part_catalog/core/ui/themes/app_spacing.dart';
import 'package:part_catalog/core/ui/molecules/loading_overlay.dart';
import 'package:part_catalog/core/ui/molecules/escape_handler.dart';

/// Универсальный шаблон для экранов с вкладками
/// Поддерживает адаптивные табы, lazy loading, сохранение состояния
class TabbedScreenScaffold extends StatefulWidget {
  // Основные параметры
  final String title;
  final List<TabConfig> tabs;
  final PreferredSizeWidget? appBar;
  final List<Widget>? actions;

  // Настройки табов
  final int initialIndex;
  final bool isScrollable;
  final TabBarIndicatorSize? indicatorSize;
  final Color? indicatorColor;
  final TabAlignment tabAlignment;

  // Поведение и состояние
  final bool keepAlive;
  final bool lazyLoad;
  final ValueChanged<int>? onTabChanged;
  final TabController? controller;

  // Загрузка и состояние
  final bool isLoading;
  final String? loadingMessage;
  final Map<int, bool>? tabLoadingStates;

  // Дополнительные элементы
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? drawer;
  final Widget? endDrawer;
  final List<Widget>? persistentFooterButtons;

  // Адаптивность
  final bool adaptive;
  final TabLayoutType layoutType;

  // Принудительное закрытие
  final bool enableForceClose;
  final VoidCallback? onForceClose;
  final bool showForceCloseButton;

  const TabbedScreenScaffold({
    super.key,
    required this.title,
    required this.tabs,
    this.appBar,
    this.actions,
    this.initialIndex = 0,
    this.isScrollable = false,
    this.indicatorSize,
    this.indicatorColor,
    this.tabAlignment = TabAlignment.center,
    this.keepAlive = true,
    this.lazyLoad = false,
    this.onTabChanged,
    this.controller,
    this.isLoading = false,
    this.loadingMessage,
    this.tabLoadingStates,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.persistentFooterButtons,
    this.adaptive = true,
    this.layoutType = TabLayoutType.top,
    this.enableForceClose = true,
    this.onForceClose,
    this.showForceCloseButton = false,
  });

  /// Создает экран с верхними табами (Material Design)
  const TabbedScreenScaffold.top({
    super.key,
    required this.title,
    required this.tabs,
    this.appBar,
    this.actions,
    this.initialIndex = 0,
    this.isScrollable = false,
    this.indicatorSize,
    this.indicatorColor,
    this.tabAlignment = TabAlignment.center,
    this.keepAlive = true,
    this.lazyLoad = false,
    this.onTabChanged,
    this.controller,
    this.isLoading = false,
    this.loadingMessage,
    this.tabLoadingStates,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.persistentFooterButtons,
    this.adaptive = true,
    this.enableForceClose = true,
    this.onForceClose,
    this.showForceCloseButton = false,
  }) : layoutType = TabLayoutType.top;

  /// Создает экран с нижними табами (iOS style)
  const TabbedScreenScaffold.bottom({
    super.key,
    required this.title,
    required this.tabs,
    this.appBar,
    this.actions,
    this.initialIndex = 0,
    this.keepAlive = true,
    this.lazyLoad = false,
    this.onTabChanged,
    this.controller,
    this.isLoading = false,
    this.loadingMessage,
    this.tabLoadingStates,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.persistentFooterButtons,
    this.adaptive = true,
    this.enableForceClose = true,
    this.onForceClose,
    this.showForceCloseButton = false,
  })  : layoutType = TabLayoutType.bottom,
        isScrollable = false,
        indicatorSize = null,
        indicatorColor = null,
        tabAlignment = TabAlignment.fill;

  /// Создает адаптивный экран (табы сверху на мобильных, сбоку на десктопе)
  const TabbedScreenScaffold.adaptive({
    super.key,
    required this.title,
    required this.tabs,
    this.appBar,
    this.actions,
    this.initialIndex = 0,
    this.isScrollable = false,
    this.indicatorSize,
    this.indicatorColor,
    this.tabAlignment = TabAlignment.center,
    this.keepAlive = true,
    this.lazyLoad = false,
    this.onTabChanged,
    this.controller,
    this.isLoading = false,
    this.loadingMessage,
    this.tabLoadingStates,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.drawer,
    this.endDrawer,
    this.persistentFooterButtons,
    this.enableForceClose = true,
    this.onForceClose,
    this.showForceCloseButton = false,
  }) : layoutType = TabLayoutType.adaptive,
       adaptive = true;

  @override
  State<TabbedScreenScaffold> createState() => _TabbedScreenScaffoldState();
}

class _TabbedScreenScaffoldState extends State<TabbedScreenScaffold>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<bool> _tabsInitialized;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _tabController = widget.controller ??
        TabController(
          length: widget.tabs.length,
          vsync: this,
          initialIndex: widget.initialIndex,
        );

    _tabsInitialized = List.filled(widget.tabs.length, false);
    if (!widget.lazyLoad) {
      // Инициализируем все табы сразу
      _tabsInitialized.fillRange(0, widget.tabs.length, true);
    } else {
      // Инициализируем только активный таб
      _tabsInitialized[widget.initialIndex] = true;
    }

    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    if (widget.controller == null) {
      _tabController.dispose();
    }
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;

    final newIndex = _tabController.index;
    if (newIndex != _currentIndex) {
      setState(() {
        _currentIndex = newIndex;
        if (widget.lazyLoad) {
          _tabsInitialized[newIndex] = true;
        }
      });
      widget.onTabChanged?.call(newIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = LoadingOverlay(
      isLoading: widget.isLoading,
      message: widget.loadingMessage,
      child: _buildScaffold(context),
    );

    // Добавляем обработку принудительного закрытия если включено
    if (widget.enableForceClose) {
      content = EscapeHandler(
        onEscape: widget.onForceClose,
        enableKeyboardEscape: true,
        enableBackGesture: true,
        enableSwipeToClose: false, // Отключаем для экранов настроек
        enableDoubleTapToClose: false,
        showCloseButton: false, // Не показываем кнопку - она в AppBar
        child: content,
      );
    }

    return content;
  }

  Widget _buildScaffold(BuildContext context) {
    final effectiveLayoutType = _getEffectiveLayoutType(context);

    switch (effectiveLayoutType) {
      case TabLayoutType.top:
        return _buildTopTabsScaffold(context);
      case TabLayoutType.bottom:
        return _buildBottomTabsScaffold(context);
      case TabLayoutType.side:
        return _buildSideTabsScaffold(context);
      case TabLayoutType.adaptive:
        // Не должно попасть сюда, но на всякий случай
        return _buildTopTabsScaffold(context);
    }
  }

  TabLayoutType _getEffectiveLayoutType(BuildContext context) {
    if (widget.layoutType != TabLayoutType.adaptive) {
      return widget.layoutType;
    }

    // Адаптивная логика
    if (AppBreakpoints.isMobile(context)) {
      return TabLayoutType.top;
    } else if (AppBreakpoints.isTablet(context)) {
      return TabLayoutType.top;
    } else {
      return TabLayoutType.side; // Desktop
    }
  }

  Widget _buildTopTabsScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildTabBarView(),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      persistentFooterButtons: widget.persistentFooterButtons,
    );
  }

  Widget _buildBottomTabsScaffold(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar ?? _buildSimpleAppBar(context),
      body: _buildTabBarView(),
      bottomNavigationBar: _buildBottomTabBar(),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      persistentFooterButtons: widget.persistentFooterButtons,
    );
  }

  Widget _buildSideTabsScaffold(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar ?? _buildSimpleAppBar(context),
      body: Row(
        children: [
          _buildSideTabBar(context),
          const VerticalDivider(width: 1),
          Expanded(child: _buildTabBarView()),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    if (widget.appBar != null) return widget.appBar!;

    // Создаем список actions с возможной кнопкой закрытия
    List<Widget> effectiveActions = [];

    // Добавляем кнопку принудительного закрытия если включена
    if (widget.showForceCloseButton) {
      effectiveActions.add(
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (widget.onForceClose != null) {
              widget.onForceClose!();
            } else {
              // Возвращаемся к центру управления API
              context.go('/api-control-center');
            }
          },
          tooltip: 'Закрыть (Esc)',
        ),
      );
    }

    // Добавляем пользовательские actions
    if (widget.actions != null) {
      effectiveActions.addAll(widget.actions!);
    }

    return AppBar(
      title: Text(widget.title),
      actions: effectiveActions.isNotEmpty ? effectiveActions : null,
      bottom: _buildTabBar(),
    );
  }

  /// Создает простой AppBar без TabBar (для боковых и нижних табов)
  PreferredSizeWidget _buildSimpleAppBar(BuildContext context) {
    // Создаем список actions с возможной кнопкой закрытия
    List<Widget> effectiveActions = [];

    // Добавляем кнопку принудительного закрытия если включена
    if (widget.showForceCloseButton) {
      effectiveActions.add(
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            if (widget.onForceClose != null) {
              widget.onForceClose!();
            } else {
              // Возвращаемся к центру управления API
              context.go('/api-control-center');
            }
          },
          tooltip: 'Закрыть (Esc)',
        ),
      );
    }

    // Добавляем пользовательские actions
    if (widget.actions != null) {
      effectiveActions.addAll(widget.actions!);
    }

    return AppBar(
      title: Text(widget.title),
      actions: effectiveActions.isNotEmpty ? effectiveActions : null,
    );
  }

  TabBar _buildTabBar() {
    // TabAlignment.start допустимо только для скроллируемых TabBar
    final effectiveTabAlignment = widget.isScrollable
        ? widget.tabAlignment
        : (widget.tabAlignment == TabAlignment.start
            ? TabAlignment.center
            : widget.tabAlignment);

    return TabBar(
      controller: _tabController,
      isScrollable: widget.isScrollable,
      indicatorSize: widget.indicatorSize,
      indicatorColor: widget.indicatorColor,
      tabAlignment: effectiveTabAlignment,
      tabs: widget.tabs.map((tab) => Tab(
        icon: tab.icon,
        text: tab.label,
        child: tab.child,
      )).toList(),
    );
  }

  Widget _buildBottomTabBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        _tabController.animateTo(index);
      },
      type: BottomNavigationBarType.fixed,
      items: widget.tabs.map((tab) => BottomNavigationBarItem(
        icon: tab.icon ?? const Icon(Icons.tab),
        label: tab.label,
      )).toList(),
    );
  }

  Widget _buildSideTabBar(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          for (int i = 0; i < widget.tabs.length; i++)
            _buildSideTabItem(i, widget.tabs[i]),
        ],
      ),
    );
  }

  Widget _buildSideTabItem(int index, TabConfig tab) {
    final isActive = index == _currentIndex;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        leading: tab.icon,
        title: Text(tab.label),
        selected: isActive,
        onTap: () {
          _tabController.animateTo(index);
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
      ),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: widget.tabs.asMap().entries.map((entry) {
        final index = entry.key;
        final tab = entry.value;

        // Lazy loading
        if (widget.lazyLoad && !_tabsInitialized[index]) {
          return _buildLoadingTab(index);
        }

        // Loading состояние конкретного таба
        if (widget.tabLoadingStates?[index] == true) {
          return _buildLoadingTab(index);
        }

        // Keep alive wrapper
        if (widget.keepAlive) {
          return _KeepAliveWrapper(child: tab.builder());
        }

        return tab.builder();
      }).toList(),
    );
  }

  Widget _buildLoadingTab(int index) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

/// Wrapper для сохранения состояния табов
class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

/// Конфигурация вкладки
class TabConfig {
  final String label;
  final Widget? icon;
  final Widget? child; // Для кастомных табов
  final Widget Function() builder;
  final String? tooltip;
  final bool enabled;

  const TabConfig({
    required this.label,
    required this.builder,
    this.icon,
    this.child,
    this.tooltip,
    this.enabled = true,
  });

  /// Создает таб с иконкой
  const TabConfig.withIcon({
    required this.label,
    required this.icon,
    required this.builder,
    this.tooltip,
    this.enabled = true,
  }) : child = null;

  /// Создает простой текстовый таб
  const TabConfig.text({
    required this.label,
    required this.builder,
    this.tooltip,
    this.enabled = true,
  }) : icon = null,
       child = null;
}

/// Типы раскладки табов
enum TabLayoutType {
  top,      // Вверху (Material Design)
  bottom,   // Внизу (iOS style)
  side,     // Сбоку (Desktop)
  adaptive, // Адаптивно в зависимости от устройства
}

/// Фабрика для создания типовых экранов с табами
class TabbedScreenFactory {
  /// Создает экран настроек поставщика
  static Widget supplierSettings({
    required String supplierName,
    required Widget basicSettingsTab,
    required Widget connectionTab,
    required Widget parametersTab,
    required Widget testingTab,
    List<Widget>? actions,
  }) {
    return TabbedScreenScaffold.adaptive(
      title: 'Настройка $supplierName',
      actions: actions,
      tabs: [
        TabConfig.withIcon(
          label: 'Основные',
          icon: const Icon(Icons.info),
          builder: () => basicSettingsTab,
        ),
        TabConfig.withIcon(
          label: 'Подключение',
          icon: const Icon(Icons.api),
          builder: () => connectionTab,
        ),
        TabConfig.withIcon(
          label: 'Параметры',
          icon: const Icon(Icons.settings),
          builder: () => parametersTab,
        ),
        TabConfig.withIcon(
          label: 'Тестирование',
          icon: const Icon(Icons.science),
          builder: () => testingTab,
        ),
      ],
      lazyLoad: true,
      keepAlive: true,
    );
  }

  /// Создает экран управления данными
  static Widget dataManagement({
    required Widget clientsTab,
    required Widget ordersTab,
    required Widget partsTab,
    List<Widget>? actions,
  }) {
    return TabbedScreenScaffold.top(
      title: 'Управление данными',
      actions: actions,
      tabs: [
        TabConfig.withIcon(
          label: 'Клиенты',
          icon: const Icon(Icons.people),
          builder: () => clientsTab,
        ),
        TabConfig.withIcon(
          label: 'Заказы',
          icon: const Icon(Icons.receipt_long),
          builder: () => ordersTab,
        ),
        TabConfig.withIcon(
          label: 'Запчасти',
          icon: const Icon(Icons.build),
          builder: () => partsTab,
        ),
      ],
      keepAlive: true,
    );
  }

  /// Создает экран аналитики
  static Widget analytics({
    required Widget dashboardTab,
    required Widget reportsTab,
    required Widget chartsTab,
    List<Widget>? actions,
  }) {
    return TabbedScreenScaffold.adaptive(
      title: 'Аналитика',
      actions: actions,
      tabs: [
        TabConfig.withIcon(
          label: 'Панель',
          icon: const Icon(Icons.dashboard),
          builder: () => dashboardTab,
        ),
        TabConfig.withIcon(
          label: 'Отчеты',
          icon: const Icon(Icons.assessment),
          builder: () => reportsTab,
        ),
        TabConfig.withIcon(
          label: 'Графики',
          icon: const Icon(Icons.bar_chart),
          builder: () => chartsTab,
        ),
      ],
      lazyLoad: true,
    );
  }
}