import 'package:flutter/material.dart';

/// Адаптивный шаблон master-detail
/// На узких экранах показывает навигацию стеком, на широких - разделенным экраном
class MasterDetailScaffold extends StatefulWidget {
  /// Заголовок приложения
  final String title;

  /// Мастер-панель (список)
  final Widget masterPanel;

  /// Панель деталей
  final Widget? detailPanel;

  /// Пустое состояние для деталей
  final Widget? detailPlaceholder;

  /// Показана ли панель деталей
  final bool showDetailPanel;

  /// Обработчик закрытия деталей на узких экранах
  final VoidCallback? onCloseDetail;

  /// Действия в AppBar
  final List<Widget>? actions;

  /// Drawer
  final Widget? drawer;

  /// Floating Action Button
  final Widget? floatingActionButton;

  /// Ширина мастер-панели на широких экранах
  final double masterPanelWidth;

  /// Breakpoint для переключения между режимами
  final double breakpoint;

  /// Соотношение ширин панелей (0.0 - 1.0)
  final double? splitRatio;

  /// Можно ли изменять размер панелей
  final bool allowResize;

  /// Минимальная ширина мастер-панели при ресайзе
  final double minMasterWidth;

  /// Максимальная ширина мастер-панели при ресайзе
  final double maxMasterWidth;

  /// Автоматически закрывать детали при изменении выбора на узких экранах
  final bool autoCloseDetailOnSelection;

  /// Анимировать переходы
  final bool animate;

  /// Показывать ли кнопку "Назад" в деталях на широких экранах
  final bool showBackButtonOnWide;

  /// Заголовок панели деталей
  final String? detailTitle;

  /// Действия в панели деталей
  final List<Widget>? detailActions;

  const MasterDetailScaffold({
    super.key,
    required this.title,
    required this.masterPanel,
    this.detailPanel,
    this.detailPlaceholder,
    this.showDetailPanel = false,
    this.onCloseDetail,
    this.actions,
    this.drawer,
    this.floatingActionButton,
    this.masterPanelWidth = 320,
    this.breakpoint = 800,
    this.splitRatio,
    this.allowResize = true,
    this.minMasterWidth = 280,
    this.maxMasterWidth = 400,
    this.autoCloseDetailOnSelection = true,
    this.animate = true,
    this.showBackButtonOnWide = false,
    this.detailTitle,
    this.detailActions,
  });

  @override
  State<MasterDetailScaffold> createState() => _MasterDetailScaffoldState();
}

class _MasterDetailScaffoldState extends State<MasterDetailScaffold> {
  double? _masterWidth;

