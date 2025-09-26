import 'package:flutter/material.dart';

/// Material Design 3 макет списка и деталей
/// Адаптивный двухпанельный макет с поддержкой мобильных и планшетных устройств
class ListDetailLayout extends StatelessWidget {
  /// Список элементов (левая панель на планшете, основной экран на мобильном)
  final Widget listView;

  /// Детали выбранного элемента (правая панель на планшете, отдельный экран на мобильном)
  final Widget? detailView;

  /// Заглушка для состояния когда ничего не выбрано
  final Widget? emptyDetailView;

  /// Ширина списка на широких экранах
  final double listWidth;

  /// Минимальная ширина для показа деталей
  final double minDetailWidth;

  /// Брейкпоинт для переключения между мобильным и планшетным режимами
  final double breakpoint;

  /// Показывать разделитель между панелями
  final bool showDivider;

  /// Скрыть список при показе деталей на узких экранах
  final bool hideListOnDetail;

  /// Настройка анимации перехода
  final Duration animationDuration;

  /// Кривая анимации
  final Curve animationCurve;

  const ListDetailLayout({
    super.key,
    required this.listView,
    this.detailView,
    this.emptyDetailView,
    this.listWidth = 320,
    this.minDetailWidth = 400,
    this.breakpoint = 600,
    this.showDivider = true,
    this.hideListOnDetail = true,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= breakpoint;
        final showDetailView = detailView != null;

        if (isWideScreen) {
          return _buildTwoPaneLayout(context, constraints);
        } else {
          return _buildSinglePaneLayout(context, showDetailView);
        }
      },
    );
  }

  Widget _buildTwoPaneLayout(BuildContext context, BoxConstraints constraints) {
    final availableWidth = constraints.maxWidth;
    final effectiveListWidth = listWidth.clamp(200.0, availableWidth * 0.6);
    final detailWidthAvailable = availableWidth - effectiveListWidth;

    return Row(
      children: [
        // Список
        SizedBox(
          width: effectiveListWidth,
          child: listView,
        ),

        // Разделитель
        if (showDivider)
          VerticalDivider(
            width: 1,
            thickness: 1,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          ),

        // Панель деталей
        Expanded(
          child: AnimatedSwitcher(
            duration: animationDuration,
            switchInCurve: animationCurve,
            switchOutCurve: animationCurve,
            child: detailWidthAvailable >= minDetailWidth
                ? (detailView ?? _buildEmptyDetailView(context))
                : _buildNarrowDetailView(context),
          ),
        ),
      ],
    );
  }

  Widget _buildSinglePaneLayout(BuildContext context, bool showDetailView) {
    if (showDetailView && hideListOnDetail) {
      return AnimatedSwitcher(
        duration: animationDuration,
        switchInCurve: animationCurve,
        switchOutCurve: animationCurve,
        child: detailView!,
      );
    }

    return AnimatedSwitcher(
      duration: animationDuration,
      switchInCurve: animationCurve,
      switchOutCurve: animationCurve,
      child: showDetailView ? detailView! : listView,
    );
  }

  Widget _buildEmptyDetailView(BuildContext context) {
    return emptyDetailView ??
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.list_alt,
                size: 64,
                color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Выберите элемент из списка',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        );
  }

  Widget _buildNarrowDetailView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.phone_android,
            size: 48,
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'Увеличьте ширину экрана\nдля просмотра деталей',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}

/// Контроллер для управления состоянием ListDetailLayout
class ListDetailController extends ChangeNotifier {
  int? _selectedIndex;
  bool _isDetailVisible = false;

  int? get selectedIndex => _selectedIndex;
  bool get isDetailVisible => _isDetailVisible;
  bool get hasSelection => _selectedIndex != null;

  void selectItem(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      _isDetailVisible = true;
      notifyListeners();
    }
  }

  void clearSelection() {
    _selectedIndex = null;
    _isDetailVisible = false;
    notifyListeners();
  }

  void showDetail() {
    if (_selectedIndex != null) {
      _isDetailVisible = true;
      notifyListeners();
    }
  }

  void hideDetail() {
    _isDetailVisible = false;
    notifyListeners();
  }

  void toggleDetail() {
    _isDetailVisible = !_isDetailVisible;
    notifyListeners();
  }
}

/// Билдер для создания адаптивного списка с деталями
class AdaptiveListDetailBuilder extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index, bool isSelected) itemBuilder;
  final Widget Function(BuildContext context, int index) detailBuilder;
  final Widget? emptyState;
  final ListDetailController? controller;
  final void Function(int index)? onItemTap;
  final ScrollController? listScrollController;
  final ScrollController? detailScrollController;
  final EdgeInsets? listPadding;
  final EdgeInsets? detailPadding;

  const AdaptiveListDetailBuilder({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.detailBuilder,
    this.emptyState,
    this.controller,
    this.onItemTap,
    this.listScrollController,
    this.detailScrollController,
    this.listPadding,
    this.detailPadding,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller ?? ListDetailController(),
      builder: (context, _) {
        final effectiveController = controller ?? ListDetailController();
        final selectedIndex = effectiveController.selectedIndex;

        return ListDetailLayout(
          listView: _buildListView(context, effectiveController),
          detailView: selectedIndex != null
              ? _buildDetailView(context, selectedIndex)
              : null,
          emptyDetailView: emptyState,
        );
      },
    );
  }

  Widget _buildListView(BuildContext context, ListDetailController controller) {
    if (itemCount == 0 && emptyState != null) {
      return emptyState!;
    }

    return ListView.builder(
      controller: listScrollController,
      padding: listPadding,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final isSelected = controller.selectedIndex == index;

        return InkWell(
          onTap: () {
            controller.selectItem(index);
            onItemTap?.call(index);
          },
          child: itemBuilder(context, index, isSelected),
        );
      },
    );
  }

  Widget _buildDetailView(BuildContext context, int index) {
    return SingleChildScrollView(
      controller: detailScrollController,
      padding: detailPadding,
      child: detailBuilder(context, index),
    );
  }
}