  @override
  void initState() {
    super.initState();
    _masterWidth = widget.splitRatio != null
        ? null
        : widget.masterPanelWidth;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= widget.breakpoint;

        if (isWideScreen) {
          return _buildWideScreenLayout(context, constraints);
        } else {
          return _buildNarrowScreenLayout(context);
        }
      },
    );
  }

  Widget _buildWideScreenLayout(BuildContext context, BoxConstraints constraints) {
    final effectiveMasterWidth = widget.splitRatio != null
        ? constraints.maxWidth * widget.splitRatio!
        : (_masterWidth ?? widget.masterPanelWidth);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: widget.actions,
      ),
      drawer: widget.drawer,
      floatingActionButton: widget.floatingActionButton,
      body: Row(
        children: [
          // Мастер-панель
          SizedBox(
            width: effectiveMasterWidth,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: widget.masterPanel,
            ),
          ),

          // Разделитель с возможностью ресайза
          if (widget.allowResize && widget.splitRatio == null)
            _buildResizeHandle(context),

          // Панель деталей
          Expanded(
            child: _buildDetailSection(context, true),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowScreenLayout(BuildContext context) {
    if (widget.showDetailPanel && widget.detailPanel != null) {
      // Показываем детали в полный экран
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.detailTitle ?? widget.title),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onCloseDetail ?? () => Navigator.of(context).pop(),
          ),
          actions: widget.detailActions,
        ),
        body: widget.animate
            ? AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: widget.detailPanel,
              )
            : widget.detailPanel!,
      );
    } else {
      // Показываем мастер-панель
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: widget.actions,
        ),
        drawer: widget.drawer,
        floatingActionButton: widget.floatingActionButton,
        body: widget.masterPanel,
      );
    }
  }

  Widget _buildDetailSection(BuildContext context, bool isWideScreen) {
    Widget content;

    if (widget.detailPanel != null) {
      content = Column(
        children: [
          if (isWideScreen && (widget.detailTitle != null || widget.detailActions != null))
            _buildDetailHeader(context),
          Expanded(
            child: widget.animate
                ? AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: widget.detailPanel,
                  )
                : widget.detailPanel!,
          ),
        ],
      );
    } else {
      content = widget.detailPlaceholder ?? _buildDefaultPlaceholder(context);
    }

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: content,
    );
  }

  Widget _buildDetailHeader(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          if (widget.showBackButtonOnWide)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: widget.onCloseDetail,
            ),
          if (widget.detailTitle != null) ...[
            if (widget.showBackButtonOnWide) const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.detailTitle!,
                style: Theme.of(context).textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ] else
            const Spacer(),
          if (widget.detailActions != null)
            ...widget.detailActions!,
        ],
      ),
    );
  }

  Widget _buildResizeHandle(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            final newWidth = (_masterWidth ?? widget.masterPanelWidth) + details.delta.dx;
            _masterWidth = newWidth.clamp(widget.minMasterWidth, widget.maxMasterWidth);
          });
        },
        child: Container(
          width: 6,
          color: Colors.transparent,
          child: Center(
            child: Container(
              width: 1,
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultPlaceholder(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Выберите элемент для просмотра деталей',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Детали выбранного элемента будут отображены здесь',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Контроллер для управления MasterDetailScaffold
class MasterDetailController extends ChangeNotifier {
  bool _showDetailPanel = false;
  String? _detailTitle;
  Widget? _detailPanel;
  List<Widget>? _detailActions;

  bool get showDetailPanel => _showDetailPanel;
  String? get detailTitle => _detailTitle;
  Widget? get detailPanel => _detailPanel;
  List<Widget>? get detailActions => _detailActions;

  void showDetail({
    required Widget panel,
    String? title,
    List<Widget>? actions,
  }) {
    _detailPanel = panel;
    _detailTitle = title;
    _detailActions = actions;
    _showDetailPanel = true;
    notifyListeners();
  }

  void hideDetail() {
    _showDetailPanel = false;
    _detailPanel = null;
    _detailTitle = null;
    _detailActions = null;
    notifyListeners();
  }

  void updateDetail({
    Widget? panel,
    String? title,
    List<Widget>? actions,
  }) {
    if (panel != null) _detailPanel = panel;
    if (title != null) _detailTitle = title;
    if (actions != null) _detailActions = actions;
    notifyListeners();
  }
}

/// Утилитарные расширения для работы с MasterDetail
extension MasterDetailExtensions on BuildContext {
  /// Проверяет, является ли текущий экран широким
  bool get isWideScreen {
    return MediaQuery.of(this).size.width >= 800;
  }

  /// Показывает детали в адаптивном режиме
  void showMasterDetail<T>({
    required Widget detailWidget,
    String? title,
    List<Widget>? actions,
  }) {
    if (isWideScreen) {
      // На широких экранах обновляем контроллер
      // Предполагается, что контроллер доступен через провайдер
    } else {
      // На узких экранах открываем новый экран
      Navigator.of(this).push(
        MaterialPageRoute<T>(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: Text(title ?? 'Детали'),
              actions: actions,
            ),
            body: detailWidget,
          ),
        ),
      );
    }
  }
}